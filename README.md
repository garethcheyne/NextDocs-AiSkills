# NextDocs AI Skills

AI assistant skills for creating documentation following NextDocs conventions.

**Works with Claude Code and GitHub Copilot.**

**No server. No dependencies. Just markdown files.**

---

## Supported Tools

| Tool | How It Works |
|------|--------------|
| **Claude Code** | `/nextdocs` slash command |
| **GitHub Copilot** | `.github/copilot-instructions.md` |

---

## Installation Options

### Option 1: Global Install (Recommended)

Install once, available in **all projects**.

#### Windows (PowerShell)

```powershell
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\scripts\install.ps1" -Global; Remove-Item -Recurse -Force $t
```

#### Mac/Linux/Git Bash

```bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/scripts/install.sh" --global && rm -rf "$t"
```

#### What it installs

| Tool | Location | Scope |
|------|----------|-------|
| Claude Code | `~/.claude/commands/nextdocs.md` | All projects |

> **Note:** GitHub Copilot doesn't support global instructions - use per-project install for Copilot.

---

### Option 2: Per-Project Install

Install in a specific project only.

#### Windows (PowerShell)

```powershell
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\scripts\install.ps1"; Remove-Item -Recurse -Force $t
```

#### Mac/Linux/Git Bash

```bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/scripts/install.sh" && rm -rf "$t"
```

#### What it installs

| Tool | Location |
|------|----------|
| Claude Code | `.claude/commands/nextdocs.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |

---

## Usage

### Claude Code

Type the slash command:

```
/nextdocs
```

### GitHub Copilot

Just ask naturally:
- "Help me create documentation for this project"
- "Set up NextDocs documentation"
- "Document this API"

Both assistants will:
1. Ask where to put documentation
2. Analyze your project
3. Propose a documentation structure
4. Create the files after your approval

---

## Manual Installation

### Claude Code (Global)

```bash
# Mac/Linux
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/nextdocs.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/nextdocs.md
```

```powershell
# Windows
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\commands"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/nextdocs.md" -OutFile "$env:USERPROFILE\.claude\commands\nextdocs.md"
```

### Claude Code (Per-Project)

```bash
mkdir -p .claude/commands
curl -o .claude/commands/nextdocs.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/nextdocs.md
```

### GitHub Copilot (Per-Project Only)

```bash
mkdir -p .github
curl -o .github/copilot-instructions.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/copilot-instructions.md
```

---

## What's Included

| File | Purpose |
|------|---------|
| `nextdocs.md` | Claude Code slash command |
| `copilot-instructions.md` | GitHub Copilot instructions |
| `AI_GUIDE.md` | Full reference guide (optional) |
| `scripts/install.ps1` | Windows installer |
| `scripts/install.sh` | Mac/Linux installer |

---

## NextDocs Conventions Summary

- **File naming**: lowercase-with-hyphens
- **_meta.json**: Navigation config (never include "index")
- **Frontmatter**: `title`, `excerpt` recommended
- **Icons**: Lucide icon names (Rocket, Book, Code, etc.)

See `AI_GUIDE.md` for complete conventions.

---

## Links

- [GitHub](https://github.com/garethcheyne/NextDocs-AiSkills)
- [Azure DevOps](https://dev.azure.com/harveynorman/HN%20Commercial%20Division/_git/NextDocs-AiSkills)
- [Lucide Icons](https://lucide.dev/icons)
