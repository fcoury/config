if type -q starship
    # PROMPT_THEME=light|dark remains a manual override, but by default we ask
    # supported terminals for their real background color via OSC 11.
    set -l prompt_theme "$PROMPT_THEME"

    if test -z "$prompt_theme"
        set prompt_theme ("$HOME/code/config/scripts/detect-terminal-theme.py" 2>/dev/null)
    end

    switch "$prompt_theme"
        case light
            set -gx STARSHIP_CONFIG "$HOME/code/config/starship-light.toml"
        case '*'
            set -gx STARSHIP_CONFIG "$HOME/code/config/starship.toml"
    end

    starship init fish | source
end
