if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

PATH=/opt/homebrew/bin:$PATH
PATH=/usr/local/bin:$PATH
PATH=/usr/local/sbin:$PATH
PATH=/usr/local/share/npm/bin:$PATH
PATH=~/.cargo/bin:$PATH
PATH=~/.local/bin:$PATH
PATH=bin:~/bin:$PATH
export PATH
shopt -s checkhash # force path search on stale cache detected

if [[ -s ~/perl5/perlbrew/etc/bashrc ]]; then
  source ~/perl5/perlbrew/etc/bashrc
fi

ulimit -n 10240

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
