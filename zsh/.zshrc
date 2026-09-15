# Sourced by zsh. DOTFILES is exported from ~/.zshenv by install.sh; the
# fallback below lets this file work even before that line exists.
: "${DOTFILES:=$HOME/dotfiles}"

for file in exports aliases functions completions; do
  [ -f "$DOTFILES/zsh/$file.zsh" ] && source "$DOTFILES/zsh/$file.zsh"
done
