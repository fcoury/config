## Tools

## Browser Automation

Use `agent-browser` for web automation. Run `agent-browser --help` for all commands.

Core workflow:

1. `agent-browser open <url>` - Navigate to page
2. `agent-browser snapshot -i` - Get interactive elements with refs (@e1, @e2)
3. `agent-browser click @e1` / `fill @e2 "text"` - Interact using refs
4. Re-snapshot after page changes

### tmux

- When to use: long/hanging commands (servers, debuggers, long tests, interactive CLIs) should start in tmux; avoid `tmux wait-for` and `while tmux …` loops; if a run exceeds ~10 min, treat it as potentially hung and inspect via tmux.
- Start: `tmux new -d -s codex-shell -n shell`
- Show user how to watch:
  - Attach: `tmux attach -t codex-shell`
  - One-off capture: `tmux capture-pane -p -J -t codex-shell:0.0 -S -200`
- Send keys safely: `tmux send-keys -t codex-shell:0.0 -- 'python3 -q' Enter` (set `PYTHON_BASIC_REPL=1` for Python REPLs).
- Wait for prompts: `./scripts/tmux/wait-for-text.sh -t codex-shell:0.0 -p '^>>>' -T 15 -l 2000` (add `-F` for fixed string).
- List sessions: `tmux list-sessions` or `./scripts/tmux/find-sessions.sh`.
- Cleanup: `tmux kill-session -t codex-shell` (or `tmux kill-server` if you must nuke all).

### oracle

When stuck on a problem or question, or consultation is needed use `npx -y @steipete/oracle --engine api --model gemini-3-pro-preview --slug "<one liner about subject>" -p "<full context for oracle>" [--file "<path/to/file1>" --file "<path/to/file2>" ...]` to get help from an AI oracle.

### psql

Normally you can use `psql <project-name>` to connect to the local Postgres DB.

### lldb

- Use `lldb` inside tmux to debug native apps; attach to the running app to inspect state.

### gh

- GitHub CLI for PRs, CI logs, releases, and repo queries; run `gh help`. When someone shares a GitHub issue/PR URL (full or relative like `/pull/5`), use `gh` to read it—do not web-search. Examples: `gh issue view <url> --comments -R owner/repo` and `gh pr view <url> --comments --files -R owner/repo`. If only a number is given, derive the repo from the URL or current checkout and still fetch details via `gh`.

### timeout

- Use `timeout <seconds> <command>` to limit execution time of commands that may hang.
