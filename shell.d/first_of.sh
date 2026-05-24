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
