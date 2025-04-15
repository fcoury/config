if status is-interactive
  set -U fish_greeting
end

set -gx EDITOR /opt/homebrew/bin/nvim
set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
set -gx TERM "xterm-256color"
