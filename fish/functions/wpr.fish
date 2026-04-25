# Checkout a GitHub PR into a worktree via worktrunk.
# Supports:
#   wpr 16201
#   wpr openai/codex 16201
#   wpr https://github.com/openai/codex/pull/16201
function wpr --description "Checkout a GitHub PR into a worktree via worktrunk"
    if not command -sq gh
        echo "Error: gh is required"
        return 1
    end

    if test (count $argv) -eq 0
        echo "Usage:"
        echo "  wpr <pr-number>"
        echo "  wpr <owner/repo> <pr-number>"
        echo "  wpr <github-pr-url>"
        return 1
    end

    set -l repo ""
    set -l pr_number ""

    if test (count $argv) -eq 1
        if string match -rq '^https://github\.com/[^/]+/[^/]+/pull/[0-9]+$' -- $argv[1]
            set -l parts (string split / $argv[1])
            set repo "$parts[4]/$parts[5]"
            set pr_number $parts[7]
        else if string match -rq '^[0-9]+$' -- $argv[1]
            set pr_number $argv[1]
        else
            echo "Error: single argument must be a PR number or GitHub PR URL"
            return 1
        end
    else if test (count $argv) -eq 2
        if string match -rq '^[^/]+/[^/]+$' -- $argv[1]; and string match -rq '^[0-9]+$' -- $argv[2]
            set repo $argv[1]
            set pr_number $argv[2]
        else
            echo "Error: expected 'wpr <owner/repo> <pr-number>'"
            return 1
        end
    else
        echo "Error: too many arguments"
        return 1
    end

    if test -z "$repo"
        set repo (gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null)
        if test $status -ne 0; or test -z "$repo"
            echo "Error: could not infer the current repo; pass OWNER/REPO explicitly"
            return 1
        end
    end

    set -l repo_root (git rev-parse --show-toplevel 2>/dev/null)
    if test $status -ne 0; or test -z "$repo_root"
        echo "Error: run wpr inside a local checkout of $repo"
        return 1
    end

    set -l matching_remote ""
    for remote in (git remote)
        set -l remote_url (git remote get-url $remote 2>/dev/null)
        set -l remote_repo (string replace -r '.*github\.com[:/](.+?)(?:\.git)?$' '$1' $remote_url)
        if test "$remote_repo" = "$repo"
            set matching_remote $remote
            break
        end
    end

    set -l branch (gh pr view $pr_number -R $repo --json headRefName --jq '.headRefName' 2>/dev/null)
    if test $status -ne 0; or test -z "$branch"
        echo "Error: PR #$pr_number not found in $repo"
        return 1
    end

    echo "Checking out $repo PR #$pr_number via wt..."

    if test -n "$matching_remote"
        git fetch $matching_remote "pull/$pr_number/head:$branch"
        if test $status -ne 0
            echo "Error: failed to fetch PR #$pr_number from $matching_remote"
            return 1
        end

        wt switch $branch
        return $status
    end

    wt switch "pr:$pr_number"
end

complete -c wpr -f -a "(gh pr list --limit 30 --json number,title --jq '.[] | \"\(.number)\t\(.title)\"' 2>/dev/null)"
