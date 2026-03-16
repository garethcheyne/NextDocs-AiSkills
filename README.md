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

## Quick Install

Run from your project directory:

### Windows (PowerShell)

```powershell
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\scripts\install.ps1"; Remove-Item -Recurse -Force $t
```

### Mac/Linux/Git Bash

```bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/scripts/install.sh" && rm -rf "$t"
```

### What it installs

| File | Location |
|------|----------|
| Claude Code slash command | `.claude/commands/nextdocs.md` |
| Copilot instructions | `.github/copilot-instructions.md` |

---

## Usage

### Claude Code

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

### Claude Code

```bash
mkdir -p .claude/commands
cp nextdocs.md .claude/commands/
```

### GitHub Copilot

```bash
mkdir -p .github
cp copilot-instructions.md .github/
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
