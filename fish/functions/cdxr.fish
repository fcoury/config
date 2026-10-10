function cdxr --description "Resume the latest Codex session from the current multiplexer pane"
    set -l captured

    if set -q HERDR_ENV; and test "$HERDR_ENV" = 1
        if not command -sq herdr
            echo 'cdxr: herdr is unavailable' >&2
            return 1
        end
        if not set -q HERDR_PANE_ID; or test -z "$HERDR_PANE_ID"
            echo 'cdxr: could not find the current herdr pane' >&2
            return 1
        end

        set captured (herdr pane read "$HERDR_PANE_ID" --source recent-unwrapped --lines 10000 --raw 2>/dev/null)
        if test $status -ne 0
            echo "cdxr: could not capture herdr pane $HERDR_PANE_ID" >&2
            return 1
        end
    else
        if not command -sq tmux
            if set -q TMUX; or set -q TMUX_PANE
                echo 'cdxr: tmux is unavailable' >&2
                return 1
            end
            cdx $argv
            return $status
        end

        set -l pane
        if set -q TMUX_PANE; and test -n "$TMUX_PANE"
            set pane (tmux display-message -p -t "$TMUX_PANE" '#{pane_id}' 2>/dev/null)
        end
        if test -z "$pane"; and begin; set -q TMUX; or set -q TMUX_PANE; end
            set pane (tmux display-message -p '#{pane_id}' 2>/dev/null)
        end

        if test -z "$pane"
            if not set -q TMUX; and not set -q TMUX_PANE
                cdx $argv
                return $status
            end
            echo 'cdxr: could not find the current tmux pane' >&2
            return 1
        end

        set captured (tmux capture-pane -p -J -S -10000 -t "$pane" 2>/dev/null)
        if test $status -ne 0
            echo "cdxr: could not capture tmux pane $pane" >&2
            return 1
        end
    end

    set -l session_ids (
        printf '%s\n' $captured |
        string match -rg '(?:codex resume |To continue this session, run codex resume, then select .*\()([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})' |
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
