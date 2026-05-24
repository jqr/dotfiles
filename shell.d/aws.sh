# zsh autoloads all homebrew completions
if [ -z "$ZSH_VERSION" ] && [ -f /opt/homebrew/etc/bash_completion.d/aws_bash_completer ]; then
  # shellcheck disable=SC1091 # path depends on homebrew prefix
  source /opt/homebrew/etc/bash_completion.d/aws_bash_completer
fi
