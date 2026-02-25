# Terminal multiplexer helpers (tmux & zellij)
#
# Session naming convention: all functions derive the session name from the
# current directory's basename, replacing dots with underscores so tmux
# doesn't choke on the name (e.g. "my.project" -> "my_project").
#
# Commands:
#   tn <name>    - create a new named tmux session
#   tm           - attach to (or create) a session for the current directory
#   tp [name]    - fuzzy-pick an existing session, or attach/create by name
#   tv [file]    - like tm, but starts nvim inside the session
#   zm           - zellij equivalent of tm

# tn: shorthand for creating a new named tmux session
alias tn 'tmux new-session -s'

# tm: attach to the session matching cwd, or create it if it doesn't exist
# also sets the terminal title to the session name
function tm
  set session_name (basename (pwd) | string replace '.' '_')
  printf '\033]0;💻 %s\007' "$session_name"

  if tmux has-session -t "$session_name"
    tmux attach-session -t "$session_name"
  else
    tmux new-session -s "$session_name"
  end
end

# tp: tmux session picker
#   no args  -> fzf over existing sessions; Esc falls back to cwd session
#   with arg -> attach to that session name, creating it if needed
#   no sessions at all -> create one for cwd
function tp
  if not command -q tmux
    echo "tmux is not installed"
    return 1
  end

  # no sessions exist yet — just create one for the current directory
  if test (tmux list-sessions 2>/dev/null | wc -l) -eq 0
    set session_name (basename (pwd) | string replace '.' '_')
    printf '\033]0;💻 %s\007' "$session_name"
    tmux new-session -s "$session_name"
    return
  end

  if test (count $argv) -eq 0
    # interactive pick via fzf
    set selected_session (tmux list-sessions -F "#{session_attached} #{session_name}#{?session_attached, (attached),}" | sort -rn | string replace -r '^\d+ ' '' | fzf --height 40% --reverse | string replace -r ' \(attached\)$' '')

    if test -n "$selected_session"
      printf '\033]0;💻 %s\007' "$selected_session"
      tmux attach-session -t "$selected_session"
    else
      # fzf cancelled — fall back to cwd session
      set session_name (basename (pwd) | string replace '.' '_')
      printf '\033]0;💻 %s\007' "$session_name"

      if tmux has-session -t "$session_name" 2>/dev/null
        tmux attach-session -t "$session_name"
      else
        tmux new-session -s "$session_name"
      end
    end
  else
    # explicit session name provided
    set session_name $argv[1]
    printf '\033]0;💻 %s\007' "$session_name"

    if tmux has-session -t "$session_name" 2>/dev/null
      tmux attach-session -t "$session_name"
    else
      tmux new-session -s "$session_name"
    end
  end
end

# tv: like tm but launches nvim as the initial command
#   no args  -> opens nvim with no file
#   with arg -> opens nvim on that file
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

# zm: zellij equivalent of tm — attach to cwd session or create it
function zm
  set session_name (basename (pwd) | string replace '.' '_')

  if zellij list-sessions -n | grep -q "^$session_name"
    zellij attach "$session_name"
  else
    zellij --session "$session_name"
  end
end
