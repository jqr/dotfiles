alias mkdir='mkdir -p'
alias recent='ls -lAt | head'

function touch {
  dir=`expr "$1" : '\(.*\/\)'`
  if [ $dir ] 
    then
    mkdir -p $dir
  fi
  /usr/bin/touch $1
}

function myip {
  curl --silent 'www.whatismyip.com/automation/n09230945.asp' && echo
}