[[ $- != *i* ]] && return

if [[ "$OSTYPE" == darwin* ]] && [[ "$BASH" == /bin/bash ]]; then
  __dotfiles_zsh_banner() {
    throttle 86400 zsh-banner echo -e "\nzsh now fully supported by jqr/dotfiles"
    PROMPT_COMMAND="${PROMPT_COMMAND/__dotfiles_zsh_banner;/}"
    unset -f __dotfiles_zsh_banner
  }
  PROMPT_COMMAND="__dotfiles_zsh_banner;${PROMPT_COMMAND:-}"
fi

# shellcheck disable=SC2034 # used by shell.d scripts
DOTFILES_SHELL=bash

if [[ -z "$DOTFILES_SKIP_SHELL_D" ]]; then
  # shellcheck disable=SC1090 # files are dynamic, loaded by glob
  for file in "$HOME"/.shell.d/*.sh; do
    source "$file"
  done
fi