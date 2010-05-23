# Switches two files contents
switch() {
  mv $1 $1_orig &&
  mv $2 $1 &&
  mv $1_orig $2
}