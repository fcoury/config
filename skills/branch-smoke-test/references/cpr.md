# CPR ownership

When `CPR_PR` and `CPR_WORKTREE` identify a CPR launch, register task-owned disposable resources so the user's separate `cpr-clean <PR>` can find them.

```fish
set raw_dir (cpr-track --tempdir); or exit 1
set smoke_pane (cpr-track --new-session "$session_name"); or exit 1
```

`--new-session` creates a detached Fish pane in the worktree and registers it atomically. Use ordinary tmux commands for windows and scenarios. Pass `--socket /absolute/socket` for a custom server.

For an existing session, use `cpr-track --session "$session_name"` while its panes remain in the worktree. Register other disposable directories with `--path /absolute/directory`. Register background PIDs with `--pid $pid` before their parents exit, especially processes that detach or change directory. Keep isolated fixtures, downloads and raw logs under the registered temporary directory.

Register only this task's local disposable resources. Shared caches, personal files and remote resources do not belong in the teardown manifest. On a registration error, stop creating resources and report the setup failure. Retain the normal smoke session and evidence after the run.
