#!/usr/bin/env bash
set -euo pipefail
source_dir="$1"
target_dir="$2"

# Preserve local runtime data when migrating from a whole-directory link.
if [[ -L "$target_dir" ]]; then
  backup="$target_dir.bak.$(date +%Y%m%d%H%M%S).$$"
  existing=$(readlink -f -- "$target_dir")
  mv -- "$target_dir" "$backup"
  mkdir -p -- "$target_dir"
  if [[ -d "$existing" ]]; then
    cp -a -- "$existing/." "$target_dir/"
  fi
  echo "Backed up Red directory link to $backup; preserved local data."
fi

mkdir -p -- "$target_dir"
source_file="$source_dir/config.toml"
target_file="$target_dir/config.toml"
if [[ -L "$target_file" && $(readlink "$target_file") == "$source_file" ]]; then
  echo "Already linked: $target_file"
  exit 0
fi
if [[ -e "$target_file" || -L "$target_file" ]]; then
  mv -- "$target_file" "$target_file.bak.$(date +%Y%m%d%H%M%S).$$"
fi
ln -s -- "$source_file" "$target_file"
echo "Linked: $target_file"
