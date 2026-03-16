#!/bin/bash
# NextDocs AI Skills Updater
# Updates existing installation with latest files

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Parse arguments
GLOBAL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --global|-g)
            GLOBAL=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Find source files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_COMMAND="$REPO_ROOT/nextdocs.md"
CONVENTIONS="$REPO_ROOT/nextdocs-conventions.md"

echo ""
echo -e "${CYAN}NextDocs AI Skills Updater${NC}"
echo -e "${CYAN}==========================${NC}"
echo ""

updated=0

if [ "$GLOBAL" = true ]; then
    echo -e "${YELLOW}Checking global installation...${NC}"
    echo ""

    CLAUDE_DIR="$HOME/.claude"

    # Update slash command
    if [ -f "$CLAUDE_DIR/commands/nextdocs.md" ]; then
        cp "$CLAUDE_COMMAND" "$CLAUDE_DIR/commands/nextdocs.md"
        echo -e "${GREEN}✓ Updated ~/.claude/commands/nextdocs.md${NC}"
        ((updated++))
    else
        echo -e "${RED}✗ Not found: ~/.claude/commands/nextdocs.md${NC}"
    fi

    # Update conventions
    if [ -f "$CLAUDE_DIR/nextdocs-conventions.md" ]; then
        cp "$CONVENTIONS" "$CLAUDE_DIR/nextdocs-conventions.md"
        echo -e "${GREEN}✓ Updated ~/.claude/nextdocs-conventions.md${NC}"
        ((updated++))
    else
        echo -e "${RED}✗ Not found: ~/.claude/nextdocs-conventions.md${NC}"
    fi

else
    echo -e "${YELLOW}Checking project installation...${NC}"
    echo ""

    TARGET="$(pwd)"
    CLAUDE_DIR="$TARGET/.claude"
    GITHUB_DIR="$TARGET/.github"

    # Update Claude slash command
    if [ -f "$CLAUDE_DIR/commands/nextdocs.md" ]; then
        cp "$CLAUDE_COMMAND" "$CLAUDE_DIR/commands/nextdocs.md"
        echo -e "${GREEN}✓ Updated .claude/commands/nextdocs.md${NC}"
        ((updated++))
    else
        echo -e "${RED}✗ Not found: .claude/commands/nextdocs.md${NC}"
    fi

    # Update Claude conventions
    if [ -f "$CLAUDE_DIR/nextdocs-conventions.md" ]; then
        cp "$CONVENTIONS" "$CLAUDE_DIR/nextdocs-conventions.md"
        echo -e "${GREEN}✓ Updated .claude/nextdocs-conventions.md${NC}"
        ((updated++))
    else
        echo -e "${RED}✗ Not found: .claude/nextdocs-conventions.md${NC}"
    fi

    # Update Copilot conventions
    if [ -f "$GITHUB_DIR/nextdocs-conventions.md" ]; then
        cp "$CONVENTIONS" "$GITHUB_DIR/nextdocs-conventions.md"
        echo -e "${GREEN}✓ Updated .github/nextdocs-conventions.md${NC}"
        ((updated++))
    else
        echo -e "${RED}✗ Not found: .github/nextdocs-conventions.md${NC}"
    fi
fi

echo ""
if [ $updated -gt 0 ]; then
    echo -e "${GREEN}Update complete! ($updated files updated)${NC}"
else
    echo -e "${RED}No files found to update. Run install.sh first.${NC}"
fi
echo ""
