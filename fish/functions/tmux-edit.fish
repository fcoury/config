function tmux-edit
    set -l tmp_file (mktemp)
    # Capture the current pane content to a temporary file
    tmux capture-pane -pS - > $tmp_file
    
    # Open the file in Neovim in a new tmux window
    tmux new-window -n "Edit Pane" "nvim $tmp_file; and fish -c 'cat $tmp_file | pbcopy; echo \"Content copied to clipboard\"; read -P \"Press Enter to close... \" -a ignore'"
    
    # Clean up the temp file (this runs after the window is closed)
    # We use a background job to give time for the new window to fully capture the file
    fish -c "sleep 1; rm $tmp_file" &
end
