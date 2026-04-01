#!/usr/bin/env bash
set -euo pipefail

BART_HOME="${BART_HOME:-$HOME/.config/bart}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing bart..."

# Dependencies
for cmd in zellij watch claude; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Missing dependency: $cmd"
    case "$cmd" in
      zellij) echo "  brew install zellij" ;;
      watch)  echo "  brew install watch" ;;
      claude) echo "  See https://docs.anthropic.com/en/docs/claude-code" ;;
    esac
    exit 1
  fi
done

# Binary
mkdir -p "$BIN_DIR"
cp "$SCRIPT_DIR/bart" "$BIN_DIR/bart"
chmod +x "$BIN_DIR/bart"

# Config
mkdir -p "$BART_HOME/prompts" "$BART_HOME/mcp-configs"
cp "$SCRIPT_DIR/AGENT.md" "$BART_HOME/AGENT.md"
cp "$SCRIPT_DIR/prompts/"* "$BART_HOME/prompts/"
cp "$SCRIPT_DIR/mcp-configs/"* "$BART_HOME/mcp-configs/"

echo ""
echo "Installed:"
echo "  $BIN_DIR/bart"
echo "  $BART_HOME/AGENT.md"
echo "  $BART_HOME/prompts/ ($(ls "$BART_HOME/prompts/" | wc -l | tr -d ' ') files)"
echo "  $BART_HOME/mcp-configs/ ($(ls "$BART_HOME/mcp-configs/" | wc -l | tr -d ' ') files)"

# Check PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo ""
  echo "Add to your PATH:"
  echo "  export PATH=\"$BIN_DIR:\$PATH\""
fi

echo ""
echo "Run: bart ~/projects"
