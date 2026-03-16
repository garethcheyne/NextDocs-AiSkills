#!/bin/bash
# NextDocs Slash Command Installer
# Just copies nextdocs.md to .claude/commands/

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Target directory (default: current directory)
TARGET="${1:-$(pwd)}"

# Find source file
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FILE="$(dirname "$SCRIPT_DIR")/nextdocs.md"

# Target paths
TARGET_DIR="$TARGET/.claude/commands"
TARGET_FILE="$TARGET_DIR/nextdocs.md"

echo ""
echo -e "${CYAN}NextDocs Slash Command Installer${NC}"
echo -e "${CYAN}=================================${NC}"
echo ""

# Check source exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}Error: nextdocs.md not found${NC}"
    exit 1
fi

# Create directory if needed
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Creating .claude/commands/...${NC}"
    mkdir -p "$TARGET_DIR"
fi

# Copy file
echo -e "${YELLOW}Installing slash command...${NC}"
cp "$SOURCE_FILE" "$TARGET_FILE"

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo -e "${CYAN}Usage:${NC}"
echo "  1. Restart Claude Code"
echo "  2. Type: /nextdocs"
echo ""
