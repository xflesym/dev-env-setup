# dev-env-setup

Automated development environment setup for macOS. One command to bootstrap a new Mac with all the tools, languages, and configs you need.

## Quick Start

```bash
git clone https://github.com/xflesym/dev-env-setup.git
cd dev-env-setup
bash setup.sh          # core dev tools
bash terminal-setup.sh # iTerm2 + fish + Starship
```

## Scripts

### `setup.sh` — Core Dev Tools

Installs and configures the full development stack. Interactive: asks for your Git name, email, and GitHub username upfront.

**Package Managers:**
- Homebrew

**Languages & Runtimes:**
- Python 3, Node.js, Go, Rust

**Development Tools:**
- Git (with aliases), Terraform, Docker, GitHub CLI (`gh`)

**Shell & Productivity:**
- fzf (fuzzy finder), ripgrep, bat, lazygit
- zsh-history-substring-search

**Shell config (.zshrc):**
- Color-coded prompt with git branch status
- Backward partial history search (↑/↓ arrows)
- 50k history with deduplication
- Aliases: `ll`, `l`, `c`, `gs`, `ga`, `gc`, `gp`, etc.
- fzf integration: `Ctrl-T` for files, `Ctrl-R` for history

---

### `terminal-setup.sh` — iTerm2 + fish + Starship

Sets up a polished terminal experience with a Nerd Font-powered Starship prompt.

**What it installs:**
- **iTerm2** — terminal emulator
- **JetBrainsMono Nerd Font** — font with dev icons
- **fish** — friendly interactive shell (optionally set as default)
- **Starship** — fast, customizable prompt (hooked into both fish and zsh)
- **Zed** — fast code editor

**Starship theme:** pastel-powerline style with colored segments for username, directory, git branch/status, language versions, and time. Icons use Nerd Font v3 codepoints.

**After running, set the font in iTerm2 manually (one-time):**
```
iTerm2 > Settings > Profiles > Text
  Font:           JetBrainsMono Nerd Font        13pt
  Non-ASCII Font: JetBrainsMono Nerd Font Mono   13pt
```

> **Note:** The Starship config is written as a single complete file via Python (not
> appended with `cat`). This prevents duplicate TOML section keys, which cause
> Starship to silently fail to parse its config at startup.

---

## After Running `setup.sh`

1. **Reload shell:**
   ```bash
   source ~/.zshrc
   ```
2. **Try it out:**
   - `Ctrl-T` — fuzzy file search
   - `Ctrl-R` — fuzzy history search
   - `lazygit` — git TUI
   - `ll` — pretty directory listing

## After Running `terminal-setup.sh`

1. Set the iTerm2 font (see above)
2. Open a new iTerm2 tab — Starship prompt appears automatically
3. Run `fish` to try the shell

## Files

| File | Purpose |
|------|---------|
| `setup.sh` | Core tools, languages, git config |
| `terminal-setup.sh` | iTerm2, fish, Starship, Zed |
| `README.md` | This file |

## Requirements

- macOS 12+, Apple Silicon (arm64) or Intel
- Internet connection
- `sudo` access (for `/etc/shells` update)

## License

MIT
