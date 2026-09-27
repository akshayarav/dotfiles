#!/bin/bash

# Get the absolute path of the directory where install.sh is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Pinned for both the Mac and containers, so they can't drift: nvim plugins are locked against this Neovim,
# and both sides share each project's .jj folder. To upgrade, bump here, rerun install.sh on the Mac, then `devc -r`
NVIM_VERSION=0.12.5
JJ_VERSION=0.45.1

# Linux (devcontainers): install personal tools, so any Debian/Ubuntu devcontainer image gets them
# `devc` clones this repo into every container and runs this script (see --dotfiles-repository)
if [[ "$(uname)" == "Linux" ]]; then
  sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    htop \
    unzip \
    wget \
    zsh \
    figlet \
    ripgrep \
    fd-find \
    python3-pip \
    clangd \
    tmux \
    && sudo rm -rf /var/lib/apt/lists/*

  ARCH=$(uname -m)
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    NVIM_ARCH=arm64 TS_ARCH=arm64 JJ_ARCH=aarch64
  else
    NVIM_ARCH=x86_64 TS_ARCH=x64 JJ_ARCH=x86_64
  fi

  # Native Neovim binary
  curl -fsSL https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-linux-$NVIM_ARCH.tar.gz | sudo tar -C /opt -xz
  sudo ln -sf /opt/nvim-linux-$NVIM_ARCH/bin/nvim /usr/local/bin/nvim

  # tree-sitter CLI (nvim-treesitter uses it to build parsers; prebuilt binaries need glibc 2.39+)
  curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-$TS_ARCH.gz | gunzip | sudo tee /usr/local/bin/tree-sitter >/dev/null
  sudo chmod +x /usr/local/bin/tree-sitter

  # Jujutsu (jj)
  curl -fsSL https://github.com/jj-vcs/jj/releases/download/v$JJ_VERSION/jj-v$JJ_VERSION-$JJ_ARCH-unknown-linux-musl.tar.gz | sudo tar -xz -C /usr/local/bin ./jj

  # Starship prompt & zsh-autosuggestions
  curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
  [ -d /usr/share/zsh-autosuggestions ] || sudo git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh-autosuggestions

  # Claude Code (native installer -> ~/.local/bin/claude)
  curl -fsSL https://claude.ai/install.sh | bash

  # A new Docker volume mounted at the Claude config dir is owned by root
  CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
  sudo mkdir -p "$CLAUDE_DIR" && sudo chown "$(id -u):$(id -g)" "$CLAUDE_DIR"
fi

mkdir -p ~/.config/git ~/.config/jj

# Clean up old target links/directories
rm -rf ~/.config/nvim ~/.zshrc ~/.tmux.conf ~/.config/starship.toml ~/.devcontainer_template ~/.config/git/config ~/.config/jj/config.toml

# Create relative symlinks using exact current path
ln -sfn "$DIR/nvim" ~/.config/nvim
ln -sf "$DIR/starship.toml" ~/.config/starship.toml
ln -sf "$DIR/.tmux.conf" ~/.tmux.conf
ln -sf "$DIR/.zshrc" ~/.zshrc
ln -sf "$DIR/.devcontainer_template" ~/.devcontainer_template
ln -sf "$DIR/git/config" ~/.config/git/config
ln -sf "$DIR/jj/config.toml" ~/.config/jj/config.toml

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

  # Neovim & jj from the same pinned releases as containers, instead of Homebrew (~/.local/bin is first on PATH)
  if [ "$(uname -m)" = "arm64" ]; then NVIM_ARCH=arm64 JJ_ARCH=aarch64; else NVIM_ARCH=x86_64 JJ_ARCH=x86_64; fi
  mkdir -p ~/.local/opt ~/.local/bin
  rm -rf ~/.local/opt/nvim-macos-$NVIM_ARCH
  curl -fsSL https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-macos-$NVIM_ARCH.tar.gz | tar -C ~/.local/opt -xz
  ln -sf ~/.local/opt/nvim-macos-$NVIM_ARCH/bin/nvim ~/.local/bin/nvim
  curl -fsSL https://github.com/jj-vcs/jj/releases/download/v$JJ_VERSION/jj-v$JJ_VERSION-$JJ_ARCH-apple-darwin.tar.gz | tar -xz -C ~/.local/bin ./jj

  # tmux plugin manager (plugins are listed in .tmux.conf; prefix + I installs them)
  [ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/bin/install_plugins

  # tmux-fingers needs its binary; fetch it now instead of via the interactive wizard
  [ -x ~/.tmux/plugins/tmux-fingers/bin/tmux-fingers ] || ~/.tmux/plugins/tmux-fingers/install-wizard.sh download-binary
fi

if [[ "$(uname)" == "Linux" ]]; then
  # Install nvim plugins at the versions pinned in lazy-lock.json
  nvim --headless '+Lazy! restore' +qa

  # Make the clone read-only, so agents in the container can't edit their own config (e.g. Claude permissions)
  sudo chown -R root:root "$DIR"
fi

echo "Symlinks successfully created from $DIR!"
