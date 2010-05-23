# http://gist.github.com/217660
dns() {
  dig soa $1 | grep -q ^$1 && 
  echo "Registered" || 
  echo "Available"
}