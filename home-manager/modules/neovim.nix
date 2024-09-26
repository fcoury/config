{ config, pkgs, lib, ... }:

let
  unstablePkgs = import <nixpkgs-unstable> { };
in
{
  programs.neovim = {
    enable = true;
    package = unstablePkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      telescope-nvim
      nvim-treesitter
      lualine-nvim
      nvim-lspconfig
    ];
  };

  home.file.".config/nvim/init.lua" = {
    source = ./nvim/init.lua;
  };
}

