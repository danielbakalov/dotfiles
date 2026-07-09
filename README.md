# dotfiles

Personal macOS setup, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a stow package mirroring `$HOME` (e.g.
`zsh/.config/zsh/main.zsh` symlinks to `~/.config/zsh/main.zsh`).

## New machine

```sh
git clone https://github.com/danielbakalov/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh
```

Installs Homebrew, everything in `Brewfile`, symlinks all packages, and sets up
tmux's plugin manager.

## Packages

| Package    | What it configures                          |
| ---------- | ------------------------------------------- |
| `zsh`      | shell (`main.zsh`, `.zprofile`, `.zshrc`)   |
| `git`      | git config                                  |
| `kitty`    | terminal (Kanagawa theme, auto-tmux)        |
| `tmux`     | multiplexer (C-a prefix, vim panes, TPM)    |
| `nvim`     | LazyVim                                     |
| `starship` | prompt                                      |
| `aerospace`| tiling window manager                       |
| `ssh`      | ssh client config (no keys!)                |

## Day to day

Files are symlinked, so edit them in place and commit here. After **adding**
new files to a package, run `stow -R <package>` from this directory. After
installing/removing brew packages, refresh the lockfile with
`brew bundle dump --file=Brewfile --force`.
