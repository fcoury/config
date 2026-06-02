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

    set -l session_id (
        tmux capture-pane -p -J -S -10000 -t "$pane" 2>/dev/null |
        string match -rg 'codex resume ([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})' |
        tail -n 1
    )

    if test -n "$session_id"
        cdx resume "$session_id" $argv
    else
        cdx $argv
    end
end
