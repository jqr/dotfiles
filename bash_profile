export PATH=~/bin:~/.seeds/bin:/usr/local/bin:/usr/local/sbin:$PATH

for a in `ls $HOME/.bash_profile.d/*.sh`; do 
  source $a
done

export VISUAL=`first_of "mate -w" "nano -w" vi`
export EDITOR=$VISUAL
export GIT_EDITOR=`first_of "mate -wl1" "nano -w" vi`

ulimit -n 10240

if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi
