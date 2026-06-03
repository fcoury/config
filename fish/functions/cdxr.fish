function cdxr --description "Resume the latest Codex session from the current tmux pane"
    if not command -sq tmux
        cdx $argv
        return $status
    end

    set -l pane
    if set -q TMUX_PANE; and test -n "$TMUX_PANE"
        set pane "$TMUX_PANE"
    else if set -q TMUX; and test -n "$TMUX"
        set pane (tmux display-message -p '#{pane_id}' 2>/dev/null)
    end

    if test -z "$pane"
        cdx $argv
        return $status
    end

    set -l session_ids (
        tmux capture-pane -p -J -S -10000 -t "$pane" 2>/dev/null |
        string match -rg 'codex resume ([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})' |
        awk '!seen[$0]++'
    )

    switch (count $session_ids)
    case 0
        cdx $argv
    case 1
        cdx resume "$session_ids[1]" $argv
    case '*'
        set -l selected_session_id

        if command -q fzf
            set selected_session_id (
                printf '%s\n' $session_ids |
                fzf --tac --height 40% --reverse --prompt 'codex resume> ' --header 'Pick a Codex session from this pane'
            )
        else
            echo "Multiple Codex sessions found:"

            set -l index 1
            set -l session_count (count $session_ids)
            for session_id in $session_ids
                set -l suffix
                if test $index -eq $session_count
                    set suffix " (latest)"
                end

                printf '  %d) %s%s\n' $index "$session_id" "$suffix"
                set index (math $index + 1)
            end

            read -l -P "Resume session number: " choice
            if string match -qr '^[0-9]+$' -- "$choice"; and test "$choice" -ge 1; and test "$choice" -le $session_count
                set selected_session_id "$session_ids[$choice]"
            else
                echo "Invalid selection."
                return 1
            end
        end

        if test -z "$selected_session_id"
            echo "No session selected."
            return 130
        end

        cdx resume "$selected_session_id" $argv
    end
end
