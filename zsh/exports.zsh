export EDITOR="vim"
export HOMEBREW_NO_ENV_HINTS=1

# atuin's "?" AI mode needs an OpenAI-compatible chat-completions endpoint
# (e.g. Ollama locally, or OpenRouter/LiteLLM if you want to point it at
# Claude). Configure via ~/.config/atuin/config.toml -> [ai] endpoint/
# api_token, not env vars here - see https://docs.atuin.sh.
