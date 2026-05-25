#!/usr/bin/env bash
# install.sh — Ingnovarte Learning Stack installer
#
# Sets up Claude Code and/or OpenCode to work with the LDD skill stack.
# Safe to re-run: all actions are idempotent (second run produces only [skip]).
#
# Usage:
#   ./install.sh [OPTIONS]
#
# Options:
#   --dry-run              Show what would be done without changing anything
#   --host=auto|claude|opencode|both
#                          Which AI host to configure (default: auto-detect)
#   --force                Re-apply even when files already exist
#   --quiet                Suppress informational output (errors still shown)
#
# Exit codes: 0 = success or warnings, 1 = fatal error

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

# Source shared helpers
# shellcheck source=scripts/lib.sh
source "$REPO_ROOT/scripts/lib.sh"

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------

DRY_RUN=false
HOST_FLAG="auto"
FORCE=false
QUIET=false

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

parse_args() {
  for arg in "$@"; do
    case "$arg" in
      --dry-run)          DRY_RUN=true ;;
      --host=*)           HOST_FLAG="${arg#--host=}" ;;
      --force)            FORCE=true ;;
      --quiet)            QUIET=true ;;
      -h|--help)
        echo "Usage: $0 [--dry-run] [--host=auto|claude|opencode|both] [--force] [--quiet]"
        exit 0
        ;;
      *)
        log_warn "Unknown argument: $arg (ignored)"
        ;;
    esac
  done
}

# ---------------------------------------------------------------------------
# Logging wrappers that respect --quiet
# ---------------------------------------------------------------------------

info() {
  if [ "$QUIET" = false ]; then
    echo "$*"
  fi
}

# ---------------------------------------------------------------------------
# Detection phase
# ---------------------------------------------------------------------------

CLAUDE_PRESENT=false
OPENCODE_PRESENT=false
ENGRAM_INSTALLED=false
JQ_AVAILABLE=false
GENTLE_AI_PRESENT=false

detect() {
  info ""
  info "=== Detecting environment ==="

  # Claude Code
  if [ -d "$HOME/.claude" ]; then
    CLAUDE_PRESENT=true
    info "  Claude Code:  found ($HOME/.claude)"
  else
    info "  Claude Code:  not found"
  fi

  # OpenCode
  if [ -d "$HOME/.config/opencode" ] || [ -d "$HOME/.local/share/opencode" ]; then
    OPENCODE_PRESENT=true
    info "  OpenCode:     found"
  else
    info "  OpenCode:     not found"
  fi

  # Engram CLI
  if check_command engram; then
    ENGRAM_INSTALLED=true
    info "  Engram:       found ($(command -v engram))"
  else
    info "  Engram:       not found"
  fi

  # jq
  if check_command jq; then
    JQ_AVAILABLE=true
    info "  jq:           found"
  else
    info "  jq:           not found (JSON merge via bash fallback)"
  fi

  # Gentle AI (informative only — installer never touches its config)
  local mcp_file="$REPO_ROOT/.mcp.json"
  if [ -d "$REPO_ROOT/gentle-ai" ] || \
     ([ -f "$mcp_file" ] && check_command jq && json_has_key "$mcp_file" '.mcpServers["gentle-ai"]' 2>/dev/null); then
    GENTLE_AI_PRESENT=true
    info "  Gentle AI:    detected (installer will preserve its config)"
  fi

  info ""
}

# ---------------------------------------------------------------------------
# Resolve effective host targets based on --host flag and detection results
# ---------------------------------------------------------------------------

CONFIGURE_CLAUDE=false
CONFIGURE_OPENCODE=false

resolve_hosts() {
  case "$HOST_FLAG" in
    auto)
      [ "$CLAUDE_PRESENT"   = true ] && CONFIGURE_CLAUDE=true
      [ "$OPENCODE_PRESENT" = true ] && CONFIGURE_OPENCODE=true
      ;;
    claude)   CONFIGURE_CLAUDE=true ;;
    opencode) CONFIGURE_OPENCODE=true ;;
    both)
      CONFIGURE_CLAUDE=true
      CONFIGURE_OPENCODE=true
      ;;
    *)
      log_warn "Unknown --host value '$HOST_FLAG'; defaulting to auto"
      [ "$CLAUDE_PRESENT"   = true ] && CONFIGURE_CLAUDE=true
      [ "$OPENCODE_PRESENT" = true ] && CONFIGURE_OPENCODE=true
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Summary counters
# ---------------------------------------------------------------------------

ACTIONS_OK=0
ACTIONS_SKIP=0
ACTIONS_WARN=0
ACTIONS_ERROR=0

record_ok()    { ACTIONS_OK=$((ACTIONS_OK + 1)); }
record_skip()  { ACTIONS_SKIP=$((ACTIONS_SKIP + 1)); }
record_warn()  { ACTIONS_WARN=$((ACTIONS_WARN + 1)); }
record_error() { ACTIONS_ERROR=$((ACTIONS_ERROR + 1)); }

# ---------------------------------------------------------------------------
# Action: regenerate skill registry
# ---------------------------------------------------------------------------

action_regenerate_registry() {
  local registry_script="$REPO_ROOT/scripts/build-registry.sh"

  if [ ! -f "$registry_script" ]; then
    log_error "build-registry.sh not found at $registry_script"
    record_error
    return
  fi

  if [ "$DRY_RUN" = true ]; then
    info "[dry-run] Would regenerate .atl/skill-registry.md"
    record_skip
    return
  fi

  bash "$registry_script" "$REPO_ROOT"
  record_ok
}

# ---------------------------------------------------------------------------
# Action: merge Engram into .mcp.json (Claude Code)
# ---------------------------------------------------------------------------

action_merge_mcp_claude() {
  if [ "$CONFIGURE_CLAUDE" = false ]; then
    return
  fi
  if [ "$ENGRAM_INSTALLED" = false ]; then
    log_warn "Engram not installed — skipping .mcp.json merge"
    record_warn
    return
  fi
  if [ "$JQ_AVAILABLE" = false ]; then
    log_warn "jq not available — skipping .mcp.json merge (install jq and re-run)"
    record_warn
    return
  fi

  local mcp_file="$REPO_ROOT/.mcp.json"
  local engram_block
  engram_block='{"type":"stdio","command":"engram","args":["mcp"],"env":{"ENGRAM_PROJECT":"ingnovarte-learning-stack"}}'

  if [ "$DRY_RUN" = true ]; then
    if json_has_key "$mcp_file" '.mcpServers.engram' 2>/dev/null; then
      info "[dry-run] .mcp.json: engram key already present (would skip)"
    else
      info "[dry-run] Would add engram to .mcp.json"
    fi
    record_skip
    return
  fi

  json_add_key "$mcp_file" '.mcpServers.engram' "$engram_block"
  record_ok
}

# ---------------------------------------------------------------------------
# Action: merge Engram into opencode.json (OpenCode)
# ---------------------------------------------------------------------------

action_merge_mcp_opencode() {
  if [ "$CONFIGURE_OPENCODE" = false ]; then
    return
  fi
  if [ "$ENGRAM_INSTALLED" = false ]; then
    log_warn "Engram not installed — skipping opencode.json merge"
    record_warn
    return
  fi

  # Try to locate opencode.json
  local opencode_file=""
  if [ -f "$HOME/.config/opencode/opencode.json" ]; then
    opencode_file="$HOME/.config/opencode/opencode.json"
  elif [ -f "$HOME/.local/share/opencode/opencode.json" ]; then
    opencode_file="$HOME/.local/share/opencode/opencode.json"
  else
    # Create in default location
    opencode_file="$HOME/.config/opencode/opencode.json"
    mkdir -p "$(dirname "$opencode_file")"
  fi

  local engram_block
  engram_block='{"type":"local","command":["engram","mcp"],"environment":{"ENGRAM_PROJECT":"ingnovarte-learning-stack"}}'

  if [ "$DRY_RUN" = true ]; then
    info "[dry-run] Would add engram to $opencode_file"
    record_skip
    return
  fi

  if [ "$JQ_AVAILABLE" = true ]; then
    json_add_key "$opencode_file" '.mcp.engram' "$engram_block"
  else
    # Fallback: simple Python-based JSON merge (no jq)
    if check_command python3; then
      python3 - "$opencode_file" "$engram_block" <<'PYEOF'
import sys, json
file_path = sys.argv[1]
block = json.loads(sys.argv[2])
try:
    with open(file_path, 'r') as f:
        obj = json.load(f)
except Exception:
    obj = {}
if 'mcp' not in obj:
    obj['mcp'] = {}
if 'engram' not in obj['mcp']:
    obj['mcp']['engram'] = block
    with open(file_path, 'w') as f:
        json.dump(obj, f, indent=2)
    print('[ok]    Added engram to opencode.json')
else:
    print('[skip]  engram already in opencode.json')
PYEOF
    else
      log_warn "Neither jq nor python3 available — cannot merge opencode.json"
      record_warn
      return
    fi
  fi
  record_ok
}

# ---------------------------------------------------------------------------
# Action: append gitignore entries
# ---------------------------------------------------------------------------

action_append_gitignore() {
  local gitignore="$REPO_ROOT/.gitignore"
  local section_marker="# Ingnovarte Learning Stack"
  local entries=(
    "cursos/"
    "gentle-ai/"
    ".atl/skill-registry.md"
    ".atl/.skill-registry.cache.json"
  )

  if [ "$DRY_RUN" = true ]; then
    info "[dry-run] Would ensure .gitignore contains LDD entries"
    record_skip
    return
  fi

  # Check which entries are already present
  local missing=()
  for entry in "${entries[@]}"; do
    if ! grep -qxF "$entry" "$gitignore" 2>/dev/null; then
      missing+=("$entry")
    fi
  done

  if [ ${#missing[@]} -eq 0 ]; then
    log_skip ".gitignore already contains all LDD entries"
    record_skip
    return
  fi

  # Append missing entries
  {
    echo ""
    echo "$section_marker — generated/local files"
    for entry in "${missing[@]}"; do
      echo "$entry"
    done
  } >> "$gitignore"

  log_ok "Appended ${#missing[@]} entries to .gitignore"
  record_ok
}

# ---------------------------------------------------------------------------
# Apply phase — run all actions
# ---------------------------------------------------------------------------

apply() {
  info "=== Applying changes ==="

  action_regenerate_registry
  action_merge_mcp_claude
  action_merge_mcp_opencode
  action_append_gitignore

  info ""
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

print_summary() {
  info "=== Summary ==="
  info "  [ok]    $ACTIONS_OK"
  info "  [skip]  $ACTIONS_SKIP"
  info "  [warn]  $ACTIONS_WARN"
  info "  [error] $ACTIONS_ERROR"
  info ""

  if [ "$ACTIONS_ERROR" -gt 0 ]; then
    log_error "Installation completed with $ACTIONS_ERROR error(s). Review output above."
    info ""
    exit 1
  fi

  if [ "$DRY_RUN" = true ]; then
    info "Dry run complete — no changes were made."
  else
    info "Installation complete."
    info ""
    info "Next steps:"
    info "  1. Open Claude Code or OpenCode in this directory."
    info "  2. Type: ejecuta ldd-onboard"
    info "  3. The skill will verify your setup end-to-end."
    info ""
    info "To initialize your first course:"
    info "  Create a course folder under cursos/ and run ldd-init."
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

parse_args "$@"
detect
resolve_hosts
apply
print_summary
