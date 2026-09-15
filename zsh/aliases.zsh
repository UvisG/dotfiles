# Shell
alias ll="ls -lah"
alias la="ls -A"
alias ..="cd .."
alias ...="cd ../.."

# Git
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

# Kubernetes
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"

# bat is aliased (not unconditionally) so a missing binary doesn't break
# the plain `cat` command everything else relies on.
if command -v bat &>/dev/null; then
  alias cat="bat --paging=never"
fi

# Add your own below
