export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:$PATH

if which rbenv > /dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
