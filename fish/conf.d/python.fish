# Pyenv
if test -d ~/.pyenv
  set -gx PYENV_ROOT $HOME/.pyenv
  status is-interactive; and source (pyenv init -|psub)
end
