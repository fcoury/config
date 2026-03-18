## Commit Messages

- **Subject**: Use conventional commits format: `type(scope): lowercase imperative description`
  - Types: `feat`, `fix`, `test`, `refactor`, `docs`, `chore`
  - Scopes: `tui`, `core`, etc.
- **Body**:
  - 1-2 short paragraphs
  - explain _what_ the change does and _why_
  - wrap at 72 characters or less
  - use backticks for config keys, paths, and code references
- **No `Testing:` section** — don't list test commands in commit messages.
- **Shell safety hint**: when commit text includes backticks, avoid double-quoted inline `-m` flags; use single quotes, escaped backticks, or `git commit -F <file>` to prevent command substitution.

## Tools

## Browser Automation

Use `agent-browser` for web automation. Run `agent-browser --help` for all commands.

Core workflow:

1. `agent-browser open <url>` - Navigate to page
2. `agent-browser snapshot -i` - Get interactive elements with refs (@e1, @e2)
3. `agent-browser click @e1` / `fill @e2 "text"` - Interact using refs
4. Re-snapshot after page changes

### wt / Worktrunk

- Prefer `wt` over raw `git worktree` when a task benefits from isolation: parallel agents, risky refactors, PR review, or keeping the main checkout clean.
- `wt` is a git worktree manager optimized for agent workflows: branch-addressed worktrees, fast switching, cross-worktree status, merge/cleanup automation, hooks, and PR checkout via `gh`.
- One-time shell setup: `wt config shell install`
- Core workflow:
  1. `wt switch --create feat-name` - create a branch + worktree from the default branch and switch into it
  2. `wt switch feat-name` - jump back to an existing worktree
  3. `wt list` - inspect all worktrees; use `wt list --full` for CI/status and `wt list --format=json` for scripts
  4. `wt merge` - squash/rebase/fast-forward the current branch into the default branch and remove the worktree
  5. `wt remove` - delete an abandoned or already-merged worktree
- Useful patterns:
  - `wt switch` with no branch opens the interactive picker
  - `wt switch pr:123` checks out a GitHub PR branch via `gh`
  - `wt switch --create fix --base=@` starts a branch from the current worktree `HEAD`
  - `wt switch --create -x 'codex' feat-name -- 'implement X'` creates a worktree and immediately launches an agent there
- Prefer `wt merge` over manual `git merge` plus `git worktree remove` when hooks or local validation should run.
- Prefer `wt remove` over manual deletion so merged-branch detection and cleanup stay consistent.
- If `wt` cannot be used in a repo, fall back to native git commands.

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

### psql

Normally you can use `psql <project-name>` to connect to the local Postgres DB.

### lldb

- Use `lldb` inside tmux to debug native apps; attach to the running app to inspect state.

### gh

- GitHub CLI for PRs, CI logs, releases, and repo queries; run `gh help`. When someone shares a GitHub issue/PR URL (full or relative like `/pull/5`), use `gh` to read it—do not web-search. Examples: `gh issue view <url> --comments -R owner/repo` and `gh pr view <url> --comments --files -R owner/repo`. If only a number is given, derive the repo from the URL or current checkout and still fetch details via `gh`.

### timeout

- Use `timeout <seconds> <command>` to limit execution time of commands that may hang.
