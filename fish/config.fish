if status is-interactive
  set -U fish_greeting
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /Users/fcoury/.ghcup/bin # ghcup-env