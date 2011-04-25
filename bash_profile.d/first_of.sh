# Returns the first command that exists, or exit status 1.
#
#  EDITOR=`first_of "mate -w" "nano -w" vi`
first_of() {
  if [ -n "$1" ]; then
    command -v $1 >> /dev/null && echo $1 || first_of "$2" "$3" "$4" "$5"
  else
    exit 1
  fi
}
