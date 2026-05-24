[[ $- != *i* ]] && return

if [[ "$OSTYPE" == darwin* ]] && [[ "$BASH" == /bin/bash ]]; then
  __dotfiles_zsh_banner() {
    echo ""
    echo "zsh now fully supported by jqr/dotfiles"
    PROMPT_COMMAND="${PROMPT_COMMAND/__dotfiles_zsh_banner;/}"
    unset -f __dotfiles_zsh_banner
  }
  PROMPT_COMMAND="__dotfiles_zsh_banner;${PROMPT_COMMAND:-}"
fi

# shellcheck disable=SC1090 # files are dynamic, loaded by glob
for file in "$HOME"/.shell.d/*.sh; do
  source "$file"
done

# shellcheck disable=SC2155 # empty VISUAL is fine if no editor is found
export VISUAL=$(first_of "subl -w" "mate -w" "nano -w" vi)
export EDITOR=$VISUAL

if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  # shellcheck disable=SC1091 # path depends on iTerm installation
  source /Applications/iTerm.app/Contents/Resources/iterm2_shell_integration.bash 2>/dev/null
fi
