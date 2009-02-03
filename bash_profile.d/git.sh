alias gi='git init; printf ".DS_Store\nThumbs.db\n" >> .gitignore'
alias gs='git status'
alias gd='git diff'
alias gdh='git diff HEAD'

alias ga='git add'
alias gc='git commit -v'
alias gca='gc -a'

alias gp='git pull --rebase || (which growlnotify > /dev/null && growlnotify -m "pull failed" "Git")'
alias gpp='gp && git push origin `current_git_branch`'
alias grc='git rebase --continue'

alias gb='git branch'
complete -o default -o nospace -F _git_branch gb

current_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
