# Sourced by zsh. Every file here (and this file itself) is a real, standalone
# copy installed by lib/link.sh - nothing at shell startup reads from wherever
# this repo happens to be checked out. Edit the source in the repo, then
# re-run install.sh (or lib/link.sh) to pick up the change.
for file in exports aliases functions completions; do
  [ -f "$HOME/.config/zsh/$file.zsh" ] && source "$HOME/.config/zsh/$file.zsh"
done

# Secrets/machine-local overrides - not part of this repo, never git-tracked.
[ -f "$HOME/.config/zsh/local.zsh" ] && source "$HOME/.config/zsh/local.zsh"
