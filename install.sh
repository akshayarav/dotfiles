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

echo "Symlinks successfully created from $DIR!"
