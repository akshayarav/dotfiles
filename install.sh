#!/bin/bash

# Get the absolute path of the directory where install.sh is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ~/.config

# Clean up old target links/directories
rm -rf ~/.config/nvim ~/.zshrc ~/.tmux.conf ~/.config/starship.toml ~/.devcontainer_template

# Create relative symlinks using exact current path
ln -sfn "$DIR/nvim" ~/.config/nvim
ln -sf "$DIR/starship.toml" ~/.config/starship.toml
ln -sf "$DIR/.tmux.conf" ~/.tmux.conf
ln -sf "$DIR/.zshrc" ~/.zshrc
ln -sf "$DIR/.devcontainer_template" ~/.devcontainer_template

# Claude Code: link individual items only, since ~/.claude also holds credentials, history and sessions
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$CLAUDE_DIR"
for item in settings.json CLAUDE.md commands themes; do
  rm -rf "$CLAUDE_DIR/$item"
  ln -sfn "$DIR/claude/$item" "$CLAUDE_DIR/$item"
done

# macOS: what Claude Code's /terminal-setup does for iTerm2 (lets /copy write to the clipboard)
if [[ "$(uname)" == "Darwin" ]]; then
  defaults write com.googlecode.iterm2 AllowClipboardAccess -bool true
fi

echo "Symlinks successfully created from $DIR!"
