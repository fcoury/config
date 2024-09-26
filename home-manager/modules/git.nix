{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "Felipe Coury";
    userEmail = "felipe.coury@gmail.com";
    
    aliases = {
      st = "status -sb";
      co = "checkout";
    };

    extraConfig = {
      color = {
        ui = "auto";
      };

      push = {
        default = "simple";
        autoSetupRemote = "true";
      };

      pull = {
        rebase = "false";
      };

      # this helps with the hub app, just do a git pull/push or another
      # operation that takes auth and then go to Personal Access Tokens,
      # generate one and paste as password when prompted
      credential = {
        helper = "store";
      };
    };
  };
}

