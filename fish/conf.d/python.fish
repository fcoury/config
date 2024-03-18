# Pyenv
if test -d ~/.pyenv
  set -gx PYENV_ROOT $HOME/.pyenv
  set -gx PATH $PYENV_ROOT/bin $PATH
  status is-interactive; and source (pyenv init -|psub)
end

if test -d /opt/homebrew/opt/pyqt@5
  # Qt 5
  set -gx PATH /opt/homebrew/opt/qt@5/bin $PATH
  set -gx PATH /opt/homebrew/opt/pyqt@5/5.15.4_1/bin $PATH
end
