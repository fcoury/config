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
    };
  };
}

