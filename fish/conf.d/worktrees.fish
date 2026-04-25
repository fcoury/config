# Git Worktree Creation Function
function wk --description "Create a git worktree with format <current_dir>-<branch_name>"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end
    
    set existing_only false
    set branch_name ""
    
    # Parse arguments
    for arg in $argv
        switch $arg
            case '--existing' '-e'
                set existing_only true
            case '*'
                if test -z "$branch_name"
                    set branch_name $arg
                else
                    echo "Error: Multiple branch names provided"
                    return 1
                end
        end
    end
    
    # Check if branch name is provided
    if test -z "$branch_name"
        echo "Usage: wk [--existing|-e] <branch_name>"
        echo "Creates worktree: <current_dir>-<branch_name>"
        echo ""
        echo "Options:"
        echo "  --existing, -e    Only use existing branches (local or remote)"
        return 1
    end
    set current_dir (basename (pwd))
    
    # Convert branch name to safe directory name by replacing slashes with dashes
    set safe_branch_name (string replace -a '/' '-' $branch_name)
    set worktree_name "$current_dir-$safe_branch_name"
    
    # Get the parent directory (one level up from current git repo)
    set parent_dir (dirname (pwd))
    set worktree_path "$parent_dir/$worktree_name"
    
    echo "Creating worktree: $worktree_name"
    echo "Path: $worktree_path"
    echo "Branch: $branch_name"
    
    # Check if branch exists (locally or remotely)
    set branch_exists false
    set target_branch $branch_name
    
    # Check if branch exists locally
    if git show-ref --verify --quiet "refs/heads/$branch_name"
        set branch_exists true
        echo "🌿 Using existing local branch: $branch_name"
    # Check if branch exists on remote
    else if git show-ref --verify --quiet "refs/remotes/origin/$branch_name"
        set branch_exists true
        echo "🌿 Using existing remote branch: origin/$branch_name"
        set target_branch "origin/$branch_name"
    end
    
    # Create the worktree
    if test $branch_exists = true
        # Branch exists, create worktree from existing branch
        if git worktree add "$worktree_path" "$target_branch"
            echo "✅ Worktree '$worktree_name' created successfully"
            echo "📁 Location: $worktree_path"
            echo "🌿 Branch: $branch_name"
            cd "$worktree_path"
        else
            echo "❌ Failed to create worktree"
            return 1
        end
    else
        if test $existing_only = true
            # --existing flag used but branch doesn't exist
            echo "❌ Branch '$branch_name' not found (local or remote)"
            echo "💡 Available branches:"
            git branch -a | head -10
            return 1
        else
            # Branch doesn't exist, create new branch from current branch
            set current_branch (git branch --show-current)
            echo "🆕 Creating new branch: $branch_name (from $current_branch)"
            if git worktree add -b "$branch_name" "$worktree_path" "$current_branch"
                echo "✅ Worktree '$worktree_name' created successfully"
                echo "📁 Location: $worktree_path"
                echo "🌿 New branch: $branch_name"
                cd "$worktree_path"
            else
                echo "❌ Failed to create worktree with new branch"
                return 1
            end
        end
    end
end

# Git Worktree Deletion Function
function wd --description "Delete a git worktree with format <current_dir>-<branch_name>"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end
    
    set force_flag false
    set delete_branch false
    set branch_name ""
    
    # Parse arguments
    for arg in $argv
        switch $arg
            case '--force' '-f'
                set force_flag true
            case '--delete-branch' '-d'
                set delete_branch true
            case '*'
                if test -z "$branch_name"
                    set branch_name $arg
                else
                    echo "Error: Multiple branch names provided"
                    return 1
                end
        end
    end
    
    # Check if branch name is provided
    if test -z "$branch_name"
        echo "Usage: wd [--force|-f] [--delete-branch|-d] <branch_name>"
        echo "Deletes worktree: <current_dir>-<branch_name>"
        echo ""
        echo "Options:"
        echo "  --force, -f           Force deletion of worktree"
        echo "  --delete-branch, -d   Also delete the associated branch"
        return 1
    end
    
    set current_dir (basename (pwd))
    
    # Convert branch name to safe directory name by replacing slashes with dashes
    set safe_branch_name (string replace -a '/' '-' $branch_name)
    set worktree_name "$current_dir-$safe_branch_name"
    
    # Get the parent directory
    set parent_dir (dirname (pwd))
    set worktree_path "$parent_dir/$worktree_name"
    
    # Check if worktree exists
    if not test -d "$worktree_path"
        echo "❌ Worktree '$worktree_name' not found at: $worktree_path"
        echo "   (Looking for branch: $branch_name)"
        return 1
    end
    
    echo "Deleting worktree: $worktree_name"
    echo "Path: $worktree_path"
    echo "Branch: $branch_name"
    
    # Remove the worktree
    set git_cmd git worktree remove "$worktree_path"
    if test $force_flag = true
        set git_cmd $git_cmd --force
        echo "🔥 Force deleting..."
    end
    
    if eval $git_cmd
        echo "✅ Worktree '$worktree_name' deleted successfully"
        
        # Delete the branch if requested
        if test $delete_branch = true
            echo "🗑️  Deleting branch '$branch_name'..."
            
            # Check if branch exists locally
            if git show-ref --verify --quiet "refs/heads/$branch_name"
                set branch_cmd git branch -d "$branch_name"
                if test $force_flag = true
                    set branch_cmd git branch -D "$branch_name"
                    echo "🔥 Force deleting branch..."
                end
                
                if eval $branch_cmd
                    echo "✅ Branch '$branch_name' deleted successfully"
                else
                    echo "❌ Failed to delete branch '$branch_name'"
                    if test $force_flag = false
                        echo "💡 Try with --force flag to force delete the branch"
                    end
                    return 1
                end
            else
                echo "⚠️  Branch '$branch_name' not found locally (may be remote-only)"
            end
        end
    else
        echo "❌ Failed to delete worktree"
        if test $force_flag = false
            echo "💡 Try with --force flag if there are uncommitted changes"
        end
        return 1
    end
end

# Git Worktree List Function - helpful for seeing all worktrees with their safe names
function wl --description "List all git worktrees with their corresponding branches"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end
    
    echo "📋 Git Worktrees:"
    git worktree list --porcelain | while read -l line
        if string match -q "worktree *" $line
            set worktree_path (string replace "worktree " "" $line)
            set worktree_name (basename $worktree_path)
        else if string match -q "branch *" $line
            set branch_name (string replace "branch refs/heads/" "" $line)
            set safe_branch_name (string replace -a '/' '-' $branch_name)
            echo "  📁 $worktree_name → 🌿 $branch_name"
        end
    end
end

# Git Worktree Remove (multi-select) Function
function wr --description "Interactively select and remove git worktrees via fzf"
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    set force_flag false
    set delete_branch false

    # Parse arguments
    for arg in $argv
        switch $arg
            case '--force' '-f'
                set force_flag true
            case '--delete-branch' '-d'
                set delete_branch true
            case '*'
                echo "Usage: wr [--force|-f] [--delete-branch|-d]"
                echo "Interactively select worktrees to remove via fzf"
                echo ""
                echo "Options:"
                echo "  --force, -f           Force deletion of worktrees"
                echo "  --delete-branch, -d   Also delete the associated branches"
                return 1
        end
    end

    # Get the main worktree path (first line of git worktree list is always the main one)
    set main_worktree (git worktree list --porcelain | head -1 | string replace "worktree " "")

    # Build the list of non-main worktrees for fzf
    set worktree_lines (git worktree list | grep -v "^$main_worktree ")
    if test -z "$worktree_lines"
        echo "No extra worktrees to remove."
        return 0
    end

    # Let the user pick with fzf multi-select
    set selected (printf '%s\n' $worktree_lines | fzf -m --header "Tab to select, Enter to confirm removal")
    if test -z "$selected"
        echo "No worktrees selected."
        return 0
    end

    # Show all worktrees that will be deleted upfront
    echo "Worktrees to remove:"
    for line in $selected
        set wt_path (echo $line | awk '{print $1}')
        set wt_name (basename $wt_path)
        set wt_branch (echo $line | string match -r '\[(.+)\]' | tail -1)
        echo "  $wt_name ($wt_path) [branch: $wt_branch]"
    end
    echo ""

    # Process each selected worktree
    for line in $selected
        # Extract the path (first field of git worktree list output)
        set wt_path (echo $line | awk '{print $1}')
        set wt_name (basename $wt_path)

        # Extract branch name from the bracketed portion, e.g. [branch-name]
        set wt_branch (echo $line | string match -r '\[(.+)\]' | tail -1)

        echo "Removing worktree: $wt_name ($wt_path)"

        set git_cmd git worktree remove "$wt_path"
        if test $force_flag = true
            set git_cmd $git_cmd --force
        end

        if eval $git_cmd
            echo "✅ Worktree '$wt_name' removed"

            # Delete the branch if requested
            if test $delete_branch = true; and test -n "$wt_branch"
                if git show-ref --verify --quiet "refs/heads/$wt_branch"
                    set branch_cmd git branch -d "$wt_branch"
                    if test $force_flag = true
                        set branch_cmd git branch -D "$wt_branch"
                    end

                    if eval $branch_cmd
                        echo "✅ Branch '$wt_branch' deleted"
                    else
                        echo "❌ Failed to delete branch '$wt_branch'"
                    end
                else
                    echo "⚠️  Branch '$wt_branch' not found locally"
                end
            end
        else
            echo "❌ Failed to remove worktree '$wt_name'"
            if test $force_flag = false
                echo "💡 Try with --force flag"
            end
        end
    end
end

# Git Worktree Switch Function
function ws --description "Interactively switch to a git worktree via fzf"
    # Check if we're in a git repository
    if not git rev-parse --git-common-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    if not command -q fzf
        echo "Error: fzf is not installed"
        return 1
    end

    set current_root (git rev-parse --show-toplevel 2>/dev/null)
    set current_dir (pwd)
    set relative_dir ""

    if command -q realpath
        set current_root (realpath "$current_root")
        set current_dir (realpath "$current_dir")
    end

    if test -n "$current_root"; and string match -q "$current_root*" "$current_dir"
        set relative_dir (string replace "$current_root" "" "$current_dir" | string replace -r '^/' '')
    end

    set selected (git worktree list --porcelain | awk -v home="$HOME" -v branch_width=34 '
        function abbrev_path(path, parts, count, i, out) {
            if (home != "" && index(path, home) == 1) {
                path = "~" substr(path, length(home) + 1)
            }

            count = split(path, parts, "/")
            out = parts[1]

            for (i = 2; i <= count; i++) {
                if (parts[i] == "") {
                    continue
                }

                if (i < count && parts[i] != "~") {
                    out = out "/" substr(parts[i], 1, 1)
                } else {
                    out = out "/" parts[i]
                }
            }

            return out
        }

        function truncate(value, width) {
            if (length(value) <= width) {
                return value
            }

            return substr(value, 1, width - 3) "..."
        }

        function print_worktree() {
            if (path == "") {
                return
            }

            branch_display = branch
            if (branch_display == "") {
                branch_display = "(unknown)"
            }

            printf "%-*s  %s  %s\t%s\n",
                branch_width,
                truncate(branch_display, branch_width),
                abbrev_path(path),
                head,
                path
        }

        /^worktree / {
            path = substr($0, 10)
            branch = ""
            head = ""
            next
        }
        /^HEAD / {
            head = substr($0, 6, 7)
            next
        }
        /^branch / {
            branch = substr($0, 8)
            sub(/^refs\/heads\//, "", branch)
            next
        }
        /^detached$/ {
            branch = "detached"
            next
        }
        /^bare$/ {
            branch = "bare"
            next
        }
        /^$/ {
            print_worktree()
            path = ""
            branch = ""
            head = ""
        }
        END {
            print_worktree()
        }
    ' | fzf --delimiter='\t' --with-nth=1 --header "Pick a worktree")

    if test -z "$selected"
        return 0
    end

    set selected_root (string split -m 1 \t -- $selected)[2]
    set target_dir "$selected_root"

    if test -n "$relative_dir"; and test -d "$selected_root/$relative_dir"
        set target_dir "$selected_root/$relative_dir"
    end

    cd "$target_dir"
end

# Optional: Add completions for branch names
complete -c wk -f -a "(git branch -a | string replace -r '^\s*\*?\s*' '' | string replace -r '^remotes/[^/]+/' '')"
complete -c wk -l existing -s e -d "Only use existing branches (local or remote)"
complete -c wd -f -a "(git branch -a | string replace -r '^\s*\*?\s*' '' | string replace -r '^remotes/[^/]+/' '')"
complete -c wd -l force -s f -d "Force deletion of worktree"
complete -c wd -l delete-branch -s d -d "Also delete the associated branch"
complete -c wr -f
complete -c wr -l force -s f -d "Force deletion of worktrees"
complete -c wr -l delete-branch -s d -d "Also delete the associated branches"
complete -c ws -f
