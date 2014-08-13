alias g='git'

alias gi='git init && printf ".DS_Store\nThumbs.db\n" >> .gitignore && git add .gitignore && git commit -qm "Added standard .gitignore." && gl'


# http://www.jukie.net/~bart/blog/pimping-out-git-log
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an %cr)%Creset' --abbrev-commit --date=relative"
alias gld="git log --pretty=format:'%cd %Cgreen%an%Creset %Cred%h%Creset - %s' --abbrev-commit --date=short"
alias glda="gld --author $1"
alias glp='gl -p'
alias glpm="glp master.."
alias glb='gl --branches'
alias glm="gl master.."

alias g{='echo -n "Name this stash (optional): "; read name; if [[ -n $name ]]; then git stash save -u "$name"; else git stash -u; fi'
alias g{p='echo -n "Name this stash (optional): "; read name; if [[ -n $name ]]; then git stash save -p -u "$name"; else git stash -u; fi'
alias g}='git stash pop'
alias g}b='git stash branch'

alias gs='git status -sb && git stash list'
alias gd='git diff'
complete -o default -o nospace -F _git_diff gd
alias gds='git diff --cached'
complete -o default -o nospace -F _git_diff gds
alias gdh='git diff HEAD'

alias gdm='gd master...'

alias ga='git add'
complete -o default -o nospace -F _git_add ga
alias gaa='git add --all'
complete -o default -o nospace -F _git_add gaa
alias gap='git add -p'
alias gc='git commit -v'
complete -o default -o nospace -F _git_commit gc
alias gca='gc -a'
complete -o default -o nospace -F _git_add gca

alias gco="git checkout"
complete -o default -o nospace -F _git_checkout gco
gcob() {
  git checkout `echo $1 | sed 's|origin/||'`
}
complete -o default -o nospace -F _git_checkout gcob
alias gcop="git checkout -p"

alias gr="git reset"
alias grp="git reset -p"

gp() {
  # local before=`git show --format=%H` &&
  git pull --rebase || (notify "pull failed" "Git" && false)
  # local after=`git show --format=%H`
  # local exit_code=$?
  # if [ "$before" != "$after" ]; then
  #   gl $before..HEAD
  # fi
  # return $exit_code
}

alias gu='git push origin HEAD || (notify "push failed" "Git" && false)'
alias gri='git rebase -i origin/master^'
alias grc='git rebase --continue'
alias gf='git fetch'
alias gfa='git fetch --all'

alias gb='git branch -v'
complete -o default -o nospace -F _git_branch gb
alias gbu='git branch -v --no-merged'
alias gbum='git branch -v --no-merged master'

alias gbr='git branch -v -r'
alias gbru='git branch -v -r --no-merged'
alias gbrum='git branch -v -r --no-merged master'
alias gba='git branch -v -a'
alias gbau='git branch -v -a --no-merged'
alias gbaum='git branch -v -a --no-merged master'

alias gbdm='git branch --merged | grep -v "*" | xargs -n 1 git branch -d'
gbrdm() {
  git branch -r --merged | grep -v "origin/master" || echo "Nothing to delete" && return
  echo
  echo -n 'Delete listed branches from origin? (y/N) '
  local yes_or_no
  read yes_or_no
  if [ "$yes_or_no" == "y" ]; then
    git branch -r --merged | grep -v "origin/master" | sed -e 's/origin\//:/' | xargs -n 1 git push origin
    git remote prune origin
  fi
}

alias grpo='git remote prune origin'

alias gitx='gitx --all'

ggc() {
  set -- `du -ks`
  local before=$1
  git reflog expire --expire=1.minute refs/heads/master && git fsck --unreachable && git prune && git gc
  set -- `du -ks`
  local after=$1
  echo "Cleaned up $((before-after)) kb."
}

grb() {
  if [ -n "$1" ]; then
    git push origin HEAD:refs/heads/$1
    git fetch origin &&
    git checkout -b $1 --track origin/$1
  else
    git branch --set-upstream-to `current_git_branch` origin/`current_git_branch`
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
  git status -sb 2> /dev/null | head -n 1 | grep ahead | sed -e 's/.*ahead \([0-9]\{1,\}\).*/+\1/'
}

git_commits_behind() {
  git status -sb 2> /dev/null | head -n 1 | grep behind | sed -e 's/.*behind \([0-9]\{1,\}\).*/-\1/'
}

# Roughly from git_completion
git_dirty_state() {
  if [ -n "`git status --porcelain 2>/dev/null`" ]; then
    echo -n "*"
  fi
}

git_special() {
  wrap_unless_empty "`git_mode`" "`git_commits_ahead`" "`git_commits_behind`" "`git_dirty_state`"
}
wrap_unless_empty() {
  if [ -n "$1" ] || [ -n "$2" ] || [ -n "$3" ] || [ -n "$4" ]; then
    echo -n "($1$2$3$4)"
  fi
}
