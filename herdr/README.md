# Saving and restoring Codex sessions externally

Run this while the agents are still running, before stopping Herdr:

```sh
herdr-codex check  # inspect only
herdr-codex save   # repair and verify autosave
```

Use `--session NAME` for another local Herdr session. The default is explicitly
the local `default` session, even when invoked from a pane in a different session.
Requires Python 3.10+, `herdr`, and `lsof` on PATH. No Codex hooks are needed.

The script finds each Codex pane's foreground PID through Herdr, reads session
metadata from that process's open rollout files, and excludes subagent sessions.
It reports verified IDs to Herdr using the session-report API and waits up to
15 seconds to confirm the references appear in that session's `session.json`.
Before the first repair, it backs up the saved layout and live snapshot under
`~/.cache/herdr-save-codex/`. The old `herdr-save-codex [--check]` command remains
a compatibility wrapper. Exit 0 means all detected Codex panes were verified;
1 means drift in check mode or unresolved panes, and 2 means inspection failed.
Confirmed panes can be repaired even if others remain unresolved.

Unreadable/deleted rollouts, multiple main conversations, and panes without an
open main rollout are left unresolved. A new empty conversation may fall into
that last case until Codex opens its rollout. Nondefault Codex homes are also
left unresolved because they need their own resume environment. The script never
guesses from titles, searches for the newest session, copies conversation data,
or stops agents. Existing Codex rollout files must remain on disk to resume.
As with Herdr's native integration, restores use `codex resume ID` from PATH;
the original executable and command-line options are not preserved.

The script runs once; run it again before each shutdown. For regular detach and
reattach, the original processes keep running and don't need restoration.

## Restoring after a restart

First open `herdr` to restore the workspace/tab/pane layout. If its automatic
Codex resume ran before Fish finished startup, run from another terminal:

```sh
herdr-codex restore --dry-run  # preview eligible panes across all workspaces
herdr-codex restore            # resume them and verify the conversation IDs
```

Restore uses the current session's saved pane-to-conversation mapping. It does
not rebuild layouts, replace session.json, or read older backup layouts. Panes
without a saved Codex reference are left alone. Already-running Codex sessions
are checked and skipped; other foreground commands are left alone.

This is tailored to the repository's Fish/Starship prompt: the shell must be
the only foreground process and its final visible line must be the empty `> $`
prompt. Downloads, startup output and partial command drafts do not qualify.
Restore polls pending panes for up to 60 seconds, including startup children
while Fish owns the foreground group. Other foreground commands are skipped.
`--wait SECONDS` adjusts this limit and the subsequent shared verification limit.
Ready panes receive commands before Codex startup verification. It checks terminal
identity/reference/readiness again before sending, then verifies the exact main
rollout is open by Codex. A failed or unverified submission is never resent in
the same run. If it times out, inspect that pane before retrying.

Missing/deleted conversation files, duplicate IDs and unsupported custom homes
remain unresolved. Restores use `codex resume ID` from PATH, without preserving
the original executable or options. Preview never sends commands or waits for
unready shells. Layout restoration still belongs to Herdr.
