export PATH=/opt/homebrew/bin:usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi
export PATH="bin:~/bin:$PATH" # ensure this is always first
shopt -s checkhash # force path search on stale cache detected

if [[ -s ~/perl5/perlbrew/etc/bashrc ]]; then
  source ~/perl5/perlbrew/etc/bashrc
fi

for file in "$HOME"/.bash_profile.d/*.sh; do
  source "$file"
done

export VISUAL=$(first_of "subl -w" "mate -w" "nano -w" vi)
export EDITOR=$VISUAL
#export GIT_EDITOR=`first_of "mate -wl1" "nano -w" vi`

ulimit -n 10240

test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
