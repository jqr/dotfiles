# Standardizing the interface to growlnotify
# 
#  notify "pull --rebase failed" "git"
notify() {
  growlnotify -m $2 $1 2> /dev/null
  echo "**********************************************************************"
  echo "**"
  echo "** $2: $1"
  echo "**"
  echo "**********************************************************************"
}
