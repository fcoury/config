# Go configuration

# Set GOPATH
if test -d "$HOME/go"
    set -gx GOPATH $HOME/go
end

# Go workspace management
function gowk
    set -l workspace $argv[1]
    
    if test -z "$workspace"
        echo "Current GOPATH: $GOPATH"
        return 0
    end
    
    set -l new_path "$HOME/go/$workspace"
    
    if not test -d "$new_path"
        echo "Creating workspace directory: $new_path"
        mkdir -p "$new_path/src" "$new_path/bin" "$new_path/pkg"
    end
    
    set -gx GOPATH $new_path
    fish_add_path --path --move --prepend $GOPATH/bin
    
    echo "Switched to Go workspace: $GOPATH"
end

# Go test with watch functionality
function wgo
    set -l cmd (string join ' ' $argv)
    watchexec -c -r -e go -- go $cmd
end
