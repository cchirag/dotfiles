# Dotfiles

My cross-platform development environment managed with [chezmoi](https://chezmoi.io).

## What's Included

| Tool | Purpose |
|------|---------|
| **Neovim** | Editor with LazyVim base |
| **Zellij** | Terminal multiplexer |
| **Git** | Version control config |

## Quick Start (New Machine)

### 1. Install chezmoi and apply dotfiles

**One-liner (recommended):**

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply cchirag
```

**Or step by step:**

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Init with your dotfiles repo
chezmoi init https://github.com/cchirag/dotfiles.git

# Preview changes
chezmoi diff

# Apply
chezmoi apply
```

### 2. That's it!

The setup scripts will automatically:
- Install required packages (neovim, zellij, ripgrep, fd, etc.)
- Set up Neovim with all plugins
- Configure git with your name/email

## Manual Installation (Without chezmoi)

If you prefer not to use chezmoi:

```bash
# Clone
git clone https://github.com/cchirag/dotfiles.git ~/dotfiles

# Copy configs
cp -r ~/dotfiles/dot_config/nvim ~/.config/
cp -r ~/dotfiles/dot_config/zellij ~/.config/

# Install packages manually (macOS)
brew install neovim zellij ripgrep fd fzf git lazygit node go python3 rust
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl           # Machine-specific variables
├── run_once_01-install-packages.sh.tmpl  # Package installation
├── run_once_02-setup-neovim.sh  # Neovim setup
├── dot_gitconfig.tmpl           # Git config (templated)
├── dot_config/
│   ├── nvim/                    # Neovim config
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── lazy.lua     # Plugin manager
│   │       │   ├── keymaps.lua  # Key mappings
│   │       │   └── options.lua  # Editor options
│   │       └── plugins/
│   │           ├── colorscheme.lua
│   │           ├── editor.lua
│   │           ├── language-support.lua
│   │           └── ui-overrides.lua
│   └── zellij/
│       └── config.kdl           # Zellij config
└── README.md
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

### Zellij

All keybindings use `Alt` to avoid conflicts with Neovim:

| Key | Action |
|-----|--------|
| `Alt g` | Toggle locked mode (pass all keys through) |
| `Alt h/j/k/l` | Navigate panes |
| `Alt -` | Split horizontal |
| `Alt \` | Split vertical |
| `Alt x` | Close pane |
| `Alt z` | Zoom/fullscreen pane |
| `Alt t` | New tab |
| `Alt w` | Close tab |
| `Alt 1-5` | Go to tab 1-5 |
| `Alt [/]` | Previous/next tab |
| `Alt r` | Enter resize mode |
| `Alt s` | Enter scroll mode |
| `Alt q` | Quit zellij |

### Zellij + Neovim Workflow

```bash
# Start zellij
zellij

# Split for code + terminal
Alt \      # Split right for terminal
Alt h      # Back to editor

# Or split for code + AI assistant
Alt \      # Split right
opencode   # Run opencode in the pane
Alt h      # Back to editor
Alt l      # Check opencode output
Alt z      # Zoom opencode when needed
```

## Updating

```bash
# Pull latest changes
chezmoi update

# Or manually
chezmoi git pull
chezmoi apply
```

## Adding New Configs

```bash
# Add a new config file
chezmoi add ~/.config/someapp/config.toml

# Edit managed files
chezmoi edit ~/.config/nvim/init.lua

# Apply changes
chezmoi apply

# Push to repo
chezmoi cd
git add -A
git commit -m "Update configs"
git push
```

## Customization

### Machine-Specific Settings

Edit `~/.config/chezmoi/chezmoi.toml` for machine-specific variables:

```toml
[data]
    name = "Your Name"
    email = "your@email.com"
```

### Adding Packages

Edit `run_once_01-install-packages.sh.tmpl` to add more packages.

## Languages Supported (Neovim)

- Go
- TypeScript / JavaScript
- Python
- Rust
- HTML / CSS

To add more, edit `lua/plugins/language-support.lua` and `lua/config/lazy.lua`.

## Troubleshooting

### Neovim plugins not installing

```bash
nvim --headless "+Lazy! sync" +qa
```

### Zellij keybindings not working

Make sure you're not in "locked" mode. Press `Alt g` to toggle.

### chezmoi not finding templates

```bash
chezmoi doctor
```

## License

MIT
