# Inspiration from http://github.com/hashrocket/dotmatrix/blob/master/.hashrc

function gemdir {
  if [ $1 ]
    then
    ls -d `gemdir`/$1* | sort | tail -1
  else
    echo `gem env gemdir`/gems
  fi
}

function cdgem {
  cd `gemdir $1`
}

function gemdoc {
  open `gemdir $1`/doc/index.html ||
  open `gemdir $1`/README*
}
function editgem {
  $EDITOR `gemdir $1`
}


function rails_root {
  (
    dir=${1:-$(pwd)}
    i=0
    while [ "/" != "$dir" -a "$i" -ne 16 ]; do
      if [ -f "$dir/config/environment.rb" ]; then
        echo "$dir"
        return 0
      fi
      dir="$(dirname "$dir")"
      i=$(expr $i + 1)
    done
    echo "* Does not appear to be a Rails project" >&2
    return 1
  )
}


function script_rails {
  rails_root=`rails_root`
  if [ -f "$rails_root/script/rails" ]; then
    "$rails_root/script/rails" "$@"
  elif [ -f "$rails_root/script/$name" ]; then
    local name
    name="$1"
    shift
    "$rails_root/script/$name" "$@"
  else
    return 1
  fi
}

alias sc='script_rails console'
alias ss='script_rails server -u'
alias sdbc='script_rails dbconsole -p'
