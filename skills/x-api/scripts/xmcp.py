#!/usr/bin/env python3
"""Install and launch the official X XMCP server with guarded tool profiles."""

from __future__ import annotations

import argparse
import os
import re
import shlex
import stat
import subprocess
import sys
from pathlib import Path

REPOSITORY_URL = "https://github.com/xdevplatform/xmcp.git"
PINNED_REVISION = "63d34362d88ed9f94d54ccd5ecd5bb4d12e11759"
REQUIRED_CREDENTIALS = (
    "X_OAUTH_CONSUMER_KEY",
    "X_OAUTH_CONSUMER_SECRET",
    "X_BEARER_TOKEN",
)
RESERVED_PROFILE_VARIABLES = (
    "X_API_TOOL_ALLOWLIST",
    "X_API_TOOL_DENYLIST",
    "X_API_TOOL_TAGS",
)
READ_TOOL_ALLOWLIST = (
    "getAccountActivitySubscriptionCount",
    "getActivitySubscriptions",
    "getChatConversation",
    "getChatConversations",
    "getCommunitiesById",
    "getComplianceJobs",
    "getComplianceJobsById",
    "getConnectionHistory",
    "getDirectMessagesEvents",
    "getDirectMessagesEventsByConversationId",
    "getDirectMessagesEventsById",
    "getDirectMessagesEventsByParticipantId",
    "getInsights28Hr",
    "getInsightsHistorical",
    "getListsById",
    "getListsFollowers",
    "getListsMembers",
    "getListsPosts",
    "getMarketplaceHandleAvailability",
    "getMediaAnalytics",
    "getMediaByMediaKey",
    "getMediaByMediaKeys",
    "getMediaUploadStatus",
    "getNews",
    "getOpenApiSpec",
    "getPostsAnalytics",
    "getPostsById",
    "getPostsByIds",
    "getPostsCountsAll",
    "getPostsCountsRecent",
    "getPostsLikingUsers",
    "getPostsQuotedPosts",
    "getPostsRepostedBy",
    "getPostsReposts",
    "getSpacesBuyers",
    "getSpacesByCreatorIds",
    "getSpacesById",
    "getSpacesByIds",
    "getSpacesPosts",
    "getTrendsByWoeid",
    "getTrendsPersonalizedTrends",
    "getUsage",
    "getUserPublicKeys",
    "getUsersAffiliates",
    "getUsersBlocking",
    "getUsersBookmarkFolders",
    "getUsersBookmarks",
    "getUsersBookmarksByFolderId",
    "getUsersById",
    "getUsersByIds",
    "getUsersByUsername",
    "getUsersByUsernames",
    "getUsersFollowedLists",
    "getUsersFollowers",
    "getUsersFollowing",
    "getUsersLikedPosts",
    "getUsersListMemberships",
    "getUsersMe",
    "getUsersMentions",
    "getUsersMuting",
    "getUsersOwnedLists",
    "getUsersPinnedLists",
    "getUsersPosts",
    "getUsersRepostsOfMe",
    "getUsersTimeline",
    "searchCommunities",
    "searchCommunityNotesWritten",
    "searchEligiblePosts",
    "searchNews",
    "searchPostsAll",
    "searchPostsRecent",
    "searchSpaces",
    "searchUsers",
)
ENV_TEMPLATE = """# X Developer Platform credentials. Keep this file private and uncommitted.
X_OAUTH_CONSUMER_KEY=
X_OAUTH_CONSUMER_SECRET=
X_BEARER_TOKEN=

# OAuth1 callback registered in the X Developer App.
X_OAUTH_CALLBACK_HOST=127.0.0.1
X_OAUTH_CALLBACK_PORT=8976
X_OAUTH_CALLBACK_PATH=/oauth/callback
X_OAUTH_CALLBACK_TIMEOUT=300

# XMCP API and local MCP endpoint settings.
X_API_BASE_URL=https://api.x.com
X_API_TIMEOUT=30
X_API_DEBUG=0
MCP_HOST=127.0.0.1
MCP_PORT=8000
"""
ENV_KEY_PATTERN = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


class LauncherError(RuntimeError):
    """Raised for actionable setup or launcher validation failures."""


def runtime_path() -> Path:
    return Path(
        os.environ.get("X_API_XMCP_HOME", "~/.local/share/x-api/xmcp")
    ).expanduser()


def credentials_path() -> Path:
    return Path(
        os.environ.get("X_API_XMCP_ENV", "~/.config/x-api/xmcp.env")
    ).expanduser()


def format_command(command: list[str]) -> str:
    return " ".join(shlex.quote(value) for value in command)


def run(command: list[str], *, dry_run: bool = False, capture: bool = False) -> str:
    if dry_run:
        print(f"+ {format_command(command)}")
        return ""
    result = subprocess.run(
        command,
        check=True,
        text=True,
        stdout=subprocess.PIPE if capture else None,
        stderr=subprocess.PIPE if capture else None,
    )
    return result.stdout.strip() if capture else ""


def ensure_managed_checkout(checkout: Path, *, dry_run: bool) -> None:
    if checkout.exists() and not (checkout / ".git").is_dir():
        raise LauncherError(f"Runtime path exists but is not an XMCP git checkout: {checkout}")
    if not checkout.exists():
        run(["git", "clone", REPOSITORY_URL, str(checkout)], dry_run=dry_run)
    if checkout.exists() and not dry_run:
        dirty = run(
            ["git", "-C", str(checkout), "status", "--porcelain", "--untracked-files=no"],
            capture=True,
        )
        if dirty:
            raise LauncherError(f"Refusing to update a modified XMCP checkout: {checkout}")
    run(
        ["git", "-C", str(checkout), "fetch", "--depth", "1", "origin", PINNED_REVISION],
        dry_run=dry_run,
    )
    run(["git", "-C", str(checkout), "checkout", "--detach", PINNED_REVISION], dry_run=dry_run)


def create_credentials_template(path: Path, *, dry_run: bool) -> None:
    if path.exists():
        print(f"Credential file already exists: {path}")
        return
    if dry_run:
        print(f"+ create credential template with mode 0600: {path}")
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    descriptor = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    with os.fdopen(descriptor, "w", encoding="utf-8") as handle:
        handle.write(ENV_TEMPLATE)
    path.chmod(0o600)
    print(f"Created credential template: {path}")


def install(args: argparse.Namespace) -> None:
    checkout = runtime_path()
    env_file = credentials_path()
    print(f"XMCP runtime: {checkout}")
    ensure_managed_checkout(checkout, dry_run=args.dry_run)
    venv_python = checkout / ".venv" / "bin" / "python"
    if args.dry_run or not venv_python.exists():
        run([sys.executable, "-m", "venv", str(checkout / ".venv")], dry_run=args.dry_run)
    run(
        [str(venv_python), "-m", "pip", "install", "-r", str(checkout / "requirements.txt")],
        dry_run=args.dry_run,
    )
    create_credentials_template(env_file, dry_run=args.dry_run)
    if not args.dry_run:
        print("Installed XMCP. Add X Developer Platform values to the credential file locally.")


def parse_env_file(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        if stripped.startswith("export "):
            stripped = stripped[7:].lstrip()
        key, separator, value = stripped.partition("=")
        key = key.strip()
        if not separator or not ENV_KEY_PATTERN.fullmatch(key):
            raise LauncherError(f"Invalid credential-file assignment at {path}:{line_number}")
        value = value.strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in {"'", '"'}:
            value = value[1:-1]
        values[key] = value
    return values


def validate_installation(checkout: Path) -> list[str]:
    failures: list[str] = []
    if not (checkout / ".git").is_dir():
        return [f"Missing installed XMCP checkout: {checkout}"]
    if not (checkout / "server.py").is_file():
        failures.append(f"Missing XMCP server.py under {checkout}")
    if not (checkout / ".venv" / "bin" / "python").is_file():
        failures.append(f"Missing XMCP virtualenv under {checkout}")
    local_env = checkout / ".env"
    if local_env.exists():
        failures.append(f"Remove unsafe checkout-local credential override: {local_env}")
    try:
        revision = run(["git", "-C", str(checkout), "rev-parse", "HEAD"], capture=True)
        if revision != PINNED_REVISION:
            failures.append(
                f"XMCP checkout is not pinned at {PINNED_REVISION}; run the installer again."
            )
    except subprocess.CalledProcessError:
        failures.append(f"Unable to read XMCP revision under {checkout}")
    return failures


def validate_credentials(path: Path) -> tuple[dict[str, str], list[str]]:
    if not path.is_file():
        return {}, [f"Missing credential file: {path}"]
    failures: list[str] = []
    mode = stat.S_IMODE(path.stat().st_mode)
    if mode != 0o600:
        failures.append(f"Credential file permissions must be 0600, found {mode:04o}: {path}")
    values = parse_env_file(path)
    missing = [key for key in REQUIRED_CREDENTIALS if not values.get(key, "").strip()]
    if missing:
        failures.append("Missing required credential variables: " + ", ".join(missing))
    reserved = [key for key in RESERVED_PROFILE_VARIABLES if key in values]
    if reserved:
        failures.append(
            "Remove tool-profile variables from the credential file: " + ", ".join(reserved)
        )
    return values, failures


def doctor(_: argparse.Namespace) -> None:
    checkout = runtime_path()
    env_file = credentials_path()
    failures = validate_installation(checkout)
    _, credential_failures = validate_credentials(env_file)
    failures.extend(credential_failures)
    if failures:
        for failure in failures:
            print(f"ERROR: {failure}", file=sys.stderr)
        raise LauncherError("XMCP setup is not ready.")
    print(f"XMCP checkout pinned at {PINNED_REVISION}")
    print(f"Credential file is configured with mode 0600: {env_file}")
    print("XMCP setup is ready. No credential values were displayed.")


def serve(args: argparse.Namespace) -> None:
    checkout = runtime_path()
    env_file = credentials_path()
    if args.dry_run:
        print(f"XMCP runtime: {checkout}")
        print(f"Credential file: {env_file}")
        print(f"Profile: {args.profile}")
        if args.profile == "read":
            print(f"Read-only allowlist tool count: {len(READ_TOOL_ALLOWLIST)}")
        else:
            print("Write profile exposes the official non-streaming XMCP operation surface.")
        print(f"+ {checkout / '.venv' / 'bin' / 'python'} {checkout / 'server.py'}")
        return

    failures = validate_installation(checkout)
    values, credential_failures = validate_credentials(env_file)
    failures.extend(credential_failures)
    if failures:
        for failure in failures:
            print(f"ERROR: {failure}", file=sys.stderr)
        raise LauncherError("XMCP setup is not ready.")

    environment = os.environ.copy()
    environment.update(values)
    for key in RESERVED_PROFILE_VARIABLES:
        environment[key] = ""
    environment["X_OAUTH_PRINT_TOKENS"] = "0"
    environment["X_OAUTH_PRINT_AUTH_HEADER"] = "0"
    if args.profile == "read":
        environment["X_API_TOOL_ALLOWLIST"] = ",".join(READ_TOOL_ALLOWLIST)
    print(f"Starting XMCP in {args.profile} profile. OAuth consent may open in a browser.")
    os.execve(
        str(checkout / ".venv" / "bin" / "python"),
        [str(checkout / ".venv" / "bin" / "python"), str(checkout / "server.py")],
        environment,
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    install_parser = subparsers.add_parser("install", help="Install pinned official XMCP locally.")
    install_parser.add_argument("--dry-run", action="store_true")
    install_parser.set_defaults(function=install)
    doctor_parser = subparsers.add_parser("doctor", help="Validate local XMCP setup safely.")
    doctor_parser.set_defaults(function=doctor)
    serve_parser = subparsers.add_parser("serve", help="Start XMCP with a guarded tool profile.")
    serve_parser.add_argument("--profile", choices=("read", "write"), default="read")
    serve_parser.add_argument("--dry-run", action="store_true")
    serve_parser.set_defaults(function=serve)
    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        args.function(args)
    except (LauncherError, OSError, subprocess.CalledProcessError) as error:
        print(f"xmcp: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
