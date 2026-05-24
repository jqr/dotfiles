# Returns the first command that exists, or exit status 1.
#
#  EDITOR=`first_of "mate -w" "nano -w" vi`
first_of() {
  if [ -n "$1" ]; then
    local arg
    arg="$1"
    shift
    # shellcheck disable=SC2001 # ${var%%} can't replace sed here, arg may contain multiple spaces
    if command -v "$(echo "$arg" | sed 's/ .*//')" >> /dev/null; then
      echo "$arg"
    else
      first_of "$@"
    fi
  else
    return 1
  fi
}

path_prepend() {
  case ":$PATH:" in
    *:"$1":*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

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
