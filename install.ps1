# install.ps1 - Ingnovarte Learning Stack installer (Windows / PowerShell)
#
# Sets up Claude Code and/or OpenCode to work with the LDD skill stack.
# Safe to re-run: all actions are idempotent (second run produces only [skip]).
#
# Usage:
#   .\install.ps1 [OPTIONS]
#
# Options:
#   -DryRun                    Show what would be done without changing anything
#   -Host auto|claude|opencode|both
#                              Which AI host to configure (default: auto-detect)
#   -Force                     Re-apply even when files already exist
#   -Quiet                     Suppress informational output (errors still shown)
#
# Exit codes: 0 = success or warnings, 1 = fatal error

[CmdletBinding()]
param(
    [switch]$DryRun,
    [Alias('Host')]
    [string]$HostMode = 'auto',
    [switch]$Force,
    [switch]$Quiet
)

$ErrorActionPreference = 'Stop'

$RepoRoot  = $PSScriptRoot

# Dot-source shared helpers
. "$RepoRoot\scripts\lib.ps1"

# ---------------------------------------------------------------------------
# Logging wrapper that respects -Quiet
# ---------------------------------------------------------------------------

function Write-Info {
    param([string]$Message = '')
    if (-not $Quiet) { Write-Host $Message }
}

# ---------------------------------------------------------------------------
# Summary counters
# ---------------------------------------------------------------------------

$Script:CountOk    = 0
$Script:CountSkip  = 0
$Script:CountWarn  = 0
$Script:CountError = 0

# ---------------------------------------------------------------------------
# Detection phase
# ---------------------------------------------------------------------------

$ClaudePresent    = $false
$OpenCodePresent  = $false
$EngramInstalled  = $false
$GentleAiPresent  = $false

function Invoke-Detect {
    Write-Info ''
    Write-Info '=== Detecting environment ==='

    # Claude Code
    $claudePath = Join-Path $env:USERPROFILE '.claude'
    if (Test-Path $claudePath) {
        $Script:ClaudePresent = $true
        Write-Info "  Claude Code:  found ($claudePath)"
    } else {
        Write-Info '  Claude Code:  not found'
    }

    # OpenCode
    $ocPath1 = Join-Path $env:APPDATA 'opencode'
    $ocPath2 = Join-Path $env:LOCALAPPDATA 'opencode'
    if ((Test-Path $ocPath1) -or (Test-Path $ocPath2)) {
        $Script:OpenCodePresent = $true
        Write-Info '  OpenCode:     found'
    } else {
        Write-Info '  OpenCode:     not found'
    }

    # Engram CLI
    $engramCmd = Get-Command engram -ErrorAction SilentlyContinue
    if ($null -ne $engramCmd) {
        $Script:EngramInstalled = $true
        Write-Info "  Engram:       found ($($engramCmd.Source))"
    } else {
        Write-Info '  Engram:       not found'
    }

    # Gentle AI (informative only)
    $mcpFile = Join-Path $RepoRoot '.mcp.json'
    $gentleAiDir = Join-Path $RepoRoot 'gentle-ai'
    if ((Test-Path $gentleAiDir) -or
        ((Test-Path $mcpFile) -and (Test-JsonKey -Path $mcpFile -KeyPath 'mcpServers.gentle-ai'))) {
        $Script:GentleAiPresent = $true
        Write-Info '  Gentle AI:    detected (installer will preserve its config)'
    }

    Write-Info ''
}

# ---------------------------------------------------------------------------
# Resolve effective host targets
# ---------------------------------------------------------------------------

$ConfigureClaude    = $false
$ConfigureOpenCode  = $false

function Resolve-Hosts {
    switch ($HostMode) {
        'auto' {
            if ($Script:ClaudePresent)   { $Script:ConfigureClaude   = $true }
            if ($Script:OpenCodePresent) { $Script:ConfigureOpenCode = $true }
        }
        'claude'   { $Script:ConfigureClaude   = $true }
        'opencode' { $Script:ConfigureOpenCode = $true }
        'both' {
            $Script:ConfigureClaude   = $true
            $Script:ConfigureOpenCode = $true
        }
        default {
            Write-Warn "Unknown -Host value '$HostMode'; defaulting to auto"
            if ($Script:ClaudePresent)   { $Script:ConfigureClaude   = $true }
            if ($Script:OpenCodePresent) { $Script:ConfigureOpenCode = $true }
        }
    }
}

# ---------------------------------------------------------------------------
# Action: regenerate skill registry
# ---------------------------------------------------------------------------

function Invoke-RegenerateRegistry {
    $registryScript = Join-Path $RepoRoot 'scripts\build-registry.ps1'

    if (-not (Test-Path $registryScript)) {
        Write-StepError "build-registry.ps1 not found at $registryScript"
        $Script:CountError++
        return
    }

    if ($DryRun) {
        Write-Info '[dry-run] Would regenerate .atl\skill-registry.md'
        $Script:CountSkip++
        return
    }

    & $registryScript -RepoRoot $RepoRoot
    $Script:CountOk++
}

# ---------------------------------------------------------------------------
# Action: merge Engram into .mcp.json (Claude Code)
# ---------------------------------------------------------------------------

function Invoke-MergeMcpClaude {
    if (-not $Script:ConfigureClaude) { return }
    if (-not $Script:EngramInstalled) {
        Write-Warn 'Engram not installed - skipping .mcp.json merge'
        $Script:CountWarn++
        return
    }

    $mcpFile = Join-Path $RepoRoot '.mcp.json'
    $engramValue = [ordered]@{
        type    = 'stdio'
        command = 'engram'
        args    = @('mcp')
        env     = [ordered]@{ ENGRAM_PROJECT = 'ingnovarte-learning-stack' }
    }

    if ($DryRun) {
        if (Test-JsonKey -Path $mcpFile -KeyPath 'mcpServers.engram') {
            Write-Info '[dry-run] .mcp.json: engram key already present (would skip)'
        } else {
            Write-Info '[dry-run] Would add engram to .mcp.json'
        }
        $Script:CountSkip++
        return
    }

    # Ensure mcpServers parent key exists first
    if (Test-Path $mcpFile) {
        if (-not (Test-JsonKey -Path $mcpFile -KeyPath 'mcpServers')) {
            Add-JsonKey -Path $mcpFile -KeyPath 'mcpServers' -Value @{}
        }
    }
    Add-JsonKey -Path $mcpFile -KeyPath 'mcpServers.engram' -Value $engramValue
    $Script:CountOk++
}

# ---------------------------------------------------------------------------
# Action: merge Engram into opencode.json (OpenCode)
# ---------------------------------------------------------------------------

function Invoke-MergeMcpOpenCode {
    if (-not $Script:ConfigureOpenCode) { return }
    if (-not $Script:EngramInstalled) {
        Write-Warn 'Engram not installed - skipping opencode.json merge'
        $Script:CountWarn++
        return
    }

    # Locate or create opencode.json
    $ocFile = $null
    $ocPath1 = Join-Path $env:APPDATA 'opencode\opencode.json'
    $ocPath2 = Join-Path $env:LOCALAPPDATA 'opencode\opencode.json'
    if (Test-Path $ocPath1) {
        $ocFile = $ocPath1
    } elseif (Test-Path $ocPath2) {
        $ocFile = $ocPath2
    } else {
        $ocDir = Join-Path $env:APPDATA 'opencode'
        if (-not (Test-Path $ocDir)) { New-Item -ItemType Directory -Path $ocDir -Force | Out-Null }
        $ocFile = $ocPath1
    }

    $engramValue = [ordered]@{
        type        = 'local'
        command     = @('engram', 'mcp')
        environment = [ordered]@{ ENGRAM_PROJECT = 'ingnovarte-learning-stack' }
    }

    if ($DryRun) {
        Write-Info "[dry-run] Would add engram to $ocFile"
        $Script:CountSkip++
        return
    }

    # Ensure mcp parent key exists
    if (Test-Path $ocFile) {
        if (-not (Test-JsonKey -Path $ocFile -KeyPath 'mcp')) {
            Add-JsonKey -Path $ocFile -KeyPath 'mcp' -Value @{}
        }
    }
    Add-JsonKey -Path $ocFile -KeyPath 'mcp.engram' -Value $engramValue
    $Script:CountOk++
}

# ---------------------------------------------------------------------------
# Action: add LDD slash commands to opencode.json (OpenCode)
# ---------------------------------------------------------------------------

function Get-OpenCodeLddCommands {
    return @{
        'ldd-onboard' = @{
            description = 'Verifica la instalacion del Ingnovarte Learning Stack.'
            prompt = 'Ejecuta ldd-onboard siguiendo AGENTS.md. Verifica el setup del Ingnovarte Learning Stack y devuelve el reporte final.'
        }
        'ldd-init' = @{
            description = 'Inicializa la estructura LDD de un curso.'
            prompt = 'Ejecuta ldd-init siguiendo AGENTS.md. Si falta codigo, nombre o carpeta del curso, pregunta solo lo necesario antes de delegar.'
        }
        'ldd-kickoff' = @{
            description = 'Prepara o procesa el kickoff del curso.'
            prompt = 'Ejecuta ldd-kickoff siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-contextualizacion' = @{
            description = 'Procesa entrevistas, inmersion y analisis documental.'
            prompt = 'Ejecuta ldd-contextualizacion siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-ficha' = @{
            description = 'Genera la Ficha Tecnica del curso.'
            prompt = 'Ejecuta ldd-ficha siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-bbok' = @{
            description = 'Genera el BBOK del curso.'
            prompt = 'Ejecuta ldd-bbok siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-lluvia' = @{
            description = 'Genera la lluvia de ideas de actividades.'
            prompt = 'Ejecuta ldd-lluvia siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-esquema' = @{
            description = 'Genera el esquema minuto a minuto del curso.'
            prompt = 'Ejecuta ldd-esquema siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-bok' = @{
            description = 'Genera el BOK final del curso.'
            prompt = 'Ejecuta ldd-bok siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-presentacion' = @{
            description = 'Genera el brief de presentacion slide por slide.'
            prompt = 'Ejecuta ldd-presentacion siguiendo AGENTS.md y el Phase Guard LDD. Respeta titulos fuente exactos del BBOK y actividades exactas del Esquema.'
        }
        'ldd-guias' = @{
            description = 'Genera guias de actividades del curso.'
            prompt = 'Ejecuta ldd-guias siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-evaluaciones' = @{
            description = 'Genera evaluaciones, rubricas y encuestas.'
            prompt = 'Ejecuta ldd-evaluaciones siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-informe' = @{
            description = 'Genera informes de retroalimentacion o eficacia.'
            prompt = 'Ejecuta ldd-informe siguiendo AGENTS.md y el Phase Guard LDD.'
        }
        'ldd-review' = @{
            description = 'Revisa un entregable LDD.'
            prompt = 'Ejecuta ldd-review siguiendo AGENTS.md. Revisa calidad, trazabilidad y coherencia pedagogica del entregable indicado por el usuario.'
        }
        'ldd-status' = @{
            description = 'Actualiza avance del plan de gestion del curso.'
            prompt = 'Ejecuta ldd-status siguiendo AGENTS.md. Actualiza el plan de gestion solo con confirmacion del usuario.'
        }
    }
}

function Invoke-MergeOpenCodeCommands {
    if (-not $Script:ConfigureOpenCode) { return }

    $ocFile = $null
    $ocPath1 = Join-Path $env:APPDATA 'opencode\opencode.json'
    $ocPath2 = Join-Path $env:LOCALAPPDATA 'opencode\opencode.json'
    if (Test-Path $ocPath1) {
        $ocFile = $ocPath1
    } elseif (Test-Path $ocPath2) {
        $ocFile = $ocPath2
    } else {
        $ocDir = Join-Path $env:APPDATA 'opencode'
        if (-not (Test-Path $ocDir)) { New-Item -ItemType Directory -Path $ocDir -Force | Out-Null }
        $ocFile = $ocPath1
    }

    $commands = Get-OpenCodeLddCommands

    if ($DryRun) {
        Write-Info "[dry-run] Would ensure $($commands.Count) LDD slash command(s) in $ocFile"
        $Script:CountSkip++
        return
    }

    if (Test-Path $ocFile) {
        if (-not (Test-JsonKey -Path $ocFile -KeyPath 'command')) {
            Add-JsonKey -Path $ocFile -KeyPath 'command' -Value @{}
        }
    }

    foreach ($name in ($commands.Keys | Sort-Object)) {
        Add-JsonKey -Path $ocFile -KeyPath "command.$name" -Value $commands[$name]
    }

    $Script:CountOk++
}

# ---------------------------------------------------------------------------
# Action: append gitignore entries
# ---------------------------------------------------------------------------

function Invoke-AppendGitignore {
    $gitignore = Join-Path $RepoRoot '.gitignore'
    $sectionMarker = '# Ingnovarte Learning Stack'
    $entries = @('cursos/', 'gentle-ai/', '.atl/skill-registry.md', '.atl/.skill-registry.cache.json')

    if ($DryRun) {
        Write-Info '[dry-run] Would ensure .gitignore contains LDD entries'
        $Script:CountSkip++
        return
    }

    # Determine which entries are missing
    $existingLines = @()
    if (Test-Path $gitignore) {
        $existingLines = Get-Content -Path $gitignore
    }

    $missing = $entries | Where-Object { $existingLines -notcontains $_ }

    if ($missing.Count -eq 0) {
        Write-Skip '.gitignore already contains all LDD entries'
        $Script:CountSkip++
        return
    }

    # Append section
    $appendLines = @('', "$sectionMarker - generated/local files") + $missing
    Add-Content -Path $gitignore -Value $appendLines -Encoding UTF8
    Write-Ok "Appended $($missing.Count) entries to .gitignore"
    $Script:CountOk++
}

# ---------------------------------------------------------------------------
# Apply phase
# ---------------------------------------------------------------------------

function Invoke-Apply {
    Write-Info '=== Applying changes ==='

    Invoke-RegenerateRegistry
    Invoke-MergeMcpClaude
    Invoke-MergeMcpOpenCode
    Invoke-MergeOpenCodeCommands
    Invoke-AppendGitignore

    Write-Info ''
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

function Write-Summary {
    Write-Info '=== Summary ==='
    Write-Info "  [ok]    $($Script:CountOk)"
    Write-Info "  [skip]  $($Script:CountSkip)"
    Write-Info "  [warn]  $($Script:CountWarn)"
    Write-Info "  [error] $($Script:CountError)"
    Write-Info ''

    if ($Script:CountError -gt 0) {
        Write-StepError "Installation completed with $($Script:CountError) error(s). Review output above."
        exit 1
    }

    if ($DryRun) {
        Write-Info 'Dry run complete - no changes were made.'
    } else {
        Write-Info 'Installation complete.'
        Write-Info ''
        Write-Info 'Next steps:'
        Write-Info '  1. Open Claude Code or OpenCode in this directory.'
        Write-Info '  2. Type: ejecuta ldd-onboard'
        Write-Info '  3. The skill will verify your setup end-to-end.'
        Write-Info ''
        Write-Info 'To initialize your first course:'
        Write-Info '  Create a course folder under cursos\ and run ldd-init.'
    }
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

Invoke-Detect
Resolve-Hosts
Invoke-Apply
Write-Summary
