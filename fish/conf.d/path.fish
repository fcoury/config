fish_add_path --prepend $HOME/.local/bin $PATH
fish_add_path --prepend $HOME/.config/scripts $PATH

# Add PostgreSQL path only if it exists
if test -d /Applications/Postgres.app/Contents/Versions/latest/bin
  fish_add_path /Applications/Postgres.app/Contents/Versions/latest/bin
end

# Add wezterm to path if it is installed
if test -d /Applications/WezTerm.app/Contents/MacOS
  fish_add_path /Applications/WezTerm.app/Contents/MacOS
end

