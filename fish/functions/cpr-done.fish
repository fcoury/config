# Finish a cpr review from a different terminal, preserving the branch and smoke evidence.
function cpr-done --description "Archive a cpr review and remove its clean worktree" --argument-names pr_number
    if test (count $argv) -ne 1; or not string match -rq '^[0-9]+$' -- "$pr_number"
        echo "Usage: cpr-done <pr-number>"
        return 1
    end

    for required in gh git tmux wt codex python3
        if not command -sq $required
            echo "Error: $required is required"
            return 1
        end
    end

    set -l codex_root "$HOME/code/codex"
    set -l branch (gh pr view "$pr_number" -R openai/codex-internal --json headRefName --jq '.headRefName' 2>/dev/null)
    if test $status -ne 0; or test -z "$branch"
        echo "Error: PR #$pr_number not found"
        return 1
    end

    if not functions -q __cpr_worktree_for_branch
        source "$HOME/.config/fish/functions/cpr.fish"
    end
    set -l worktree_path (__cpr_worktree_for_branch "$codex_root" "$branch")
    if test -z "$worktree_path"; or not string match -q -- "$HOME/code/codex.*" "$worktree_path"; or not test -d "$worktree_path"
        echo "Error: no matching sibling worktree for PR #$pr_number"
        return 1
    end

    set -l session_name (basename "$worktree_path" | string replace -a '.' '_')
    if set -q TMUX; and test (tmux display-message -p '#S') = "$session_name"
        echo "Error: run cpr-done from outside tmux session $session_name"
        return 1
    end

    set -l changes (git -C "$worktree_path" status --porcelain --untracked-files=all)
    if test $status -ne 0; or test -n "$changes"
        echo "Error: worktree has uncommitted files: $worktree_path"
        return 1
    end
    if test -d "$worktree_path/target/manual-smoke"; or test -d "$worktree_path/codex-rs/target/manual-smoke"
        echo "Error: retain or move manual smoke evidence before removing $worktree_path"
        return 1
    end

    set -l tasks (python3 -c '
import sqlite3, sys
db = sqlite3.connect("file:" + sys.argv[1] + "?mode=ro", uri=True)
review = "$pr-reviewer code only, dont run tests"
smoke = "$branch-smoke-test"
prompts = (review, smoke, review + " — PR #" + sys.argv[3], smoke + " — PR #" + sys.argv[3])
for task_id, archived in db.execute("SELECT id, archived FROM threads WHERE cwd = ? AND first_user_message IN (?, ?, ?, ?)", (sys.argv[2], *prompts)):
    print(task_id, archived)
' "$HOME/.codex/state_5.sqlite" "$worktree_path" "$pr_number")
    if test $status -ne 0; or test (count $tasks) -eq 0
        echo "Error: no matching cpr tasks found in the local Codex index"
        return 1
    end

    if tmux has-session -t "=$session_name" 2>/dev/null
        tmux kill-session -t "=$session_name"; or return 1
    end
    for task in $tasks
        set -l fields (string split ' ' -- "$task")
        if test "$fields[2]" = 0
            codex archive "$fields[1]"; or return 1
        end
    end
    wt -C "$codex_root" remove --no-delete-branch --foreground "$worktree_path"; or return 1
    echo "Archived the PR tasks and removed $worktree_path; branch retained."
end
