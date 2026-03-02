#!/bin/bash
# Bootstrap script for mise tools
# hash: v3-opencode-zellij

# Activate mise to get access to installed tools
eval "$(~/.local/bin/mise activate bash)" 2>/dev/null

if command -v mise &> /dev/null; then
    # Uninstall removed tools
    echo "Cleaning up removed tools..."
    mise uninstall ollama --all 2>/dev/null
    mise uninstall eza --all 2>/dev/null

    # Install current tools
    echo "Installing mise tools..."
    mise install --yes 2>/dev/null
fi

# Remove old Python packages
echo "Cleaning up Python packages..."
pip3 uninstall -y duckduckgo-mcp 2>/dev/null

echo "Bootstrap complete"
