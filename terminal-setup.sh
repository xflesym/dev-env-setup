#!/bin/bash
set -e

echo ""
echo "Setting up terminal: iTerm2 + fish + Starship + JetBrainsMono Nerd Font..."
echo ""

# ═══════════════════════════════════════════════════════════════════
# 1. Homebrew check
# ═══════════════════════════════════════════════════════════════════
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
else
  echo "✓ Homebrew already installed"
fi

# ═══════════════════════════════════════════════════════════════════
# 2. iTerm2
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "Installing iTerm2..."
if ! [ -d "/Applications/iTerm.app" ]; then
  brew install --cask iterm2
  echo "✓ iTerm2 installed"
else
  echo "✓ iTerm2 already installed"
fi

# ═══════════════════════════════════════════════════════════════════
# 3. Nerd Font (JetBrains Mono)
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "Installing JetBrainsMono Nerd Font..."
brew install --cask font-jetbrains-mono-nerd-font
echo "✓ Font installed"
echo ""
echo "  iTerm2 font setup (one-time manual step):"
echo "  iTerm2 > Settings > Profiles > Text"
echo "    Font:          JetBrainsMono Nerd Font  (size 13)"
echo "    Non-ASCII Font: JetBrainsMono Nerd Font Mono  (size 13)"

# ═══════════════════════════════════════════════════════════════════
# 4. Fish shell
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "Installing fish..."
brew install fish

FISH_PATH="$(brew --prefix)/bin/fish"

if ! grep -qF "$FISH_PATH" /etc/shells; then
  echo "Adding fish to /etc/shells (requires sudo)..."
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

echo ""
read -p "Set fish as your default shell? (y/n): " set_fish
if [[ "$set_fish" =~ ^[Yy]$ ]]; then
  chsh -s "$FISH_PATH"
  echo "✓ Default shell set to fish (takes effect in new terminal sessions)"
else
  echo "  Skipped — fish available but current shell remains default"
fi

# ═══════════════════════════════════════════════════════════════════
# 5. Starship
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "Installing Starship..."
brew install starship

# Hook into fish
FISH_CONFIG_DIR="$HOME/.config/fish"
FISH_CONFIG="$FISH_CONFIG_DIR/config.fish"
mkdir -p "$FISH_CONFIG_DIR"

if ! grep -q "starship init fish" "$FISH_CONFIG" 2>/dev/null; then
  echo "" >> "$FISH_CONFIG"
  echo "# Starship prompt" >> "$FISH_CONFIG"
  echo 'starship init fish | source' >> "$FISH_CONFIG"
  echo "✓ Starship hooked into fish"
else
  echo "✓ Starship already in fish config"
fi

# Hook into zsh as fallback
if ! grep -q "starship init zsh" "$HOME/.zshrc" 2>/dev/null; then
  echo "" >> "$HOME/.zshrc"
  echo "# Starship prompt" >> "$HOME/.zshrc"
  echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
  echo "✓ Starship hooked into zsh"
fi

# ═══════════════════════════════════════════════════════════════════
# 6. Starship config — pastel powerline + Nerd Font v3 icons
#
# Written as a single complete file (not appended) to avoid duplicate
# TOML section keys, which cause Starship to silently fail at startup.
# Unicode escape sequences ensure Nerd Font glyphs survive the write.
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "Writing Starship config..."
STARSHIP_CONFIG="$HOME/.config/starship.toml"

if [ -f "$STARSHIP_CONFIG" ]; then
  cp "$STARSHIP_CONFIG" "${STARSHIP_CONFIG}.bak"
  echo "  Backed up existing config to starship.toml.bak"
fi

python3 - << 'PYEOF'
import os

# Nerd Font v3 codepoints used below:
#   \ue0a0  git branch     \ue61e  C          \ue61d  C++
#   \ue724  Go             \ue777  Haskell    \ue738  Java
#   \ue6a1  Julia          \ue718  Node.js    \uf01a5 Nim
#   \ue606  Python         \ue7a8  Rust       \ue737  Scala
#   \ue62d  Elixir         \ue62c  Elm        \uf308  Docker
#   \uf03d7 Package

content = (
    'format = """\n'
    '[](#9A348E)\\\n'
    '$os\\\n'
    '$username\\\n'
    '[](bg:#DA627D fg:#9A348E)\\\n'
    '$directory\\\n'
    '[](fg:#DA627D bg:#FCA17D)\\\n'
    '$git_branch\\\n'
    '$git_status\\\n'
    '[](fg:#FCA17D bg:#86BBD8)\\\n'
    '$c\\\n'
    '$elixir\\\n'
    '$elm\\\n'
    '$golang\\\n'
    '$gradle\\\n'
    '$haskell\\\n'
    '$java\\\n'
    '$julia\\\n'
    '$nodejs\\\n'
    '$nim\\\n'
    '$rust\\\n'
    '$scala\\\n'
    '[](fg:#86BBD8 bg:#06969A)\\\n'
    '$docker_context\\\n'
    '[](fg:#06969A bg:#33658A)\\\n'
    '$time\\\n'
    '[ ](fg:#33658A)\\\n'
    '"""\n'
    '\n'
    '[username]\n'
    'show_always = true\n'
    'style_user = "bg:#9A348E"\n'
    'style_root = "bg:#9A348E"\n'
    "format = '[$user ]($style)'\n"
    'disabled = false\n'
    '\n'
    '[os]\n'
    'style = "bg:#9A348E"\n'
    'disabled = true\n'
    '\n'
    '[directory]\n'
    'style = "bg:#DA627D"\n'
    "format = '[ $path ]($style)'\n"
    'truncation_length = 3\n'
    'truncation_symbol = "\u2026/"\n'
    '\n'
    '[directory.substitutions]\n'
    '"Documents" = "\U000f01f9 "\n'
    '"Downloads" = "\uf019 "\n'
    '"Music" = "\uf001 "\n'
    '"Pictures" = "\uf03e "\n'
    '\n'
    '[c]\n'
    'symbol = "\ue61e "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[cpp]\n'
    'symbol = "\ue61d "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[docker_context]\n'
    'symbol = "\uf308 "\n'
    'style = "bg:#06969A"\n'
    "format = '[ $symbol $context ]($style)'\n"
    '\n'
    '[elixir]\n'
    'symbol = "\ue62d "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[elm]\n'
    'symbol = "\ue62c "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[git_branch]\n'
    'symbol = "\ue0a0 "\n'
    'style = "bg:#FCA17D"\n'
    "format = '[ $symbol $branch ]($style)'\n"
    '\n'
    '[git_status]\n'
    'style = "bg:#FCA17D"\n'
    "format = '[$all_status$ahead_behind ]($style)'\n"
    '\n'
    '[golang]\n'
    'symbol = "\ue724 "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[gradle]\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[haskell]\n'
    'symbol = "\ue777 "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[java]\n'
    'symbol = "\ue738 "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[julia]\n'
    'symbol = "\ue6a1 "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[nodejs]\n'
    'symbol = "\ue718 "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[nim]\n'
    'symbol = "\U000f01a5 "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[package]\n'
    'symbol = "\U000f03d7 "\n'
    '\n'
    '[python]\n'
    'symbol = "\ue606 "\n'
    '\n'
    '[rust]\n'
    'symbol = "\ue7a8 "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[scala]\n'
    'symbol = "\ue737 "\n'
    'style = "bg:#86BBD8"\n'
    "format = '[ $symbol ($version) ]($style)'\n"
    '\n'
    '[time]\n'
    'disabled = false\n'
    'time_format = "%R"\n'
    'style = "bg:#33658A"\n'
    "format = '[ \u2665 $time ]($style)'\n"
)

path = os.path.expanduser("~/.config/starship.toml")
with open(path, "w") as f:
    f.write(content)
print("done")
PYEOF

echo "✓ Starship config written to ~/.config/starship.toml"

# ═══════════════════════════════════════════════════════════════════
# 7. Zed
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "Installing Zed..."
if ! [ -d "/Applications/Zed.app" ]; then
  curl -f https://zed.dev/install.sh | sh
  echo "✓ Zed installed"
else
  echo "✓ Zed already installed"
fi

# ═══════════════════════════════════════════════════════════════════
# Done
# ═══════════════════════════════════════════════════════════════════
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           Terminal setup complete!                             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "What was installed:"
echo "  • iTerm2"
echo "  • JetBrainsMono Nerd Font"
echo "  • fish shell"
echo "  • Starship prompt (pastel-powerline with Nerd Font v3 icons)"
echo "  • Zed editor"
echo ""
echo "Next steps:"
echo "  1. Set font in iTerm2:"
echo "     Settings > Profiles > Text"
echo "       Font:           JetBrainsMono Nerd Font  13pt"
echo "       Non-ASCII Font: JetBrainsMono Nerd Font Mono  13pt"
echo "  2. Open a new iTerm2 tab to see Starship in action"
echo "  3. Run 'fish' to try the shell interactively"
echo ""
