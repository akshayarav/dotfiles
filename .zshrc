# Neovim Aliases
alias v='nvim'
alias vim='nvim'

bindkey '^F' autosuggest-accept

if command -v figlet > /dev/null; then
  echo -e "\033[1;34m"
  figlet AA
  echo -e "\033[0m"
  
  echo -e "\033[1;36m📅  Date:\033[0m       $(date '+%A, %B %d, %Y')"
  echo -e "\033[1;36m⏰  Time:\033[0m       $(date '+%I:%M %p')"
  echo -e "\033[1;36m🖥️  Host:\033[0m       $(hostname)"
  echo -e "\033[1;36m📂  Directory:\033[0m  $(pwd)"
  echo -e "\033[1;36m🔥  Uptime:\033[0m     $(uptime | awk -F'(up |,)' '{print $2}' | xargs)"
  echo ""
  echo -e "\033[1;32m🚀 Welcome, $(whoami)! Let's build something awesome.\033[0m"
  echo -e "\033[1;30m──────────────────────────────────────────────────────\033[0m"
fi

alias pip3='/opt/homebrew/bin/python3.12 -m pip'
export PATH="/opt/homebrew/bin:$PATH"
# opam configuration
[[ ! -r /Users/akshay/.opam/opam-init/init.zsh ]] || source /Users/akshay/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
export CMR_ROOT=/Users/akshay/cmr
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null ||
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH="/Users/akshay/.deta/bin:$PATH"

export PATH="/Users/akshay/.detaspace/bin:$PATH"
alias rv='docker run -i --rm -v `pwd`:/root ghcr.io/sampsyo/cs3410-infra'
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
alias g++="g++ -std=c++17"
work() {
    if [ -z "$1" ]; then
        echo "Error: Please provide a session name. Usage: work <session_name>"
        return 1
    fi
    # Attaches if session exists; creates a new one if it doesn't
    tmux new-session -A -s "$1"
}
bindkey '^K' up-line-or-history
bindkey '^J' down-line-or-history
eval "$(starship init zsh)"

# ──────────────── Devcontainer Dotfiles & Helpers ────────────────
devc() {
  colima status >/dev/null 2>&1 || colima start --cpu 4 --memory 4 --mount-type virtiofs || return
  local -x DOCKER_CONTEXT=colima
  local args=(--workspace-folder "$PWD") rebuild=() env=(--remote-env CLAUDE_CONFIG_DIR=/home/vscode/.claude)
  [ -d .devcontainer ] || args+=(--config ~/.devcontainer_template/devcontainer.json)
  [[ $1 == -r ]] && rebuild=(--remove-existing-container) && shift
  # Personal layer on top of any config: dotfiles (cloned, then install.sh), Claude config volume, node for nvim LSPs
  # ~/.ssh is deliberately not mounted: no GitHub credentials in containers, so pushes happen from the Mac
  devcontainer up "${args[@]}" "${rebuild[@]}" "${env[@]}" \
    --dotfiles-repository https://github.com/akshayarav/dotfiles.git \
    --mount type=volume,source=claude-config,target=/home/vscode/.claude \
    --additional-features '{"ghcr.io/devcontainers/features/node:1":{}}' || return
  local name=${1:-${PWD:t}} cmd="DOCKER_CONTEXT=colima ${commands[devcontainer]} exec ${(j: :)${(@q)args}} ${(j: :)${(@q)env}} --remote-env TERM=xterm-256color --remote-env COLORTERM=truecolor --remote-env \"TMUX=\$TMUX\" zsh"
  tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" "$cmd" \; set-option default-command "$cmd"
  [ -n "$TMUX" ] && tmux switch-client -t "=$name" || tmux attach -t "=$name"
}

export PATH="$HOME/.devcontainers/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
