if type rv > /dev/null 2>&1; then
  eval "$(rv shell init bash)"
  eval "$(rv shell completions bash)"
elif which rbenv > /dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

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

export RUBY_YJIT_ENABLE=1

# spring is very problematic on latest macOS
export DISABLE_SPRING=1

# https://github.com/rails/rails/issues/38560
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# rtdm: rails test diff main
rtdm() {
  # shellcheck disable=SC2046 # word splitting is intentional, each file is a separate arg
  rails test $(git diff "$(git_main_branch)" --name-status | grep -E $'^[^D]\t(test|spec)/.*\.rb')
}
