# Checkout an openai/codex PR worktree and open the standard review tmux layout.
#
# Supports:
#   cpr 22225
#   cpr https://github.com/openai/codex/pull/22225
#   cpr --recreate 22225
function cpr --description "Checkout an openai/codex PR and open the Codex review tmux layout"
    set -l recreate false
    set -l pr_args

    for arg in $argv
        switch $arg
            case --recreate -r
                set recreate true
            case '*'
                set -a pr_args $arg
        end
    end

    if test (count $pr_args) -ne 1
        echo "Usage:"
        echo "  cpr [--recreate|-r] <pr-number>"
        echo "  cpr [--recreate|-r] <https://github.com/openai/codex/pull/pr-number>"
        return 1
    end

    set -l pr_arg (string replace -r '/$' '' -- $pr_args[1])
    set -l pr_number $pr_arg
    if not string match -rq '^[0-9]+$' -- $pr_arg
        if not string match -rq '^https://github\.com/openai/codex/pull/[0-9]+$' -- $pr_arg
            echo "Error: expected an openai/codex PR number or URL"
            return 1
        end

        set -l parts (string split / -- $pr_arg)
        set pr_number $parts[7]
    end

    for required in git gh wt tmux
        if not command -sq $required
            echo "Error: $required is required"
            return 1
        end
    end

    set -l codex_root "$HOME/code/codex"
    if not git -C "$codex_root" rev-parse --show-toplevel >/dev/null 2>&1
        echo "Error: $codex_root is not a git checkout"
        return 1
    end

    set -l original_dir (pwd)

    echo "Updating $codex_root main..."
    git -C "$codex_root" switch main
    if test $status -ne 0
        return 1
    end

    git -C "$codex_root" pull --ff-only origin main
    if test $status -ne 0
        return 1
    end

    cd "$codex_root"
    if test $status -ne 0
        cd "$original_dir"
        return 1
    end

    set -l branch (gh pr view $pr_number -R openai/codex --json headRefName --jq '.headRefName' 2>/dev/null)
    if test $status -ne 0; or test -z "$branch"
        echo "Error: PR #$pr_number not found in openai/codex"
        cd "$original_dir"
        return 1
    end

    set -l worktree_path (__cpr_worktree_for_branch "$codex_root" "$branch")
    if test -n "$worktree_path"
        echo "Using existing worktree for PR #$pr_number: $worktree_path"
        cd "$worktree_path"
        if test $status -ne 0
            cd "$original_dir"
            return 1
        end
    else
        wpr $pr_arg
        if test $status -ne 0
            cd "$original_dir"
            return 1
        end

        set worktree_path (pwd)
    end

    __cpr_start_tmux "$worktree_path" "$recreate"
end

function __cpr_worktree_for_branch --argument-names repo_root branch
    git -C "$repo_root" worktree list --porcelain | awk -v branch="refs/heads/$branch" '
        $1 == "worktree" {
            path = substr($0, 10)
        }
        $1 == "branch" && $2 == branch {
            print path
            exit
        }
    '
end

function __cpr_start_tmux --argument-names worktree_path recreate
    set -l session_name (basename "$worktree_path" | string replace -a '.' '_')
    printf '\033]0;💻 %s\007' "$session_name"

    if tmux has-session -t "$session_name" 2>/dev/null
        if test "$recreate" = true
            tmux kill-session -t "$session_name"
        else
            echo "tmux session '$session_name' already exists; use --recreate to rebuild it"
            __cpr_attach_or_switch "$session_name"
            return $status
        end
    end

    if tmux has-session -t "$session_name" 2>/dev/null
        __cpr_attach_or_switch "$session_name"
        return $status
    end

    set -l left_pane (tmux new-session -d -P -F '#{pane_id}' -s "$session_name" -c "$worktree_path" "fish -lc 'just c; exec fish'")
    if test $status -ne 0
        return 1
    end

    # Let Codex queue each initial prompt until its TUI session is ready instead of
    # racing startup with synthetic tmux keystrokes.
    set -l review_prompt '$pr-reviewer code only, dont run tests'
    set -l smoke_prompt '$branch-smoke-test'

    set -l right_top_pane (tmux split-window -h -P -F '#{pane_id}' -t "$left_pane" -c "$worktree_path" fish -lc 'cdx "$argv[1]"; exec fish' -- "$review_prompt")
    if test $status -ne 0
        return 1
    end

    set -l right_bottom_pane (tmux split-window -v -P -F '#{pane_id}' -t "$right_top_pane" -c "$worktree_path" fish -lc 'cdx "$argv[1]"; exec fish' -- "$smoke_prompt")
    if test $status -ne 0
        return 1
    end

    tmux select-pane -t "$right_top_pane"
    __cpr_attach_or_switch "$session_name"
end

function __cpr_attach_or_switch --argument-names session_name
    if set -q TMUX; and test -n "$TMUX"
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    end
end
