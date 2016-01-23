# Inspiration from http://github.com/hashrocket/dotmatrix/blob/master/.hashrc

rails_root() {
  (
    dir="$(pwd)"
    i=0
    while [ "/" != "$dir" ] && [ "$i" -ne 16 ]; do
      if [ -f "$dir/config/environment.rb" ]; then
        echo "$dir"
        return 0
      fi
      dir="$(dirname "$dir")"
      ((i=i + 1))
    done
    echo "* Does not appear to be a Rails project" >&2
    return 1
  )
}


script_rails() {
  rails_root=$(rails_root)
  if [ -f "$rails_root/bin/rails" ]; then
    "$rails_root/bin/rails" "$@"
  elif [ -f "$rails_root/script/rails" ]; then
    "$rails_root/script/rails" "$@"
  elif [ -f "$rails_root/script/$1" ]; then
    local name
    name="$1"
    shift
    "$rails_root/script/$name" "$@"
  else
    return 1
  fi
}

alias sc='script_rails console'
alias sg='script_rails generate'
alias sd='script_rails destroy'
alias ss='script_rails server'
alias sr='script_rails runner'
alias sdbc='script_rails dbconsole -p'

alias r='rake'
alias rs='rake spec'
alias cwip='cucumber --tags @wip'

alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'
alias bo='bundle outdated'


# decent Ruby options for faster local development
export RUBY_GC_HEAP_INIT_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000
