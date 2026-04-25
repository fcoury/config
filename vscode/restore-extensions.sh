#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/vscode-extensions.txt"

if [[ ! -f "$EXTENSIONS_FILE" ]]; then
  echo "Error: $EXTENSIONS_FILE not found"
  exit 1
fi

while IFS= read -r ext; do
  [[ -z "$ext" ]] && continue
  echo "Installing $ext..."
  code --install-extension "$ext" --force
done < "$EXTENSIONS_FILE"

echo "Done. All extensions restored."
