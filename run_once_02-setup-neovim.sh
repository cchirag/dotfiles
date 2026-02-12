#!/bin/bash
# Setup Neovim - runs once after packages are installed

set -e

echo "🔧 Setting up Neovim..."

# Create nvim data directories
mkdir -p ~/.local/share/nvim
mkdir -p ~/.local/state/nvim

# Install lazy.nvim if not present
LAZY_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
    echo "📦 Installing lazy.nvim..."
    git clone --filter=blob:none --branch=stable \
        https://github.com/folke/lazy.nvim.git "$LAZY_PATH"
fi

# Run nvim headless to install plugins
echo "📦 Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo "✅ Neovim setup complete!"
