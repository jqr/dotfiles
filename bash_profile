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
  if [ $dir ] 
    then
    mkdir -p $dir
  fi
  /usr/bin/touch $1
}

alias recent='ls -lAt | head'

alias m="mate"


# Git
alias gs='git status'
alias gd='git diff'
alias gdh='git diff HEAD'
alias ga='git add'
alias gc='git commit -v'
alias gca='gc -a'
alias gp='git pull --rebase'
alias gpp='gp && git push'


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


parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
PS1="\h \w\$(parse_git_branch) $ "
