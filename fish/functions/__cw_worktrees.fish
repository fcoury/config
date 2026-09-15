function __cw_worktrees --description 'List short names and paths for local Codex checkouts'
    for dir in "$HOME/code/codex" "$HOME"/code/codex.*/
        set dir (string trim --right --chars / -- "$dir")
        test -e "$dir/.git"; or continue
        set -l name (path basename "$dir")
        if test "$name" = codex
            set name main
        else
            set name (string replace --regex '^codex\.(fcoury-)?' '' -- "$name")
        end
        printf '%s\t%s\n' "$name" "$dir"
    end
end
