FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

USER root

# Install base terminal tools & build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && rm -rf /var/lib/apt/lists/*

# Install native Neovim binary matching system architecture (arm64 vs x86_64)
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz && \
      tar -C /opt -xzf nvim-linux-arm64.tar.gz && \
      ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim && \
      rm nvim-linux-arm64.tar.gz; \
    else \
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
      tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
      ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
      rm nvim-linux-x86_64.tar.gz; \
    fi

# Install Tmux & Starship Prompt
RUN apt-get update && apt-get install -y tmux && rm -rf /var/lib/apt/lists/*
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install zsh-autosuggestions globally inside container
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh-autosuggestions

USER vscode
ENV SHELL=/bin/zsh
WORKDIR /home/vscode

# Install Claude Code (native installer -> ~/.local/bin/claude)
# Pre-create ~/.claude so the named volume mounted there is owned by vscode, not root
RUN curl -fsSL https://claude.ai/install.sh | bash && mkdir -p /home/vscode/.claude
