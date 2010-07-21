alias mkdir='mkdir -p'
alias recent='ls -lAt | head'
alias old='ls -lAt | tail'

touch() {
  dir=`expr "$1" : '\(.*\/\)'`
  if [ $dir ] 
    then
    mkdir -p $dir
  fi
  /usr/bin/touch $1
}

myip() {
  curl --silent 'www.whatismyip.com/automation/n09230945.asp' && echo
}


_ssh_hosts() {
  grep "Host " ~/.ssh/config 2> /dev/null | sed -e "s/Host //g"
  # http://news.ycombinator.com/item?id=751220
  cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["
}
complete -W "$(_ssh_hosts)" ssh
