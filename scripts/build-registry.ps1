# scripts/build-registry.ps1 — Scan ldd-* skills and build .atl/skill-registry.md
#
# Usage:
#   .\scripts\build-registry.ps1 [-RepoRoot <path>] [-DryRun]
#
# Parameters:
#   RepoRoot   Path to the repository root. Defaults to the parent of the
#              directory this script lives in.
#   DryRun     Print the generated registry to stdout instead of writing it.
#
# Output file: <RepoRoot>\.atl\skill-registry.md
# All paths in the output file are relative to RepoRoot using forward slashes.

[CmdletBinding()]
param(
    [string]$RepoRoot = '',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Resolve RepoRoot
# ---------------------------------------------------------------------------

if ([string]::IsNullOrEmpty($RepoRoot)) {
    # Default: parent of the scripts/ directory
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}
$RepoRoot = (Resolve-Path $RepoRoot).Path

$HeaderFile = Join-Path $RepoRoot 'skills\_shared\skill-registry.header.md'
$OutputFile = Join-Path $RepoRoot '.atl\skill-registry.md'
$SkillsDir  = Join-Path $RepoRoot 'skills'

# ---------------------------------------------------------------------------
# Validate prerequisites
# ---------------------------------------------------------------------------

if (-not (Test-Path $HeaderFile)) {
    Write-Host "[error] Header template not found: $HeaderFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $SkillsDir)) {
    Write-Host "[error] Skills directory not found: $SkillsDir" -ForegroundColor Red
    exit 1
}

# ---------------------------------------------------------------------------
# Helper: extract a single YAML frontmatter field value from a SKILL.md file.
# Reads between the first pair of --- delimiters.
# Returns the inline value, or the first list item if the value is on the
# next line prefixed with "  - ".
# ---------------------------------------------------------------------------

function Get-FrontmatterField {
    param(
        [string]$FilePath,
        [string]$FieldName
    )

    $lines = Get-Content -Path $FilePath
    $inFrontmatter = $false
    $fmCount = 0
    $foundField = $false
    $value = ''

    foreach ($line in $lines) {
        if ($line -match '^---\s*$') {
            $fmCount++
            if ($fmCount -eq 1) { $inFrontmatter = $true; continue }
            if ($fmCount -eq 2) { break }
        }

        if (-not $inFrontmatter) { continue }

        if ($line -match "^${FieldName}:\s*(.+)$") {
            $value = $Matches[1].Trim().Trim('"').Trim("'")
            $foundField = $false  # got inline value
            break
        } elseif ($line -match "^${FieldName}:\s*$") {
            $foundField = $true  # value is on next line(s) as list
            continue
        } elseif ($foundField) {
            if ($line -match '^\s+-\s+(.+)$') {
                $value = $Matches[1].Trim().Trim('"').Trim("'")
                break
            } elseif ($line -notmatch '^\s') {
                break  # end of list block
            }
        }
    }

    return $value
}

# ---------------------------------------------------------------------------
# Scan skills and build table rows
# ---------------------------------------------------------------------------

$DateNow = Get-Date -Format 'yyyy-MM-dd'

# Replace {DATE} placeholder in header template
$headerContent = (Get-Content -Raw -Path $HeaderFile) -replace '\{DATE\}', $DateNow

$tableRows = [System.Text.StringBuilder]::new()

$skillFiles = Get-ChildItem -Path $SkillsDir -Filter 'SKILL.md' -Recurse |
    Where-Object { $_.DirectoryName -match '[/\\]ldd-[^/\\]+$' } |
    Sort-Object FullName

foreach ($skillFile in $skillFiles) {
    $skillName = Split-Path -Leaf (Split-Path -Parent $skillFile.FullName)

    $description = Get-FrontmatterField -FilePath $skillFile.FullName -FieldName 'description'
    $trigger     = Get-FrontmatterField -FilePath $skillFile.FullName -FieldName 'triggers'

    if ([string]::IsNullOrEmpty($description)) {
        $description = $trigger
    }

    # Relative path from RepoRoot with forward slashes
    $relPath = $skillFile.FullName.Substring($RepoRoot.Length).TrimStart('\', '/') -replace '\\', '/'

    # Truncate description to 80 chars
    if ($description.Length -gt 80) {
        $description = $description.Substring(0, 77) + '...'
    }

    [void]$tableRows.AppendLine("| $skillName | $relPath | $description |")
}

# ---------------------------------------------------------------------------
# Compose final output
# ---------------------------------------------------------------------------

$registryContent = $headerContent + "`n" + $tableRows.ToString()

# ---------------------------------------------------------------------------
# Write or print
# ---------------------------------------------------------------------------

if ($DryRun) {
    Write-Output $registryContent
    Write-Host ""
    Write-Host "[ok]    dry-run — no files written"
} else {
    # Ensure output directory exists
    $outputDir = Split-Path -Parent $OutputFile
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }

    # Hash-based idempotency: skip write if content unchanged
    if (Test-Path $OutputFile) {
        $existingContent = Get-Content -Raw -Path $OutputFile
        if ($existingContent -eq $registryContent) {
            Write-Host "[skip]  skill-registry.md is already up to date"
            exit 0
        }
    }

    Set-Content -Path $OutputFile -Value $registryContent -Encoding UTF8 -NoNewline
    Write-Host "[ok]    skill-registry.md written to $OutputFile"
    Write-Host "[ok]    $($skillFiles.Count) skill(s) indexed"
}
