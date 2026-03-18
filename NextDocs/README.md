# NextDocs AI Skills

AI assistant skills for creating documentation following NextDocs conventions.

**Works with Claude Code and GitHub Copilot.**

**No servers. No dependencies. Just markdown files.**

---

## How It Works

| Tool | Mechanism |
|------|-----------|
| **Claude Code** | Skill in `.claude/skills/nextdocs/` + `/nextdocs` slash command |
| **GitHub Copilot** | Skill in `.github/skills/nextdocs/` (VS Code Copilot Chat) |

Both tools use the same skill definition - one source of truth.

---

## Safe Installation

The installer **never overwrites** your existing settings:

- **Skills**: Installed to dedicated directories (doesn't touch other skills)
- **VS Code**: Adds skill locations to `settings.json` (preserves your settings)
- **Claude Code**: Installs slash command (doesn't touch other commands)

---

## Installation

### Global Install (Claude Code Only)

Install once, available in **all projects**.

**Windows (PowerShell):**

```powershell
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\NextDocs\scripts\install.ps1" -Global; Remove-Item -Recurse -Force $t
```

**Mac/Linux/Git Bash:**

```bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/NextDocs/scripts/install.sh" --global && rm -rf "$t"
```

**What it installs:**

| File | Location |
|------|----------|
| Slash command | `~/.claude/commands/nextdocs.md` |
| Conventions | `~/.claude/nextdocs-conventions.md` |
| Skill | `~/.claude/skills/nextdocs/SKILL.md` |
| Version tracker | `~/.claude/nextdocs.version` |

> **Note:** Copilot skills require per-project installation.

---

### Per-Project Install (Recommended)

Install in a specific project (supports both Claude Code and Copilot).

**Windows (PowerShell):**

```powershell
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\NextDocs\scripts\install.ps1"; Remove-Item -Recurse -Force $t
```

**Mac/Linux/Git Bash:**

```bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/NextDocs/scripts/install.sh" && rm -rf "$t"
```

**What it installs:**

| File | Location |
|------|----------|
| Slash command | `.claude/commands/nextdocs.md` |
| Conventions | `.claude/nextdocs-conventions.md` |
| Claude skill | `.claude/skills/nextdocs/SKILL.md` |
| Copilot skill | `.github/skills/nextdocs/SKILL.md` |
| VS Code settings | `.vscode/settings.json` (skill locations) |
| Version tracker | `.claude/nextdocs.version` |

---

## Usage

### Claude Code

Use the slash command or invoke the skill:

```
/nextdocs
```

Or use the skill directly:
- Type `/nextdocs init` to initialize documentation
- Type `/nextdocs review` to review existing docs
- Type `/nextdocs create page` to create a new page

### GitHub Copilot (VS Code)

In Copilot Chat, just ask naturally:
- "Help me create documentation for this project"
- "Set up NextDocs documentation"
- "Document this API"
- "@workspace /nextdocs init"

Both assistants will:
1. Confirm the project directory
2. Ask where to put documentation
3. Analyze your project
4. Propose a documentation structure
5. Create the files after your approval

---

## VS Code Configuration

The installer automatically adds skill locations to `.vscode/settings.json`:

```json
{
  "chat.agentSkillsLocations": {
    ".github/skills/**": true,
    ".claude/skills/**": true
  }
}
```

This enables both Copilot and Claude Code to discover skills in your project.

---

## Updating

To update an existing installation with the latest files:

**Global:**

```bash
# Mac/Linux/Git Bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/NextDocs/scripts/update.sh" --global && rm -rf "$t"
```

```powershell
# Windows
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\NextDocs\scripts\update.ps1" -Global; Remove-Item -Recurse -Force $t
```

**Per-Project:**

```bash
# Mac/Linux/Git Bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/NextDocs/scripts/update.sh" && rm -rf "$t"
```

```powershell
# Windows
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\NextDocs\scripts\update.ps1"; Remove-Item -Recurse -Force $t
```

---

## Manual Installation

### Claude Code (Global)

```bash
# Mac/Linux
mkdir -p ~/.claude/commands ~/.claude/skills/nextdocs
curl -o ~/.claude/commands/nextdocs.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs.md
curl -o ~/.claude/nextdocs-conventions.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs-conventions.md
curl -o ~/.claude/skills/nextdocs/SKILL.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/skills/nextdocs/SKILL.md
```

```powershell
# Windows
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\commands"
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills\nextdocs"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs.md" -OutFile "$env:USERPROFILE\.claude\commands\nextdocs.md"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs-conventions.md" -OutFile "$env:USERPROFILE\.claude\nextdocs-conventions.md"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/skills/nextdocs/SKILL.md" -OutFile "$env:USERPROFILE\.claude\skills\nextdocs\SKILL.md"
```

### GitHub Copilot (Per-Project)

```bash
mkdir -p .github/skills/nextdocs
curl -o .github/skills/nextdocs/SKILL.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/skills/nextdocs/SKILL.md
```

Then add to your `.vscode/settings.json`:

```json
{
  "chat.agentSkillsLocations": {
    ".github/skills/**": true
  }
}
```

---

## What's Included

```
NextDocs/
├── VERSION                      # Skill version (for update checking)
├── nextdocs.md                  # Claude Code slash command
├── nextdocs-conventions.md      # Documentation conventions (for slash command)
├── skills/
│   └── nextdocs/
│       └── SKILL.md             # Complete skill definition (Claude + Copilot)
└── scripts/
    ├── install.ps1              # Windows installer
    ├── install.sh               # Mac/Linux installer
    ├── update.ps1               # Windows updater
    └── update.sh                # Mac/Linux updater
```

---

## NextDocs Conventions Summary

- **File naming**: lowercase-with-hyphens
- **_meta.json**: Navigation config (never include "index")
- **Frontmatter**: `title`, `excerpt` recommended
- **Icons**: Lucide icon names (Rocket, Book, Code, etc.)

See `NextDocs/skills/nextdocs/SKILL.md` for complete conventions including blogs, authors, API specs, custom blocks, and more.

---

## Uninstall

### Global

**Mac/Linux/Git Bash:**
```bash
rm ~/.claude/commands/nextdocs.md
rm ~/.claude/nextdocs-conventions.md
rm ~/.claude/nextdocs.version
rm -rf ~/.claude/skills/nextdocs
```

**Windows (PowerShell):**
```powershell
Remove-Item "$env:USERPROFILE\.claude\commands\nextdocs.md" -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\.claude\nextdocs-conventions.md" -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\.claude\nextdocs.version" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude\skills\nextdocs" -ErrorAction SilentlyContinue
```

### Per-Project

```bash
rm -rf .claude/commands/nextdocs.md
rm -rf .claude/nextdocs-conventions.md
rm -rf .claude/nextdocs.version
rm -rf .claude/skills/nextdocs
rm -rf .github/skills/nextdocs
```

Then optionally remove the `chat.agentSkillsLocations` entries from `.vscode/settings.json`.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `/nextdocs` command not found | Run install with `--global` flag |
| Copilot doesn't see the skill | Check `.vscode/settings.json` has `chat.agentSkillsLocations` |
| Skill not found | Re-run the installer for your mode (global or per-project) |
| Update says "already up to date" | Use `--force` / `-Force` to update anyway |
| Permission denied (Mac/Linux) | Use `bash script.sh` instead of `./script.sh` |

---

## Links

- [GitHub](https://github.com/garethcheyne/NextDocs-AiSkills)
- [Azure DevOps](https://dev.azure.com/harveynorman/HN%20Commercial%20Division/_git/NextDocs-AiSkills)
- [Lucide Icons](https://lucide.dev/icons)
- [GitHub Copilot Skills Docs](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot)
