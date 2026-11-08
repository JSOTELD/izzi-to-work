param(
    [ValidateSet("Stop", "PreCompact", "PostCompact")]
    [string]$Mode = "Stop"
)

$ErrorActionPreference = "SilentlyContinue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$workDir = (Get-Location).Path
$claudeDir = Join-Path $workDir ".claude"
$checkpointPath = Join-Path $claudeDir "checkpoint.md"
$controlPath = Join-Path $workDir "docs\plan\CHECKPOINT.md"

function Update-CheckpointMeta {
    if (-not (Test-Path $claudeDir)) {
        New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
    }
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $branch = (git rev-parse --abbrev-ref HEAD 2>$null)
    if (-not $branch) { $branch = "no-git" }
    $lastCommit = (git log -1 --oneline 2>$null)
    if (-not $lastCommit) { $lastCommit = "no-commits" }
    $recentCommits = (git log -n 5 --oneline 2>$null) -join "`n  - "
    $dirtyFiles = (git status --short 2>$null) -join "`n  "
    if (-not $dirtyFiles) { $dirtyFiles = "(clean tree)" }

    if (-not (Test-Path $checkpointPath)) {
        $initial = @"
# GARRY DUSTPAN · ACTIVE TASK CHECKPOINT
- **Updated:** $now
- **Git Branch:** $branch
- **Last Commit:** $lastCommit

## 1. Completed Items
  - [x] Initial checkpoint created

## 2. Recent Commits
  - $recentCommits

## 3. Immediate State / Modified Files
  $dirtyFiles

## 4. Exact Next Step
  - Continue implementing tasks from spec or plan
"@
        Set-Content -Path $checkpointPath -Value $initial -Encoding UTF8
    } else {
        $content = Get-Content -Path $checkpointPath -Raw -Encoding UTF8
        $content = $content -replace '(?m)^-\s*\*\*(Timestamp|Updated|Actualizado):\*\*.*$', "- **Updated:** $now"
        $content = $content -replace '(?m)^-\s*\*\*(Last Commit|Último Commit):\*\*.*$', "- **Last Commit:** $lastCommit"
        $content = $content -replace '(?m)^-\s*\*\*(Git Branch|Rama Git):\*\*.*$', "- **Git Branch:** $branch"
        Set-Content -Path $checkpointPath -Value $content -Encoding UTF8 -NoNewline
    }
}

if ($Mode -eq "Stop" -or $Mode -eq "PreCompact") {
    Update-CheckpointMeta
    exit 0
}

if ($Mode -eq "PostCompact") {
    Update-CheckpointMeta
    Write-Output "=== GARRY DUSTPAN: POST-COMPACTION MEMORY RESTORED ==="
    if (Test-Path $checkpointPath) {
        $cpLines = Get-Content -Path $checkpointPath -TotalCount 45 -Encoding UTF8
        Write-Output ($cpLines -join "`n")
    }
    if (Test-Path $controlPath) {
        Write-Output "`n--- Excerpt from docs/plan/CHECKPOINT.md ---"
        $ctrlLines = Get-Content -Path $controlPath -Tail 25 -Encoding UTF8
        Write-Output ($ctrlLines -join "`n")
    }
    Write-Output "=== END GARRY DUSTPAN (Resume from Exact Next Step without rescanning repo) ==="
    exit 0
}

exit 0

