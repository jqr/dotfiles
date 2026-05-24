Dotfiles for bash/zsh on macOS.

# Install

Symlink all the dotfiles into the appropriate locations:

```sh
bin/install
```

This symlinks config files (`bashrc`, `zshrc`, `gitconfig`, etc.) into your home directory and inserts generated blocks into `~/.gemrc` and `~/.gitconfig`.

Re-run `bin/install` after pulling to pick up changes. It will clean up stale symlinks from removed files automatically.

## How it works

Shell config is modular. `bashrc` and `zshrc` both source every `*.sh` file in `shell.d/`, which includes git aliases, prompt, completions, language version managers, and more. Most files work in both bash and zsh.

## Local-only modifications

Any files matching `local.*` in `shell.d/` are not tracked by git.

## Testing

```sh
bin/test                          # shellcheck + bash/zsh startup checks
bin/test-install .                # full install test in a temp HOME
bin/test-install HEAD~3 HEAD .    # test an upgrade sequence
bin/test-milestone-upgrade 30     # test upgrading from every 30-day milestone to current
```
