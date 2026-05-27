if type rv > /dev/null 2>&1; then
  eval "$(rv shell init "$DOTFILES_SHELL")"
  eval "$(rv shell completions "$DOTFILES_SHELL")"
  # rv's DEBUG trap runs _rv_autoload_hook before every command. On bash 3.2,
  # this fires inside readline completion functions, interfering with
  # git-completion.bash's unquoted [ $c -lt $cword ] tests.
  # Replace the DEBUG trap with a PROMPT_COMMAND hook that only fires on
  # directory changes (which is all rv needs).
  if [[ -z "$ZSH_VERSION" && "${BASH_VERSINFO[0]}" -lt 4 ]]; then
    trap - DEBUG
    _rv_prompt_hook() {
      if [[ "$_rv_prev_pwd" != "$PWD" ]]; then
        _rv_prev_pwd="$PWD"
        _rv_autoload_hook
      fi
    }
    _rv_prev_pwd="$PWD"
    PROMPT_COMMAND="_rv_prompt_hook;${PROMPT_COMMAND}"
  fi
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
