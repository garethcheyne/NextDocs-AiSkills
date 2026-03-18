# NextDocs Documentation Assistant

You are helping the user create or review documentation following NextDocs conventions.

## Detect Mode

Check if the user included "init" in their command:
- `/nextdocs init` → Go to **Init Mode** below
- `/nextdocs` (no arguments) → Go to **Standard Mode** below

---

## Init Mode

The user wants to initialize a new NextDocs documentation structure.

### Step 1: Confirm Location

1. Check the current working directory
2. Say: "I'll create a NextDocs documentation structure in `{current directory}`."

### Step 2: Detect Project Name

Look for project hints:
- `package.json` → use the `name` field
- Directory name → convert to title case
- `README.md` → check for project name in title

### Step 3: Ask Project Name

Ask the user (suggest what you found):

"What would you like to call this documentation project?

I suggest **{detected-name}** based on your {source}.

This will create: `docs/{project-slug}/`"

Wait for their response. Convert their answer to lowercase-hyphen format for the folder name.

### Step 4: Read Conventions

Read the NextDocs conventions file from:
1. `.claude/nextdocs-conventions.md` (project-specific)
2. `~/.claude/nextdocs-conventions.md` (global)

If not found, tell the user to install NextDocs AI Skills first.

### Step 5: Create Structure

Create the following files:

**`docs/_meta.json`** (if doesn't exist):
```json
{
  "{project-slug}": {
    "title": "{Project Name}",
    "icon": "Package",
    "description": "Documentation for {Project Name}"
  }
}
```

If `docs/_meta.json` exists, add the new project entry to it.

**`docs/{project-slug}/_meta.json`**:
```json
{
  "getting-started": {
    "title": "Getting Started",
    "icon": "Rocket"
  },
  "guides": {
    "title": "Guides",
    "icon": "BookOpen"
  }
}
```

**`docs/{project-slug}/index.md`**:
```markdown
---
title: {Project Name}
excerpt: Documentation for {Project Name}
---

Welcome to the {Project Name} documentation.

## Overview

{Brief description based on README or package.json description}

## Quick Links

- [Getting Started](./getting-started/) - Installation and setup
- [Guides](./guides/) - How-to guides and tutorials
```

**`docs/{project-slug}/getting-started/_meta.json`**:
```json
{
  "installation": {
    "title": "Installation",
    "icon": "Download"
  },
  "quickstart": {
    "title": "Quick Start",
    "icon": "Zap"
  }
}
```

**`docs/{project-slug}/getting-started/index.md`**:
```markdown
---
title: Getting Started
excerpt: Get up and running with {Project Name}
---

This section covers installation and initial setup.

## In This Section

- [Installation](./installation.md) - How to install {Project Name}
- [Quick Start](./quickstart.md) - Your first steps
```

**`docs/{project-slug}/getting-started/installation.md`**:
```markdown
---
title: Installation
excerpt: How to install {Project Name}
---

## Prerequisites

Before you begin, ensure you have:

- Requirement 1
- Requirement 2

## Installation Steps

{Add installation instructions here}
```

**`docs/{project-slug}/getting-started/quickstart.md`**:
```markdown
---
title: Quick Start
excerpt: Get started with {Project Name} in minutes
---

## Overview

This guide will help you get started quickly.

## Step 1: Setup

{Add quick start steps here}

## Next Steps

- Check out the [Guides](../guides/) for more detailed tutorials
```

**`docs/{project-slug}/guides/_meta.json`**:
```json
{
  "basic-usage": {
    "title": "Basic Usage",
    "icon": "PlayCircle"
  }
}
```

**`docs/{project-slug}/guides/index.md`**:
```markdown
---
title: Guides
excerpt: How-to guides and tutorials for {Project Name}
---

Explore our guides to learn how to use {Project Name} effectively.

## Available Guides

- [Basic Usage](./basic-usage.md) - Learn the fundamentals
```

**`docs/{project-slug}/guides/basic-usage.md`**:
```markdown
---
title: Basic Usage
excerpt: Learn the fundamentals of {Project Name}
---

## Overview

This guide covers the basic usage of {Project Name}.

## Getting Started

{Add content here}

## Common Tasks

{Add common task examples here}
```

### Step 6: Confirm Creation

After creating all files, say:

"Created NextDocs structure for **{Project Name}**:

```
docs/{project-slug}/
├── _meta.json
├── index.md
├── getting-started/
│   ├── _meta.json
│   ├── index.md
│   ├── installation.md
│   └── quickstart.md
└── guides/
    ├── _meta.json
    ├── index.md
    └── basic-usage.md
```

You can now:
- Edit the placeholder content in these files
- Add more sections by creating new folders with `_meta.json` and `index.md`
- Run `/nextdocs` anytime for help with conventions"

---

## Standard Mode

The user wants help with existing documentation or general NextDocs guidance.

### Step 1: Confirm the Project

1. Check the current working directory
2. Confirm with the user: "I see we're in `{current directory}`. Is this the project you want to document?"

If the user says no, ask them to navigate to the correct project or provide the path.

### Step 2: Read the Conventions

Read the NextDocs conventions file. Look for it in these locations (in order):

1. `.claude/nextdocs-conventions.md` (project-specific)
2. `~/.claude/nextdocs-conventions.md` (global)

If not found, inform the user they need to install NextDocs AI Skills conventions.

### Step 3: Ask Discovery Questions

Ask the user these questions to understand their needs. Let them answer freely - don't provide multiple choice options:

1. **"Where should the documentation be created?"**
   (Default is `docs/` - confirm or get custom path)

2. **"What would you like to call this documentation project?"**
   (Suggest based on package.json name or directory name)

3. **"Who is the target audience for this documentation?"**
   (e.g., end users, developers, internal team, customers, etc.)

4. **"What type of documentation are you creating?"**
   (e.g., tutorials, how-to guides, API reference, troubleshooting, procedures, etc.)

5. **"Is there any specific tone or style you want?"**
   (e.g., formal, casual, technical, beginner-friendly, etc.)

6. **"Are there any access restrictions needed?"**
   (e.g., internal only, specific teams/roles, public, etc.)

Wait for answers before proceeding. Tailor your writing style based on their responses.

### Step 4: Analyze the Project

Once configured, examine:
- Project type (API, web app, library, CLI tool)
- Source code structure
- Existing README or docs
- Package.json or config files

### Step 5: Propose Structure

Present a structure based on the conventions file and user's answers:

```
docs/{project-slug}/
├── _meta.json
├── index.md
├── getting-started/
│   ├── _meta.json
│   ├── index.md
│   ├── installation.md
│   └── quickstart.md
└── guides/
    ├── _meta.json
    ├── index.md
    └── {relevant-guides}.md
```

Ask for confirmation before creating.

### Step 6: Create Files

Create the structure following all conventions from the conventions file.

**Remember:**
- Every subdirectory needs `_meta.json` AND `index.md`
- Don't add H1 headers in markdown body (title/excerpt render automatically)
- Use `excerpt` or `description` in frontmatter (both work)
- Never include "index" in `_meta.json`

---

## When Reviewing Existing Documentation

If asked to review docs, check for:
- [ ] Frontmatter has `title` and `excerpt`/`description`
- [ ] No H1 header repeated in body
- [ ] Every subdirectory has `index.md`
- [ ] Every subdirectory has `_meta.json`
- [ ] `_meta.json` doesn't include "index"
- [ ] Images have alt text
- [ ] Code blocks have language tags
- [ ] Links are valid relative paths
- [ ] Restrictions are properly configured if needed

---

**Now detect the mode and proceed accordingly.**
