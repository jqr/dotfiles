for a in `ls $HOME/.bash_profile.d/*.sh`; do 
  source $a
done

export EDITOR='mate -w'
export GIT_EDITOR='mate -wl1'

export PATH=~/bin:~/.gem/ruby/1.8/bin:~/.seeds/bin:$PATH

if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi
