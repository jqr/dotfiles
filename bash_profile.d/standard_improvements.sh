alias mkdir='mkdir -p'
alias recent='ls -lAt | head'
alias old='ls -lAt | tail'
alias psg='ps aux | grep'
alias ka='killall'

f() {
  find . -name "*$1*"
}

touch() {
  dir=`expr "$1" : '\(.*\/\)'`
  if [ $dir ]
    then
    mkdir -p $dir
  fi
  /usr/bin/touch $1
}

myip() {
  curl --silent --fail 'ifconfig.co'
}


_ssh_hosts() {
  grep "Host " ~/.ssh/config 2> /dev/null | sed -e "s/Host //g"
  # http://news.ycombinator.com/item?id=751220
  cat ~/.ssh/known_hosts 2> /dev/null | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["
}
complete -W "$(_ssh_hosts)" ssh
