# Formulae that ship zsh completions drop them under
# $(brew --prefix)/share/zsh/site-functions or share/zsh-completions.
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
fi

autoload -Uz compinit
compinit

# Below this line: completions for CLI tools that don't ship a zsh completion
# file via Homebrew, so they can't be picked up from FPATH above. When adding
# a new CLI tool to the Brewfile, add its completion here too.

# git, gh, sops, kubectx/kubens, glab: completion files are installed by
# their Homebrew formulae into site-functions and picked up automatically
# via FPATH above.

if command -v kubectl &>/dev/null; then
  source <(kubectl completion zsh)
  compdef k=kubectl
fi

if command -v sofka &>/dev/null; then
  source <(sofka completion zsh 2>/dev/null)
fi

# zoxide init defines the z/zi commands themselves, plus their completion.
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

if command -v tofu &>/dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C tofu tofu
fi

if command -v aws_completer &>/dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C aws_completer aws
fi

# terragrunt has no native completion (gruntwork-io/terragrunt#689); it
# proxies unrecognized args to tofu, so reuse tofu's completer as a
# best-effort fallback rather than skipping completion entirely.
if command -v terragrunt &>/dev/null && command -v tofu &>/dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C tofu terragrunt
fi

# atuin: shell history search/sync. Binds Ctrl-r and Up-arrow to its search
# UI, and a lone "?" at an empty prompt to its AI natural-language mode (see
# exports.zsh for pointing that at an OpenAI-compatible endpoint).
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# direnv hooks precmd/chpwd to load/unload .envrc files per directory.
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# kube-ps1: not a completion, but the same "load a tool's shell integration
# once it's installed" pattern - shows current kube context/namespace in the
# prompt.
if type brew &>/dev/null && command -v kubectl &>/dev/null; then
  KUBE_PS1_SH="$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
  if [ -f "$KUBE_PS1_SH" ]; then
    source "$KUBE_PS1_SH"
    PS1='$(kube_ps1)'$PS1
  fi
fi
