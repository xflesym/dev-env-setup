#!/bin/bash
set -e

echo ""
echo "🚀 Starting macOS development environment setup..."
echo ""

# ═══════════════════════════════════════════════════════════════════
# 0. Collect personal info upfront
# ═══════════════════════════════════════════════════════════════════
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              Personal Information & Preferences                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Git name
read -p "Git user name: " git_name
while [[ -z "$git_name" ]]; do
  read -p "Git user name (required): " git_name
done

# Git email
read -p "Git email: " git_email
while [[ -z "$git_email" ]]; do
  read -p "Git email (required): " git_email
done

# GitHub username
read -p "GitHub username (for gh CLI auth): " github_username
while [[ -z "$github_username" ]]; then
  read -p "GitHub username (required): " github_username
done

# Hostname
read -p "Computer hostname (leave blank to skip): " hostname

# Default editor
read -p "Preferred editor (default: vim): " editor
editor=${editor:-"vim"}

echo ""

# ═══════════════════════════════════════════════════════════════════
# 1. Install Homebrew
# ═══════════════════════════════════════════════════════════════════
echo "📦 Installing Homebrew..."
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✓ Homebrew already installed"
fi

# ═══════════════════════════════════════════════════════════════════
# 2. Install development tools & languages
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "📦 Installing development tools..."
brew install \
  git \
  python3 \
  node \
  terraform \
  docker \
  go \
  rust \
  fzf \
  bat \
  ripgrep \
  lazygit \
  gh \
  zsh-history-substring-search \
  --quiet

echo "✓ All tools installed"

# ═══════════════════════════════════════════════════════════════════
# 3. Copy .zshrc
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "⚙️  Setting up .zshrc..."
if [[ -f .zshrc ]]; then
  cp .zshrc ~/.zshrc
  echo "✓ .zshrc installed"
else
  echo "⚠ .zshrc not found in repo"
fi

# ═══════════════════════════════════════════════════════════════════
# 4. Configure Git
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "⚙️  Configuring Git..."
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global core.editor "$editor"
git config --global init.defaultBranch "main"

# Git aliases
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.visual "log --graph --oneline --all"

echo "✓ Git configured:"
echo "  Name: $git_name"
echo "  Email: $git_email"
echo "  Editor: $editor"

# ═══════════════════════════════════════════════════════════════════
# 5. Authenticate GitHub CLI
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "⚙️  Authenticating GitHub CLI..."
echo "(You'll be prompted to authenticate in your browser)"
gh auth login --git-protocol https --skip-ssh-key || true

# ═══════════════════════════════════════════════════════════════════
# 6. Set hostname (if provided)
# ═══════════════════════════════════════════════════════════════════
if [[ -n "$hostname" ]]; then
  echo ""
  echo "⚙️  Setting hostname..."
  sudo scutil --set ComputerName "$hostname"
  sudo scutil --set LocalHostName "$hostname"
  sudo scutil --set HostName "$hostname"
  echo "✓ Hostname set to '$hostname'"
fi

# ═══════════════════════════════════════════════════════════════════
# 7. Summary
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        ✅ Development environment setup complete!              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Configuration Summary:"
echo "  Git User: $git_name"
echo "  Git Email: $git_email"
echo "  GitHub User: $github_username"
echo "  Editor: $editor"
if [[ -n "$hostname" ]]; then
  echo "  Hostname: $hostname"
fi
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. Try it out:"
echo "     • Ctrl-T: fuzzy file search"
echo "     • Ctrl-R: fuzzy history search"
echo "     • lazygit: beautiful git TUI"
echo "     • ll, l, c: common aliases"
echo ""
echo "Happy coding! 🚀"
