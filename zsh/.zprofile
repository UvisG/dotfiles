# Homebrew shell environment. Checked in this order: Apple Silicon,
# Intel Mac, Linuxbrew.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# pipx-installed CLIs (e.g. sgpt) land here.
export PATH="$HOME/.local/bin:$PATH"

# go-installed CLIs (e.g. awss) land here.
export PATH="$HOME/go/bin:$PATH"
