if status is-interactive
  set -U fish_greeting
end

set -gx EDITOR /opt/homebrew/bin/nvim
set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
set -gx TERM "xterm-256color"

# Added by Windsurf
set -g PATH $HOME/.codeium/windsurf/bin $PATH

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/fcoury/.cache/lm-studio/bin
# End of LM Studio CLI section

# increase maximum number of open files (for language servers, etc.)
ulimit -n 65536

# opencode
fish_add_path /Users/fcoury/.opencode/bin

# fabro
fish_add_path $HOME/.fabro/bin
