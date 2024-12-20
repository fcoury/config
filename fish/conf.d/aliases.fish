# git aliases
alias gl "git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gp 'git pull'
alias gps 'git push'
alias gs 'git status'
alias gpr 'hub pull-request|xargs open'
alias gtr 'git track'
alias gap 'git add -p'

# neovim aliases
alias vi 'nvim'
alias vim 'nvim'
alias vivi 'cd ~/code/config/nvim; nvim'
alias vic 'cd ~/code/config; nvim'

# homebrew
alias bi 'HOMEBREW_NO_AUTO_UPDATE=1 brew install'

# tmux
alias tn 'tmux new-session -s'

function ca
  cargo add $argv; and cargo sort
end

function cr
  cargo remove $argv; and cargo sort
end

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
