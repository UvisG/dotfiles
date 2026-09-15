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
3. Copy the tracked dotfiles into `$HOME` as real, standalone files (never
   symlinks - nothing in `$HOME` should depend on where this repo lives,
   e.g. under `~/Documents`), backing up anything already there as
   `<file>.bak.<timestamp>`.
4. Export `DOTFILES` in `~/.zshenv` so `.zshrc` knows where to source the
   modular pieces (`aliases.zsh`, `exports.zsh`, etc.) from.

Re-running `install.sh` is safe — it skips files already up to date
and won't clobber unrelated existing config.

## Layout

    Brewfile        CLI tools, shared across macOS and Linux
    Brewfile.mac    GUI apps (casks) and Mac App Store apps, macOS only
    zsh/            .zshrc, .zprofile, and the pieces they source:
                    exports.zsh, aliases.zsh, functions.zsh, completions.zsh
    lib/link.sh     installs the files above into $HOME (see below)

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
