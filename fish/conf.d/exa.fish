# Remove alias or function named 'ls' if it exists
functions -e ls

# Check if 'eza' command exists
if type -q eza || test -e /opt/homebrew/bin/exa
    # Define the 'ls' function
    function ls
        # Check if '-rt' is in the arguments
        set contains_rt false
        for arg in $argv
            if test "$arg" = "-rt"
                set contains_rt true
                break
            end
        end

        # Replace '-rt' with '-snew' if present
        if test $contains_rt = true
            set new_argv (string replace -- '-rt' '-snew' $argv)
            eza $new_argv
        else
            eza $argv
        end
    end
end

