if test -d "$HOME/.atuin"
  source "$HOME/.atuin/bin/env.fish"
  type -q atuin && atuin init fish --disable-up-arrow | source
end
