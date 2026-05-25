# Counter Helpers
#
# Every command below has an independent database in
# ~/.cache/dotfiles/<command>/. They are safe to delete but will "reset."
# 
# Inside each command is just a bunch of flat key files, these commands are
# all "scoped" to a key, so you can use them to "count" different things, not
# just one global counter, that would suck.

# Run a command at most once per interval.
#
#   throttle 10 keyA echo WARNING  # prints WARNING
#   throttle 10 keyZ echo WARNING  # prints WARNING, first call to keyZ
#   throttle 10 keyA echo WARNING  # hidden
#   sleep 10
#   throttle 10 keyA echo WARNING  # prints WARNING
#
#
# Combines nicely with run_after_n, see Combining Helpers below.
throttle() {
  local interval="$1" key="$2"
  shift 2

  local stamp="$HOME/.cache/dotfiles/throttle/$key"
  local now; now=$(date +%s)
  local last
  last=$([[ -f "$stamp" ]] && cat "$stamp" || echo 0)
  last=${last:-0}

  if (( now - last > interval )); then
    mkdir -p "$(dirname "$stamp")"
    echo "$now" > "$stamp"
    "$@"
  fi
}

# Run a command after N invocations.
#
#   run_after_n 2 keyA echo 1  # hidden
#   run_after_n 2 keyZ echo 4  # hidden, first call to keyZ
#   run_after_n 2 keyA echo 2  # prints 2
#   run_after_n 2 keyA echo 3  # prints 3
#
# Combines nicely with throttle, see Combining Helpers below.
run_after_n() {
  local threshold="$1" key="$2"
  shift 2

  local counter="$HOME/.cache/dotfiles/run_after_n/$key"
  mkdir -p "$(dirname "$counter")"

  local count
  count=$([[ -f "$counter" ]] && cat "$counter" || echo 0)
  count=${count:-0}
  count=$((count + 1))
  echo "$count" > "$counter"

  if (( count >= threshold )); then
    "$@"
  fi
}

# Run a command only for the first N invocations.
#
#   run_before_n 3 my-key echo "heads up"  # prints "heads up"
#   run_before_n 3 my-key echo "heads up"  # prints "heads up"
#   run_before_n 3 my-key echo "heads up"  # hidden
#
# Combines nicely with throttle, see Combining Helpers below.
run_before_n() {
  local threshold="$1" key="$2"
  shift 2

  local counter="$HOME/.cache/dotfiles/run_before_n/$key"
  mkdir -p "$(dirname "$counter")"

  local count
  count=$([[ -f "$counter" ]] && cat "$counter" || echo 0)
  count=${count:-0}
  count=$((count + 1))
  echo "$count" > "$counter"

  if (( count < threshold )); then
    "$@"
  fi
}

# Combining Helpers
#
# throttle and run_after_n compose in handy ways:
#
#
# throttle ... run_after_n ...
#   # Alert to sudo bypass when used on 5 different days.
#   throttle 86400 sudoWarning \
#   run_after_n 5 sudoWarning \
#   echo "Tired of typing in your sudo password? ..."
#
#
# run_after_n ... throttle ...
#   # After 100 fetches, intentionally slow down
#   run_after_n 100 fetchSlower \
#   throttle 86400 fetchSlower \
#   sleep 1
#
#
# throttle ... run_before_n ...
#   # Warn about a deprecation once a day, for the first 5 days.
#   throttle 86400 deprecation \
#   run_before_n 5 deprecation \
#   echo "This command is going away, use 'foo' instead."
