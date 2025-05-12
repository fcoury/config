# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains personal configuration files (dotfiles) for various developer tools and applications. It's organized as a symlink-based configuration manager that creates links from this repository to the user's ~/.config directory.

## Installation and Setup

The primary setup script is `setup.sh`, which:
- Creates symbolic links from this repository to `~/.config/`
- Supports machine-specific overrides via the `_override/hostname/` directory
- Handles platform-specific configurations (macOS vs Linux)

To install configurations:
```bash
# From the repository root
./setup.sh
```

## Repository Structure

This repository contains configurations for:

### Terminal Emulators
- WezTerm (`wezterm/`)
- Alacritty (`alacritty.toml`)
- Kitty (`kitty/`)
- Ghostty (`ghostty/`)

### Shell
- Fish shell (`fish/`) with extensive configurations in `conf.d/`

### Editors
- Neovim (`nvim/`) with plugin configurations in `lua/plugins/`
- Helix (`helix/`)
- Zed (`zed/`)
- Red (`red/`) - possibly a text editor configuration

### Window Managers
- Yabai (`yabai/`) - macOS window manager
- Hyprland (`hypr/`) - Wayland compositor for Linux
- Aerospace (`aerospace/`) - macOS window manager

### Terminal Multiplexers
- Tmux (`tmux/`)
- Zellij (`zellij/`)

### UI Elements
- Rofi (`rofi/`) - Application launcher for Linux
- Waybar (`waybar/`) - Status bar for Wayland
- Starship (`starship.toml`) - Shell prompt

### CLI Tools
- Git UI (`gitui/`)
- Various utility scripts (`scripts/`)

## Key Features

1. **Machine-specific Overrides**: Files in `_override/hostname/` take precedence over the base configuration
2. **Modular Fish Configuration**: Organized in `conf.d/` for easy maintenance
3. **Cross-platform Support**: Configurations for both macOS and Linux systems
4. **Theming**: Various themes defined across tools (nord, catppuccin, etc.)

## Working with This Repository

When making changes:
1. Modify the config files directly in this repository
2. For machine-specific changes, create an override in `_override/hostname/`
3. Run `./setup.sh` to apply changes

## Utility Scripts

Various utility scripts are available in the `scripts/` directory:
- `gh-merged-branches` - Git utility for managing merged branches
- `git-defbranch` - Get the default branch of a Git repository
- `grb` - Likely a Git rebase utility
- `rfv`, `rl`, `rlr` - File/directory navigation utilities
- `tp` - Unknown utility
- `wn` - Unknown utility
- `zz` - Unknown utility

## Notes for Editors

- Neovim configuration is highly modular with separate plugin files in `lua/plugins/`
- There are both active and disabled plugins in the Neovim setup
- Fish configuration relies heavily on the module system in `conf.d/`