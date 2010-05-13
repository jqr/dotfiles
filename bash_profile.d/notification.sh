# Standardizing the interface to growlnotify
# 
#  notify "pull --rebase failed" "git"
notify() {
  growlnotify -m $1 $2 2> /dev/null
  echo "**********************************************************************"
  echo "**"
  echo "** $2: $1"
  echo "**"
  echo "**********************************************************************"
}
