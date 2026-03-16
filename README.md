# AI Skills

A collection of AI assistant skills for Claude Code and GitHub Copilot.

**No servers. No dependencies. Just markdown files.**

---

## Available Skills

| Skill | Description |
|-------|-------------|
| [NextDocs](./NextDocs/) | Create documentation following NextDocs conventions |

---

## How Skills Work

Each skill provides instructions that help AI assistants understand specific conventions or tasks:

- **Claude Code**: Slash commands (e.g., `/nextdocs`)
- **GitHub Copilot**: Instructions via `.github/copilot-instructions.md`

---

## Installation

Each skill has its own installer. See the skill's README for details.

### Quick Install: NextDocs

**Global (Claude Code only):**

```bash
# Mac/Linux/Git Bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/NextDocs/scripts/install.sh" --global && rm -rf "$t"
```

```powershell
# Windows
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\NextDocs\scripts\install.ps1" -Global; Remove-Item -Recurse -Force $t
```

**Per-Project (Claude Code + Copilot):**

```bash
# Mac/Linux/Git Bash
t=$(mktemp -d) && git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" "$t" && bash "$t/NextDocs/scripts/install.sh" && rm -rf "$t"
```

```powershell
# Windows
$t="$env:TEMP\nd-$(Get-Random)"; git clone --depth 1 "https://github.com/garethcheyne/NextDocs-AiSkills" $t; & "$t\NextDocs\scripts\install.ps1"; Remove-Item -Recurse -Force $t
```

---

## Links

- [GitHub](https://github.com/garethcheyne/NextDocs-AiSkills)
- [Azure DevOps](https://dev.azure.com/harveynorman/HN%20Commercial%20Division/_git/NextDocs-AiSkills)
