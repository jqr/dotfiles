export HISTSIZE=10000
export HISTCONTROL=ignoredups

if [ -n "$ZSH_VERSION" ]; then
  export SAVEHIST=250000
  setopt APPEND_HISTORY
else
  export HISTFILESIZE=250000
  shopt -s histappend
fi

hgrep() {
  history | grep "$@"
}
