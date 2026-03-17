#!/bin/bash
# NextDocs AI Skills Updater
# Updates existing installation with latest files (with version checking)

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m'

# Parse arguments
GLOBAL=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --global|-g)
            GLOBAL=true
            shift
            ;;
        --force|-f)
            FORCE=true
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
COPILOT_SNIPPET="$REPO_ROOT/copilot-instructions.md"
VERSION_FILE="$REPO_ROOT/VERSION"

# Markers for Copilot instructions
MARKER_START="<!-- NEXTDOCS-AI-SKILLS-START -->"
MARKER_END="<!-- NEXTDOCS-AI-SKILLS-END -->"

# Version comparison: returns 0 if $1 > $2
version_gt() {
    [ "$1" != "$2" ] && [ "$(printf '%s\n' "$1" "$2" | sort -V | tail -n1)" = "$1" ]
}

# Function to update Copilot snippet (replace marker block)
update_copilot_snippet() {
    local target_file="$1"
    local source_file="$2"

    if [ ! -f "$target_file" ]; then
        return 1
    fi

    if grep -q "$MARKER_START" "$target_file"; then
        local escaped_start escaped_end
        escaped_start=$(printf '%s\n' "$MARKER_START" | sed 's/[[\.*/^$]/\\&/g')
        escaped_end=$(printf '%s\n' "$MARKER_END" | sed 's/[[\.*/^$]/\\&/g')
        sed "/${escaped_start}/,/${escaped_end}/d" "$target_file" > "$target_file.tmp"
        sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$target_file.tmp" 2>/dev/null || true
        echo "" >> "$target_file.tmp"
        cat "$source_file" >> "$target_file.tmp"
        mv "$target_file.tmp" "$target_file"
        return 0
    fi

    return 1
}

echo ""
echo -e "${CYAN}NextDocs AI Skills Updater${NC}"
echo -e "${CYAN}==========================${NC}"
echo ""

# Read source version
SOURCE_VERSION=""
if [ -f "$VERSION_FILE" ]; then
    SOURCE_VERSION=$(cat "$VERSION_FILE" | tr -d '\n\r ')
fi

if [ -z "$SOURCE_VERSION" ]; then
    echo -e "${RED}Error: VERSION file not found in source${NC}"
    exit 1
fi

# Determine installed version file location
if [ "$GLOBAL" = true ]; then
    CLAUDE_DIR="$HOME/.claude"
    INSTALLED_VERSION_FILE="$CLAUDE_DIR/nextdocs.version"
    echo -e "${YELLOW}Checking global installation...${NC}"
else
    TARGET="$(pwd)"
    CLAUDE_DIR="$TARGET/.claude"
    GITHUB_DIR="$TARGET/.github"
    INSTALLED_VERSION_FILE="$CLAUDE_DIR/nextdocs.version"
    echo -e "${YELLOW}Checking project installation...${NC}"
fi

# Read installed version
INSTALLED_VERSION=""
if [ -f "$INSTALLED_VERSION_FILE" ]; then
    INSTALLED_VERSION=$(cat "$INSTALLED_VERSION_FILE" | tr -d '\n\r ')
fi

echo ""

# Version check
if [ -n "$INSTALLED_VERSION" ] && [ "$FORCE" = false ]; then
    if [ "$SOURCE_VERSION" = "$INSTALLED_VERSION" ]; then
        echo -e "${GREEN}Already up to date (v${INSTALLED_VERSION})${NC}"
        echo ""
        echo -e "${GRAY}Use --force to update anyway${NC}"
        echo ""
        exit 0
    fi

    if version_gt "$SOURCE_VERSION" "$INSTALLED_VERSION"; then
        echo -e "${CYAN}Updating: v${INSTALLED_VERSION} → v${SOURCE_VERSION}${NC}"
    else
        echo -e "${YELLOW}Warning: Source (v${SOURCE_VERSION}) is older than installed (v${INSTALLED_VERSION})${NC}"
        echo -e "${GRAY}Use --force to downgrade${NC}"
        echo ""
        exit 0
    fi
elif [ -z "$INSTALLED_VERSION" ]; then
    echo -e "${YELLOW}No version found — updating all files${NC}"
else
    echo -e "${YELLOW}Force update to v${SOURCE_VERSION}${NC}"
fi

echo ""

updated=0

if [ "$GLOBAL" = true ]; then
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

    # Update version file
    cp "$VERSION_FILE" "$CLAUDE_DIR/nextdocs.version"

else
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

    # Update Copilot instructions snippet
    if [ -f "$COPILOT_SNIPPET" ] && [ -f "$GITHUB_DIR/copilot-instructions.md" ]; then
        if update_copilot_snippet "$GITHUB_DIR/copilot-instructions.md" "$COPILOT_SNIPPET"; then
            echo -e "${GREEN}✓ Updated .github/copilot-instructions.md (NextDocs reference)${NC}"
            ((updated++))
        fi
    fi

    # Update version file
    cp "$VERSION_FILE" "$CLAUDE_DIR/nextdocs.version"
fi

echo ""
if [ $updated -gt 0 ]; then
    echo -e "${GREEN}Update complete! ($updated files updated → v${SOURCE_VERSION})${NC}"
else
    echo -e "${RED}No files found to update. Run install.sh first.${NC}"
fi
echo ""
