#!/bin/bash
# Bootstrap script for Ollama models and Python packages

# Activate mise to get access to installed tools
eval "$(~/.local/bin/mise activate bash)" 2>/dev/null

# --- Install mise tools first ---
if command -v mise &> /dev/null; then
    echo "Installing mise tools..."
    mise install --yes 2>/dev/null
fi

# --- Python packages ---
echo "Installing Python packages..."
pip3 install --quiet --upgrade duckduckgo-mcp 2>/dev/null && echo "duckduckgo-mcp installed" || echo "pip install failed"

# --- Ollama models ---
MODELS_FILE="$HOME/.config/ollama/models.txt"

if ! command -v ollama &> /dev/null; then
    echo "Ollama not installed, skipping model bootstrap"
    exit 0
fi

if [[ ! -f "$MODELS_FILE" ]]; then
    echo "No models file found at $MODELS_FILE"
    exit 0
fi

echo "Bootstrapping Ollama models..."

# Start ollama serve temporarily if not running
STARTED_SERVER=false
if ! curl -s http://127.0.0.1:11434/api/tags > /dev/null 2>&1; then
    echo "Starting Ollama server..."
    ollama serve > /dev/null 2>&1 &
    STARTED_SERVER=true
    # Wait for server to be ready
    for i in {1..30}; do
        if curl -s http://127.0.0.1:11434/api/tags > /dev/null 2>&1; then
            break
        fi
        sleep 1
    done
fi

while IFS= read -r model || [[ -n "$model" ]]; do
    # Skip empty lines and comments
    [[ -z "$model" || "$model" =~ ^# ]] && continue

    echo "Pulling $model..."
    ollama pull "$model"
done < "$MODELS_FILE"

# Stop ollama if we started it
if [[ "$STARTED_SERVER" == true ]]; then
    pkill -f "ollama serve" 2>/dev/null
fi

echo "Ollama bootstrap complete"
