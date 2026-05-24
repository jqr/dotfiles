# Loaded once per login shell.

shopt -s checkhash # force path search on stale cache detected


# shellcheck disable=SC1090 # path depends on user's home directory
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
