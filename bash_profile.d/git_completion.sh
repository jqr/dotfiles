# shellcheck disable=SC1091 # path depends on homebrew prefix
if [ -f /opt/homebrew/etc/bash_completion.d/git-completion.bash ]; then
  source /opt/homebrew/etc/bash_completion.d/git-completion.bash
fi
