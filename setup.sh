#!/usr/bin/env bash

SCRIPT=$(basename $0)
SCRIPT_PATH=$(pwd)
LINK_TARGET="$HOME/.config"

# Detect OS
case "$OSTYPE" in
    darwin*)  PLATFORM="macOS" ;;
    linux*)   PLATFORM="Linux" ;;
    *)        PLATFORM="unknown" ;;
esac

# Function to convert to absolute path
function to-abs-path {
  local target="$1"
  if [ "$target" == "." ]; then
    echo "$(pwd)"
  elif [ "$target" == ".." ]; then
    echo "$(dirname "$(pwd)")"
  else
    echo "$(
      cd "$(dirname "$1")"
      pwd
    )/$(basename "$1")"
  fi
}

link-path() {
  cd "$1"
  shopt -s dotglob
  for f in "$1"/*; do
    if [ "$f" != "./$SCRIPT" ]; then
      FOLDER_NAME=$(basename "$f")
      SKIP_FOLDER=false

      if [ -f "$f/.skip" ]; then
        while IFS= read -r line; do
          if [ "$line" == "$PLATFORM" ]; then
            SKIP_FOLDER=true
            break
          fi
        done < "$f/.skip"
      fi

      if [ "$SKIP_FOLDER" == true ]; then
        echo "Skipping $FOLDER_NAME on $PLATFORM"
        continue
      fi

      SOURCE=$(to-abs-path "$f")
      TARGET="${LINK_TARGET}/$1/$f"
      TARGET="$(echo "$TARGET" | sed -r 's|\.\/||g')"
      if [ -f "${f}/.link" ]; then
        LINK_NAME=$(cat "${f}/.link")
        TARGET="${LINK_TARGET}/${LINK_NAME}"
      fi
      if [ -e "$TARGET" ]; then
        echo "Skipping (already exists): $SOURCE"
      else
        echo "Linking: $SOURCE -> $TARGET"
        ln -s "$SOURCE" "$TARGET"
      fi
    fi
  done
}

link-path "."

