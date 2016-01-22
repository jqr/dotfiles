export HISTFILESIZE=20000
export HISTCONTROL=ignoredups
hgrep() {
  history | grep "$@"
}
