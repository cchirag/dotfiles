# Dotfiles

Cross-platform development environment managed with [chezmoi](https://chezmoi.io).

## Quick Start (New Machine)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply cchirag
```

Restart your shell after installation.

## What's Included

| Tool | Purpose |
|------|---------|
| **Neovim** | Editor (LazyVim base) |
| **Zellij** | Terminal multiplexer |
| **mise** | Version manager (Node, Python, Go, Rust, etc.) |
| **Zsh** | Shell with autosuggestions |

## Editing Workflow

Chezmoi **copies** files (not symlinks). Here's how to edit:

### Option 1: Edit via chezmoi (recommended)

```bash
# Edit source file directly (opens in $EDITOR)
chezmoi edit ~/.config/nvim/init.lua

# Changes are auto-applied on save
```

### Option 2: Edit target, then sync back

```bash
# Edit the actual config file
nvim ~/.config/nvim/init.lua

# Sync changes back to chezmoi source
chezmoi re-add ~/.config/nvim/init.lua
```

### Option 3: Edit source repo directly

```bash
# Go to source directory
chezmoi cd
# Or: cd ~/.local/share/chezmoi

# Edit files
nvim dot_config/nvim/init.lua

# Apply changes to system
chezmoi apply
```

### Pushing changes

```bash
chezmoi cd
git add -A
git commit -m "Update nvim config"
git push
```

### Pulling changes (on another machine)

```bash
chezmoi update
```

### See what would change

```bash
chezmoi diff
```

## Structure

```
~/.local/share/chezmoi/
├── run_once_01-install-packages.sh.tmpl  # Install tools via mise
├── run_once_02-setup-neovim.sh           # Setup nvim plugins
├── dot_zshrc                             # → ~/.zshrc
├── dot_gitconfig.tmpl                    # → ~/.gitconfig
└── dot_config/
    ├── nvim/                             # → ~/.config/nvim/
    ├── zellij/                           # → ~/.config/zellij/
    └── mise/                             # → ~/.config/mise/
```

**Naming:** `dot_` → `.`, `_` → `/`, `.tmpl` → templated

## Managing Tools with mise

```bash
mise list                 # Show installed
mise use node@20          # Install/switch version
mise use --global go@1.22 # Set global default
mise upgrade              # Upgrade all
```

## Keybindings

### Neovim

| Key | Action |
|-----|--------|
| `Space` | Leader |
| `<leader>e` / `-` | File explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Grep |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `sa/sd/sr` | Surround add/delete/replace |

### Zellij (Alt-based, no nvim conflicts)

| Key | Action |
|-----|--------|
| `Alt h/j/k/l` | Navigate panes |
| `Alt -` | Split horizontal |
| `Alt \` | Split vertical |
| `Alt z` | Zoom pane |
| `Alt x` | Close pane |
| `Alt t` | New tab |
| `Alt 1-5` | Go to tab |
| `Alt g` | Lock mode |
| `Alt q` | Quit |

### Zsh

| Key | Action |
|-----|--------|
| `↑/↓` | Search history (matching prefix) |
| `Ctrl+R` | Interactive history search |
| `Ctrl+F` | Accept autosuggestion |
| `Tab` | Completion menu |

## Aliases

```
v, vim  → nvim
lg      → lazygit
zj      → zellij
g       → git
gs      → git status -sb
```

## Adding New Configs

```bash
# Add a file to chezmoi
chezmoi add ~/.config/someapp/config.toml

# Add entire directory
chezmoi add ~/.config/someapp
```

## Troubleshooting

```bash
chezmoi doctor           # Check status
chezmoi diff             # See pending changes
chezmoi apply -v         # Apply with verbose output
mise install             # Reinstall tools
nvim --headless "+Lazy! sync" +qa  # Reinstall nvim plugins
```

## License

MIT
