for a in `ls $HOME/.bash_profile.d/*.sh`; do 
  source $a
done

export EDITOR='mate -w'

PS1="\h \w\$(current_git_branch) $ "


