export NVM_DIR="$HOME/.nvm"

__load_nvm() {
  unset -f nvm node npm npx
  # shellcheck disable=SC1091 # paths depend on nvm installation
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  # shellcheck disable=SC1091
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm()  { __load_nvm; nvm  "$@"; }
node() { __load_nvm; node "$@"; }
npm()  { __load_nvm; npm  "$@"; }
npx()  { __load_nvm; npx  "$@"; }

alias node-repl='rlwrap node-repl || node-repl'
