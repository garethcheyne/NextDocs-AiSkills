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

# Markers for Copilot instructions
MARKER_START="<!-- NEXTDOCS-AI-SKILLS-START -->"
MARKER_END="<!-- NEXTDOCS-AI-SKILLS-END -->"

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
CLAUDE_COMMAND="$REPO_ROOT/nextdocs.md"
CONVENTIONS="$REPO_ROOT/nextdocs-conventions.md"
COPILOT_SNIPPET="$REPO_ROOT/copilot-instructions.md"

# Function to install Copilot snippet (append or update)
install_copilot_snippet() {
    local target_file="$1"
    local source_file="$2"
    local target_dir
    target_dir="$(dirname "$target_file")"

    mkdir -p "$target_dir"

    if [ -f "$target_file" ]; then
        # File exists - check for our markers
        if grep -q "$MARKER_START" "$target_file"; then
            # Our section exists - replace it
            echo -e "${YELLOW}[Copilot] Updating existing NextDocs reference...${NC}"

            # Create temp file with content before our section
            sed -n "1,/${MARKER_START}/{ /${MARKER_START}/!p }" "$target_file" > "$target_file.tmp"

            # Add our new content
            cat "$source_file" >> "$target_file.tmp"

            # Add content after our section
            sed -n "/${MARKER_END}/,\${ /${MARKER_END}/!p }" "$target_file" >> "$target_file.tmp"

            mv "$target_file.tmp" "$target_file"
            echo -e "${GREEN}[Copilot] Updated${NC}"
        else
            # File exists but doesn't have our section - append
            echo -e "${YELLOW}[Copilot] Adding NextDocs reference to existing file...${NC}"
            echo "" >> "$target_file"
            cat "$source_file" >> "$target_file"
            echo -e "${GREEN}[Copilot] Added${NC}"
        fi
    else
        # File doesn't exist - create it
        echo -e "${YELLOW}[Copilot] Creating copilot-instructions.md...${NC}"
        cp "$source_file" "$target_file"
        echo -e "${GREEN}[Copilot] Done${NC}"
    fi
}

echo ""
echo -e "${CYAN}NextDocs AI Skills Installer${NC}"
echo -e "${CYAN}============================${NC}"
echo ""

if [ "$GLOBAL" = true ]; then
    echo -e "${MAGENTA}Mode: Global (all projects)${NC}"
    echo ""

    CLAUDE_DIR="$HOME/.claude"

    # Install Claude Code slash command
    if [ -f "$CLAUDE_COMMAND" ]; then
        mkdir -p "$CLAUDE_DIR/commands"
        echo -e "${YELLOW}[Claude Code] Installing /nextdocs command...${NC}"
        cp "$CLAUDE_COMMAND" "$CLAUDE_DIR/commands/nextdocs.md"
        echo -e "${GREEN}[Claude Code] Done${NC}"
    fi

    # Install conventions file
    if [ -f "$CONVENTIONS" ]; then
        echo -e "${YELLOW}[Claude Code] Installing conventions...${NC}"
        cp "$CONVENTIONS" "$CLAUDE_DIR/nextdocs-conventions.md"
        echo -e "${GREEN}[Claude Code] Done${NC}"
    fi

    echo ""
    echo -e "${GRAY}[Copilot] Skipped - Copilot requires per-project installation${NC}"

else
    echo -e "${MAGENTA}Mode: Per-project${NC}"
    echo ""

    CLAUDE_DIR="$TARGET/.claude"
    GITHUB_DIR="$TARGET/.github"

    # Install Claude Code slash command
    if [ -f "$CLAUDE_COMMAND" ]; then
        mkdir -p "$CLAUDE_DIR/commands"
        echo -e "${YELLOW}[Claude Code] Installing /nextdocs command...${NC}"
        cp "$CLAUDE_COMMAND" "$CLAUDE_DIR/commands/nextdocs.md"
        echo -e "${GREEN}[Claude Code] Done${NC}"
    fi

    # Install conventions file for Claude
    if [ -f "$CONVENTIONS" ]; then
        echo -e "${YELLOW}[Claude Code] Installing conventions...${NC}"
        cp "$CONVENTIONS" "$CLAUDE_DIR/nextdocs-conventions.md"
        echo -e "${GREEN}[Claude Code] Done${NC}"
    fi

    # Install conventions file for Copilot
    if [ -f "$CONVENTIONS" ]; then
        mkdir -p "$GITHUB_DIR"
        echo -e "${YELLOW}[Copilot] Installing conventions...${NC}"
        cp "$CONVENTIONS" "$GITHUB_DIR/nextdocs-conventions.md"
        echo -e "${GREEN}[Copilot] Done${NC}"
    fi

    # Install Copilot snippet (smart merge)
    if [ -f "$COPILOT_SNIPPET" ]; then
        install_copilot_snippet "$GITHUB_DIR/copilot-instructions.md" "$COPILOT_SNIPPET"
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
echo -e "${CYAN}Installed files:${NC}"
if [ "$GLOBAL" = true ]; then
    echo "  ~/.claude/commands/nextdocs.md     (slash command)"
    echo "  ~/.claude/nextdocs-conventions.md  (conventions)"
else
    echo "  .claude/commands/nextdocs.md       (slash command)"
    echo "  .claude/nextdocs-conventions.md    (conventions)"
    echo "  .github/nextdocs-conventions.md    (conventions)"
    echo "  .github/copilot-instructions.md    (reference added)"
fi
echo ""
