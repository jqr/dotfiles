alias openports='sudo lsof -iTCP -sTCP:LISTEN -P'

# http://superuser.com/questions/52483/terminal-tips-and-tricks-for-mac-os-x
alias ql='qlmanage -p 2>/dev/null'

pman () {
    man -t "${1}" | open -f -a /Applications/Preview.app
}

# Load a new shell with x86 architecture
alias x86='arch -x86_64 $SHELL --login'
