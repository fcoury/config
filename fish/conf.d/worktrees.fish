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
            # Branch doesn't exist, create new branch and worktree
            echo "🆕 Creating new branch: $branch_name"
            if git worktree add -b "$branch_name" "$worktree_path"
                echo "✅ Worktree '$worktree_name' created successfully"
                echo "📁 Location: $worktree_path"
                echo "🌿 New branch: $branch_name"
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
    set branch_name ""
    
    # Parse arguments
    for arg in $argv
        switch $arg
            case '--force' '-f'
                set force_flag true
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
        echo "Usage: wd [--force|-f] <branch_name>"
        echo "Deletes worktree: <current_dir>-<branch_name>"
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

# Optional: Add completions for branch names
complete -c wk -f -a "(git branch -a | string replace -r '^\s*\*?\s*' '' | string replace -r '^remotes/[^/]+/' '')"
complete -c wk -l existing -s e -d "Only use existing branches (local or remote)"
complete -c wd -f -a "(git branch -a | string replace -r '^\s*\*?\s*' '' | string replace -r '^remotes/[^/]+/' '')"
complete -c wd -l force -s f -d "Force deletion of worktree"
