if command -v fnm > /dev/null 2>&1; then
  # fnm leaks a new fnm_multishells/<pid>/bin onto PATH every `fnm env`
  # (https://github.com/Schniz/fnm/pull/1309). In nested/reloaded shells these
  # accumulate unbounded, bloating PATH (hundreds of entries) and slowing down
  # anything that globs it during init. Only init once per process tree;
  # nested shells inherit FNM_MULTISHELL_PATH and skip it.
  if [ -z "$FNM_MULTISHELL_PATH" ]; then
    eval "$(fnm env --use-on-cd)"
  fi
fi

alias node-repl='rlwrap node-repl || node-repl'
