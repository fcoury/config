# Go configuration

# Set GOPATH and add to PATH
if test -d "$HOME/go"
    set -gx GOPATH $HOME/go
    set -gx PATH $GOPATH/bin $PATH
end

# Add Go installation to PATH (if using Homebrew)
if test -d "/opt/homebrew/opt/go/bin"
    set -gx PATH /opt/homebrew/opt/go/bin $PATH
end

# Alternate Go install locations
if test -d "/usr/local/go/bin"
    set -gx PATH /usr/local/go/bin $PATH
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
    set -gx PATH $GOPATH/bin $PATH
    
    echo "Switched to Go workspace: $GOPATH"
end

# Go test with watch functionality
function wgo
    set -l cmd (string join ' ' $argv)
    watchexec -c -r -e go -- go $cmd
end