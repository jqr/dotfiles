# shellcheck disable=SC1090 # files are dynamic, loaded by glob
for file in "$HOME"/.bash_profile.d/*.sh; do
  source "$file"
done

# shellcheck disable=SC2155 # empty VISUAL is fine if no editor is found
export VISUAL=$(first_of "subl -w" "mate -w" "nano -w" vi)
export EDITOR=$VISUAL
