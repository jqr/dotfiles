if [ -n "$ZSH_VERSION" ]; then
  alias reload='exec zsh -l'
elif [ -n "$BASH_VERSION" ]; then
  alias reload='exec bash -l'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cd..='cd ..'
alias ll='ls -lh'
alias la='ls -lA'
alias du='du -hc'
alias more='less'

alias lc='wc -l'

export CLICOLOR=1
export LSCOLORS=gxgxcxdxbxegedabagacad

alias c="code"
alias s="subl"
alias z="zed"
alias e='$EDITOR'
alias nano='nano -w'
alias o='open'

alias k="kubectl"
