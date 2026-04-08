# dev-env-setup

Automated development environment setup for macOS. One command to bootstrap a new Mac with all the tools, languages, and configs you need.

## Quick Start

```bash
git clone https://github.com/xflesym/dev-env-setup.git
cd dev-env-setup
bash setup.sh
```

## What Gets Installed

**Package Managers:**
- Homebrew

**Languages & Runtimes:**
- Python 3
- Node.js
- Go
- Rust

**Development Tools:**
- Git
- Terraform
- Docker
- GitHub CLI (`gh`)

**Shell & Productivity:**
- fzf (fuzzy finder)
- ripgrep (`rg` — fast grep)
- bat (syntax-highlighted cat)
- lazygit (beautiful git TUI)
- zsh-history-substring-search

## Configuration

**Shell (.zshrc):**
- Pretty color-coded prompt with git branch status
- Backward partial history search (↑/↓ arrows)
- 50k history with deduplication
- Handy aliases: `ll`, `l`, `c`, `gs`, `ga`, `gc`, `gp`, etc.
- fzf integration: `Ctrl-T` for files, `Ctrl-R` for history

**Git:**
- Configured globally with your name and email
- Useful aliases: `st`, `co`, `br`, `unstage`, `last`, `visual`
- Default branch: `main`

**Optional:**
- Computer hostname (prompted during setup)

## After Setup

1. **Reload shell:**
   ```bash
   source ~/.zshrc
   ```

2. **Try it out:**
   - `Ctrl-T` — fuzzy file search
   - `Ctrl-R` — fuzzy history search
   - `lazygit` — open a beautiful git TUI
   - `ll` — pretty directory listing

## Files

- `setup.sh` — Main installation script (interactive)
- `.zshrc` — Your shell configuration
- `README.md` — This file

## Notes

- The script will ask for your Git name and email (with defaults provided)
- Optionally set your computer hostname during setup
- All package installations use Homebrew
- Tested on macOS 12+ with Apple Silicon (arm64)

## License

MIT
