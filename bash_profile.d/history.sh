export HISTSIZE=10000
export HISTFILESIZE=250000
export HISTCONTROL=ignoredups

shopt -s histappend

hgrep() {
  history | grep "$@"
}
