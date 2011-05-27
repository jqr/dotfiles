alias m="mate"
alias s="subl"
alias openports='sudo lsof -iTCP -sTCP:LISTEN -P'

# http://superuser.com/questions/52483/terminal-tips-and-tricks-for-mac-os-x
alias ql='qlmanage -p 2>/dev/null'

pman () {
    man -t "${1}" | open -f -a /Applications/Preview.app
}
