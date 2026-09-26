#!/bin/bash
# Symlink configurations to home directory
mkdir -p ~/.config
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.zshrc ~/.zshrc
