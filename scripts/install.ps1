# NextDocs Slash Command Installer
# Just copies nextdocs.md to .claude/commands/

param(
    [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

# Find source file
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceFile = Join-Path (Split-Path -Parent $ScriptDir) "nextdocs.md"

# Target paths
$TargetDir = Join-Path $Target ".claude\commands"
$TargetFile = Join-Path $TargetDir "nextdocs.md"

Write-Host ""
Write-Host "NextDocs Slash Command Installer" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check source exists
if (-not (Test-Path $SourceFile)) {
    Write-Host "Error: nextdocs.md not found" -ForegroundColor Red
    exit 1
}

# Create directory if needed
if (-not (Test-Path $TargetDir)) {
    Write-Host "Creating .claude/commands/..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

# Copy file
Write-Host "Installing slash command..." -ForegroundColor Yellow
Copy-Item -Path $SourceFile -Destination $TargetFile -Force

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""
Write-Host "Usage:" -ForegroundColor Cyan
Write-Host "  1. Restart Claude Code"
Write-Host "  2. Type: /nextdocs"
Write-Host ""
