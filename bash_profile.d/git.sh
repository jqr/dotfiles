alias gs='git status'
alias gd='git diff'
alias gdh='git diff HEAD'
alias ga='git add'
alias gc='git commit -v'
alias gca='gc -a'
alias gp='git pull --rebase'
alias gpp='gp && git push'

current_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
