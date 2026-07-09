#!/bin/sh
# Bootstrap a new Mac from this repo. Idempotent — safe to re-run.
set -e

cd "$(dirname "$0")"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Packages (installs stow itself too)
brew bundle --file=Brewfile

# Symlink every package's files into $HOME
for pkg in */; do
  stow --restow --target="$HOME" "${pkg%/}"
done

# tmux plugin manager (prefix + I inside tmux to install plugins)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "Done. Open a new terminal (kitty) to pick everything up."
