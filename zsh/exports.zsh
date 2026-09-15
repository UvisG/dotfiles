export EDITOR="vim"
export HOMEBREW_NO_ENV_HINTS=1

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
