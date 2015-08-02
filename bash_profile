export PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH
if which rbenv > /dev/null; then
  export RBENV_ROOT=/usr/local/var/rbenv
  eval "$(rbenv init -)"
fi
export PATH="./bin:$PATH"

if [[ -s ~/perl5/perlbrew/etc/bashrc ]]; then
  source ~/perl5/perlbrew/etc/bashrc
fi

for a in `ls $HOME/.bash_profile.d/*.sh`; do
  source $a
done

export VISUAL=`first_of "subl -w" "mate -w" "nano -w" vi`
export EDITOR=$VISUAL
#export GIT_EDITOR=`first_of "mate -wl1" "nano -w" vi`

ulimit -n 10240
