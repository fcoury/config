{ config, pkgs, lib, ... }:

let
  font = "FantasqueSansM Nerd Font Mono";
in
{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}


