export EDITOR="vim"
export HOMEBREW_NO_ENV_HINTS=1

# Custom prompt: kube context/namespace (kube_ps1, defined in completions.zsh)
# + current directory + git branch, with a red dot if the tree is dirty
# (git_ps1, defined in functions.zsh) - both loaded after this file, fine
# since $(...) here is evaluated lazily per-prompt, not at assignment time.
# Deliberately no user@host.
PROMPT='$(kube_ps1)%1~ $(git_ps1)%# '

# atuin's "?" AI mode needs an OpenAI-compatible chat-completions endpoint
# (e.g. Ollama locally, or OpenRouter/LiteLLM if you want to point it at
# Claude). Configure via ~/.config/atuin/config.toml -> [ai] endpoint/
# api_token, not env vars here - see https://docs.atuin.sh.

# Anthropic key, pulled from macOS Keychain (never stored in a plaintext
# file, tracked or otherwise). Populate it once with:
#   security add-generic-password -a "$USER" -s "anthropic-api-key" -w
# sgpt (shell_gpt) is configured (sgpt/.sgptrc) to call Claude via litellm;
# despite the name, OPENAI_API_KEY must hold this same value - see the
# comment in sgpt/.sgptrc for why.
if command -v security &>/dev/null; then
  ANTHROPIC_API_KEY="$(security find-generic-password -a "$USER" -s "anthropic-api-key" -w 2>/dev/null)"
  if [ -n "$ANTHROPIC_API_KEY" ]; then
    export ANTHROPIC_API_KEY
    export OPENAI_API_KEY="$ANTHROPIC_API_KEY"
  fi
fi

# claude-sonnet-5 rejects sgpt's hardcoded temperature=0.0 (only temperature=1
# is supported) - this makes litellm silently drop unsupported params like
# that instead of erroring, rather than sgpt needing per-call flags.
export LITELLM_DROP_PARAMS=true

# pet reads this env var directly for its GitHub gist sync backend (pet
# sync) - a real, built-in override, not a workaround. Needs a token with
# the "gist" scope: https://github.com/settings/tokens/new. Populate once:
#   security add-generic-password -a "$USER" -s "pet-github-token" -w
if command -v security &>/dev/null; then
  PET_GITHUB_ACCESS_TOKEN="$(security find-generic-password -a "$USER" -s "pet-github-token" -w 2>/dev/null)"
  [ -n "$PET_GITHUB_ACCESS_TOKEN" ] && export PET_GITHUB_ACCESS_TOKEN
fi
