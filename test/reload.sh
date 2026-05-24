#!/bin/bash
set -e
# shellcheck source=test/helpers.sh
source "$(dirname "$0")/helpers.sh"

shell="${1:?Usage: test/reload.sh <bash|zsh>}"
case "$shell" in
  bash|zsh) ;;
  *) echo "Unknown shell: $shell"; exit 1 ;;
esac

test_file="shell.d/_test_reload.sh"
# shellcheck disable=SC2064 # intentional: expand path now
trap "rm -f $test_file; rm -rf ${work:?}" EXIT

# Set up a fake home that sources our dotfiles
ln -s "$PWD/bash_profile" "$work/.bash_profile"
ln -s "$PWD/bashrc" "$work/.bashrc"
ln -s "$PWD/zshrc" "$work/.zshrc"
ln -s "$PWD/shell.d" "$work/.shell.d"

run_in_shell() {
  HOME="$work" "$shell" -i -c "$1" 2>/dev/null
}

# --- Phase 1: initial load ---
cat > "$test_file" <<'SHELL'
alias __test_alias='echo original'
__test_fn() { echo original; }
export __TEST_VAR=original
SHELL

assert "new alias loaded" \
  "original" "$(run_in_shell '__test_alias')"
assert "new function loaded" \
  "original" "$(run_in_shell '__test_fn')"
# shellcheck disable=SC2016 # expansion happens inside the subshell
assert "new export loaded" \
  "original" "$(run_in_shell 'echo $__TEST_VAR')"

# --- Phase 2: modify definitions, reload within a session ---
cat > "$test_file" <<'SHELL'
alias __test_alias='echo updated'
__test_fn() { echo updated; }
export __TEST_VAR=updated
alias __test_new_alias='echo added'
SHELL

assert "modified alias after reload" \
  "updated" "$(run_in_shell "source ~/.\${DOTFILES_SHELL}rc; __test_alias")"
assert "modified function after reload" \
  "updated" "$(run_in_shell "source ~/.\${DOTFILES_SHELL}rc; __test_fn")"
assert "modified export after reload" \
  "updated" "$(run_in_shell "source ~/.\${DOTFILES_SHELL}rc; echo \$__TEST_VAR")"
assert "new alias after reload" \
  "added" "$(run_in_shell "source ~/.\${DOTFILES_SHELL}rc; __test_new_alias")"

# --- Phase 3: remove definitions, start fresh shell (simulates exec $SHELL -l) ---
rm -f "$test_file"

assert "removed alias is gone" \
  "" "$(run_in_shell '__test_alias 2>/dev/null || true')"
assert "removed function is gone" \
  "" "$(run_in_shell '__test_fn 2>/dev/null || true')"
# shellcheck disable=SC2016 # expansion happens inside the subshell
assert "removed export is gone" \
  "" "$(run_in_shell 'echo $__TEST_VAR')"

test_summary "$shell"
