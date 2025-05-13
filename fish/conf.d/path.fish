set -g PATH $HOME/.local/bin $HOME/.config/scripts $PATH

# Add PostgreSQL path only if it exists
if test -d /Applications/Postgres.app/Contents/Versions/latest/bin
  set -g PATH /Applications/Postgres.app/Contents/Versions/latest/bin $PATH
end

# Add wezterm to path if it is installed
if test -d /Applications/WezTerm.app/Contents/MacOS
  set -g PATH /Applications/WezTerm.app/Contents/MacOS $PATH
end

