if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/${DOTFILES_SHELL}/ghostty.${DOTFILES_SHELL}"
fi

if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
  source "/Applications/iTerm.app/Contents/Resources/iterm2_shell_integration.${DOTFILES_SHELL}" 2>/dev/null
fi
