# http://gist.github.com/217660
dns() {
  dig soa "$1" | grep -q "^$1" &&
  echo "Registered" ||
  echo "Available"
}

# official way to flush dns on macOS
dns_flush() {
  if sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder; then
    echo "DNS cache flushed."
  else
    echo "ERROR: DNS cache flush failed."
    return 1
  fi
}
