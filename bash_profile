# General
alias ..='cd ..'
alias ll='ls -lh'
alias la='ls -la'
alias ps='ps -ax'
alias du='du -hc'
alias cd..='cd ..'
alias more='less'
alias mkdir='mkdir -p'

function touch {
  dir=`expr "$1" : '\(.*\/\)'`
  mkdir -p $dir
  /usr/bin/touch $1
}

alias recent='ls -lAt | head'

alias m="mate"


# Git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -v'
alias gp='git pull --rebase'
alias gp='gp && git push'


export EDITOR='mate -w'


function cdgem {
  cd `gem env gemdir`/gems
  cd `ls | grep $1 | sort | tail -1`
}
function gemdoc {
  GEMDIR=`gem env gemdir`/doc
  open $GEMDIR/`ls $GEMDIR | grep $1 | sort | tail -1`/rdoc/index.html
}
function mategem {
  GEMDIR=`gem env gemdir`/gems
  mate $GEMDIR/`ls $GEMDIR | grep $1 | sort | tail -1`
}