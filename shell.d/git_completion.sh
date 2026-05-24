# zsh autoloads all homebrew completions
if [ -z "$ZSH_VERSION" ] && [ -f /opt/homebrew/etc/bash_completion.d/git-completion.bash ]; then
  # shellcheck disable=SC1091 # path depends on homebrew prefix
  source /opt/homebrew/etc/bash_completion.d/git-completion.bash
fi
