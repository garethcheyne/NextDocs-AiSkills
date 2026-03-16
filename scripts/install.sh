#!/bin/bash
# NextDocs AI Skills Installer
# Installs slash command for Claude Code + instructions for GitHub Copilot

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

TARGET="${1:-$(pwd)}"

# Find source files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_SOURCE="$REPO_ROOT/nextdocs.md"
COPILOT_SOURCE="$REPO_ROOT/copilot-instructions.md"

echo ""
echo -e "${CYAN}NextDocs AI Skills Installer${NC}"
echo -e "${CYAN}============================${NC}"
echo ""

# Install Claude Code slash command
if [ -f "$CLAUDE_SOURCE" ]; then
    CLAUDE_DIR="$TARGET/.claude/commands"
    CLAUDE_TARGET="$CLAUDE_DIR/nextdocs.md"

    mkdir -p "$CLAUDE_DIR"

    echo -e "${YELLOW}[Claude Code] Installing /nextdocs command...${NC}"
    cp "$CLAUDE_SOURCE" "$CLAUDE_TARGET"
    echo -e "${GREEN}[Claude Code] Done${NC}"
fi

# Install GitHub Copilot instructions
if [ -f "$COPILOT_SOURCE" ]; then
    COPILOT_DIR="$TARGET/.github"
    COPILOT_TARGET="$COPILOT_DIR/copilot-instructions.md"

    mkdir -p "$COPILOT_DIR"

    echo -e "${YELLOW}[Copilot] Installing instructions...${NC}"
    cp "$COPILOT_SOURCE" "$COPILOT_TARGET"
    echo -e "${GREEN}[Copilot] Done${NC}"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${CYAN}Usage:${NC}"
echo "  Claude Code: Type /nextdocs"
echo "  Copilot:     Ask 'help me create documentation'"
echo ""
