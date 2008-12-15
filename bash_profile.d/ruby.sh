function cdgem {
  cd `gem env gemdir`/gems
  cd `ls | grep $1 | sort | tail -1`
}
function gemdoc {
  GEMDIR=`gem env gemdir`/doc
  open $GEMDIR/`ls $GEMDIR | grep $1 | sort | tail -1`/rdoc/index.html
}
function editgem {
  GEMDIR=`gem env gemdir`/gems
  $EDITOR $GEMDIR/`ls $GEMDIR | grep $1 | sort | tail -1`
}
