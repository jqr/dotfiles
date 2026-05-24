if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/${DOTFILES_SHELL}/ghostty.${DOTFILES_SHELL}"
fi

if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
  # shellcheck disable=SC1090 # path depends on DOTFILES_SHELL
  source "/Applications/iTerm.app/Contents/Resources/iterm2_shell_integration.${DOTFILES_SHELL}" 2>/dev/null
fi
