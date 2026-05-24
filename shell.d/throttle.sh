# Run a command at most once per interval.
#
#   throttle 86400 my-key echo "hello"
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
