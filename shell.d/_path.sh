path_prepend() {
  case ":$PATH:" in
    *:"$1":*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_prepend /opt/homebrew/bin
path_prepend /usr/local/bin
path_prepend /usr/local/sbin
path_prepend /usr/local/share/npm/bin
path_prepend ~/.cargo/bin
path_prepend ~/.local/bin
path_prepend ~/bin
path_prepend bin
export PATH
