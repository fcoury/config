# Completions for tms - remote tmux session manager (default host: m5pro)

function __fish_tms_sessions
    # Fetch remote tmux sessions (with timeout to avoid hanging)
    set -l tms_host m5pro
    if set -q TMS_SSH_HOST
        set tms_host $TMS_SSH_HOST
    end

    set -l sessions (ssh -o ConnectTimeout=2 "$tms_host" "tmux list-sessions -F '#{session_attached}|#{session_name}' 2>/dev/null" 2>/dev/null | sort -t '|' -k1,1nr -k2,2)
    for session in $sessions
        set -l fields (string split -m 1 '|' -- "$session")
        if test (count $fields) -lt 2
            continue
        end

        if test "$fields[1]" -gt 0 2>/dev/null
            printf '%s\t(attached)\n' "$fields[2]"
        else
            printf '%s\t(detached)\n' "$fields[2]"
        end
    end
end

# Complete with existing remote sessions
complete -c tms -f -a "(__fish_tms_sessions)"
