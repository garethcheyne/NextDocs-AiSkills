# NextDocs AI Skills Installer
# Installs slash command for Claude Code + instructions for GitHub Copilot

param(
    [switch]$Global,
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

# Markers for Copilot instructions
$MarkerStart = "<!-- NEXTDOCS-AI-SKILLS-START -->"
$MarkerEnd = "<!-- NEXTDOCS-AI-SKILLS-END -->"

# Find source files
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ClaudeCommand = Join-Path $RepoRoot "nextdocs.md"
$Conventions = Join-Path $RepoRoot "nextdocs-conventions.md"
$CopilotSnippet = Join-Path $RepoRoot "copilot-instructions.md"
$VersionFile = Join-Path $RepoRoot "VERSION"

# Function to install Copilot snippet (append or update)
function Install-CopilotSnippet {
    param(
        [string]$TargetFile,
        [string]$SourceFile
    )

    $TargetDir = Split-Path -Parent $TargetFile

    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    $SourceContent = Get-Content -Path $SourceFile -Raw

    if (Test-Path $TargetFile) {
        $ExistingContent = Get-Content -Path $TargetFile -Raw

        if ($ExistingContent -match [regex]::Escape($MarkerStart)) {
            # Our section exists - replace it
            Write-Host "[Copilot] Updating existing NextDocs reference..." -ForegroundColor Yellow

            # Use regex to replace the section between markers
            $Pattern = "(?s)$([regex]::Escape($MarkerStart)).*?$([regex]::Escape($MarkerEnd))"
            $NewContent = $ExistingContent -replace $Pattern, $SourceContent.TrimEnd()

            Set-Content -Path $TargetFile -Value $NewContent -NoNewline
            Write-Host "[Copilot] Updated" -ForegroundColor Green
        }
        else {
            # File exists but doesn't have our section - append
            Write-Host "[Copilot] Adding NextDocs reference to existing file..." -ForegroundColor Yellow

            $CombinedContent = $ExistingContent.TrimEnd() + "`n`n" + $SourceContent
            Set-Content -Path $TargetFile -Value $CombinedContent -NoNewline

            Write-Host "[Copilot] Added" -ForegroundColor Green
        }
    }
    else {
        # File doesn't exist - create it
        Write-Host "[Copilot] Creating copilot-instructions.md..." -ForegroundColor Yellow
        Copy-Item -Path $SourceFile -Destination $TargetFile -Force
        Write-Host "[Copilot] Done" -ForegroundColor Green
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

    # Install version file
    if (Test-Path $VersionFile) {
        $Ver = (Get-Content $VersionFile -Raw).Trim()
        Copy-Item -Path $VersionFile -Destination (Join-Path $ClaudeDir "nextdocs.version") -Force
        Write-Host "[Version] Installed v$Ver" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "[Copilot] Skipped - Copilot requires per-project installation" -ForegroundColor DarkGray

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

    # Install conventions file for Copilot
    if (Test-Path $Conventions) {
        if (-not (Test-Path $GitHubDir)) {
            New-Item -ItemType Directory -Path $GitHubDir -Force | Out-Null
        }

        Write-Host "[Copilot] Installing conventions..." -ForegroundColor Yellow
        Copy-Item -Path $Conventions -Destination (Join-Path $GitHubDir "nextdocs-conventions.md") -Force
        Write-Host "[Copilot] Done" -ForegroundColor Green
    }

    # Install Copilot snippet (smart merge)
    if (Test-Path $CopilotSnippet) {
        $CopilotTarget = Join-Path $GitHubDir "copilot-instructions.md"
        Install-CopilotSnippet -TargetFile $CopilotTarget -SourceFile $CopilotSnippet
    }

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
    Write-Host "  Copilot:     Ask 'help me create documentation'"
}
Write-Host ""
Write-Host "Installed files:" -ForegroundColor Cyan
if ($Global) {
    Write-Host "  ~/.claude/commands/nextdocs.md     (slash command)"
    Write-Host "  ~/.claude/nextdocs-conventions.md  (conventions)"
    Write-Host "  ~/.claude/nextdocs.version         (version tracker)"
} else {
    Write-Host "  .claude/commands/nextdocs.md       (slash command)"
    Write-Host "  .claude/nextdocs-conventions.md    (conventions)"
    Write-Host "  .claude/nextdocs.version           (version tracker)"
    Write-Host "  .github/nextdocs-conventions.md    (conventions)"
    Write-Host "  .github/copilot-instructions.md    (reference added)"
}
Write-Host ""
