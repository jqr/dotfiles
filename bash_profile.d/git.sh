alias gi='git init; printf ".DS_Store\nThumbs.db\n" >> .gitignore'

alias gl='git log'
alias glp='git log -p'

alias gs='git status'
alias gd='git diff'
alias gds='git diff --cached'
alias gdh='git diff HEAD'

alias ga='git add'
alias gc='git commit -v'
alias gca='gc -a'

alias gp='git pull --rebase || (notify "pull failed" "Git" && false)'
alias gpp='gp && git push origin `current_git_branch`'
alias gri='git rebase -i origin/master^'
alias grc='git rebase --continue'

alias gb='git branch'
complete -o default -o nospace -F _git_branch gb

alias gitx='gitx --all'

grb() {
  git push origin `current_git_branch`:refs/heads/$1
  git fetch origin &&
  git checkout -b $1 --track origin/$1
}

current_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
