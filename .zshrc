# ═══════════════════════════════════════════════════════════════════
# ZSH Configuration
# ═══════════════════════════════════════════════════════════════════

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ─────────────────────────────────────────────────────────────────────
# Backward Partial Search (already installed via Homebrew)
# ─────────────────────────────────────────────────────────────────────
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
plugins=(git zsh-history-substring-search)
HISTORY_SUBSTRING_SEARCH_PREFIXED=1
bindkey '^[[A' history-substring-search-up    # Up arrow
bindkey '^[[B' history-substring-search-down  # Down arrow

# ─────────────────────────────────────────────────────────────────────
# Pretty Prompt with Colors & Git Status
# ─────────────────────────────────────────────────────────────────────
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

# Git branch info
git_branch() {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n "$branch" ]]; then
    echo " %F{magenta}($branch)%f"
  fi
}

git_status() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if git diff-index --quiet HEAD -- 2>/dev/null; then
      echo "%F{green}✓%f"
    else
      echo "%F{yellow}●%f"
    fi
  fi
}

# Prompt
setopt PROMPT_SUBST
PROMPT='%F{cyan}%n%f@%F{blue}%m%f %F{green}%~%f$(git_branch) $(git_status) %F{yellow}❯%f '

# ─────────────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────────────
# Navigation & listing
alias ll='ls -lhA'
alias l='ls -1'
alias c='clear'
alias cd..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Common shortcuts
alias reload='source ~/.zshrc'
alias zshconfig='vim ~/.zshrc'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph -10'
alias greset='git reset --hard'

# Development
alias python='python3'
alias pip='pip3'
alias mkenv='python3 -m venv venv && source venv/bin/activate'
alias activate='source venv/bin/activate'
alias deactivate='deactivate'

# Utilities
alias grep='grep --color=auto'
alias cat='bat'  # prettier cat (requires bat install)
alias find='fd'  # faster find (if installed)
alias killport='lsof -ti:' # Usage: killport 3000

# ─────────────────────────────────────────────────────────────────────
# Useful Functions
# ─────────────────────────────────────────────────────────────────────
# Quick project setup
proj() {
  if [[ -z "$1" ]]; then
    echo "Usage: proj <project-name>"
    return 1
  fi
  mkdir -p "$1" && cd "$1"
}

# Extract archives
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *) echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a file"
  fi
}

# ─────────────────────────────────────────────────────────────────────
# Tool Integrations
# ─────────────────────────────────────────────────────────────────────
# fzf - Fuzzy finder keybindings
export FZF_DEFAULT_COMMAND='find . -type f -hidden -path "*/\.*" -prune -o -type f -print'

# Ctrl-T: fuzzy file search
# Ctrl-R: fuzzy history search
if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Export for tools
export CLICOLOR=1
export CLICOLOR_FORCE=1

# ─────────────────────────────────────────────────────────────────────
# PATH
# ─────────────────────────────────────────────────────────────────────
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
