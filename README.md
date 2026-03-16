# NextDocs Documentation Skill

A slash command for Claude Code that helps create documentation following NextDocs conventions.

**No server. No dependencies. Just a markdown file.**

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

### What it does

1. Creates `.claude/commands/` in your project (if needed)
2. Copies `nextdocs.md` slash command
3. That's it!

---

## Usage

After installation, restart Claude Code and type:

```
/nextdocs
```

The assistant will:
1. Ask where to put documentation
2. Analyze your project
3. Propose a documentation structure
4. Create the files after your approval

---

## Manual Installation

Just copy `nextdocs.md` to `.claude/commands/nextdocs.md` in your project.

```bash
mkdir -p .claude/commands
cp nextdocs.md .claude/commands/
```

---

## What's Included

| File | Purpose |
|------|---------|
| `nextdocs.md` | The slash command (this is all you need) |
| `AI_GUIDE.md` | Full reference guide (optional reading) |
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
