# Ruby version manager. rv is the default; `use-rbenv` switches the current
# shell (and anything it launches) to rbenv, which can run rubies older than rv
# supports. `use-rv` switches back.

# Removes every PATH entry at or under a prefix.
_ruby_manager_path_strip() {
  [ -n "${1:-}" ] || return 0
  local prefix="$1" rest="$PATH" entry out=""
  while [ -n "$rest" ]; do
    entry="${rest%%:*}"
    case "$rest" in
      *:*) rest="${rest#*:}" ;;
      *) rest="" ;;
    esac
    case "$entry" in
      "$prefix"|"$prefix"/*) ;;
      *) out="${out:+$out:}$entry" ;;
    esac
  done
  export PATH="$out"
}

# Removes a command from bash's PROMPT_COMMAND chain.
_ruby_manager_prompt_command_strip() {
  local name="$1" rest="${PROMPT_COMMAND:-}" entry out=""
  while [ -n "$rest" ]; do
    entry="${rest%%;*}"
    case "$rest" in
      *\;*) rest="${rest#*;}" ;;
      *) rest="" ;;
    esac
    if [ "$entry" != "$name" ]; then
      out="${out:+$out;}$entry"
    fi
  done
  PROMPT_COMMAND="$out"
}

_ruby_manager_rv_enable() {
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
}

_ruby_manager_rv_disable() {
  if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook -d preexec _rv_autoload_hook 2>/dev/null
  else
    case "$(trap -p DEBUG 2>/dev/null)" in
      *_rv_*) trap - DEBUG ;;
    esac
    _ruby_manager_prompt_command_strip _rv_autoload_hook
    _ruby_manager_prompt_command_strip _rv_prompt_hook
  fi
  unset -f _rv_autoload_hook _rv_prompt_hook 2>/dev/null
  _ruby_manager_path_strip "${RUBY_ROOT:-}"
  _ruby_manager_path_strip "${XDG_DATA_HOME:-$HOME/.local/share}/rv"
  unset RUBY_ROOT RUBY_ENGINE RUBY_VERSION GEM_HOME GEM_PATH
  hash -r
}

_ruby_manager_rbenv_enable() {
  # Drop any inherited shims first so re-running doesn't stack PATH entries.
  _ruby_manager_path_strip "$(rbenv root 2>/dev/null)/shims"
  eval "$(rbenv init - "$DOTFILES_SHELL")"
}

_ruby_manager_rbenv_disable() {
  _ruby_manager_path_strip "$(rbenv root 2>/dev/null)/shims"
  unset -f rbenv 2>/dev/null
  unset RBENV_SHELL RBENV_VERSION
  hash -r
}

# use-rbenv [version]: switch this shell to rbenv, optionally picking a version.
use-rbenv() {
  if ! command -v rbenv > /dev/null 2>&1; then
    echo "use-rbenv: rbenv is not installed" >&2
    return 1
  fi
  if command -v rv > /dev/null 2>&1; then
    _ruby_manager_rv_disable
  fi
  export DOTFILES_RUBY_MANAGER=rbenv
  _ruby_manager_rbenv_enable
  if [ -n "${1:-}" ]; then
    rbenv shell "$1" || return 1
  fi
  ruby-manager
}

# use-rv: switch this shell back to rv.
use-rv() {
  if ! command -v rv > /dev/null 2>&1; then
    echo "use-rv: rv is not installed" >&2
    return 1
  fi
  if command -v rbenv > /dev/null 2>&1; then
    _ruby_manager_rbenv_disable
  fi
  export DOTFILES_RUBY_MANAGER=rv
  _ruby_manager_rv_enable
  ruby-manager
}

# Reports which manager is active and which ruby it resolves to.
ruby-manager() {
  echo "$DOTFILES_RUBY_MANAGER: $(command -v ruby 2>/dev/null || echo 'no ruby') ($(ruby -e 'print RUBY_VERSION' 2>/dev/null || echo 'unknown'))"
}

DOTFILES_RUBY_MANAGER="${DOTFILES_RUBY_MANAGER:-rv}"
if [ "$DOTFILES_RUBY_MANAGER" = "rbenv" ] && command -v rbenv > /dev/null 2>&1; then
  _ruby_manager_rbenv_enable
elif command -v rv > /dev/null 2>&1; then
  DOTFILES_RUBY_MANAGER=rv
  _ruby_manager_rv_enable
elif command -v rbenv > /dev/null 2>&1; then
  DOTFILES_RUBY_MANAGER=rbenv
  _ruby_manager_rbenv_enable
else
  DOTFILES_RUBY_MANAGER=none
fi
export DOTFILES_RUBY_MANAGER

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
