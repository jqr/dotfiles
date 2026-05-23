for file in "$HOME"/.bash_profile.d/*.sh; do
  source "$file"
done

export VISUAL=$(first_of "subl -w" "mate -w" "nano -w" vi)
export EDITOR=$VISUAL
