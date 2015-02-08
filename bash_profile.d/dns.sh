# http://gist.github.com/217660
dns() {
  dig soa $1 | grep -q ^$1 &&
  echo "Registered" ||
  echo "Available"
}

# official way to flush dns on OS X 10.7+
dns_flush() {
  sudo discoveryutil mdnsflushcache || sudo killall -HUP mDNSResponder
}
