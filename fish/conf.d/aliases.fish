# git aliases
alias gl "git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gp 'git pull'
alias gps 'git push'
alias gs 'git status'
alias gpr 'hub pull-request|xargs open'
alias gtr 'git track'
alias gap 'git add -p'

# best lsusb for macOS is cyme
# https://github.com/tuna-f1sh/cyme
alias lsusb 'cyme'

# neovim aliases
alias vi 'nvim'
alias vim 'nvim'
alias vivi 'cd ~/code/config/nvim; nvim'
alias vic 'cd ~/code/config; nvim'

# homebrew
alias bi 'HOMEBREW_NO_AUTO_UPDATE=1 brew install'

# tmux
alias tn 'tmux new-session -s'

# ai and vibecoding
#alias yolo 'ENABLE_BACKGROUND_TASKS=1 FORCE_AUTO_BACKGROUND_TASKS=1 claude --dangerously-skip-permissions'
alias yolo 'claude --dangerously-skip-permissions'
alias yolovt 'vt claude --dangerously-skip-permissions'
alias yologlm 'ccr code --dangerously-skip-permissions'

# uses bat for cat if available
function cat
    if command -v bat >/dev/null 2>&1
        bat --no-pager $argv
    else
        command cat $argv
    end
end

function ca
  cargo add $argv; and cargo sort
end

# removed because it conflicts with coderabbit alias
# function cr
#   cargo remove $argv; and cargo sort
# end

function mc
  set dir $argv[1]
  if test -z "$argv[1]"
    set dir (pwd)
  end

  set prev_dir (pwd)

  function onexit --on-signal SIGINT --on-signal SIGTERM
    cd $prev_dir
  end

  cd $HOME/code/msuite
  cargo run -- -d config --env-file "$dir/.env" --path "$dir" --watch

  cd $prev_dir
end

function tt
  set dir (pwd)
  set test $argv[1]
  if test -z "$argv[1]"
    set test "."
  end

  set prev_dir (pwd)

  function onexit --on-signal SIGINT --on-signal SIGTERM
    cd $prev_dir
  end

  cd $HOME/code/msuite
  cargo watch -x 'run -- config --path '"$dir"' --env-file '"$dir/.env"' test '"$dir/$argv"' --watch'

  cd $prev_dir
end

function tm
  set session_name (basename (pwd) | string replace '.' '_')

  if tmux has-session -t "$session_name"
    tmux attach-session -t "$session_name"
  else
    tmux new-session -s "$session_name"
  end
end

function zm
  set session_name (basename (pwd) | string replace '.' '_')

  if zellij list-sessions -n | grep -q "^$session_name"
    zellij attach "$session_name"
  else
    zellij --session "$session_name"
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

# --- fd and rg aliases ---
alias fdh 'fd --color=always --hidden --no-ignore'
alias rgh 'rg --color=always --hidden --no-ignore'
