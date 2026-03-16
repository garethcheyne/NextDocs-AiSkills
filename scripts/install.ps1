# NextDocs AI Skills Installer
# Installs slash command for Claude Code + instructions for GitHub Copilot

param(
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

# Find source files
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ClaudeSource = Join-Path $RepoRoot "nextdocs.md"
$CopilotSource = Join-Path $RepoRoot "copilot-instructions.md"

Write-Host ""
Write-Host "NextDocs AI Skills Installer" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

# Install Claude Code slash command
if (Test-Path $ClaudeSource) {
    $ClaudeDir = Join-Path $Target ".claude\commands"
    $ClaudeTarget = Join-Path $ClaudeDir "nextdocs.md"

    if (-not (Test-Path $ClaudeDir)) {
        New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
    }

    Write-Host "[Claude Code] Installing /nextdocs command..." -ForegroundColor Yellow
    Copy-Item -Path $ClaudeSource -Destination $ClaudeTarget -Force
    Write-Host "[Claude Code] Done" -ForegroundColor Green
}

# Install GitHub Copilot instructions
if (Test-Path $CopilotSource) {
    $CopilotDir = Join-Path $Target ".github"
    $CopilotTarget = Join-Path $CopilotDir "copilot-instructions.md"

    if (-not (Test-Path $CopilotDir)) {
        New-Item -ItemType Directory -Path $CopilotDir -Force | Out-Null
    }

    Write-Host "[Copilot] Installing instructions..." -ForegroundColor Yellow
    Copy-Item -Path $CopilotSource -Destination $CopilotTarget -Force
    Write-Host "[Copilot] Done" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor Cyan
Write-Host "  Claude Code: Type /nextdocs"
Write-Host "  Copilot:     Ask 'help me create documentation'"
Write-Host ""
