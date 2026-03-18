# NextDocs AI Skills Installer
# Installs skills for Claude Code and GitHub Copilot

param(
    [switch]$Global,
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

# Find source files
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ClaudeCommand = Join-Path $RepoRoot "nextdocs.md"
$Conventions = Join-Path $RepoRoot "nextdocs-conventions.md"
$SkillDir = Join-Path $RepoRoot "skills\nextdocs"
$VersionFile = Join-Path $RepoRoot "VERSION"

# Function to update VS Code settings.json
function Update-VSCodeSettings {
    param([string]$TargetDir)

    $VSCodeDir = Join-Path $TargetDir ".vscode"
    $SettingsFile = Join-Path $VSCodeDir "settings.json"

    if (-not (Test-Path $VSCodeDir)) {
        New-Item -ItemType Directory -Path $VSCodeDir -Force | Out-Null
    }

    if (Test-Path $SettingsFile) {
        $Content = Get-Content -Path $SettingsFile -Raw
        if ($Content -match "chat\.agentSkillsLocations") {
            Write-Host "[VS Code] Skills location already configured" -ForegroundColor DarkGray
        } else {
            Write-Host "[VS Code] Adding skill locations to settings.json..." -ForegroundColor Yellow
            try {
                $Settings = $Content | ConvertFrom-Json
                $Settings | Add-Member -NotePropertyName "chat.agentSkillsLocations" -NotePropertyValue @{
                    ".github/skills/**" = $true
                    ".claude/skills/**" = $true
                } -Force
                $Settings | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile
                Write-Host "[VS Code] Done" -ForegroundColor Green
            } catch {
                Write-Host "[VS Code] Add this to settings.json manually:" -ForegroundColor Yellow
                Write-Host '  "chat.agentSkillsLocations": { ".github/skills/**": true, ".claude/skills/**": true }'
            }
        }
    } else {
        Write-Host "[VS Code] Creating settings.json with skill locations..." -ForegroundColor Yellow
        $NewSettings = @{
            "chat.agentSkillsLocations" = @{
                ".github/skills/**" = $true
                ".claude/skills/**" = $true
            }
        }
        $NewSettings | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile
        Write-Host "[VS Code] Done" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "NextDocs AI Skills Installer" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

if ($Global) {
    Write-Host "Mode: Global (all projects)" -ForegroundColor Magenta
    Write-Host ""

    $ClaudeDir = Join-Path $env:USERPROFILE ".claude"

    # Install Claude Code slash command
    if (Test-Path $ClaudeCommand) {
        $CommandsDir = Join-Path $ClaudeDir "commands"
        if (-not (Test-Path $CommandsDir)) {
            New-Item -ItemType Directory -Path $CommandsDir -Force | Out-Null
        }

        Write-Host "[Claude Code] Installing /nextdocs command..." -ForegroundColor Yellow
        Copy-Item -Path $ClaudeCommand -Destination (Join-Path $CommandsDir "nextdocs.md") -Force
        Write-Host "[Claude Code] Done" -ForegroundColor Green
    }

    # Install conventions file
    if (Test-Path $Conventions) {
        if (-not (Test-Path $ClaudeDir)) {
            New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
        }

        Write-Host "[Claude Code] Installing conventions..." -ForegroundColor Yellow
        Copy-Item -Path $Conventions -Destination (Join-Path $ClaudeDir "nextdocs-conventions.md") -Force
        Write-Host "[Claude Code] Done" -ForegroundColor Green
    }

    # Install Claude skills
    if (Test-Path $SkillDir) {
        $SkillsTarget = Join-Path $ClaudeDir "skills\nextdocs"
        if (-not (Test-Path $SkillsTarget)) {
            New-Item -ItemType Directory -Path $SkillsTarget -Force | Out-Null
        }

        Write-Host "[Claude Code] Installing skill..." -ForegroundColor Yellow
        Copy-Item -Path (Join-Path $SkillDir "*") -Destination $SkillsTarget -Recurse -Force
        Write-Host "[Claude Code] Done" -ForegroundColor Green
    }

    # Install version file
    if (Test-Path $VersionFile) {
        $Ver = (Get-Content $VersionFile -Raw).Trim()
        Copy-Item -Path $VersionFile -Destination (Join-Path $ClaudeDir "nextdocs.version") -Force
        Write-Host "[Version] Installed v$Ver" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "[Copilot] Skipped - Copilot skills require per-project installation" -ForegroundColor DarkGray

} else {
    Write-Host "Mode: Per-project" -ForegroundColor Magenta
    Write-Host ""

    $ClaudeDir = Join-Path $Target ".claude"
    $GitHubDir = Join-Path $Target ".github"

    # Install Claude Code slash command
    if (Test-Path $ClaudeCommand) {
        $CommandsDir = Join-Path $ClaudeDir "commands"
        if (-not (Test-Path $CommandsDir)) {
            New-Item -ItemType Directory -Path $CommandsDir -Force | Out-Null
        }

        Write-Host "[Claude Code] Installing /nextdocs command..." -ForegroundColor Yellow
        Copy-Item -Path $ClaudeCommand -Destination (Join-Path $CommandsDir "nextdocs.md") -Force
        Write-Host "[Claude Code] Done" -ForegroundColor Green
    }

    # Install conventions file for Claude
    if (Test-Path $Conventions) {
        if (-not (Test-Path $ClaudeDir)) {
            New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
        }

        Write-Host "[Claude Code] Installing conventions..." -ForegroundColor Yellow
        Copy-Item -Path $Conventions -Destination (Join-Path $ClaudeDir "nextdocs-conventions.md") -Force
        Write-Host "[Claude Code] Done" -ForegroundColor Green
    }

    # Install Claude skill
    if (Test-Path $SkillDir) {
        $ClaudeSkillTarget = Join-Path $ClaudeDir "skills\nextdocs"
        if (-not (Test-Path $ClaudeSkillTarget)) {
            New-Item -ItemType Directory -Path $ClaudeSkillTarget -Force | Out-Null
        }

        Write-Host "[Claude Code] Installing skill..." -ForegroundColor Yellow
        Copy-Item -Path (Join-Path $SkillDir "*") -Destination $ClaudeSkillTarget -Recurse -Force
        Write-Host "[Claude Code] Done" -ForegroundColor Green
    }

    # Install Copilot skill (GitHub Copilot format)
    if (Test-Path $SkillDir) {
        $CopilotSkillTarget = Join-Path $GitHubDir "skills\nextdocs"
        if (-not (Test-Path $CopilotSkillTarget)) {
            New-Item -ItemType Directory -Path $CopilotSkillTarget -Force | Out-Null
        }

        Write-Host "[Copilot] Installing skill..." -ForegroundColor Yellow
        Copy-Item -Path (Join-Path $SkillDir "*") -Destination $CopilotSkillTarget -Recurse -Force
        Write-Host "[Copilot] Done" -ForegroundColor Green
    }

    # Update VS Code settings
    Update-VSCodeSettings -TargetDir $Target

    # Install version file
    if (Test-Path $VersionFile) {
        $Ver = (Get-Content $VersionFile -Raw).Trim()
        Copy-Item -Path $VersionFile -Destination (Join-Path $ClaudeDir "nextdocs.version") -Force
        Write-Host "[Version] Installed v$Ver" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor Cyan
Write-Host "  Claude Code: Type /nextdocs"
if (-not $Global) {
    Write-Host "  Copilot:     Type /nextdocs or ask 'help me create documentation'"
}
Write-Host ""
Write-Host "Installed files:" -ForegroundColor Cyan
if ($Global) {
    Write-Host "  ~/.claude/commands/nextdocs.md       (slash command)"
    Write-Host "  ~/.claude/nextdocs-conventions.md    (conventions)"
    Write-Host "  ~/.claude/skills/nextdocs/SKILL.md   (skill definition)"
    Write-Host "  ~/.claude/nextdocs.version           (version tracker)"
} else {
    Write-Host "  .claude/commands/nextdocs.md         (slash command)"
    Write-Host "  .claude/nextdocs-conventions.md      (conventions)"
    Write-Host "  .claude/skills/nextdocs/SKILL.md     (Claude skill)"
    Write-Host "  .github/skills/nextdocs/SKILL.md     (Copilot skill)"
    Write-Host "  .vscode/settings.json                (skills enabled)"
}
Write-Host ""
