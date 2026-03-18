#!/bin/bash
# NextDocs AI Skills Installer
# Installs skills for Claude Code and GitHub Copilot

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
CLAUDE_COMMAND="$REPO_ROOT/nextdocs.md"
CONVENTIONS="$REPO_ROOT/nextdocs-conventions.md"
SKILL_DIR="$REPO_ROOT/skills/nextdocs"
VERSION_FILE="$REPO_ROOT/VERSION"

# Function to update VS Code settings.json
update_vscode_settings() {
    local target_dir="$1"
    local vscode_dir="$target_dir/.vscode"
    local settings_file="$vscode_dir/settings.json"

    # Create .vscode directory if needed
    mkdir -p "$vscode_dir"

    # Create settings.json if it doesn't exist
    if [ ! -f "$settings_file" ]; then
        echo -e "${YELLOW}[VS Code] Creating settings.json with skill locations...${NC}"
        cat > "$settings_file" << 'EOF'
{
    "chat.agentSkillsLocations": {
        ".github/skills/**": true,
        ".claude/skills/**": true
    }
}
EOF
        echo -e "${GREEN}[VS Code] Done${NC}"
        return
    fi

    # Check if chat.agentSkillsLocations already exists
    if grep -q "chat.agentSkillsLocations" "$settings_file"; then
        echo -e "${GRAY}[VS Code] Skills location already configured${NC}"
        return
    fi

    # Add skill locations to existing settings
    echo -e "${YELLOW}[VS Code] Adding skill locations to settings.json...${NC}"

    # Use node to safely modify JSON (with proper path handling for Windows/Git Bash)
    if command -v node &> /dev/null; then
        # Read current content and pass as stdin to avoid path issues
        local current_content
        current_content=$(cat "$settings_file")

        local new_content
        new_content=$(node -e "
            const settings = JSON.parse(process.argv[1]);
            settings['chat.agentSkillsLocations'] = {
                '.github/skills/**': true,
                '.claude/skills/**': true
            };
            console.log(JSON.stringify(settings, null, 4));
        " "$current_content" 2>/dev/null)

        if [ -n "$new_content" ]; then
            echo "$new_content" > "$settings_file"
            echo -e "${GREEN}[VS Code] Done${NC}"
        else
            echo -e "${YELLOW}[VS Code] Add this to settings.json manually:${NC}"
            echo '  "chat.agentSkillsLocations": { ".github/skills/**": true, ".claude/skills/**": true }'
        fi
    else
        echo -e "${YELLOW}[VS Code] Add this to settings.json manually:${NC}"
        echo '  "chat.agentSkillsLocations": { ".github/skills/**": true, ".claude/skills/**": true }'
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

    # Install Claude skills
    if [ -d "$SKILL_DIR" ]; then
        mkdir -p "$CLAUDE_DIR/skills/nextdocs"
        echo -e "${YELLOW}[Claude Code] Installing skill...${NC}"
        cp -r "$SKILL_DIR/"* "$CLAUDE_DIR/skills/nextdocs/"
        echo -e "${GREEN}[Claude Code] Done${NC}"
    fi

    # Install version file
    if [ -f "$VERSION_FILE" ]; then
        cp "$VERSION_FILE" "$CLAUDE_DIR/nextdocs.version"
        echo -e "${GREEN}[Version] Installed v$(cat "$VERSION_FILE" | tr -d '\n')${NC}"
    fi

    echo ""
    echo -e "${GRAY}[Copilot] Skipped - Copilot skills require per-project installation${NC}"

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

    # Install Claude skill
    if [ -d "$SKILL_DIR" ]; then
        mkdir -p "$CLAUDE_DIR/skills/nextdocs"
        echo -e "${YELLOW}[Claude Code] Installing skill...${NC}"
        cp -r "$SKILL_DIR/"* "$CLAUDE_DIR/skills/nextdocs/"
        echo -e "${GREEN}[Claude Code] Done${NC}"
    fi

    # Install Copilot skill (GitHub Copilot format)
    if [ -d "$SKILL_DIR" ]; then
        mkdir -p "$GITHUB_DIR/skills/nextdocs"
        echo -e "${YELLOW}[Copilot] Installing skill...${NC}"
        cp -r "$SKILL_DIR/"* "$GITHUB_DIR/skills/nextdocs/"
        echo -e "${GREEN}[Copilot] Done${NC}"
    fi

    # Update VS Code settings
    update_vscode_settings "$TARGET"

    # Install version file
    if [ -f "$VERSION_FILE" ]; then
        cp "$VERSION_FILE" "$CLAUDE_DIR/nextdocs.version"
        echo -e "${GREEN}[Version] Installed v$(cat "$VERSION_FILE" | tr -d '\n')${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${CYAN}Usage:${NC}"
echo "  Claude Code: Type /nextdocs"
if [ "$GLOBAL" = false ]; then
    echo "  Copilot:     Type /nextdocs or ask 'help me create documentation'"
fi
echo ""
echo -e "${CYAN}Installed files:${NC}"
if [ "$GLOBAL" = true ]; then
    echo "  ~/.claude/commands/nextdocs.md       (slash command)"
    echo "  ~/.claude/nextdocs-conventions.md    (conventions)"
    echo "  ~/.claude/skills/nextdocs/SKILL.md   (skill definition)"
    echo "  ~/.claude/nextdocs.version           (version tracker)"
else
    echo "  .claude/commands/nextdocs.md         (slash command)"
    echo "  .claude/nextdocs-conventions.md      (conventions)"
    echo "  .claude/skills/nextdocs/SKILL.md     (Claude skill)"
    echo "  .github/skills/nextdocs/SKILL.md     (Copilot skill)"
    echo "  .vscode/settings.json                (skills enabled)"
fi
echo ""
