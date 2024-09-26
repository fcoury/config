{ config, pkgs, ... }:


let
  unstablePkgs = import <nixpkgs-unstable> { };
in
{
  imports = [
    ./modules/font.nix
    ./modules/fish.nix
    ./modules/wezterm.nix
    ./modules/tmux.nix
    ./modules/git.nix
    ./modules/neovim.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.username = "fcoury";
  home.homeDirectory = "/home/fcoury";

  programs.firefox.enable = true;


  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    gcc
    pkg-config
    rustup
    nodejs_22
    alacritty
    kitty
    xclip
    hyprland
    wl-clipboard
    waybar
    ripgrep
    fd
    tree
    lazygit
    starship
  ];
}

