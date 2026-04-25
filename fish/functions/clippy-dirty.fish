function clippy-dirty -d "Run cargo clippy --fix only on currently modified .rs files"
    set -l dirty_before (git diff --name-only -- '*.rs')

    if test (count $dirty_before) -eq 0
        echo "No modified .rs files"
        return 0
    end

    cargo clippy --fix --tests --allow-dirty $argv

    # Revert clippy changes to files that weren't already dirty
    for file in (git diff --name-only -- '*.rs')
        if not contains -- $file $dirty_before
            git checkout -- $file
        end
    end
end
