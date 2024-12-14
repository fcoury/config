#!/usr/bin/env bash
SCRIPT=$(basename $0)
SCRIPT_PATH=$(pwd)
LINK_TARGET="$HOME/.config"
HOSTNAME=$(hostname -s)

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

# Function to check for machine-specific override
function get-override-path {
  local base_path="$1"
  local base_name=$(basename "$base_path")
  local override_path="_override/$HOSTNAME/$base_name"
  
  if [ -e "$override_path" ]; then
    echo "$override_path"
  else
    echo "$base_path"
  fi
}

link-path() {
  cd "$1"
  shopt -s dotglob
  for f in "$1"/*; do
    if [ "$f" != "./$SCRIPT" ] && [ "$(basename "$f")" != "_override" ]; then
      FOLDER_NAME=$(basename "$f")
      SKIP_FOLDER=false
      
      # Check for machine-specific override
      ORIGINAL_PATH="$f"
      f=$(get-override-path "$f")
      
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
      TARGET="${LINK_TARGET}/${FOLDER_NAME}"
      
      if [ -f "${f}/.link" ]; then
        LINK_NAME=$(cat "${f}/.link")
        TARGET="${LINK_TARGET}/${LINK_NAME}"
      fi
      
      if [ -e "$TARGET" ]; then
        echo "Skipping (already exists): $SOURCE"
      else
        echo "Linking: $SOURCE -> $TARGET"
        mkdir -p "$(dirname "$TARGET")"
        ln -s "$SOURCE" "$TARGET"
      fi
    fi
  done
}

link-path "."
