{ config, pkgs, lib, ... }:
let
  t-smart-manager = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "t-smart-tmux-session-manager";
      version = "unstable-2023-01-06";
      rtpFilePath = "t-smart-tmux-session-manager.tmux";
      src = pkgs.fetchFromGitHub {
        owner = "joshmedeski";
        repo = "t-smart-tmux-session-manager";
        rev = "a1e91b427047d0224d2c9c8148fb84b47f651866";
        sha256 = "sha256-HN0hJeB31MvkD12dbnF2SjefkAVgtUmhah598zAlhQs=";
      };
    };
  tmux-nvim = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux.nvim";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "aserowy";
        repo = "tmux.nvim/";
        rev = "57220071739c723c3a318e9d529d3e5045f503b8";
        sha256 = "sha256-zpg7XJky7PRa5sC7sPRsU2ZOjj0wcepITLAelPjEkSI=";
      };
    };
  tmux-browser = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-browser";
      version = "unstable-2023-01-06";
      src = pkgs.fetchFromGitHub {
        owner = "ofirgall";
        repo = "tmux-browser";
        rev = "c3e115f9ebc5ec6646d563abccc6cf89a0feadb8";
        sha256 = "sha256-ngYZDzXjm4Ne0yO6pI+C2uGO/zFDptdcpkL847P+HCI=";
      };
    };

  # tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin
  #   {
  #     pluginName = "tmux-super-fingers";
  #     version = "unstable-2023-01-06";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "artemave";
  #       repo = "tmux_super_fingers";
  #       rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
  #       sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
  #     };
  #   };

  bg = "#2a2a2a";
  default_fg = "#cccccc";
  session_fg = "#789978";
  selection_bg = "#7788AA";
  selection_fg = "#2a2a2a";
  active_pane_border = "#aaaaaa";
  active_window_fg = "#7788AA";
  status_highlight_bg = "#444444";
  highlight_bg = "#373737";
  highlight_fg = "#191919";

in
{
  programs.tmux = {
    enable = true;

    shell = "${pkgs.fish}/bin/fish";
    terminal = "xterm-256color";
    historyLimit = 100000;
    baseIndex = 1;
    prefix = "C-S";

    plugins = with pkgs; [
      tmux-nvim
      {
        plugin = tmux-browser;
        extraConfig = ''
          set -g @browser_close_on_deattach '1'
        '';
      }

      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }

      tmuxPlugins.continuum
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
    ];

    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      unbind r

      set -sg escape-time 0 # without this <ESC> on neovim it takes a few seconds
      set -g mouse on       # mouse mode on

      # act live vim
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # resize pane
      bind-key -r H resize-pane -L 5
      bind-key -r J resize-pane -D 5
      bind-key -r K resize-pane -U 5
      bind-key -r L resize-pane -R 5

      # maximize pane
      bind-key z resize-pane -Z

      # Creating panes
      bind d split-window -h
      bind s split-window -v

      # Detach
      bind-key - detach

      # Closing panes
      bind x kill-pane

      # Moving between panes
      bind-key -n C-x select-pane -t :.+

      set -g status-position bottom
      set -g status-left "#[fg=${session_fg},bold,bg=${status_highlight_bg}]   #(hostname -s) #[fg=${status_highlight_bg},bg=${highlight_bg}]#[fg=${default_fg},bold,bg=${highlight_bg}] #S #[fg=${highlight_bg},bg=default]"
      set -g status-right "#[fg=${status_highlight_bg},bg=${bg}]#[fg=${default_fg},bg=${status_highlight_bg}] 󰃮 %b-%d-%y 󱑒 %H:%M "
      set -g status-justify centre
      set -g status-left-length 200
      set -g status-right-length 200
      set-option -g status-style bg=${bg}
      set -g window-status-current-format "#[fg=${active_window_fg},bg=default]  #I:#W"
      set -g window-status-format "#[fg=${default_fg},bg=default] #I:#W"
      set -g window-status-last-style "fg=${default_fg},bg=default"
      set -g message-command-style bg=default,fg=${default_fg}
      set -g message-style bg=default,fg=${default_fg}
      set -g mode-style bg=${selection_bg},fg=${selection_fg}
      set -g pane-active-border-style "fg=${active_pane_border},bg=default"
      set -g pane-border-style 'fg=brightblack,bg=default'
    '';
  };
}

