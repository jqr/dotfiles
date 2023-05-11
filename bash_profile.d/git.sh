# Basic commands, all are suped up versions which do slightly more than the
# original. See below for full descriptions, or just start using this list as
# a crash course. Almost all commands have autocompletions too, so give that a
# shot.
#
# gs = git status
# gp = git pull
# gl = git log
# gd = git diff
# ga = git add
# gc = git commit
# gu = git upload: git push really
# gb = git branch: shows local branches
# gbr = git branch remote: shows remote branches
# grb = git remote branch: makes a new remote branch
#
# Common suffixes, mostly on diffs/logs
# p = patch, open the interactive mode for selecting parts of files to include.
# s = stats, shows summary information
# m = main, comparing with main(or automatically picks up alternate names)
#
#
# The rest of this file is the aliases/functions I use regularly, in this format:
#
# acronym expansion: human explanation


# git: Yes, I'm occasionally this lazy. git is is aliased as just g.
alias g='git'

# git init: make a new repo with some sensible defaults, commit it, show me the log for good measure.
gi() {
  if [ -d ".git" ]; then
    echo "Already in a git repo."
  else
    git init && printf ".DS_Store\nThumbs.db\n" >> .gitignore && git add .gitignore && git commit -qm "Added standard .gitignore." && gl
  fi
}

# git commits date: Git commits by date across all branches, aka wtf has everyone been up to?
alias gcd="git rev-list --all --pretty=format:'%cd %Cgreen%an%Creset %Cred%h%Creset - %s' --abbrev-commit --date=short  | grep -v ^commit | less -R"
# git commits date author: ... and author, helpful if you forget what you did.
gcda() {
  git rev-list --all --pretty=format:'%cd %Cgreen%an%Creset %Cred%h%Creset - %s' --abbrev-commit --date=short --author "$1" | grep -v ^commit | less -R
}

# git log: history with pretty colors and relative times
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an %cr)%Creset' --abbrev-commit --date=relative"
# git log main: ... only show commits different from main
glm() {
  gl "$(git_main_branch).."
}

glo() {
  gl "origin/$(current_git_branch).."
}

# git log patch: git log but also what changed.
alias glp='gl -p'
# git log patch main: ... only show commits different from main
glpm() {
  glp "$(git_main_branch).."
}

# git log graph: history with fancy graph and branches, great for simple branching.
alias glg='gl --graph --branches'

# git stash: get it? adds everything changed to the stash, including untracked files.
alias "g{"='echo -n "Name this stash (optional): "; read name; if [[ -n $name ]]; then git stash save --include-untracked "$name"; else git stash --include-untracked; fi'
# git stash patch: ... but select patches interactively.
alias "g{p"='echo -n "Name this stash (optional): "; read name; if [[ -n $name ]]; then git stash save --patch "$name"; else git stash --patch; fi'
# git stash staged: ... but select patches which are staged.
alias "g{s"='git stash --staged'
# git unstash: unstash the most recent stash.
alias "g}"='git stash pop'
# git unstash branch: actually check out the revision where this was stashed so as not to make a mess.
alias "g}b"='git stash branch'

# git status: short mode and also list the stash
alias gs='git status -sb && git stash list'
# git diff: wtf have I changed? include renames. this doesn't include staged changes.
alias gd='git diff -M'
complete -o default -o nospace -F _git_diff gd
# git diff stats: which files have I changed, and how much?
alias gds='gd --stat'
complete -o default -o nospace -F _git_diff gds
# git diff head: same as gd but includes staged changes.
alias gdh='gd HEAD'
# git diff head stats: ... which files and how much?
alias gdhs='gdh --stat'
# git diff origin: show diff between this branch and the same branch on origin.
alias gdo='gd origin/$(current_git_branch)'
# git diff origin stats: ... which files and how much?
alias gdos='gdo --stat'

# git diff main: show diff between this branch and main.
gdm() {
  gd "$(git_main_branch)..."
}
# git diff main stats: ... which files and how much?
gdms() {
  gd --stat "$(git_main_branch)..."
}

# git add: yep, that's what it is.
alias ga='git add'
complete -o default -o nospace -F _git_add ga
# git add all: also add things like deletes.
alias gaa='git add --all'
complete -o default -o nospace -F _git_add gaa
# git add patch: interactively select things to add.
alias gap='git add -p'
# git add patch wildcard: select changed files by wildcard
gap*() {
  gap "*$1*"
}

# git commit: open my editor with a diff and let me write up a description, ^C if you see more in the diff than you wanted.
alias gc='git commit -v'
complete -o default -o nospace -F _git_commit gc

# git commit ammend: oh crap, I meant to add this to that commit too! you probably shouldn't do this after pushing commits.
alias gca='gc -a'
complete -o default -o nospace -F _git_add gca

# git checkout: switch branches or revert changes to a file, but also detect branches that begin with origin/ which is autocompleteable and make local branch of the same name.
gco() {
  if [[ $1 == origin/* ]]; then
    local local_branch
    local_branch="${1//origin\//}"
    echo local_branch
    git checkout "$local_branch" "${@:2}"
  else
    git checkout "$@"
  fi
}
complete -o default -o nospace -F _git_checkout gco
# git checkout patch: revert some, but not all changes to a file.
alias gcop="git checkout -p"

# git reset: unstage changes.
alias gr="git reset"
# git reset patch: ... interacively unstage changes.
alias grp="git reset -p"

# git pull: this used to be fancy and list the diff, but I seem to have disabled it for reasons I don't recall :)
gp() {
  # WARNING: you should not call this after doing a merge as it will mess it up. push first!
  # local before=`git show --format=%H` &&
  git pull --rebase || (notify "pull failed" "Git" && false)
  # local after=`git show --format=%H`
  # local exit_code=$?
  # if [ "$before" != "$after" ]; then
  #   gl $before..HEAD
  # fi
  # return $exit_code
}

# git upload: upload... it's like push, but gp already was spoken for.
alias gu='git push origin HEAD || (notify "push failed" "Git" && false)'

# git rebase interactive: opens your editor with a list of commits that haven't been pushed, then allows you to edit/remove/squash them, use gca to modify commits and grc to continue, git rebase --abort to GTFO.
alias gri='git rebase -i ${1:HEAD~$(git_commits_ahead | sed "s/[^0-9]//")}'
# git rebase continue: continue on once you're satisified with changes to the current commit.
alias grc='git rebase --continue'

# git fetch: get changes from origin, but don't do a merge/rebase, useful for seeing what else has happened without making changes.
alias gf='git fetch'
# git fetch all: ... do that but for every remote defined.
alias gfa='git fetch --all'

# a helper used for some of the branch stuff.
alias git_columnize="column -t -s $'\t'"

# git branch: show local git branches and the most recent commit.
alias gb='git for-each-ref --sort=committerdate --format="%(refname:short)%09%(subject)" refs/heads/ | git_columnize'
complete -o default -o nospace -F _git_branch gb
# git branch unmerged: show branches not merged into this branch.
alias gbu='git branch -v --no-merged'
# git branch unmerged main: show branches not merged into main.
gbum() {
  git branch -v --no-merged "$(git_main_branch)"
}

# git branch remote: show remote git branches and most recent commit.
alias gbr='git for-each-ref --sort=committerdate --format="%(refname:short)%09%(subject)" refs/remotes/*/** | grep -ve "^tddium/" | git_columnize'
# git branch remote unmerged: show remote branches not merged into this branch.
alias gbru='git branch -v -r --no-merged'
# git branch remote unmerged naster: show remote branches not merged into main.
gbrum() {
  git branch -v -r --no-merged "$(git_main_branch)"
}
# git branch all: show all branches
alias gba='git branch -v -a'
# git branch all: show all branches unmerged into this branch.
alias gbau='git branch -v -a --no-merged'
# git branch all: show all branches unmerged into main.
gbaum() {
  git branch -v -a --no-merged "$(git_main_branch)"
}

# git branch delete merged: deletes local branches that have been merged into this one, skips main :)
gbdm() {
  git branch --merged | grep -v "*" |  grep -ve "^\s*$(git_main_branch)$" | xargs -n 1 git branch -d
}
# git branch remote delete merged: deletes remote branches that have been merged into this one (with confirmation), also removes markers for remote branches that no longer exist.
gbrdm() {
  local upstream="origin"
  git fetch $upstream
  git remote prune $upstream
  if git branch -r --merged | grep -v "/$(git_main_branch)\$" | grep -ve "$(current_git_branch)\$" | grep "$upstream/"; then
    echo
    echo -n "Delete listed branches from $upstream? (y/N) "
    local yes_or_no
    read -r yes_or_no
    if [ "$yes_or_no" == "y" ]; then
      git branch -r --merged | grep -v "/$(git_main_branch)\$" | grep -ve "$(current_git_branch)\$" | grep "$upstream/" | sed -e "s/$upstream\\///" | xargs -n 100 git push $upstream --delete
      git remote prune $upstream
    fi
  else
    echo "Nothing to delete"
  fi
}
# git remote prune origin: cleans remote branches which no longer exist.
alias grpo='git remote prune origin'

# git garbage collect: removes git data which is no longer useful, like deleted branches, etc.
ggc() {
  set -- "$(du -ks)"
  local before="$1"
  git reflog expire --expire=1.minute "$(git_main_branch)" && git fsck --unreachable && git prune && git gc
  set -- "$(du -ks)"
  local after="$1"
  echo "Cleaned up $((before-after)) kb."
}

# git remote branch: branches from the current revision into a new branch that is immediatley pushed to origin.
grb() {
  if [ -n "$1" ]; then
    git push origin "HEAD:refs/heads/$1"
    git fetch origin &&
    git checkout -b "$1" --track "origin/$1"
  else
    git push origin "HEAD:refs/heads/$(current_git_branch)" &&
    git fetch origin
    git branch --set-upstream-to "origin/$(current_git_branch)"
  fi
}

# a helper that shows if git is doing something modal like bisecting, rebasing, or merging.
git_mode() {
  # https://github.com/hashrocket/dotmatrix/commit/d888bfee55ca430ba109e011d8b0958e810f799a
  local git_dir
  git_dir="$(git rev-parse --git-dir 2>/dev/null)"
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
  echo -n "$git_mode"
}

# a helper that shows the local branch name.
current_git_branch() {
  local git_dir
  git_dir="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -d "$git_dir" ]; then
    local git_branch
    git_branch=$(git symbolic-ref HEAD 2>/dev/null || git describe --exact-match HEAD 2>/dev/null | cut -c1-7 "$git_dir/HEAD")
    git_branch=${git_branch#refs/heads/}
    echo -n "$git_branch"
  fi
}

# a helper that shows the number of commits unpushed in this branch.
git_commits_ahead() {
  git status --short --branch 2> /dev/null | head -n 1 | grep ahead | sed -e 's/.*ahead \([0-9]\{1,\}\).*/+\1/'
}

# a helper that shows the remote commits unapplied to this branch.
git_commits_behind() {
  git status --short --branch 2> /dev/null | head -n 1 | grep behind | sed -e 's/.*behind \([0-9]\{1,\}\).*/-\1/'
}

# a helper that shows if any modifications are outstanding.
git_dirty_state() {
  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo -n "*"
  fi
}

# a helper that wraps a bunch of helpers.
git_special() {
  wrap_unless_empty "$(git_mode)" "$(git_commits_ahead)" "$(git_commits_behind)" "$(git_dirty_state)"
}

# a helper that joins strings and wraps them into parens if they're non-empty.
wrap_unless_empty() {
  if [ -n "$1$2$3$4" ]; then
    echo -n "($1$2$3$4)"
  fi
}

# a helper to return the primary or "default" branch name
git_main_branch() {
  local origin_head
  origin_head="$(git symbolic-ref refs/remotes/origin/HEAD 2> /dev/null | cut -d "/" -f4)"
  if [ -n "$origin_head" ]; then
    echo "$origin_head"
  else
    git branch --list --format "%(refname:short)" | grep -E "^(main|master)\$" | sort | head -n 1
  fi
}
