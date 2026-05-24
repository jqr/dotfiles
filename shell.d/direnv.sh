if type direnv >& /dev/null; then
  eval "$(direnv hook "${DOTFILES_SHELL}")"
fi
