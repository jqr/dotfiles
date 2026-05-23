[[ $- != *i* ]] && return

for file in "$HOME"/.bash_profile.d/*.sh; do
  source "$file"
done

export VISUAL=$(first_of "subl -w" "mate -w" "nano -w" vi)
export EDITOR=$VISUAL

if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  # shellcheck disable=SC1091 # path depends on iTerm installation
  source /Applications/iTerm.app/Contents/Resources/iterm2_shell_integration.bash 2>/dev/null
fi
