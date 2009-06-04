alias gi='git init; printf ".DS_Store\nThumbs.db\n" >> .gitignore'

alias gl='git log'
alias glp='git log -p'

alias gs='git status'
alias gd='git diff'
alias gdh='git diff HEAD'

alias ga='git add'
alias gc='git commit -v'
alias gca='gc -a'

alias gp='git pull --rebase || (notify "pull failed" "Git" && false)'
alias gpp='gp && git push origin `current_git_branch`'
alias grc='git rebase --continue'

alias gb='git branch'
complete -o default -o nospace -F _git_branch gb

alias gitx='gitx --all'

grb() {
  # TODO: investigate "fatal" warning
  starting_git_branch=`current_git_branch`
  git checkout -b $1 && 
  git push origin $1 && 
  git checkout $starting_git_branch && 
  git branch -d $1 && 
  git checkout -b $1 --track origin/$1
}

current_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
