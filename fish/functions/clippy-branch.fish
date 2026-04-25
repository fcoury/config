function clippy-branch -d "Run cargo clippy --fix only on branch-changed .rs files"
    # Detect default branch from the remote HEAD ref
    set -l default_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||')
    if test -z "$default_branch"
        set default_branch main
    end
    set -l base (git merge-base HEAD $default_branch)
    set -l branch_files (git diff --name-only $base HEAD -- '*.rs')
    set -l dirty_before (git diff --name-only -- '*.rs')

    if test (count $branch_files) -eq 0
        echo "No .rs files changed in this branch"
        return 0
    end

    cargo clippy --fix --tests --allow-dirty $argv

    # Revert clippy changes to files not changed in this branch
    for file in (git diff --name-only -- '*.rs')
        if not contains -- $file $branch_files
            if not contains -- $file $dirty_before
                git checkout -- $file
            end
        end
    end
end
