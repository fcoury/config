# Quick password retrieval
alias getpass='op item get'

# Function to copy password to clipboard
function get_password
    op item get $argv[1] --fields password | pbcopy
    echo "Password copied to clipboard"
end

# Function with argument validation
function get_password
    if test (count $argv) -eq 0
        echo "Usage: get_password <item-name>"
        return 1
    end
    
    op item get $argv[1] --fields password | pbcopy
    echo "Password copied to clipboard for: $argv[1]"
end

# Function to get any field from 1Password item
function get_field
    if test (count $argv) -lt 2
        echo "Usage: get_field <item-name> <field-name>"
        return 1
    end
    
    op item get $argv[1] --fields $argv[2] | pbcopy
    echo "$argv[2] copied to clipboard for: $argv[1]"
end

# Quick SSH connection using 1Password
function ssh_from_1p
    if test (count $argv) -eq 0
        echo "Usage: ssh_from_1p <item-name>"
        return 1
    end
    
    set username (op item get $argv[1] --fields username)
    set hostname (op item get $argv[1] --fields hostname)
    ssh $username@$hostname
end

