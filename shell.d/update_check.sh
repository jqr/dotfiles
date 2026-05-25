dotfiles-update() (
  cd -P "$HOME/.shell.d"/.. && bin/update
)

_dotfiles_update_notice="$HOME/.cache/dotfiles/dotfiles-update-notice"

if [[ -f "$_dotfiles_update_notice" ]]; then
  cat "$_dotfiles_update_notice"
  rm "$_dotfiles_update_notice"
fi

_dotfiles_update_check() {
  local dotfiles_dir origin
  dotfiles_dir="$(cd -P "$HOME/.shell.d" && cd .. && pwd -P)"
  origin=$(git -C "$dotfiles_dir" remote get-url origin 2>/dev/null) || return

  ( (
    git -C "$dotfiles_dir" fetch --quiet 2>/dev/null || exit 0

    local behind
    behind=$(git -C "$dotfiles_dir" rev-list --count "HEAD..@{upstream}" 2>/dev/null) || exit 0

    if (( behind > 0 )); then
      local local_head compare_url
      local_head=$(git -C "$dotfiles_dir" rev-parse --short HEAD 2>/dev/null)
      compare_url=$(echo "$origin" | sed -e 's|git@github.com:|https://github.com/|' -e 's|\.git$||')
      compare_url="$compare_url/compare/$local_head...HEAD"

      mkdir -p "$(dirname "$_dotfiles_update_notice")"
      cat > "$_dotfiles_update_notice" <<MSG
Checked $origin for updates... $behind available.
  See changes:  $compare_url
  Update:       dotfiles-update
MSG
    fi
  ) & )
}

# Every 13 days: background fetch (rotates through the week)
throttle 1123200 dotfiles-update-check _dotfiles_update_check
