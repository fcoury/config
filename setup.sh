#!/bin/bash

SCRIPT=$(basename $0)
SCRIPT_PATH=$(pwd)

mkdir -p ~/.config

for f in *; do
  if [ "$f" != "$SCRIPT" ]; then
    ln -s "$SCRIPT_PATH/$f" "$HOME/.config/$f"
  fi
done
