# Completions for tms - tmux session manager for m3pro

function __fish_tms_sessions
    # Fetch remote tmux sessions (with timeout to avoid hanging)
    ssh -o ConnectTimeout=2 m3pro "tmux list-sessions -F '#S' 2>/dev/null" 2>/dev/null
end

# Complete with existing remote sessions
complete -c tms -f -a "(__fish_tms_sessions)" -d "tmux session"
