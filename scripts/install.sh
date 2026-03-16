#!/bin/bash
# NextDocs AI Skills Installer
# Installs slash command for Claude Code + instructions for GitHub Copilot

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
NC='\033[0m'

# Parse arguments
GLOBAL=false
TARGET="$(pwd)"

while [[ $# -gt 0 ]]; do
    case $1 in
        --global|-g)
            GLOBAL=true
            shift
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

# Find source files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_SOURCE="$REPO_ROOT/nextdocs.md"
COPILOT_SOURCE="$REPO_ROOT/copilot-instructions.md"

echo ""
echo -e "${CYAN}NextDocs AI Skills Installer${NC}"
echo -e "${CYAN}============================${NC}"
echo ""

if [ "$GLOBAL" = true ]; then
    echo -e "${MAGENTA}Mode: Global (all projects)${NC}"
    echo ""

    # Install Claude Code slash command globally
    if [ -f "$CLAUDE_SOURCE" ]; then
        CLAUDE_DIR="$HOME/.claude/commands"
        CLAUDE_TARGET="$CLAUDE_DIR/nextdocs.md"

        mkdir -p "$CLAUDE_DIR"

        echo -e "${YELLOW}[Claude Code] Installing globally to ~/.claude/commands/...${NC}"
        cp "$CLAUDE_SOURCE" "$CLAUDE_TARGET"
        echo -e "${GREEN}[Claude Code] Done - Available in all projects${NC}"
    fi

    echo ""
    echo -e "${GRAY}[Copilot] Skipped - Copilot requires per-project installation${NC}"

else
    echo -e "${MAGENTA}Mode: Per-project${NC}"
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
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${CYAN}Usage:${NC}"
echo "  Claude Code: Type /nextdocs"
if [ "$GLOBAL" = false ]; then
    echo "  Copilot:     Ask 'help me create documentation'"
fi
echo ""
