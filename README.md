# dotfiles

Personal machine setup: Homebrew packages, zsh config, aliases, completions.
Clone this on a new Mac or Linux box, run one script, get a configured shell.

## Usage

    git clone <this-repo-url> ~/dotfiles
    cd ~/dotfiles
    ./install.sh

This will:

1. Install Homebrew if it's missing (works on macOS and Linux).
2. Install everything listed in `Brewfile` (and `Brewfile.mac` on macOS).
3. Copy the tracked dotfiles into `$HOME` as real, standalone files - never
   symlinks, and nothing at shell startup reads from wherever this repo
   happens to live (e.g. under `~/Documents`) - backing up anything already
   there as `<file>.bak.<timestamp>`.

Re-running `install.sh` is safe — it skips files already up to date
and won't clobber unrelated existing config.

## Layout

    Brewfile        CLI tools, shared across macOS and Linux
    Brewfile.mac    GUI apps (casks) and Mac App Store apps, macOS only
    zsh/            .zshrc, .zprofile, and the pieces it sources:
                    exports.zsh, aliases.zsh, functions.zsh, completions.zsh
                    (deployed to ~/.config/zsh/, not sourced from here)
    lib/link.sh     installs the files above into $HOME (see below)

`~/.zshrc` sources `~/.config/zsh/{exports,aliases,functions,completions}.zsh`
by fixed path, plus `~/.config/zsh/local.zsh` if present for secrets/machine-
local overrides (never tracked in this repo - see below).

## Adding a new dotfile

1. Put the file under a matching directory (e.g. `git/.gitconfig`).
2. Add a `"source:target"` line to the `LINKS` array in `lib/link.sh`.
3. Re-run `./install.sh`. This copies the file into `$HOME` - it does not
   symlink, so after editing the source in the repo you need to re-run
   `install.sh` (or `lib/link.sh` directly) to pick up the change.

## Keeping the Brewfile current

After installing something new with `brew install`/`brew install --cask`,
regenerate the lists from what's actually on the machine:

    brew bundle dump --file=Brewfile --force

## Secrets

Never commit a real API key/token to this repo. On macOS, store it in
Keychain once:

    security add-generic-password -a "$USER" -s "<some-name>" -w

then read it back in `exports.zsh` with
`security find-generic-password -a "$USER" -s "<some-name>" -w` (see the
Anthropic key there for a working example). For anything that doesn't fit
that pattern, `~/.config/zsh/local.zsh` is sourced by `.zshrc` if present -
it lives outside this repo and is never git-tracked.
