alias g='git'

alias gi='git init && printf ".DS_Store\nThumbs.db\n" >> .gitignore && git add .gitignore && git commit -qm "Added standard .gitignore." && gl'


# http://www.jukie.net/~bart/blog/pimping-out-git-log
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an %cr)%Creset' --abbrev-commit --date=relative"
alias glp='gl -p'
alias glb='gl --branches'
alias glm="gl master..."

alias gs='git status'
alias gd='git diff'
complete -o default -o nospace -F _git_diff gd
alias gds='git diff --cached'
complete -o default -o nospace -F _git_diff gds
alias gdh='git diff HEAD'

alias gdm='gd master...'

alias ga='git add'
complete -o default -o nospace -F _git_add ga
alias gap='git add -p'
alias gc='git commit -v'
complete -o default -o nospace -F _git_commit gc
alias gca='gc -a'
complete -o default -o nospace -F _git_add gca

alias gco="git checkout"
complete -o default -o nospace -F _git_checkout gco
alias gcop="git checkout -p"

alias gp='git pull --rebase || (notify "pull failed" "Git" && false)'
alias gu='git push origin HEAD || (notify "push failed" "Git" && false)'
alias gpru='gp && rake && gu'
alias gri='git rebase -i origin/master^'
alias grc='git rebase --continue'

alias gb='git branch'
complete -o default -o nospace -F _git_branch gb
alias gbr='git branch -r'
alias gba='git branch -a'
alias gbdm='git branch --merged | grep -v "*" | xargs -n 1 git branch -d'

alias grpo='git remote prune origin'

alias gitx='gitx --all'

ggc() {
  set -- `du -ks`
  before=$1
  git reflog expire --expire=1.minute refs/heads/master && git fsck --unreachable && git prune && git gc
  set -- `du -ks`
  after=$1
  echo "Cleaned up $((before-after)) kb."
}

grb() {
  if [ -n "$1" ]; then
    git push origin HEAD:refs/heads/$1
    git fetch origin &&
    git checkout -b $1 --track origin/$1
  else
    git branch --set-upstream `current_git_branch` origin/`current_git_branch`
  fi
}

git_mode() {
  # https://github.com/hashrocket/dotmatrix/commit/d888bfee55ca430ba109e011d8b0958e810f799a
  local git_dir="$(git rev-parse --git-dir 2>/dev/null)"
  local git_mode
  if [ -f "$git_dir/BISECT_LOG" ] ; then
    git_mode='BISECTING'
  elif [ -f "$git_dir/rebase-merge/interactive" ] ; then
    git_mode='REBASE-i'
  elif [ -f "$git_dir/rebase-apply/rebasing" ] ; then
    git_mode='REBASE'
  elif [ -f "$git_dir/MERGE_HEAD" ] ; then
    git_mode='MERGING'
  fi
  echo -n $git_mode
}
current_git_branch() {
  local git_dir="$(git rev-parse --git-dir 2>/dev/null)"
  local git_branch
  if [ -d "$git_dir" ]; then
    git_branch=`git symbolic-ref HEAD 2>/dev/null || git describe --exact-match HEAD 2>/dev/null | cut -c1-7 "$git_dir/HEAD"`
    git_branch=${git_branch#refs/heads/}
    echo -n $git_branch
  fi
}

git_commits_ahead() {
  git status 2> /dev/null | grep ahead | sed -e 's/.*by \([0-9]\{1,\}\) commits\{0,1\}\./\1/'
}

# Roughly from git_completion
git_dirty_state() {
  if [ -n "`git status --porcelain 2>/dev/null`" ]; then
    echo -n "+"
  fi
}

git_special() {
  wrap_unless_empty "`git_mode`" "`git_commits_ahead`" "`git_dirty_state`"
}
wrap_unless_empty() {
  if [ -n "$1" ] || [ -n "$2" ] || [ -n "$3" ] || [ -n "$4" ]; then
    echo -n "($1$2$3$4)"
  fi
}
