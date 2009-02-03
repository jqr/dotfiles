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
