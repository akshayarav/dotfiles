# Neovim Aliases
alias v='nvim'
alias vim='nvim'

bindkey '^F' autosuggest-accept

if command -v figlet > /dev/null; then
  echo -e "\033[1;34m"
  figlet AA
  echo -e "\033[0m"
  
  # ──────────────── Aesthetic Info Block ────────────────
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
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

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
