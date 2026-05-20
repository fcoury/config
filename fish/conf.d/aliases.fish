# git aliases
alias gl "git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gp 'git pull'
alias gps 'git push'
alias gs 'git status'
alias gpr 'hub pull-request|xargs open'
alias gtr 'git track'
alias gap 'git add -p'
alias fgit git-fcoury

function git-fcoury --description "Run git using the personal GitHub SSH key"
    env GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519_fcoury_github -o IdentitiesOnly=yes' git $argv
end

function br --description "Open current repo in browser on current branch"
    gh browse --branch (git rev-parse --abbrev-ref HEAD)
end

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

# ai and vibecoding
#alias yolo 'ENABLE_BACKGROUND_TASKS=1 FORCE_AUTO_BACKGROUND_TASKS=1 claude --dangerously-skip-permissions'
alias yolo 'claude --dangerously-skip-permissions --chrome'
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

function psc
  ps -Ao pid,etime,%cpu,%mem,command | sort -k3 -rn | head -10
end

function psm
  ps -Ao pid,etime,%cpu,%mem,command | sort -k4 -rn | head -10
end

# --- fd and rg aliases ---
alias fdh 'fd --color=always --hidden --no-ignore'
alias rgh 'rg --color=always --hidden --no-ignore'

function trashpick --description "Interactively select files/folders in the current directory and move them to trash"
    if not command -q fzf
        echo "Error: fzf is not installed"
        return 1
    end

    if not command -q trash
        echo "Error: trash is not installed"
        return 1
    end

    set -l selected (
        find . -mindepth 1 -maxdepth 1 -exec sh -c '
            for p do
                if [ -L "$p" ]; then
                    printf "LINK\t%s\t%s\n" "$p" "$(readlink "$p")"
                elif [ -d "$p" ]; then
                    printf "DIR \t%s\t\n" "$p"
                else
                    printf "FILE\t%s\t\n" "$p"
                fi
            done
        ' sh {} + |
        fzf -m \
            --delimiter '\t' \
            --with-nth 1,2,3 \
            --prompt "trash> " \
            --header "Tab to select, Enter to move selected files/folders to trash" \
            --preview 'ls -la {2}'
    )

    if test -z "$selected"
        echo "No files selected."
        return 0
    end

    set -l targets
    for line in $selected
        set -l fields (string split \t -- $line)
        set -a targets "$fields[2]"
    end

    trash -- $targets
end
