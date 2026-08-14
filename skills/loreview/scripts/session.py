#!/usr/bin/env python3
"""Keep Loreview review sessions private and pinned to exact Git snapshots."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
from typing import Any


SESSION_NAME = re.compile(r"[A-Za-z0-9][A-Za-z0-9._-]{0,119}\Z")
EVIDENCE_KINDS = ("observed", "source-grounded", "inferred", "hypothetical")
SCHEMA_VERSION = 1


class SessionError(Exception):
    """Represent an expected user-facing session error."""


def timestamp() -> str:
    return dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds")


def git(repository: Path, *arguments: str) -> bytes:
    result = subprocess.run(
        ["git", "-C", str(repository), *arguments],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if result.returncode:
        message = result.stderr.decode("utf-8", errors="replace").strip()
        raise SessionError(message or f"git exited with status {result.returncode}")
    return result.stdout


def git_text(repository: Path, *arguments: str) -> str:
    return git(repository, *arguments).decode("utf-8", errors="surrogateescape").strip()


def repository_paths(value: str) -> tuple[Path, Path]:
    requested = Path(value).expanduser().resolve()
    root = Path(git_text(requested, "rev-parse", "--show-toplevel")).resolve()
    common = Path(
        git_text(root, "rev-parse", "--path-format=absolute", "--git-common-dir")
    ).resolve()
    return root, common


def resolve_commit(repository: Path, revision: str) -> str:
    return git_text(
        repository,
        "rev-parse",
        "--verify",
        "--end-of-options",
        f"{revision}^{{commit}}",
    )


def digest(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def committed_patch(repository: Path, base: str, head: str) -> bytes:
    return git(
        repository,
        "diff",
        "--binary",
        "--no-ext-diff",
        "--no-renames",
        "--no-color",
        base,
        head,
        "--",
    )


def worktree_state(repository: Path) -> tuple[str, list[str]]:
    patch = git(
        repository,
        "diff",
        "--binary",
        "--no-ext-diff",
        "--no-renames",
        "--no-color",
        "HEAD",
        "--",
    )
    status = git(repository, "status", "--porcelain=v1", "-z", "--untracked-files=all")
    untracked = [
        os.fsdecode(entry[3:])
        for entry in status.split(b"\0")
        if entry.startswith(b"?? ")
    ]
    return digest(patch + b"\0" + status), untracked


def checked_name(value: str) -> str:
    if not SESSION_NAME.fullmatch(value):
        raise SessionError(
            "session names must contain only letters, numbers, dots, underscores, "
            "or hyphens and may not start with punctuation"
        )
    return value


def secure_directory(path: Path) -> None:
    if path.is_symlink():
        raise SessionError(f"refusing to use a symbolic link for private state: {path}")
    path.mkdir(mode=0o700, parents=False, exist_ok=True)
    if not path.is_dir():
        raise SessionError(f"private state path is not a directory: {path}")
    path.chmod(0o700)


def sessions_root(common: Path, *, create: bool) -> Path:
    root = common / "loreview"
    if create:
        secure_directory(root)
    elif root.exists() and (root.is_symlink() or not root.is_dir()):
        raise SessionError(f"invalid private session root: {root}")
    return root


def session_path(common: Path, name: str) -> Path:
    return sessions_root(common, create=False) / checked_name(name)


def write_json(path: Path, content: Any) -> None:
    encoded = json.dumps(content, indent=2, sort_keys=True, ensure_ascii=False) + "\n"
    descriptor, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        os.fchmod(descriptor, 0o600)
        with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
            stream.write(encoded)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
        path.chmod(0o600)
    except BaseException:
        try:
            os.unlink(temporary)
        except FileNotFoundError:
            pass
        raise


def read_json(path: Path) -> Any:
    if path.is_symlink():
        raise SessionError(f"refusing to read a symbolic link as private state: {path}")
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as error:
        raise SessionError(f"session state does not exist: {path}") from error
    except (OSError, json.JSONDecodeError) as error:
        raise SessionError(f"could not read session state {path}: {error}") from error


def emit(value: Any) -> None:
    print(json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False))


def load_session(repository: str, name: str) -> tuple[Path, Path, dict[str, Any]]:
    root, common = repository_paths(repository)
    location = session_path(common, name)
    if location.is_symlink():
        raise SessionError(f"refusing to use a symbolic-link session: {location}")
    metadata = read_json(location / "session.json")
    if metadata.get("schema_version") != SCHEMA_VERSION:
        raise SessionError("unsupported Loreview session schema")
    if metadata.get("git_common_dir") != str(common):
        raise SessionError("session belongs to a different Git repository")
    return root, location, metadata


def make_snapshot(repository: Path, arguments: argparse.Namespace) -> dict[str, Any]:
    if arguments.worktree:
        head = resolve_commit(repository, "HEAD")
        patch_digest, untracked = worktree_state(repository)
        return {
            "kind": "worktree",
            "base_sha": head,
            "head_sha": head,
            "merge_base_sha": head,
            "head_selector": "HEAD",
            "patch_sha256": patch_digest,
            "excluded_untracked_paths": untracked,
        }

    if not arguments.base or not arguments.head:
        raise SessionError("committed sessions require both --base and --head")

    base = resolve_commit(repository, arguments.base)
    head = resolve_commit(repository, arguments.head)
    merge_base = git_text(repository, "merge-base", base, head)
    return {
        "kind": "committed",
        "base_sha": base,
        "head_sha": head,
        "merge_base_sha": merge_base,
        "base_selector": arguments.base,
        "head_selector": arguments.head,
        "patch_sha256": digest(committed_patch(repository, merge_base, head)),
        "excluded_untracked_paths": [],
    }


def initialize(arguments: argparse.Namespace) -> int:
    repository, common = repository_paths(arguments.repo)
    label = checked_name(arguments.session)
    snapshot = make_snapshot(repository, arguments)
    identifier = (
        f"{label}-{snapshot['head_sha'][:12]}-{snapshot['patch_sha256'][:8]}"
    )
    checked_name(identifier)
    root = sessions_root(common, create=True)
    location = root / identifier
    secure_directory(location)

    metadata_path = location / "session.json"
    if metadata_path.exists():
        existing = read_json(metadata_path)
        if existing.get("snapshot") != snapshot:
            raise SessionError("an existing session identifier has a different snapshot")
        if existing.get("research_opt_in") != arguments.research_consent:
            raise SessionError(
                "the existing session has a different research consent setting; "
                "start a separately named session"
            )
        emit({"resumed": True, "session_dir": str(location), **existing})
        return 0

    metadata = {
        "schema_version": SCHEMA_VERSION,
        "session_id": identifier,
        "label": label,
        "source": arguments.source or label,
        "created_at": timestamp(),
        "status": "active",
        "repository_root": str(repository),
        "git_common_dir": str(common),
        "checkout_head_sha": resolve_commit(repository, "HEAD"),
        "research_opt_in": arguments.research_consent,
        "snapshot": snapshot,
    }
    write_json(metadata_path, metadata)
    emit({"resumed": False, "session_dir": str(location), **metadata})
    return 0


def verification(repository: Path, metadata: dict[str, Any]) -> dict[str, Any]:
    snapshot = metadata["snapshot"]
    reasons: list[str] = []
    current_checkout = resolve_commit(repository, "HEAD")
    if current_checkout != metadata["checkout_head_sha"]:
        reasons.append("checkout_head_changed")

    if snapshot["kind"] == "worktree":
        current_digest, current_untracked = worktree_state(repository)
        if current_checkout != snapshot["head_sha"]:
            reasons.append("review_head_changed")
        if current_digest != snapshot["patch_sha256"]:
            reasons.append("working_tree_patch_changed")
        details = {"current_excluded_untracked_paths": current_untracked}
    else:
        current_digest = digest(
            committed_patch(
                repository, snapshot["merge_base_sha"], snapshot["head_sha"]
            )
        )
        if current_digest != snapshot["patch_sha256"]:
            reasons.append("pinned_patch_changed")

        for field, selector_field, reason in (
            ("base_sha", "base_selector", "base_ref_changed"),
            ("head_sha", "head_selector", "review_head_changed"),
        ):
            try:
                current_ref = resolve_commit(repository, snapshot[selector_field])
            except SessionError:
                reasons.append(f"{selector_field}_unavailable")
            else:
                if current_ref != snapshot[field]:
                    reasons.append(reason)
        details = {}

    return {
        "ok": not reasons,
        "session_id": metadata["session_id"],
        "review_head_sha": snapshot["head_sha"],
        "current_checkout_head_sha": current_checkout,
        "expected_patch_sha256": snapshot["patch_sha256"],
        "current_patch_sha256": current_digest,
        "reasons": reasons,
        **details,
    }


def verify(arguments: argparse.Namespace) -> int:
    repository, _location, metadata = load_session(arguments.repo, arguments.session)
    result = verification(repository, metadata)
    emit(result)
    return 0 if result["ok"] else 2


def show(arguments: argparse.Namespace) -> int:
    _repository, location, metadata = load_session(arguments.repo, arguments.session)
    findings_path = location / "findings.json"
    findings = read_json(findings_path) if findings_path.exists() else []
    emit({"session_dir": str(location), "findings": findings, **metadata})
    return 0


def listing(arguments: argparse.Namespace) -> int:
    _repository, common = repository_paths(arguments.repo)
    root = sessions_root(common, create=False)
    sessions: list[dict[str, Any]] = []
    if root.exists():
        for location in sorted(root.iterdir()):
            if not location.is_dir() or location.is_symlink():
                continue
            metadata = read_json(location / "session.json")
            sessions.append(
                {
                    "session_id": metadata["session_id"],
                    "source": metadata["source"],
                    "status": metadata["status"],
                    "created_at": metadata["created_at"],
                    "review_head_sha": metadata["snapshot"]["head_sha"],
                }
            )
    emit({"sessions": sessions})
    return 0


def add_finding(arguments: argparse.Namespace) -> int:
    repository, location, metadata = load_session(arguments.repo, arguments.session)
    if metadata["status"] != "active":
        raise SessionError("cannot add a finding to a completed session")
    result = verification(repository, metadata)
    if not result["ok"]:
        raise SessionError(
            "reviewed snapshot changed; start a new session before saving a finding: "
            + ", ".join(result["reasons"])
        )

    findings_path = location / "findings.json"
    findings = read_json(findings_path) if findings_path.exists() else []
    finding = {
        "created_at": timestamp(),
        "title": arguments.title,
        "anchor": arguments.anchor,
        "evidence_kind": arguments.evidence_kind,
        "detail": arguments.detail,
        "review_head_sha": metadata["snapshot"]["head_sha"],
    }
    findings.append(finding)
    write_json(findings_path, findings)
    emit({"saved": True, "finding": finding, "session_id": metadata["session_id"]})
    return 0


def add_event(arguments: argparse.Namespace) -> int:
    _repository, location, metadata = load_session(arguments.repo, arguments.session)
    if not metadata.get("research_opt_in"):
        raise SessionError("research telemetry is disabled; explicit consent is required")
    if metadata["status"] != "active":
        raise SessionError("cannot add telemetry to a completed session")

    try:
        payload = json.loads(arguments.data)
    except json.JSONDecodeError as error:
        raise SessionError(f"invalid event JSON: {error}") from error
    if not isinstance(payload, dict):
        raise SessionError("event data must be a JSON object")

    event = {"timestamp": timestamp(), "kind": arguments.kind, "data": payload}
    events_path = location / "events.jsonl"
    if events_path.is_symlink():
        raise SessionError("refusing to write telemetry through a symbolic link")
    descriptor = os.open(events_path, os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o600)
    with os.fdopen(descriptor, "a", encoding="utf-8") as stream:
        stream.write(json.dumps(event, ensure_ascii=False) + "\n")
        stream.flush()
        os.fsync(stream.fileno())
    events_path.chmod(0o600)
    emit({"recorded": True, "kind": arguments.kind, "session_id": metadata["session_id"]})
    return 0


def finish(arguments: argparse.Namespace) -> int:
    _repository, location, metadata = load_session(arguments.repo, arguments.session)
    metadata["status"] = "complete"
    metadata["completed_at"] = timestamp()
    write_json(location / "session.json", metadata)
    emit({"completed": True, "session_id": metadata["session_id"]})
    return 0


def common_arguments(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--repo", default=".", help="path inside the Git repository")


def parser() -> argparse.ArgumentParser:
    root = argparse.ArgumentParser(description=__doc__)
    commands = root.add_subparsers(dest="command", required=True)

    initialize_parser = commands.add_parser("init", help="create a private pinned session")
    common_arguments(initialize_parser)
    initialize_parser.add_argument("--session", required=True)
    initialize_parser.add_argument("--base")
    initialize_parser.add_argument("--head")
    initialize_parser.add_argument("--source")
    initialize_parser.add_argument("--worktree", action="store_true")
    initialize_parser.add_argument("--research-consent", action="store_true")
    initialize_parser.set_defaults(handler=initialize)

    for name, handler, help_text in (
        ("verify", verify, "verify that a session still matches its reviewed snapshot"),
        ("show", show, "read a private session and its saved findings"),
        ("finish", finish, "mark a session complete"),
    ):
        command = commands.add_parser(name, help=help_text)
        common_arguments(command)
        command.add_argument("--session", required=True)
        command.set_defaults(handler=handler)

    list_parser = commands.add_parser("list", help="list private sessions for a repository")
    common_arguments(list_parser)
    list_parser.set_defaults(handler=listing)

    finding_parser = commands.add_parser("finding", help="save a reviewer-approved finding")
    common_arguments(finding_parser)
    finding_parser.add_argument("--session", required=True)
    finding_parser.add_argument("--title", required=True)
    finding_parser.add_argument("--anchor", required=True)
    finding_parser.add_argument("--evidence-kind", choices=EVIDENCE_KINDS, required=True)
    finding_parser.add_argument("--detail", required=True)
    finding_parser.set_defaults(handler=add_finding)

    event_parser = commands.add_parser("event", help="record an explicitly consented research event")
    common_arguments(event_parser)
    event_parser.add_argument("--session", required=True)
    event_parser.add_argument("--kind", required=True)
    event_parser.add_argument("--data", default="{}")
    event_parser.set_defaults(handler=add_event)

    return root


def main() -> int:
    os.umask(0o077)
    arguments = parser().parse_args()
    if arguments.command == "init" and arguments.worktree and (arguments.base or arguments.head):
        raise SessionError("--worktree cannot be combined with --base or --head")
    return arguments.handler(arguments)


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except SessionError as error:
        print(json.dumps({"error": str(error)}), file=sys.stderr)
        raise SystemExit(1)
