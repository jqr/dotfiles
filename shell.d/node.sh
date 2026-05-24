export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091 # paths depend on nvm installation
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

alias node-repl='rlwrap node-repl || node-repl'
