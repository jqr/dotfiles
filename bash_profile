export PATH=/opt/homebrew/bin:usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi
export PATH="bin:~/bin:$PATH"
shopt -s checkhash

if [[ -s ~/perl5/perlbrew/etc/bashrc ]]; then
  source ~/perl5/perlbrew/etc/bashrc
fi

ulimit -n 10240

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
