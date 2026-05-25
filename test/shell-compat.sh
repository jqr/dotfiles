#!/bin/bash
set -e
# shellcheck source=test/helpers.sh
source "$(dirname "$0")/helpers.sh"

# Set up a fake home that sources our dotfiles
ln -s "$PWD/bash_profile" "$work/.bash_profile"
ln -s "$PWD/bashrc" "$work/.bashrc"
ln -s "$PWD/zshrc" "$work/.zshrc"
ln -s "$PWD/shell.d" "$work/.shell.d"

# Extract alias and function names defined in our shell.d files
names_file="$work/names.txt"
grep -hE '^\s*alias ' shell.d/*.sh | sed "s/^[[:space:]]*alias //" | sed "s/=.*//" | tr -d "'" | tr -d '"' | sort -u | sed 's/$/\talias/' > "$names_file"
grep -hE '^[a-zA-Z_][a-zA-Z0-9_]*\(\)|^function [a-zA-Z_][a-zA-Z0-9_]*' shell.d/*.sh | sed 's/().*//' | sed 's/^function //' | sed 's/[( {].*//' | grep -v '^_' | sort -u | sed 's/$/\tfunction/' >> "$names_file"

# Check which names are callable in each shell (one shell invocation each)
check_script='
while IFS="$(printf "\t")" read -r name kind; do
  if eval "type $name" >/dev/null 2>&1; then
    echo "$name"
  fi
done < "$1"
'

bash_callable=$(HOME="$work" bash -i -c "$check_script" _ "$names_file" 2>/dev/null)
zsh_callable=$(HOME="$work" zsh -i -c "$check_script" _ "$names_file" 2>/dev/null)

while IFS=$'\t' read -r name kind; do
  [ -z "$name" ] && continue
  in_bash=0 in_zsh=0
  echo "$bash_callable" | grep -qx "$name" && in_bash=1
  echo "$zsh_callable" | grep -qx "$name" && in_zsh=1

  if [ "$in_bash" -eq 1 ] && [ "$in_zsh" -eq 1 ]; then
    echo "  OK: $kind $name"
    ((__pass++)) || true
  elif [ "$in_bash" -eq 0 ] && [ "$in_zsh" -eq 0 ]; then
    echo "  OK: $kind $name (unavailable in both, likely missing tool)"
    ((__pass++)) || true
  elif [ "$in_bash" -eq 0 ]; then
    echo "FAIL: $kind $name callable in zsh but not bash"
    ((__fail++)) || true
  else
    echo "FAIL: $kind $name callable in bash but not zsh"
    ((__fail++)) || true
  fi
done < "$names_file"

test_summary "shell-compat"
