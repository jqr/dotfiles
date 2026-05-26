if [ -n "$ZSH_VERSION" ]; then
  autoload -Uz compinit && compinit
  autoload -Uz bashcompinit && bashcompinit

  zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
  zstyle ':completion:*:*:kill:*' menu yes select
fi
