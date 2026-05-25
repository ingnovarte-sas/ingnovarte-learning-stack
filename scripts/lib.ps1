# scripts/lib.ps1 — Shared PowerShell helpers for the Ingnovarte Learning Stack installer
# Dot-source this file from other scripts: . "$PSScriptRoot\lib.ps1"
# Do NOT execute directly.

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Log helpers
# ---------------------------------------------------------------------------

function Write-Ok {
    param([string]$Message)
    Write-Host "[ok]    $Message"
}

function Write-Skip {
    param([string]$Message)
    Write-Host "[skip]  $Message"
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[warn]  $Message" -ForegroundColor Yellow
}

function Write-StepError {
    param([string]$Message)
    Write-Host "[error] $Message" -ForegroundColor Red
}

# ---------------------------------------------------------------------------
# File hashing
# Wraps the built-in Get-FileHash to return the SHA256 hex string.
# Usage: $hash = Get-FileHashSHA256 -Path <path>
# Returns empty string if file does not exist or on failure.
# ---------------------------------------------------------------------------

function Get-FileHashSHA256 {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        return ''
    }
    try {
        $result = Get-FileHash -Path $Path -Algorithm SHA256
        return $result.Hash.ToLower()
    } catch {
        Write-Warn "Get-FileHashSHA256 failed for '$Path': $_"
        return ''
    }
}

# ---------------------------------------------------------------------------
# JSON helpers (pure PowerShell — no jq dependency)
# ---------------------------------------------------------------------------

# Test-JsonKey -Path <file> -KeyPath <dotted-key>
# Returns $true if the key path resolves to a non-null value in the JSON file.
# KeyPath supports simple dot notation: "mcpServers.engram"
# Returns $false if file missing, JSON invalid, or key absent.
function Test-JsonKey {
    param(
        [string]$Path,
        [string]$KeyPath
    )
    if (-not (Test-Path $Path)) { return $false }
    try {
        $obj = Get-Content -Raw -Path $Path | ConvertFrom-Json
        $segments = $KeyPath -split '\.'
        $current = $obj
        foreach ($seg in $segments) {
            if ($null -eq $current) { return $false }
            # PSCustomObject property access
            $prop = $current.PSObject.Properties[$seg]
            if ($null -eq $prop) { return $false }
            $current = $prop.Value
        }
        return ($null -ne $current)
    } catch {
        return $false
    }
}

# Add-JsonKey -Path <file> -KeyPath <dotted-key> -Value <hashtable or PSObject>
# Merges Value into the JSON file at the nested key path ONLY if the key
# does not already exist. Creates file if missing. Idempotent.
# Value should be a [hashtable] that will be serialized to JSON.
function Add-JsonKey {
    param(
        [string]$Path,
        [string]$KeyPath,
        [hashtable]$Value
    )

    # Create file if missing
    if (-not (Test-Path $Path)) {
        '{}' | Set-Content -Path $Path -Encoding UTF8
    }

    # Check if key already present
    if (Test-JsonKey -Path $Path -KeyPath $KeyPath) {
        Write-Skip "JSON key '$KeyPath' already present in '$Path'"
        return
    }

    try {
        $raw = Get-Content -Raw -Path $Path
        # ConvertFrom-Json returns PSCustomObject; work with it as a hashtable
        $obj = $raw | ConvertFrom-Json
        $segments = $KeyPath -split '\.'

        # Navigate/create nested path
        # Convert root object to hashtable for easier mutation
        $root = ConvertTo-Hashtable $obj

        $node = $root
        for ($i = 0; $i -lt ($segments.Length - 1); $i++) {
            $seg = $segments[$i]
            if (-not $node.ContainsKey($seg)) {
                $node[$seg] = @{}
            } elseif ($node[$seg] -isnot [hashtable]) {
                # Convert PSCustomObject to hashtable if needed
                $node[$seg] = ConvertTo-Hashtable $node[$seg]
            }
            $node = $node[$seg]
        }

        $lastKey = $segments[-1]
        if (-not $node.ContainsKey($lastKey)) {
            $node[$lastKey] = $Value
        }

        $root | ConvertTo-Json -Depth 10 | Set-Content -Path $Path -Encoding UTF8
        Write-Ok "Added JSON key '$KeyPath' to '$Path'"
    } catch {
        Write-StepError "Failed to add JSON key '$KeyPath' to '$Path': $_"
        throw
    }
}

# ConvertTo-Hashtable <PSCustomObject>
# Recursively converts a PSCustomObject (from ConvertFrom-Json) to a hashtable.
# This enables in-place mutation without losing nested structure.
function ConvertTo-Hashtable {
    param($InputObject)

    if ($null -eq $InputObject) { return $null }

    if ($InputObject -is [System.Management.Automation.PSCustomObject]) {
        $ht = [ordered]@{}
        foreach ($prop in $InputObject.PSObject.Properties) {
            $ht[$prop.Name] = ConvertTo-Hashtable $prop.Value
        }
        return $ht
    } elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $arr = @()
        foreach ($item in $InputObject) {
            $arr += ConvertTo-Hashtable $item
        }
        return $arr
    } else {
        return $InputObject
    }
}
