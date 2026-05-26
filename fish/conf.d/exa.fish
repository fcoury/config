# Resolve eza when ls is invoked: path.fish is loaded after this fragment.
function ls
    if not type -q eza
        command ls $argv
        return
    end

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
