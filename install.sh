#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Dotfiles bootstrap from $REPO_DIR"

brew_bin() {
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return
    fi
  done
}

if [ -z "$(brew_bin)" ]; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Homebrew already installed"
fi

eval "$("$(brew_bin)" shellenv)"

# Homebrew refuses to load formulae from third-party taps until trusted
# (`brew trust`). Trust every tap this Brewfile references so `brew bundle`
# doesn't get stuck on "untrusted tap" - harmless no-op on older Homebrew
# versions that don't have this command yet.
trust_taps() {
  [ -f "$1" ] || return 0
  grep -oE '^tap "[^"]+"' "$1" | sed -E 's/^tap "(.+)"$/\1/' | while read -r tap_name; do
    echo "==> Trusting tap: $tap_name"
    brew trust --tap "$tap_name" >/dev/null 2>&1 || true
  done || true
}
trust_taps "$REPO_DIR/Brewfile"
trust_taps "$REPO_DIR/Brewfile.mac"

echo "==> Installing packages from Brewfile"
brew bundle --file="$REPO_DIR/Brewfile"

if [[ "$(uname -s)" == "Darwin" ]] && [ -f "$REPO_DIR/Brewfile.mac" ]; then
  echo "==> Installing macOS-only packages from Brewfile.mac"
  brew bundle --file="$REPO_DIR/Brewfile.mac"
fi

echo "==> Installing shell_gpt (sgpt) via pipx"
export PATH="$HOME/.local/bin:$PATH"
pipx install shell-gpt >/dev/null
# shell_gpt's own dependency metadata doesn't always pull in click, leaving
# it broken with "ModuleNotFoundError: No module named 'click'" - inject it
# explicitly. Safe to re-run: pipx no-ops if it's already there.
pipx inject shell-gpt click >/dev/null
# litellm lets sgpt call Claude instead of OpenAI - see sgpt/.sgptrc.
pipx inject shell-gpt litellm >/dev/null

echo "==> Linking dotfiles"
"$REPO_DIR/lib/link.sh"

echo "==> Done. Restart your shell or run: exec zsh"
