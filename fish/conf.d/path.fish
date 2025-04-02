set -gx path $path $home/.local/bin
set -gx path $path $home/.config/scripts

# Add PostgreSQL path only if it exists
if test -d /Applications/Postgres.app/Contents/Versions/latest/bin
    set -gx PATH $PATH /Applications/Postgres.app/Contents/Versions/latest/bin
end
