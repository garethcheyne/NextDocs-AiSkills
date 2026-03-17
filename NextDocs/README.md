# NextDocs AI Skills

AI assistant skills for creating documentation following NextDocs conventions.

**Works with Claude Code and GitHub Copilot.**

**No servers. No dependencies. Just markdown files.**

---

## How It Works

| Tool | Mechanism |
|------|-----------|
| **Claude Code** | `/nextdocs` slash command reads `nextdocs-conventions.md` |
| **GitHub Copilot** | Reference in `copilot-instructions.md` points to `nextdocs-conventions.md` |

Both tools read the same conventions file - one source of truth.

---

## Safe Installation

The installer **never overwrites** your existing settings:

- **Claude Code**: Installs a new slash command file (doesn't touch other commands)
- **Copilot**: Adds a small reference to existing `copilot-instructions.md` (preserves your content)
- **Conventions**: Installed as a separate file that both tools reference

---

## Installation

### Global Install (Recommended for Claude Code)

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

> **Note:** Copilot requires per-project installation.

---

### Per-Project Install

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
| Conventions (Claude) | `.claude/nextdocs-conventions.md` |
| Conventions (Copilot) | `.github/nextdocs-conventions.md` |
| Copilot reference | `.github/copilot-instructions.md` (appended) |

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
1. Confirm the project directory
2. Ask where to put documentation
3. Analyze your project
4. Propose a documentation structure
5. Create the files after your approval

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
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/nextdocs.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs.md
curl -o ~/.claude/nextdocs-conventions.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs-conventions.md
```

```powershell
# Windows
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\commands"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs.md" -OutFile "$env:USERPROFILE\.claude\commands\nextdocs.md"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs-conventions.md" -OutFile "$env:USERPROFILE\.claude\nextdocs-conventions.md"
```

### GitHub Copilot (Per-Project)

```bash
mkdir -p .github
curl -o .github/nextdocs-conventions.md https://raw.githubusercontent.com/garethcheyne/NextDocs-AiSkills/main/NextDocs/nextdocs-conventions.md
```

Then add this to your `.github/copilot-instructions.md`:

```markdown
## NextDocs Documentation

When creating or modifying documentation, read and follow the conventions in `.github/nextdocs-conventions.md`.
```

---

## What's Included

```
NextDocs/
├── nextdocs.md                # Claude Code slash command
├── nextdocs-conventions.md    # Documentation conventions (shared)
├── copilot-instructions.md    # Small reference snippet for Copilot
└── scripts/
    ├── install.ps1            # Windows installer
    ├── install.sh             # Mac/Linux installer
    ├── update.ps1             # Windows updater
    └── update.sh              # Mac/Linux updater
```

---

## NextDocs Conventions Summary

- **File naming**: lowercase-with-hyphens
- **_meta.json**: Navigation config (never include "index")
- **Frontmatter**: `title`, `excerpt` recommended
- **Icons**: Lucide icon names (Rocket, Book, Code, etc.)

See `NextDocs/nextdocs-conventions.md` for complete conventions.

---

## Links

- [GitHub](https://github.com/garethcheyne/NextDocs-AiSkills)
- [Azure DevOps](https://dev.azure.com/harveynorman/HN%20Commercial%20Division/_git/NextDocs-AiSkills)
- [Lucide Icons](https://lucide.dev/icons)
