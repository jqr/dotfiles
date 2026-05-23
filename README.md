Dotfiles for bash/zsh on macOS.

# Install

Symlink all the dotfiles into the appropriate locations:

```sh
rake install
```

This symlinks config files (`bashrc`, `zshrc`, `gitconfig`, etc.) into your home directory and inserts generated blocks into `~/.gemrc` and `~/.gitconfig`.

## How it works

Shell config is modular. `bashrc` and `zshrc` both source every `*.sh` file in `bash_profile.d/`, which includes git aliases, prompt, completions, language version managers, and more. Most files work in both bash and zsh.

## Local-only modifications

Any files matching `local.*` in `bash_profile.d/` are not tracked by git.

## Testing

```sh
script/test
```

Runs shellcheck on all shell files and verifies both bash and zsh start cleanly.
