WORKSPACE_PATH="${SUPERCONDUCTOR_WORKSPACE_PATH:-$CONDUCTOR_WORKSPACE_PATH}"

prompt_path() {
  local cwd="$PWD"
  if [ -n "$WORKSPACE_PATH" ] && [ -n "$TERM_PROGRAM" ]; then
    local ws="${WORKSPACE_PATH%/}"
    local relative="${cwd/#$ws/}"
    relative="${relative#/}"
    if [ -n "$relative" ]; then
      echo "./$relative"
    else
      echo "."
    fi
  else
    echo "${cwd/#$HOME/~}"
  fi
}

if [ -n "$WORKSPACE_PATH" ]; then
  cd() {
    if [ $# -eq 0 ]; then
      builtin cd "$WORKSPACE_PATH"
    else
      builtin cd "$@"
    fi
  }
fi

if [ -n "$WORKSPACE_PATH" ] && [ -n "$TERM_PROGRAM" ]; then
  PS1="$RED\$(prompt_path) $LIGHTRED\$(current_git_branch)\$(git_special) $LIGHTRED$ $NC"
elif [ "$SSH_TTY" ]; then
  PS1="$RED\u@\h $RED\$(prompt_path) $LIGHTRED\$(current_git_branch)\$(git_special) $LIGHTRED$ $NC"
  PS1="$PS1\[\e]0;\u@\h\a\]"
else
  PS1="$GREEN\h $RED\$(prompt_path) $LIGHTRED\$(current_git_branch)\$(git_special) $LIGHTRED$ $NC"
  PS1="$PS1\[\e]0;\a\]"
fi
