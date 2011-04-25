# Returns the first command that exists, or exit status 1.
#
#  EDITOR=`first_of "mate -w" "nano -w" vi`
first_of() {
  if [ -n "$1" ]; then
    local arg=$1
    shift
    command -v $arg >> /dev/null && echo $arg || first_of "$@"
  else
    exit 1
  fi
}
