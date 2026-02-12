# Dotfiles

My cross-platform development environment managed with [chezmoi](https://chezmoi.io).

## What's Included

| Tool | Purpose |
|------|---------|
| **Neovim** | Editor with LazyVim base |
| **Zellij** | Terminal multiplexer |
| **mise** | Version manager (Node, Python, Go, Rust) |
| **Git** | Version control config |

## Quick Start (New Machine)

**One-liner:**

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply cchirag
```

This will automatically:
1. Install system packages (neovim, zellij, ripgrep, fd, fzf, git)
2. Install mise and language runtimes (Node LTS, Python 3.12, Go, Rust)
3. Set up Neovim with all plugins
4. Apply all configs

**Restart your shell after installation to activate mise.**

## Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl                    # User variables
├── run_once_01-install-packages.sh.tmpl  # System + mise install
├── run_once_02-setup-neovim.sh           # Neovim plugins
├── dot_zshrc.tmpl                        # Shell config
├── dot_gitconfig.tmpl                    # Git config
└── dot_config/
    ├── nvim/                             # Neovim
    │   ├── init.lua
    │   └── lua/
    │       ├── config/
    │       │   ├── lazy.lua
    │       │   ├── keymaps.lua
    │       │   └── options.lua
    │       └── plugins/
    │           ├── colorscheme.lua
    │           ├── editor.lua
    │           ├── language-support.lua
    │           └── ui-overrides.lua
    ├── zellij/
    │   └── config.kdl
    └── mise/
        └── config.toml                   # Global tool versions
```

## Managing Versions with mise

```bash
# List installed tools
mise list

# Install a specific version
mise use node@20
mise use python@3.11

# Per-project versions (creates .mise.toml in current dir)
cd my-project
mise use node@18

# Upgrade all tools
mise upgrade
```

## Keybindings

### Neovim

| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `<leader>e` | File explorer (Oil) |
| `-` | Parent directory |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename |
| `sa` | Surround add |
| `sd` | Surround delete |
| `sr` | Surround replace |

### Zellij

All keybindings use `Alt` to avoid conflicts with Neovim:

| Key | Action |
|-----|--------|
| `Alt h/j/k/l` | Navigate panes |
| `Alt -` | Split horizontal |
| `Alt \` | Split vertical |
| `Alt z` | Zoom pane |
| `Alt x` | Close pane |
| `Alt t` | New tab |
| `Alt w` | Close tab |
| `Alt 1-5` | Go to tab |
| `Alt [/]` | Prev/next tab |
| `Alt r` | Resize mode |
| `Alt s` | Scroll mode |
| `Alt g` | Lock mode (pass all keys) |
| `Alt q` | Quit |

### Workflow: Neovim + Zellij + OpenCode

```bash
# Start zellij
zj

# Split for code + AI
Alt \           # Split right
opencode        # Run in right pane
Alt h           # Back to editor
Alt l           # Check AI output
Alt z           # Zoom AI pane when needed
```

## Updating

```bash
chezmoi update
```

## Adding Configs

```bash
# Add new config
chezmoi add ~/.config/someapp/config.toml

# Edit and apply
chezmoi edit ~/.config/nvim/init.lua
chezmoi apply

# Push changes
chezmoi cd
git add -A && git commit -m "Update" && git push
```

## Aliases

| Alias | Command |
|-------|---------|
| `v` | `nvim` |
| `vim` | `nvim` |
| `lg` | `lazygit` |
| `zj` | `zellij` |

## Troubleshooting

```bash
# Check chezmoi status
chezmoi doctor

# Reinstall nvim plugins
nvim --headless "+Lazy! sync" +qa

# Reinstall mise tools
mise install
```

## License

MIT
