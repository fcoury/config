function cw --description 'Jump to a Codex worktree by short name, or open a fuzzy picker'
    if contains -- --help $argv; or contains -- -h $argv
        printf '%s\n' \
            'cw [words...]  Jump to a matching Codex worktree; pick when ambiguous' \
            'cw             Open the searchable worktree picker' \
            'cw main        Go to ~/code/codex' \
            'cw -           Return to the previous directory'
        return 0
    end
    if test (count $argv) -eq 1; and test "$argv[1]" = -
        cd -
        return $status
    end

    set -l rows (__cw_worktrees)
    if test (count $rows) -eq 0
        echo 'cw: no Codex checkouts found in ~/code' >&2
        return 1
    end

    set -l query (string join ' ' -- $argv)
    if test -n "$query"
        set -l matches
        for row in $rows
            set -l fields (string split \t -- "$row")
            if test "$fields[1]" = "$query"
                cd -- "$fields[2]"
                return $status
            end
            if string match --quiet --ignore-case --regex -- (string escape --style=regex "$query") "$fields[1]"
                set -a matches "$row"
            end
        end
        if test (count $matches) -eq 1
            set -l fields (string split \t -- "$matches[1]")
            cd -- "$fields[2]"
            return $status
        end
    end

    if not command -q fzf
        echo 'cw: use an exact/unique name, or install fzf for the picker' >&2
        return 1
    end
    set -l selected (printf '%s\n' $rows | command fzf \
        --no-multi --delimiter=\t --with-nth=1 --nth=1 \
        --height=60% --layout=reverse --prompt='codex> ' \
        --header='Enter to jump · Esc to cancel' --query="$query")
    set -l picker_status $status
    if test $picker_status -ne 0
        contains -- "$picker_status" 1 130; and return 0
        return $picker_status
    end
    test -n "$selected"; or return 0
    set -l fields (string split \t -- "$selected")
    cd -- "$fields[2]"
end
