for a in `ls $HOME/.bash_profile.d/*.sh`; do 
  source $a
done

export EDITOR='mate -w'
export GIT_EDITOR='mate -wl1'

PS1="\h \w \$(current_git_branch)$ "

export PATH=$HOME/bin:$PATH

