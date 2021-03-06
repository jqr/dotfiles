# Inspiration from http://github.com/hashrocket/dotmatrix/blob/master/.hashrc

alias r='rails'
alias rc='rails console'
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
