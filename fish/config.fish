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

/home/fcoury/.local/bin/mise activate fish | source
source $HOME/.cargo/env.fish
