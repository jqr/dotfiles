# shellcheck disable=SC2155 # empty VISUAL is fine if no editor is found
export VISUAL=$(first_of "subl -w" "mate -w" "nano -w" vi)
export EDITOR=$VISUAL
