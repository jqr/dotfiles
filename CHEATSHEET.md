# Cheat Sheet

## Navigation

| Alias | Command | Why |
|-------|---------|-----|
| `..` | `cd ..` | Go up one |
| `...` | `cd ../..` | Go up two |
| `....` | `cd ../../..` | Go up three |
| `.....` | `cd ../../../..` | Go up four |
| `......` | `cd ../../../../..` | Go up five |

## Files & System

| Alias | Description | Why |
|-------|-------------|-----|
| `ll` | `ls -lh` | See file details |
| `la` | `ls -lA` (includes hidden) | See everything, including dotfiles |
| `recent` | List files by newest first | What just changed? |
| `old` | List files by oldest first | What hasn't been touched? |
| `f <pattern>` | Find files matching `*pattern*` | Where is that file? |
| `du` | `du -hc` (human-readable with total) | What's eating disk space? |
| `mkdir` | `mkdir -p` (create parents automatically) | This whole chain of dirs should exist |
| `touch` | Enhanced: auto-creates parent directories | This whole chain of dirs and file should exist |
| `lc` | `wc -l` (line count) | How many lines? |
| `psg` | `ps aux \| grep` | Find a running process |
| `ka` | `killall` | Kill a process by name |
| `switch <a> <b>` | Swap contents of two files | Swap backup with current |
| `reload` | Restart shell with a fresh login session | Pick up dotfile changes |
| `myip` | Show your public IP | What IP am I on? |

## Editors & Apps

| Alias | Command | Why |
|-------|---------|-----|
| `e` | `$EDITOR` | Open your default editor |
| `c` | `code` (VS Code) | Open in VS Code |
| `s` | `subl` (Sublime Text) | Open in Sublime |
| `z` | `zed` | Open in Zed |
| `o` | `open` (macOS open) | Open anything in its default app |
| `k` | `kubectl` | Kubernetes the short way |

## Git - Basics

| Alias | Description | Why |
|-------|-------------|-----|
| `g` | `git` | For when even "git" is too long |
| `gs` | Status (short) + stash list | What was I up to? |
| `gi` | Init new repo with sensible defaults | Start a new project |

## Git - Log

| Alias | Description | Why |
|-------|-------------|-----|
| `gl` | Pretty log with colors and relative times | Browse history |
| `glm` | Log of commits not on main | What is this branch up to? |
| `glo` | Log of commits not on origin | What haven't I pushed? |
| `gls` | Log with diffstat per commit | Which files did each commit touch? |
| `glms` | Log vs main with diffstat | Scope of this branch by file |
| `glp` | Log with full patch (what changed) | Show me actual changes (great for search!) |
| `glpm` | Log with patch, only commits not on main | Review this branch's changes in detail |
| `glg` | Log with graph of branches | Visualize branch topology |
| `gcd` | All commits by date across all branches | What has everyone been up to? |
| `gcda <author>` | Same filtered by author | What has one person been up to? |

## Git - Diff

| Alias | Description | Why |
|-------|-------------|-----|
| `gd` | Diff (unstaged changes) | What did I just change? |
| `gds` | Diff stat (file summary) | Which files did I touch? |
| `gdh` | Diff HEAD (staged + unstaged) | Everything I've changed, period |
| `gdhs` | Diff HEAD stat | File summary of all changes |
| `gdo` | Diff vs same branch on origin | What's different from what's pushed? |
| `gdos` | Diff vs origin stat | File summary vs pushed |
| `gdm` | Diff vs main | Full diff of this branch's work |
| `gdms` | Diff vs main stat | File summary of this branch's work |

## Git - Staging & Committing

| Alias | Description | Why |
|-------|-------------|-----|
| `ga` | `git add` | Stage files |
| `gaa` | `git add --all` | Stage everything |
| `gap` | `git add -p` (interactive patch) | Stage only specific hunks |
| `gap* <pattern>` | Add patch matching wildcard | Stage hunks from matching files |
| `gc` | `git commit -v` (verbose, shows diff) | Commit with the diff visible in your editor |
| `gca` | Commit all changed tracked files | Quick commit without staging |
| `gcam` | Amend last commit | Oops, meant to include that too |
| `gcf` | Fixup a previous commit (interactive pick + autosquash) | Oops, I forgot this on commit X |

## Git - Branches

| Alias | Description | Why |
|-------|-------------|-----|
| `gb` | Local branches with last commit | What branches do I have? |
| `gbr` | Remote branches with last commit | What branches exist on origin? |
| `gba` | All branches | See everything |
| `gbu` | Local branches not merged into current | What's still outstanding? |
| `gbum` | Local branches not merged into main | What hasn't landed yet? |
| `gbru` | Remote branches not merged into current | Remote work not in this branch |
| `gbrum` | Remote branches not merged into main | Remote work not yet landed |
| `gbau` | All branches not merged into current | Everything outstanding vs here |
| `gbaum` | All branches not merged into main | Everything outstanding vs main |
| `gbdm` | Delete local branches merged into current | Clean up finished branches |
| `gbrdm` | Delete remote branches merged into current (with confirmation) | Clean up finished remote branches |
| `grpo` | Prune remote tracking branches that no longer exist | Remove stale remote refs |

## Git - Checkout & Navigation

| Alias | Description | Why |
|-------|-------------|-----|
| `gco` | Checkout (auto-handles `origin/` prefix) | Switch branches (tab-complete remote names too) |
| `gcom` | Checkout main | Get back to main |
| `gcop` | Checkout patch (revert selected hunks) | Undo specific changes to a file |

## Git - Push, Pull & Fetch

| Alias | Description | Why |
|-------|-------------|-----|
| `gp` | Pull with rebase | Get latest and replay my work on top |
| `gu` | Push current branch to origin | Ship it |
| `gf` | Fetch | Refresh remote branches |
| `gfa` | Fetch all remotes | Refresh remote branches from all remotes |
| `grb [name]` | Create + push remote branch (defaults to current branch name) | Make this branch into a remote branch |

## Git - Stash

| Alias | Description | Why |
|-------|-------------|-----|
| `g{` | Stash everything (including untracked), prompts for name | Set aside current work |
| `g{p` | Stash interactively (patch mode) | Set aside some changes |
| `g{s` | Stash only staged changes | Set aside what's staged |
| `g}` | Pop most recent stash | Resume stashed work |
| `g}b` | Pop stash into its original branch | Pop on original commit (never has merge conflicts) |
| `g{}` | Show all stashes with full diffs | What did I stash? |

## Git - Rebase & Reset

| Alias | Description | Why |
|-------|-------------|-----|
| `gri [ref]` | Interactive rebase (defaults to unpushed commits) | Modify commits not yet pushed |
| `grc` | Rebase continue | Keep going after resolving conflicts |
| `gr` | `git reset` (unstage) | Unstage files |
| `grp` | `git reset -p` (interactive unstage) | Unstage specific hunks |

## Git - Misc

| Alias | Description | Why |
|-------|-------------|-----|
| `ggc` | Garbage collect + report space saved | Reclaim disk space in a bloated repo |
| `gtc` | Touch all modified files (retrigger file-watching test runners) | Re-run tests without changing code |
| `gtcm` | Touch all files changed vs main (retrigger file-watching test runners) | Re-run tests for this branch's changes |

## Ruby / Rails

| Alias | Description | Why |
|-------|-------------|-----|
| `r` | `rails` | Rails shorthand |
| `rc` | `rails console` | Open a REPL with your app loaded |
| `rs` | `rails server` | Start the dev server |
| `rt` | `rails test` | Run the test suite |
| `rg` | `rails generate` | Scaffold code |
| `rd` | `rails destroy` | Undo a generate |
| `rr` | `rails runner` | Run a script in app context |
| `rdb` | `rails dbconsole` | SQL prompt against your app's DB |
| `rtdm` | Run tests only for files changed vs main | Test just this branch's work |
| `be` | `bundle exec` | Run a gem's binary in bundle context |
| `bi` | `bundle install` | Install dependencies |
| `bu` | `bundle update` | Update dependencies |
| `bo` | `bundle outdated` | What needs updating? |

## macOS

| Alias | Description | Why |
|-------|-------------|-----|
| `ql <file>` | Quick Look preview | Preview without opening an app |
| `pman <cmd>` | Open man page as PDF in Preview | Read man pages comfortably |
| `openports` | List all listening TCP ports | What's using which port? |
| `x86` | Open a Rosetta (x86_64) shell | Run x86 binaries on Apple Silicon |
| `notify <msg> <title>` | macOS notification + terminal banner | Get alerted when something finishes |

## DNS

| Alias | Description | Why |
|-------|-------------|-----|
| `dns <domain>` | Check if a domain is registered or available | Is this domain taken? |
| `dns_flush` | Flush macOS DNS cache | Fix stale DNS after changes |
