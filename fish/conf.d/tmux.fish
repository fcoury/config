# tmux
alias tn 'tmux new-session -s'

function tm
  set session_name (basename (pwd) | string replace '.' '_')
  printf '\033]0;💻 %s\007' "$session_name"

  if tmux has-session -t "$session_name"
    tmux attach-session -t "$session_name"
  else
    tmux new-session -s "$session_name"
  end
end

function tp
  # Check if tmux is running
  if not command -q tmux
    echo "tmux is not installed"
    return 1
  end

  # If no tmux sessions exist, create one based on current directory
  if test (tmux list-sessions 2>/dev/null | wc -l) -eq 0
    set session_name (basename (pwd) | string replace '.' '_')
    tmux new-session -s "$session_name"
    return
  end

  # If no argument is given, use fzf to select a session
  if test (count $argv) -eq 0
    set selected_session (tmux list-sessions -F "#{session_name}" | fzf --height 40% --reverse)

    # If user selected a session, attach to it
    if test -n "$selected_session"
      tmux attach-session -t "$selected_session"
    else
      # If no session was selected (user pressed Esc), create a new one
      set session_name (basename (pwd) | string replace '.' '_')

      if tmux has-session -t "$session_name" 2>/dev/null
        tmux attach-session -t "$session_name"
      else
        tmux new-session -s "$session_name"
      end
    end
  else
    # If an argument is given, try to attach to that session or create it
    set session_name $argv[1]

    if tmux has-session -t "$session_name" 2>/dev/null
      tmux attach-session -t "$session_name"
    else
      tmux new-session -s "$session_name"
    end
  end
end

function tv
  set session_name (basename (pwd) | string replace '.' '_')

  if test (count $argv) -gt 0
    set file_to_edit $argv[1]
  else
    set file_to_edit ""
  end

  if tmux has-session -t "$session_name"
    tmux attach-session -t "$session_name"
  else
    if test -n "$file_to_edit"
      tmux new-session -s "$session_name" "nvim $file_to_edit"
    else
      tmux new-session -s "$session_name" "nvim"
    end
  end
end

# zellij
function zm
  set session_name (basename (pwd) | string replace '.' '_')

  if zellij list-sessions -n | grep -q "^$session_name"
    zellij attach "$session_name"
  else
    zellij --session "$session_name"
  end
end
