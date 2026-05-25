if type -q mise 
  mise activate fish --shims | source
  mise completion fish | source

  function __mise_keep_local_bin_first --on-event fish_prompt --on-variable PWD
    fish_add_path --path --move --prepend "$HOME/.local/bin"
  end
end
