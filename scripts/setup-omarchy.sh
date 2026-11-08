#!/usr/bin/env bash
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
case "${1:-}" in
  ""|--omarchy) ;;
  *) echo "Usage: setup.sh --omarchy" >&2; exit 2 ;;
esac
link_config() {
local source_dir="$1"
local target="$2"
if [[ -L "$target" && $(readlink "$target") == "$source_dir" ]]; then
  echo "Already linked: $target"
  return
fi
if [[ -e "$target" || -L "$target" ]]; then
  backup="$target.bak.$(date +%Y%m%d%H%M%S).$$"
  mv -- "$target" "$backup"
  echo "Backed up config to $backup"
fi
mkdir -p -- "$(dirname -- "$target")"
ln -s -- "$source_dir" "$target"
echo "Linked: $target"
}

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
link_config "$repo/fish/omarchy" "$config_home/fish"
bash "$repo/scripts/setup-red.sh" "$repo/red" "$config_home/red"
link_config "$repo/omarchy/ghostty/config" "$config_home/ghostty/config"
link_config "$repo/omarchy/hypr/input.lua" "$config_home/hypr/input.lua"
link_config "$repo/omarchy/hypr/monitors.lua" "$config_home/hypr/monitors.lua"
link_config "$repo/omarchy/hypr/bindings.lua" "$config_home/hypr/bindings.lua"
link_config "$repo/omarchy/XCompose" "$HOME/.XCompose"
echo "To apply desktop changes, run: hyprctl reload; hyprctl configerrors; omarchy restart xcompose"
