if [ $SSH_TTY ]; then
  PS1="$RED\u@\h $RED\w $LIGHTRED\$(current_git_branch)\$(git_special)$LIGHTRED$ $NC"
  PS1="$PS1\[\e]0;\u@\h\a\]"
else
  PS1="$GREEN\h $RED\w $LIGHTRED\$(current_git_branch)\$(git_special)$LIGHTRED$ $NC"
  PS1="$PS1\[\e]0;\a\]"
fi
