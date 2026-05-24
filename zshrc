# shellcheck disable=SC2034 # used by shell.d scripts
DOTFILES_SHELL=zsh

if [[ -z "$DOTFILES_SKIP_SHELL_D" ]]; then
  # shellcheck disable=SC1090 # files are dynamic, loaded by glob
  for file in "$HOME"/.shell.d/*.sh; do
    source "$file"
  done
fi

# shellcheck disable=SC2155 # empty VISUAL is fine if no editor is found
export VISUAL=$(first_of "subl -w" "mate -w" "nano -w" vi)
export EDITOR=$VISUAL
