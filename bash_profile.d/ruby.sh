# Inspiration from http://github.com/hashrocket/dotmatrix/blob/master/.hashrc

alias r='rails'
alias rc='rails console'
alias rt='rails test'
alias rg='rails generate'
alias rd='rails destroy'
alias rs='rails server'
alias rr='rails runner'
alias rdb='rails dbconsole -p'

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
export RUBY_YJIT_ENABLE=1

# spring is very problematic on latest macOS
export DISABLE_SPRING=1

# https://github.com/rails/rails/issues/38560
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# rtdm: rails test diff main
rtdm() {
  rails test $(git diff $(git_main_branch) --name-status | grep -E $'^[^D]\t(test|spec)/.*\.rb')
}
