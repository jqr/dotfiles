# Loaded once per login shell.

# Re-search $PATH when a cached command location is stale (e.g. after brew upgrade).
shopt -s checkhash

# shellcheck disable=SC1090 # path depends on user's home directory
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
