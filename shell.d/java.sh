find_java_home() {
  local java_home
  java_home=$(/usr/libexec/java_home 2> /dev/null)
  if [[ "$java_home" ]]; then
    export JAVA_HOME
    JAVA_HOME=$java_home
  fi
}

find_java_home
