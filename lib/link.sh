#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

# "source path (relative to repo root):target path (relative to $HOME)"
# Everything is copied, never symlinked - nothing in $HOME may depend on
# where this repo happens to live (e.g. under ~/Documents). Re-run
# install.sh after editing a source file here to pick up the change.
LINKS=(
  "zsh/.zshrc:.zshrc"
  "zsh/.zprofile:.zprofile"
  "zsh/exports.zsh:.config/zsh/exports.zsh"
  "zsh/aliases.zsh:.config/zsh/aliases.zsh"
  "zsh/functions.zsh:.config/zsh/functions.zsh"
  "zsh/completions.zsh:.config/zsh/completions.zsh"
  "git/.gitconfig:.gitconfig"
  "git/.gitignore_global:.gitignore_global"
  "vim/.vimrc:.vimrc"
  "sgpt/.sgptrc:.config/shell_gpt/.sgptrc"
  "pet/snippet.toml:.config/pet/snippet.toml"
)

copy_one() {
  local src="$REPO_DIR/$1"
  local dest="$HOME/$2"

  if [ -f "$dest" ] && [ ! -L "$dest" ] && cmp -s "$src" "$dest"; then
    echo "  ok:     $2 already up to date"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="${dest}.bak.${TIMESTAMP}"
    echo "  backup: $2 -> $(basename "$backup")"
    mv "$dest" "$backup"
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "  copied: $2 -> $1"
}

echo "==> Copying dotfiles into $HOME"
for entry in "${LINKS[@]}"; do
  src="${entry%%:*}"
  dest="${entry#*:}"

  if [ ! -e "$REPO_DIR/$src" ]; then
    echo "  skip:   $src (not found in repo)"
    continue
  fi

  copy_one "$src" "$dest"
done
