#!/usr/bin/env bash
# Symlink every dotfile in this repo into $HOME, then install tmux plugins.
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

# clone <url> <dir> [ref]: shallow-clone a repo unless it's already there.
clone() {
  local url="$1" dir="$2" ref="${3:-}"
  if [ -d "$dir/.git" ]; then
    echo "ok      $dir"
    return
  fi
  git -c advice.detachedHead=false clone -q --depth 1 ${ref:+--branch "$ref"} "$url" "$dir"
  echo "clone   $dir${ref:+ ($ref)}"
}

# tmux: tpm, plus catppuccin loaded directly from .tmux.conf (not via tpm)
clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
clone https://github.com/catppuccin/tmux.git "$HOME/.config/tmux/plugins/catppuccin/tmux" v2.3.0

# install the remaining @plugin entries from .tmux.conf
if command -v tmux >/dev/null; then
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null
  echo "ok      tpm plugins"
else
  echo "skip    tpm plugins (tmux not installed)"
fi
