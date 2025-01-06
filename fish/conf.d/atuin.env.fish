if test -d "$HOME/.atuin"
  source "$HOME/.atuin/bin/env.fish"
  # atuin init fish --disable-up-arrow --disable-ctrl-r | source
  atuin init fish --disable-up-arrow | source
end
