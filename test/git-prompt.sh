#!/bin/bash
set -e
# shellcheck source=test/helpers.sh
source "$(dirname "$0")/helpers.sh"

shell="${1:?Usage: test/git-prompt.sh <bash|zsh>}"
case "$shell" in
  bash|zsh) ;;
  *) echo "Unknown shell: $shell"; exit 1 ;;
esac

ln -s "$PWD/bash_profile" "$work/.bash_profile"
ln -s "$PWD/bashrc" "$work/.bashrc"
ln -s "$PWD/zshrc" "$work/.zshrc"
ln -s "$PWD/shell.d" "$work/.shell.d"

repo="$work/repo"
git init -q "$repo"
(cd "$repo" && git commit --allow-empty -m init -q)

run() {
  HOME="$work" "$shell" -c "
    export DOTFILES_SHELL=$shell
    for f in ~/.shell.d/*.sh; do . \$f; done
    cd ~/repo
    $1
  " 2>/dev/null
}

# ===== git_main_branch =====

assert "git_main_branch: detects main" \
  "main" "$(run 'git_main_branch')"

# ===== current_git_branch =====

assert "current_git_branch: on main" \
  "main" "$(run 'current_git_branch')"

(cd "$repo" && git checkout -q -b feature/test-branch)
assert "current_git_branch: feature branch" \
  "feature/test-branch" "$(run 'current_git_branch')"
(cd "$repo" && git checkout -q main)

assert_empty "current_git_branch: outside repo" \
  "$(HOME="$work" "$shell" -c "
    export DOTFILES_SHELL=$shell
    for f in ~/.shell.d/*.sh; do . \$f; done
    cd /tmp
    current_git_branch
  " 2>/dev/null)"

# ===== git_mode =====

assert_empty "git_mode: normal" \
  "$(run 'git_mode')"

(cd "$repo" && git bisect start >/dev/null 2>&1)
assert "git_mode: bisecting" \
  "BISECTING" "$(run 'git_mode')"
(cd "$repo" && git bisect reset >/dev/null 2>&1)

(cd "$repo" && git checkout -q -b merge-test-branch)
(cd "$repo" && echo "a" > mergefile.txt && git add mergefile.txt && git commit -qm "branch side")
(cd "$repo" && git checkout -q main)
(cd "$repo" && echo "b" > mergefile.txt && git add mergefile.txt && git commit -qm "main side")
(cd "$repo" && git merge merge-test-branch 2>/dev/null || true)
assert "git_mode: merging" \
  "MERGING" "$(run 'git_mode')"
(cd "$repo" && git merge --abort)

# ===== git_dirty_state =====

assert_empty "git_dirty_state: clean" \
  "$(run 'git_dirty_state')"

(cd "$repo" && echo "x" > untracked.txt)
assert "git_dirty_state: untracked file" \
  "*" "$(run 'git_dirty_state')"
(cd "$repo" && rm untracked.txt)

(cd "$repo" && echo "x" > tracked.txt && git add tracked.txt && git commit -qm "add tracked")
(cd "$repo" && echo "modified" > tracked.txt)
assert "git_dirty_state: modified file" \
  "*" "$(run 'git_dirty_state')"
(cd "$repo" && git checkout -q -- tracked.txt)

(cd "$repo" && echo "staged" > staged.txt && git add staged.txt)
assert "git_dirty_state: staged file" \
  "*" "$(run 'git_dirty_state')"
(cd "$repo" && git reset -q HEAD -- staged.txt && rm staged.txt)

# ===== git_commits_ahead / git_commits_behind =====

assert_empty "git_commits_ahead: no remote" \
  "$(run 'git_commits_ahead')"
assert_empty "git_commits_behind: no remote" \
  "$(run 'git_commits_behind')"

(cd "$repo" && git clone -q . ../remote-bare --bare)
(cd "$repo" && git remote add origin ../remote-bare)
(cd "$repo" && git fetch -q origin)
(cd "$repo" && { git branch --set-upstream-to=origin/main main 2>/dev/null || git branch --set-upstream-to=origin/master master 2>/dev/null; })

assert_empty "git_commits_ahead: in sync" \
  "$(run 'git_commits_ahead')"
assert_empty "git_commits_behind: in sync" \
  "$(run 'git_commits_behind')"

(cd "$repo" && git commit --allow-empty -qm "ahead 1")
assert "git_commits_ahead: 1 ahead" \
  "+1" "$(run 'git_commits_ahead')"
assert_empty "git_commits_behind: still in sync" \
  "$(run 'git_commits_behind')"

(cd "$repo" && git commit --allow-empty -qm "ahead 2")
assert "git_commits_ahead: 2 ahead" \
  "+2" "$(run 'git_commits_ahead')"

(cd "$repo" && { git push -q origin main 2>/dev/null || git push -q origin master 2>/dev/null; })
(cd "$repo" && git reset -q HEAD~1)
(cd "$repo" && git checkout -q -- .)
assert_empty "git_commits_ahead: after reset" \
  "$(run 'git_commits_ahead')"
assert "git_commits_behind: 1 behind" \
  "-1" "$(run 'git_commits_behind')"

(cd "$repo" && git commit --allow-empty -qm "diverge")
assert "git_commits_ahead: diverged" \
  "+1" "$(run 'git_commits_ahead')"
assert "git_commits_behind: diverged" \
  "-1" "$(run 'git_commits_behind')"

# ===== wrap_unless_empty =====

assert_empty "wrap_unless_empty: all empty" \
  "$(run "wrap_unless_empty '' '' '' ''")"
assert "wrap_unless_empty: one value" \
  "(hello)" "$(run "wrap_unless_empty 'hello' '' '' ''")"
assert "wrap_unless_empty: multiple values" \
  "(abc)" "$(run "wrap_unless_empty 'a' 'b' '' 'c'")"

# ===== git_special (combined behavior) =====

(cd "$repo" && echo "z" > tmp.txt)
assert "git_special: ahead + behind + dirty" \
  "(+1-1*)" "$(run 'git_special')"
(cd "$repo" && rm -f tmp.txt)

assert "git_special: ahead + behind" \
  "(+1-1)" "$(run 'git_special')"

# Verify git_special agrees with individual helpers
(cd "$repo" && echo "check" > agree.txt)
combined="$(run 'git_special')"
mode="$(run 'git_mode')"
ahead="$(run 'git_commits_ahead')"
behind="$(run 'git_commits_behind')"
dirty="$(run 'git_dirty_state')"
expected="$(run "wrap_unless_empty '$mode' '$ahead' '$behind' '$dirty'")"
assert "git_special: agrees with individual helpers" \
  "$expected" "$combined"

test_summary "$shell"
