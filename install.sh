#!/usr/bin/env bash
# Symlink every dotfile in this repo into $HOME.
# Existing files that aren't already our symlinks are moved to <name>.bak.<timestamp>.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
stamp="$(date +%Y%m%d%H%M%S)"

shopt -s dotglob nullglob
for src in "$repo"/.*; do
  name="$(basename "$src")"
  case "$name" in
    . | .. | .git | .gitignore | .github) continue ;;
  esac

  dest="$HOME/$name"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok      $dest"
    continue
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak.$stamp"
    echo "backup  $dest -> $dest.bak.$stamp"
  fi

  ln -s "$src" "$dest"
  echo "link    $dest -> $src"
done
