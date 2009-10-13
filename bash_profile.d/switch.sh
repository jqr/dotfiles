# Switches two files contents
function switch {
  mv $1 $1_orig &&
  mv $2 $1 &&
  mv $1_orig $2
}