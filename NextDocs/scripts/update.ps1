# NextDocs AI Skills Updater
# Updates existing installation with latest files

param(
    [switch]$Global
)

$ErrorActionPreference = "Stop"

# Find source files
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ClaudeCommand = Join-Path $RepoRoot "nextdocs.md"
$Conventions = Join-Path $RepoRoot "nextdocs-conventions.md"

Write-Host ""
Write-Host "NextDocs AI Skills Updater" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

$updated = 0

if ($Global) {
    Write-Host "Checking global installation..." -ForegroundColor Yellow
    Write-Host ""

    $ClaudeDir = Join-Path $env:USERPROFILE ".claude"

    # Update slash command
    $CommandFile = Join-Path $ClaudeDir "commands\nextdocs.md"
    if (Test-Path $CommandFile) {
        Copy-Item -Path $ClaudeCommand -Destination $CommandFile -Force
        Write-Host "[OK] Updated ~/.claude/commands/nextdocs.md" -ForegroundColor Green
        $updated++
    } else {
        Write-Host "[X] Not found: ~/.claude/commands/nextdocs.md" -ForegroundColor Red
    }

    # Update conventions
    $ConventionsFile = Join-Path $ClaudeDir "nextdocs-conventions.md"
    if (Test-Path $ConventionsFile) {
        Copy-Item -Path $Conventions -Destination $ConventionsFile -Force
        Write-Host "[OK] Updated ~/.claude/nextdocs-conventions.md" -ForegroundColor Green
        $updated++
    } else {
        Write-Host "[X] Not found: ~/.claude/nextdocs-conventions.md" -ForegroundColor Red
    }

} else {
    Write-Host "Checking project installation..." -ForegroundColor Yellow
    Write-Host ""

    $Target = (Get-Location).Path
    $ClaudeDir = Join-Path $Target ".claude"
    $GitHubDir = Join-Path $Target ".github"

    # Update Claude slash command
    $CommandFile = Join-Path $ClaudeDir "commands\nextdocs.md"
    if (Test-Path $CommandFile) {
        Copy-Item -Path $ClaudeCommand -Destination $CommandFile -Force
        Write-Host "[OK] Updated .claude/commands/nextdocs.md" -ForegroundColor Green
        $updated++
    } else {
        Write-Host "[X] Not found: .claude/commands/nextdocs.md" -ForegroundColor Red
    }

    # Update Claude conventions
    $ClaudeConventions = Join-Path $ClaudeDir "nextdocs-conventions.md"
    if (Test-Path $ClaudeConventions) {
        Copy-Item -Path $Conventions -Destination $ClaudeConventions -Force
        Write-Host "[OK] Updated .claude/nextdocs-conventions.md" -ForegroundColor Green
        $updated++
    } else {
        Write-Host "[X] Not found: .claude/nextdocs-conventions.md" -ForegroundColor Red
    }

    # Update Copilot conventions
    $CopilotConventions = Join-Path $GitHubDir "nextdocs-conventions.md"
    if (Test-Path $CopilotConventions) {
        Copy-Item -Path $Conventions -Destination $CopilotConventions -Force
        Write-Host "[OK] Updated .github/nextdocs-conventions.md" -ForegroundColor Green
        $updated++
    } else {
        Write-Host "[X] Not found: .github/nextdocs-conventions.md" -ForegroundColor Red
    }
}

Write-Host ""
if ($updated -gt 0) {
    Write-Host "Update complete! ($updated files updated)" -ForegroundColor Green
} else {
    Write-Host "No files found to update. Run install.ps1 first." -ForegroundColor Red
}
Write-Host ""
