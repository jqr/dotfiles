alias gs='git status'
alias gd='git diff'
alias gdh='git diff HEAD'
alias ga='git add'
alias gc='git commit -v'
alias gca='gc -a'
alias gp='git pull --rebase || which growlnotify > /dev/null && growlnotify -m "pull failed" "Git"'
alias gpp='gp && git push'
alias grc='git rebase --continue'

current_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
