# NextDocs AI Skills Updater
# Updates existing installation with latest files (with version checking)

param(
    [switch]$Global,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Find source files
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ClaudeCommand = Join-Path $RepoRoot "nextdocs.md"
$Conventions = Join-Path $RepoRoot "nextdocs-conventions.md"
$CopilotSnippet = Join-Path $RepoRoot "copilot-instructions.md"
$VersionFile = Join-Path $RepoRoot "VERSION"

# Markers for Copilot instructions
$MarkerStart = "<!-- NEXTDOCS-AI-SKILLS-START -->"
$MarkerEnd = "<!-- NEXTDOCS-AI-SKILLS-END -->"

# Function to update Copilot snippet (replace marker block)
function Update-CopilotSnippet {
    param(
        [string]$TargetFile,
        [string]$SourceFile
    )

    if (-not (Test-Path $TargetFile)) { return $false }

    $ExistingContent = Get-Content -Path $TargetFile -Raw
    if ($ExistingContent -match [regex]::Escape($MarkerStart)) {
        $SourceContent = Get-Content -Path $SourceFile -Raw
        $Pattern = "(?s)$([regex]::Escape($MarkerStart)).*?$([regex]::Escape($MarkerEnd))"
        $NewContent = $ExistingContent -replace $Pattern, $SourceContent.TrimEnd()
        Set-Content -Path $TargetFile -Value $NewContent -NoNewline
        return $true
    }

    return $false
}

Write-Host ""
Write-Host "NextDocs AI Skills Updater" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

# Read source version
if (-not (Test-Path $VersionFile)) {
    Write-Host "Error: VERSION file not found in source" -ForegroundColor Red
    exit 1
}
$SourceVersion = (Get-Content $VersionFile -Raw).Trim()

# Determine installed version file location
if ($Global) {
    $ClaudeDir = Join-Path $env:USERPROFILE ".claude"
    $InstalledVersionFile = Join-Path $ClaudeDir "nextdocs.version"
    Write-Host "Checking global installation..." -ForegroundColor Yellow
} else {
    $Target = (Get-Location).Path
    $ClaudeDir = Join-Path $Target ".claude"
    $GitHubDir = Join-Path $Target ".github"
    $InstalledVersionFile = Join-Path $ClaudeDir "nextdocs.version"
    Write-Host "Checking project installation..." -ForegroundColor Yellow
}

# Read installed version
$InstalledVersion = ""
if (Test-Path $InstalledVersionFile) {
    $InstalledVersion = (Get-Content $InstalledVersionFile -Raw).Trim()
}

Write-Host ""

# Version check
if ($InstalledVersion -and -not $Force) {
    if ($SourceVersion -eq $InstalledVersion) {
        Write-Host "Already up to date (v$InstalledVersion)" -ForegroundColor Green
        Write-Host ""
        Write-Host "Use -Force to update anyway" -ForegroundColor DarkGray
        Write-Host ""
        exit 0
    }

    if ([version]$SourceVersion -gt [version]$InstalledVersion) {
        Write-Host "Updating: v$InstalledVersion -> v$SourceVersion" -ForegroundColor Cyan
    } else {
        Write-Host "Warning: Source (v$SourceVersion) is older than installed (v$InstalledVersion)" -ForegroundColor Yellow
        Write-Host "Use -Force to downgrade" -ForegroundColor DarkGray
        Write-Host ""
        exit 0
    }
} elseif (-not $InstalledVersion) {
    Write-Host "No version found - updating all files" -ForegroundColor Yellow
} else {
    Write-Host "Force update to v$SourceVersion" -ForegroundColor Yellow
}

Write-Host ""

$updated = 0

if ($Global) {
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

    # Update version file
    Copy-Item -Path $VersionFile -Destination (Join-Path $ClaudeDir "nextdocs.version") -Force

} else {
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

    # Update Copilot instructions snippet
    $CopilotInstructions = Join-Path $GitHubDir "copilot-instructions.md"
    if ((Test-Path $CopilotSnippet) -and (Test-Path $CopilotInstructions)) {
        if (Update-CopilotSnippet -TargetFile $CopilotInstructions -SourceFile $CopilotSnippet) {
            Write-Host "[OK] Updated .github/copilot-instructions.md (NextDocs reference)" -ForegroundColor Green
            $updated++
        }
    }

    # Update version file
    Copy-Item -Path $VersionFile -Destination (Join-Path $ClaudeDir "nextdocs.version") -Force
}

Write-Host ""
if ($updated -gt 0) {
    Write-Host "Update complete! ($updated files updated -> v$SourceVersion)" -ForegroundColor Green
} else {
    Write-Host "No files found to update. Run install.ps1 first." -ForegroundColor Red
}
Write-Host ""
