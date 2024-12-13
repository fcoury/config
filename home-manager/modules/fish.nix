{ config, pkgs, lib, ... }:

{
  # Starts fish from bash

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # set -U fish_user_paths $HOME/bin $fish_user_paths

      if status is-interactive
        set -U fish_greeting
      end

      set -gx EDITOR "${pkgs.neovim}/bin/nvim"
      set -gx TERM "xterm-256color"

      set PATH $HOME/.local/bin $HOME/.cargo/bin $PATH
      set -g CDPATH . $HOME $HOME/code

      ${builtins.readFile ./fish/aliases.fish}
      ${builtins.readFile ./fish/starship.fish}
    '';
  };
}
