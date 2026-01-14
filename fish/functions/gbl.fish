# List all subfolders and their git branches
function gbl --description "List subfolders with their git branches"
    for dir in */
        set dir (string trim -r -c '/' $dir)
        # Check for .git directory OR .git file (worktree)
        if test -d "$dir/.git" -o -f "$dir/.git"
            set branch (git -C "$dir" branch --show-current 2>/dev/null)
            if test -z "$branch"
                # Detached HEAD state
                set branch (git -C "$dir" rev-parse --short HEAD 2>/dev/null)
                printf "%-30s %s\n" "$dir" "(detached: $branch)"
            else
                printf "%-30s %s\n" "$dir" "$branch"
            end
        else
            printf "%-30s %s\n" "$dir" "-"
        end
    end
end
