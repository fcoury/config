#!/usr/bin/env python3
"""Safely verify, replace, and clean up a reconstructed PR branch.

The default action is read-only verification. Replacement and cleanup require
separate explicit confirmation strings. All state is persisted atomically in
the walkthrough manifest so interrupted operations can be resumed safely.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


SHA_RE = re.compile(r"^[0-9a-f]{40}(?:[0-9a-f]{24})?$")
REPLACE_CONFIRMATION = "REPLACE_PR_BRANCH"
CLEANUP_CONFIRMATION = "CLEANUP_TEMPORARY_RECONSTRUCTION"


class Refusal(RuntimeError):
    """A safety condition prevented the requested action."""


@dataclass
class CommandResult:
    returncode: int
    stdout: str
    stderr: str


def now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def run(
    args: list[str],
    *,
    cwd: Path | None = None,
    check: bool = True,
) -> CommandResult:
    completed = subprocess.run(
        args,
        cwd=str(cwd) if cwd else None,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    result = CommandResult(completed.returncode, completed.stdout, completed.stderr)
    if check and completed.returncode != 0:
        detail = completed.stderr.strip() or completed.stdout.strip() or "no output"
        raise Refusal(f"command failed ({' '.join(args)}): {detail}")
    return result


def git(repo: Path, *args: str, check: bool = True) -> CommandResult:
    return run(["git", "-C", str(repo), *args], check=check)


def load_manifest(path: Path) -> dict[str, Any]:
    try:
        data = json.loads(path.read_text())
    except FileNotFoundError as exc:
        raise Refusal(f"manifest does not exist: {path}") from exc
    except json.JSONDecodeError as exc:
        raise Refusal(f"manifest is not valid JSON: {exc}") from exc
    if not isinstance(data, dict):
        raise Refusal("manifest root must be an object")
    return data


def save_manifest(path: Path, manifest: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    fd, tmp_name = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "w") as handle:
            handle.write(payload)
            handle.flush()
            os.fsync(handle.fileno())
        os.replace(tmp_name, path)
    finally:
        if os.path.exists(tmp_name):
            os.unlink(tmp_name)


def require_object(parent: dict[str, Any], name: str) -> dict[str, Any]:
    value = parent.get(name)
    if not isinstance(value, dict):
        raise Refusal(f"manifest field {name!r} must be an object")
    return value


def require_string(parent: dict[str, Any], name: str) -> str:
    value = parent.get(name)
    if not isinstance(value, str) or not value:
        raise Refusal(f"manifest field {name!r} must be a non-empty string")
    return value


def require_sha(value: str, label: str) -> str:
    if not SHA_RE.fullmatch(value):
        raise Refusal(f"{label} must be a full lowercase Git SHA, got {value!r}")
    return value


def require_absolute_path(value: str, label: str) -> Path:
    path = Path(value)
    if not path.is_absolute():
        raise Refusal(f"{label} must be an absolute path: {value!r}")
    return path.resolve(strict=False)


def validate_manifest(path: Path, manifest: dict[str, Any]) -> dict[str, Any]:
    if manifest.get("schema_version") != 1:
        raise Refusal("manifest schema_version must be 1")

    pr = require_object(manifest, "pr")
    target = require_object(manifest, "target")
    reconciliation = require_object(manifest, "reconciliation")
    dependencies = require_object(manifest, "dependencies")
    finalization = require_object(manifest, "finalization")

    pr_url = require_string(pr, "url")
    if not pr_url.startswith("https://github.com/"):
        raise Refusal("pr.url must be an https://github.com pull request URL")
    head_repo = require_string(pr, "head_repo")
    if head_repo.count("/") != 1:
        raise Refusal("pr.head_repo must use owner/repository form")
    head_remote = require_string(pr, "head_remote")
    head_remote_url = require_string(pr, "head_remote_url")
    head_ref = require_string(pr, "head_ref")
    original_sha = require_sha(require_string(pr, "original_head_sha"), "original head SHA")
    require_sha(require_string(pr, "source_base_sha"), "source base SHA")

    worktree = require_absolute_path(require_string(target, "worktree"), "target.worktree")
    admin_worktree = require_absolute_path(
        require_string(target, "repository_admin_worktree"),
        "target.repository_admin_worktree",
    )
    if worktree == admin_worktree:
        raise Refusal("temporary worktree and repository admin worktree must differ")
    branch = require_string(target, "branch")
    rebuilt_sha = require_sha(require_string(target, "rebuilt_sha"), "rebuilt SHA")
    require_sha(require_string(target, "base_sha"), "target base SHA")
    if branch == head_ref:
        raise Refusal("temporary reconstruction branch must differ from the PR head branch")

    if not reconciliation.get("complete"):
        raise Refusal("reconciliation.complete must be true before finalization")
    dependent_prs = dependencies.get("dependent_prs")
    if not isinstance(dependent_prs, list):
        raise Refusal("dependencies.dependent_prs must be a list")
    if dependent_prs and not dependencies.get("impact_reviewed"):
        raise Refusal("dependent stacked PRs exist but their impact is not approved")

    backup_ref = require_string(finalization, "backup_ref")
    if not backup_ref.startswith("refs/heads/"):
        raise Refusal("finalization.backup_ref must be a full refs/heads/... ref")
    head_full_ref = f"refs/heads/{head_ref}"
    if backup_ref == head_full_ref:
        raise Refusal("backup ref must differ from the PR head ref")

    manifest_resolved = path.resolve(strict=False)
    try:
        manifest_resolved.relative_to(worktree)
    except ValueError:
        pass
    else:
        raise Refusal("manifest must live outside the temporary reconstruction worktree")

    return {
        "pr": pr,
        "target": target,
        "reconciliation": reconciliation,
        "dependencies": dependencies,
        "finalization": finalization,
        "pr_url": pr_url,
        "head_repo": head_repo,
        "head_remote": head_remote,
        "head_remote_url": head_remote_url,
        "head_ref": head_ref,
        "head_full_ref": head_full_ref,
        "original_sha": original_sha,
        "worktree": worktree,
        "admin_worktree": admin_worktree,
        "branch": branch,
        "rebuilt_sha": rebuilt_sha,
        "backup_ref": backup_ref,
    }


def record_checkpoint(
    path: Path,
    manifest: dict[str, Any],
    phase: str,
    **values: Any,
) -> None:
    finalization = require_object(manifest, "finalization")
    finalization["phase"] = phase
    finalization["updated_at"] = now_iso()
    finalization["last_error"] = None
    finalization.update(values)
    save_manifest(path, manifest)


def record_failure(
    path: Path,
    manifest: dict[str, Any],
    operation: str,
    message: str,
    **values: Any,
) -> None:
    finalization = require_object(manifest, "finalization")
    finalization["last_error"] = {
        "operation": operation,
        "message": message,
        "observed_at": now_iso(),
        **values,
    }
    save_manifest(path, manifest)


def current_branch(repo: Path) -> str:
    return git(repo, "symbolic-ref", "--quiet", "--short", "HEAD").stdout.strip()


def current_head(repo: Path) -> str:
    return git(repo, "rev-parse", "HEAD").stdout.strip()


def is_clean(repo: Path) -> bool:
    return not git(repo, "status", "--porcelain=v1", "--untracked-files=all").stdout.strip()


def local_ref(repo: Path, ref: str) -> str | None:
    result = git(repo, "rev-parse", "--verify", ref, check=False)
    if result.returncode != 0:
        return None
    value = result.stdout.strip()
    return value if SHA_RE.fullmatch(value) else None


def remote_ref(repo: Path, remote: str, ref: str) -> str | None:
    result = git(repo, "ls-remote", "--refs", remote, ref)
    lines = [line for line in result.stdout.splitlines() if line.strip()]
    if not lines:
        return None
    if len(lines) != 1:
        raise Refusal(f"remote query for {ref} returned multiple refs")
    sha, observed_ref = lines[0].split(maxsplit=1)
    if observed_ref != ref or not SHA_RE.fullmatch(sha):
        raise Refusal(f"unexpected ls-remote result for {ref}: {lines[0]!r}")
    return sha


def pr_metadata(pr_url: str, repo: Path) -> dict[str, Any]:
    result = run(
        [
            "gh",
            "pr",
            "view",
            pr_url,
            "--json",
            "headRefOid,headRefName,headRepository,headRepositoryOwner",
        ],
        cwd=repo,
    )
    try:
        value = json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        raise Refusal(f"gh returned invalid PR JSON: {exc}") from exc
    if not isinstance(value, dict):
        raise Refusal("gh PR response must be an object")
    return value


def pr_head_repo(metadata: dict[str, Any]) -> str:
    repository = metadata.get("headRepository")
    owner = metadata.get("headRepositoryOwner")
    if isinstance(repository, dict):
        name_with_owner = repository.get("nameWithOwner")
        if isinstance(name_with_owner, str) and name_with_owner:
            return name_with_owner
        name = repository.get("name")
        owner_login = owner.get("login") if isinstance(owner, dict) else None
        if isinstance(name, str) and isinstance(owner_login, str):
            return f"{owner_login}/{name}"
    raise Refusal("unable to resolve the PR's actual head repository from GitHub")


def verify_pr_identity(
    metadata: dict[str, Any],
    *,
    expected_repo: str,
    expected_ref: str,
) -> str:
    observed_repo = pr_head_repo(metadata)
    observed_ref = metadata.get("headRefName")
    observed_sha = metadata.get("headRefOid")
    if observed_repo != expected_repo:
        raise Refusal(
            f"PR head repository moved: expected {expected_repo}, observed {observed_repo}"
        )
    if observed_ref != expected_ref:
        raise Refusal(f"PR head ref moved: expected {expected_ref}, observed {observed_ref}")
    if not isinstance(observed_sha, str) or not SHA_RE.fullmatch(observed_sha):
        raise Refusal(f"GitHub returned an invalid PR head SHA: {observed_sha!r}")
    return observed_sha


def worktree_entries(repo: Path) -> list[dict[str, str]]:
    output = git(repo, "worktree", "list", "--porcelain").stdout
    entries: list[dict[str, str]] = []
    current: dict[str, str] = {}
    for line in output.splitlines() + [""]:
        if not line:
            if current:
                entries.append(current)
                current = {}
            continue
        key, _, value = line.partition(" ")
        current[key] = value
    return entries


def original_branch_worktrees(context: dict[str, Any]) -> list[dict[str, Any]]:
    expected_branch = f"refs/heads/{context['head_ref']}"
    matches: list[dict[str, Any]] = []
    for entry in worktree_entries(context["admin_worktree"]):
        if entry.get("branch") != expected_branch:
            continue
        path = Path(entry["worktree"]).resolve(strict=False)
        matches.append({"path": str(path), "clean": path.exists() and is_clean(path)})
    return matches


def verify_repository(context: dict[str, Any]) -> None:
    worktree: Path = context["worktree"]
    admin: Path = context["admin_worktree"]
    if not worktree.exists():
        raise Refusal(f"temporary worktree does not exist: {worktree}")
    if not admin.exists():
        raise Refusal(f"repository admin worktree does not exist: {admin}")
    if git(worktree, "rev-parse", "--is-inside-work-tree").stdout.strip() != "true":
        raise Refusal(f"not a Git worktree: {worktree}")
    if current_branch(worktree) != context["branch"]:
        raise Refusal(
            f"temporary branch mismatch: expected {context['branch']}, "
            f"observed {current_branch(worktree)}"
        )
    if current_head(worktree) != context["rebuilt_sha"]:
        raise Refusal(
            f"temporary HEAD mismatch: expected {context['rebuilt_sha']}, "
            f"observed {current_head(worktree)}"
        )
    if not is_clean(worktree):
        raise Refusal("temporary reconstruction worktree is dirty")
    remote_url = git(worktree, "remote", "get-url", context["head_remote"]).stdout.strip()
    if remote_url != context["head_remote_url"]:
        raise Refusal(
            "head remote URL mismatch: "
            f"expected {context['head_remote_url']!r}, observed {remote_url!r}"
        )
    if git(worktree, "cat-file", "-e", f"{context['original_sha']}^{{commit}}", check=False).returncode:
        raise Refusal("original PR head commit is not available locally; fetch it explicitly first")
    if git(worktree, "cat-file", "-e", f"{context['rebuilt_sha']}^{{commit}}", check=False).returncode:
        raise Refusal("rebuilt commit is not available locally")
    for ref in (context["head_full_ref"], context["backup_ref"]):
        if git(worktree, "check-ref-format", ref, check=False).returncode:
            raise Refusal(f"invalid full Git ref: {ref}")


def collect_status(context: dict[str, Any]) -> dict[str, Any]:
    verify_repository(context)
    remote_sha = remote_ref(
        context["worktree"], context["head_remote"], context["head_full_ref"]
    )
    backup_sha = remote_ref(
        context["worktree"], context["head_remote"], context["backup_ref"]
    )
    metadata = pr_metadata(context["pr_url"], context["worktree"])
    pr_sha = verify_pr_identity(
        metadata,
        expected_repo=context["head_repo"],
        expected_ref=context["head_ref"],
    )
    originals = original_branch_worktrees(context)
    blockers: list[str] = []
    if remote_sha not in (context["original_sha"], context["rebuilt_sha"]):
        blockers.append(
            f"remote head is {remote_sha or 'missing'}, not the original or rebuilt SHA"
        )
    if pr_sha not in (context["original_sha"], context["rebuilt_sha"]):
        blockers.append(f"PR head is {pr_sha}, not the original or rebuilt SHA")
    dirty_originals = [entry["path"] for entry in originals if not entry["clean"]]
    if dirty_originals:
        blockers.append("original PR branch is dirty in: " + ", ".join(dirty_originals))
    clean_originals = [entry["path"] for entry in originals if entry["clean"]]
    if clean_originals and not context["finalization"].get(
        "original_checkout_acknowledged"
    ):
        blockers.append(
            "original PR branch is checked out separately; acknowledge that those clean "
            "checkouts will be preserved and locally stale"
        )
    return {
        "remote_head_sha": remote_sha,
        "pr_head_sha": pr_sha,
        "backup_sha": backup_sha,
        "original_branch_worktrees": originals,
        "blockers": blockers,
    }


def verify_action(context: dict[str, Any]) -> int:
    status = collect_status(context)
    result = {
        "action": "verify",
        "read_only": True,
        "ok": not status["blockers"],
        **status,
    }
    print(json.dumps(result, indent=2, sort_keys=True))
    return 0 if result["ok"] else 2


def require_replacement_authorization(
    context: dict[str, Any],
    *,
    expected_remote_sha: str | None,
    rebuilt_sha: str | None,
    backup_ref: str | None,
    confirmation: str | None,
) -> None:
    if confirmation != REPLACE_CONFIRMATION:
        raise Refusal(
            f"replacement requires --confirm {REPLACE_CONFIRMATION}; verification is the default"
        )
    if context["finalization"].get("decision") != "replace":
        raise Refusal("manifest finalization.decision must be the explicit value 'replace'")
    if expected_remote_sha != context["original_sha"]:
        raise Refusal("--expected-remote-sha must exactly match the pinned original head SHA")
    if rebuilt_sha != context["rebuilt_sha"]:
        raise Refusal("--rebuilt-sha must exactly match the reconciled rebuilt SHA")
    if backup_ref != context["backup_ref"]:
        raise Refusal("--backup-ref must exactly match the manifest backup ref")


def replace_action(
    manifest_path: Path,
    manifest: dict[str, Any],
    context: dict[str, Any],
    *,
    expected_remote_sha: str | None,
    rebuilt_sha: str | None,
    backup_ref: str | None,
    confirmation: str | None,
) -> int:
    require_replacement_authorization(
        context,
        expected_remote_sha=expected_remote_sha,
        rebuilt_sha=rebuilt_sha,
        backup_ref=backup_ref,
        confirmation=confirmation,
    )
    try:
        status = collect_status(context)
        if status["blockers"]:
            raise Refusal("; ".join(status["blockers"]))

        remote_sha = status["remote_head_sha"]
        pr_sha = status["pr_head_sha"]
        backup_sha = status["backup_sha"]

        if remote_sha == context["rebuilt_sha"]:
            if backup_sha != context["original_sha"]:
                raise Refusal(
                    "remote already points to rebuilt SHA but the verified original backup is missing"
                )
            if pr_sha != context["rebuilt_sha"]:
                record_checkpoint(
                    manifest_path,
                    manifest,
                    "remote_verified_pr_pending",
                    backup_verified_sha=backup_sha,
                    remote_verified_sha=remote_sha,
                )
                raise Refusal(
                    "remote replacement is complete but GitHub has not reported the rebuilt PR "
                    "head; rerun replace after GitHub catches up"
                )
            record_checkpoint(
                manifest_path,
                manifest,
                "pr_verified",
                backup_verified_sha=backup_sha,
                remote_verified_sha=remote_sha,
                pr_verified_sha=pr_sha,
            )
            print("replacement already complete and fully verified")
            return 0

        if remote_sha != context["original_sha"] or pr_sha != context["original_sha"]:
            raise Refusal(
                "concurrent movement detected before backup: remote and PR heads must both "
                "equal the pinned original SHA"
            )

        if backup_sha is None:
            record_checkpoint(manifest_path, manifest, "backup_pending")
            push_backup = git(
                context["worktree"],
                "push",
                "--porcelain",
                f"--force-with-lease={context['backup_ref']}:",
                context["head_remote"],
                f"{context['original_sha']}:{context['backup_ref']}",
                check=False,
            )
            if push_backup.returncode != 0:
                raise Refusal(
                    "backup push failed: "
                    + (push_backup.stderr.strip() or push_backup.stdout.strip() or "no output")
                )
            backup_sha = remote_ref(
                context["worktree"], context["head_remote"], context["backup_ref"]
            )
        if backup_sha != context["original_sha"]:
            raise Refusal(
                f"backup ref conflict: expected {context['original_sha']}, observed "
                f"{backup_sha or 'missing'}"
            )
        record_checkpoint(
            manifest_path,
            manifest,
            "backup_verified",
            backup_verified_sha=backup_sha,
        )

        remote_sha = remote_ref(
            context["worktree"], context["head_remote"], context["head_full_ref"]
        )
        metadata = pr_metadata(context["pr_url"], context["worktree"])
        pr_sha = verify_pr_identity(
            metadata,
            expected_repo=context["head_repo"],
            expected_ref=context["head_ref"],
        )
        if remote_sha != context["original_sha"] or pr_sha != context["original_sha"]:
            raise Refusal(
                "concurrent movement detected after backup; replacement was not attempted"
            )

        record_checkpoint(manifest_path, manifest, "replacement_attempting")
        push = git(
            context["worktree"],
            "push",
            "--porcelain",
            f"--force-with-lease={context['head_full_ref']}:{context['original_sha']}",
            context["head_remote"],
            f"{context['rebuilt_sha']}:{context['head_full_ref']}",
            check=False,
        )
        observed_remote = remote_ref(
            context["worktree"], context["head_remote"], context["head_full_ref"]
        )
        if push.returncode != 0 and observed_remote != context["rebuilt_sha"]:
            raise Refusal(
                "exact-lease replacement failed: "
                + (push.stderr.strip() or push.stdout.strip() or "no output")
            )
        if observed_remote != context["rebuilt_sha"]:
            raise Refusal(
                f"replacement push returned but remote head is {observed_remote or 'missing'}"
            )
        if remote_ref(
            context["worktree"], context["head_remote"], context["backup_ref"]
        ) != context["original_sha"]:
            raise Refusal("original backup changed or disappeared after replacement")
        record_checkpoint(
            manifest_path,
            manifest,
            "remote_verified_pr_pending",
            backup_verified_sha=context["original_sha"],
            remote_verified_sha=observed_remote,
        )

        metadata = pr_metadata(context["pr_url"], context["worktree"])
        observed_pr = verify_pr_identity(
            metadata,
            expected_repo=context["head_repo"],
            expected_ref=context["head_ref"],
        )
        if observed_pr != context["rebuilt_sha"]:
            raise Refusal(
                "remote replacement succeeded, but GitHub has not reported the rebuilt PR head; "
                "retain all state and rerun replace after GitHub catches up"
            )
        record_checkpoint(
            manifest_path,
            manifest,
            "pr_verified",
            backup_verified_sha=context["original_sha"],
            remote_verified_sha=observed_remote,
            pr_verified_sha=observed_pr,
        )
        print(
            f"replaced {context['head_full_ref']} with {context['rebuilt_sha']} after "
            f"verifying backup {context['backup_ref']}"
        )
        return 0
    except Refusal as exc:
        record_failure(manifest_path, manifest, "replace", str(exc))
        raise


def cleanup_action(
    manifest_path: Path,
    manifest: dict[str, Any],
    context: dict[str, Any],
    *,
    confirmation: str | None,
) -> int:
    if confirmation != CLEANUP_CONFIRMATION:
        raise Refusal(
            f"cleanup requires --confirm {CLEANUP_CONFIRMATION}; it is never part of replacement"
        )
    if context["finalization"].get("phase") not in ("pr_verified", "cleanup_partial"):
        raise Refusal("cleanup is blocked until replacement, remote head, and PR head are verified")

    try:
        admin: Path = context["admin_worktree"]
        if not admin.exists():
            raise Refusal(f"repository admin worktree does not exist: {admin}")
        remote_sha = remote_ref(admin, context["head_remote"], context["head_full_ref"])
        backup_sha = remote_ref(admin, context["head_remote"], context["backup_ref"])
        metadata = pr_metadata(context["pr_url"], admin)
        pr_sha = verify_pr_identity(
            metadata,
            expected_repo=context["head_repo"],
            expected_ref=context["head_ref"],
        )
        if remote_sha != context["rebuilt_sha"] or pr_sha != context["rebuilt_sha"]:
            raise Refusal("cleanup guard failed: remote and PR heads must still equal rebuilt SHA")
        if backup_sha != context["original_sha"]:
            raise Refusal("cleanup guard failed: verified original backup is missing or changed")

        target_exists = context["worktree"].exists()
        if target_exists:
            if not is_clean(context["worktree"]):
                raise Refusal("temporary reconstruction worktree became dirty; cleanup refused")
            if current_head(context["worktree"]) != context["rebuilt_sha"]:
                raise Refusal("temporary worktree HEAD changed; cleanup refused")
            if current_branch(context["worktree"]) != context["branch"]:
                raise Refusal("temporary worktree branch changed; cleanup refused")
            removal = git(
                admin,
                "worktree",
                "remove",
                str(context["worktree"]),
                check=False,
            )
            if removal.returncode != 0:
                raise Refusal(
                    "temporary worktree removal failed: "
                    + (removal.stderr.strip() or removal.stdout.strip() or "no output")
                )
            record_checkpoint(
                manifest_path,
                manifest,
                "cleanup_partial",
                cleanup_worktree_removed=True,
            )

        temp_ref = f"refs/heads/{context['branch']}"
        observed_temp = local_ref(admin, temp_ref)
        if observed_temp is not None:
            if observed_temp != context["rebuilt_sha"]:
                raise Refusal(
                    f"temporary branch moved to {observed_temp}; expected {context['rebuilt_sha']}"
                )
            deletion = git(
                admin,
                "update-ref",
                "-d",
                temp_ref,
                context["rebuilt_sha"],
                check=False,
            )
            if deletion.returncode != 0:
                raise Refusal(
                    "temporary branch deletion failed: "
                    + (deletion.stderr.strip() or deletion.stdout.strip() or "no output")
                )

        record_checkpoint(
            manifest_path,
            manifest,
            "cleanup_complete",
            cleanup_worktree_removed=True,
            cleanup_branch_removed=True,
        )
        print(
            "removed only the temporary reconstruction worktree and local branch; "
            "durable state and remote backup were retained"
        )
        return 0
    except Refusal as exc:
        record_failure(manifest_path, manifest, "cleanup", str(exc))
        raise


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "action",
        nargs="?",
        choices=("verify", "replace", "cleanup"),
        default="verify",
        help="default: verify (read-only)",
    )
    parser.add_argument("--manifest", required=True, type=Path)
    parser.add_argument("--expected-remote-sha")
    parser.add_argument("--rebuilt-sha")
    parser.add_argument("--backup-ref")
    parser.add_argument("--confirm")
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    manifest_path = args.manifest.resolve(strict=False)
    try:
        manifest = load_manifest(manifest_path)
        context = validate_manifest(manifest_path, manifest)
        if args.action == "verify":
            return verify_action(context)
        if args.action == "replace":
            return replace_action(
                manifest_path,
                manifest,
                context,
                expected_remote_sha=args.expected_remote_sha,
                rebuilt_sha=args.rebuilt_sha,
                backup_ref=args.backup_ref,
                confirmation=args.confirm,
            )
        return cleanup_action(
            manifest_path,
            manifest,
            context,
            confirmation=args.confirm,
        )
    except Refusal as exc:
        print(f"REFUSED: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
