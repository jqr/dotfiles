export PATH=~/bin::$HOME/.rbenv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH
eval "$(rbenv init -)"
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
