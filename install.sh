#!/usr/bin/env bash
#
# Symlinks this repo's OS-specific dotfiles (linux/ or mac/) into $HOME so
# that editing ~/.bashrc etc. edits the tracked file directly. Existing real
# files/dirs at the target path are backed up (not overwritten) before the
# symlink is created. Safe to re-run.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Linux)  OS_DIR="$REPO_DIR/linux" ;;
  Darwin) OS_DIR="$REPO_DIR/mac" ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
backed_up=false

link() {
  local src="$1" dest="$2"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      echo "ok      $dest"
      return
    fi
    echo "relink  $dest"
    rm "$dest"
  elif [ -e "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "backup  $dest -> $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
    backed_up=true
  else
    echo "link    $dest"
  fi

  ln -s "$src" "$dest"
}

shopt -s nullglob
for entry in "$OS_DIR"/.[!.]* "$OS_DIR"/[!.]*; do
  name="$(basename "$entry")"
  link "$entry" "$HOME/$name"
done
shopt -u nullglob

if [ "$backed_up" = true ]; then
  echo
  echo "Pre-existing files were moved to $BACKUP_DIR"
fi
