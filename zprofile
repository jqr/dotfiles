# Loaded once per login shell.

# shellcheck disable=SC1090 # path depends on user's home directory
if [ -f ~/.zshrc ]; then
  source ~/.zshrc
fi
