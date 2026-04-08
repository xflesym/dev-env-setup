#!/bin/bash
set -e

echo "🚀 Starting macOS development environment setup..."

# ═══════════════════════════════════════════════════════════════════
# 1. Install Homebrew
# ═══════════════════════════════════════════════════════════════════
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✓ Homebrew already installed"
fi

# ═══════════════════════════════════════════════════════════════════
# 2. Install development tools & languages
# ═══════════════════════════════════════════════════════════════════
echo "Installing development tools..."
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
echo "Setting up .zshrc..."
if [[ -f .zshrc ]]; then
  cp .zshrc ~/.zshrc
  echo "✓ .zshrc installed"
else
  echo "⚠ .zshrc not found in repo"
fi

# ═══════════════════════════════════════════════════════════════════
# 4. Configure Git
# ═══════════════════════════════════════════════════════════════════
echo "Configuring Git..."
read -p "Enter your Git user name (default: Fei Xiang): " git_name
git_name=${git_name:-"Fei Xiang"}

read -p "Enter your Git email (default: xflesym@gmail.com): " git_email
git_email=${git_email:-"xflesym@gmail.com"}

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global core.editor "vim"
git config --global init.defaultBranch "main"

# Git aliases
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.visual "log --graph --oneline --all"

echo "✓ Git configured"

# ═══════════════════════════════════════════════════════════════════
# 5. Set hostname (optional)
# ═══════════════════════════════════════════════════════════════════
read -p "Set computer hostname? (leave blank to skip): " hostname
if [[ -n "$hostname" ]]; then
  echo "Setting hostname to '$hostname'..."
  sudo scutil --set ComputerName "$hostname"
  sudo scutil --set LocalHostName "$hostname"
  sudo scutil --set HostName "$hostname"
  echo "✓ Hostname set to '$hostname'"
fi

# ═══════════════════════════════════════════════════════════════════
# 6. Summary
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        ✅ Development environment setup complete!              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "1. Reload your shell: source ~/.zshrc"
echo "2. Try it out:"
echo "   • Ctrl-T: fuzzy file search"
echo "   • Ctrl-R: fuzzy history search"
echo "   • lazygit: beautiful git TUI"
echo "   • ll, l, c: common aliases"
echo ""
echo "Happy coding! 🚀"
