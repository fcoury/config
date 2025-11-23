## Tools

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

### lldb

- Use `lldb` inside tmux to debug native apps; attach to the running app to inspect state.

### gh

- GitHub CLI for PRs, CI logs, releases, and repo queries; run `gh help`. When someone shares a GitHub issue/PR URL (full or relative like `/pull/5`), use `gh` to read it—do not web-search. Examples: `gh issue view <url> --comments -R owner/repo` and `gh pr view <url> --comments --files -R owner/repo`. If only a number is given, derive the repo from the URL or current checkout and still fetch details via `gh`.

### oracle

- oracle gives your agents a simple, reliable way to bundle a prompt plus the right files and hand them to another AI (GPT 5 Pro + more). Use when stuck/bugs/reviewing code.
- You must call `npx -y @steipete/oracle --help` once per session to learn syntax.

### coderabbit

- CodeRabbit CLI for reviewing code; run `coderabbit --prompt-only` to get a list of files, lines, type and a "Prompt for AI Agent". Evaluate each issue and present the list to the user ordered by severity. Also show a number for each issue to allow the user to request more details, ask to execute some of the issues, or all issues from given categories.
