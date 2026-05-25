#!/usr/bin/env bash
# scripts/lib.sh — Shared bash helpers for the Ingnovarte Learning Stack installer
# Source this file from other scripts: source "$(dirname "$0")/lib.sh"
# Do NOT execute directly.

# ---------------------------------------------------------------------------
# Log helpers
# ---------------------------------------------------------------------------

log_ok()    { echo "[ok]    $*"; }
log_skip()  { echo "[skip]  $*"; }
log_warn()  { echo "[warn]  $*"; }
log_error() { echo "[error] $*" >&2; }

# ---------------------------------------------------------------------------
# File hashing
# Uses sha256sum (Linux) or shasum -a 256 (macOS) — whichever is available.
# Usage: file_hash <path>
# Returns: hex digest string, or empty string on failure
# ---------------------------------------------------------------------------

file_hash() {
  local path="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$path" 2>/dev/null | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$path" 2>/dev/null | awk '{print $1}'
  else
    log_warn "Neither sha256sum nor shasum found; file_hash returning empty"
    echo ""
  fi
}

# ---------------------------------------------------------------------------
# JSON helpers (require jq)
# ---------------------------------------------------------------------------

# check_command <cmd>
# Returns 0 if command exists, 1 otherwise (no output).
check_command() {
  command -v "$1" >/dev/null 2>&1
}

# json_has_key <file> <key_path>
# Returns 0 if the jq key_path expression yields a non-null value in file.
# Example: json_has_key config.json '.mcpServers.engram'
json_has_key() {
  local file="$1"
  local key="$2"
  if ! check_command jq; then
    log_warn "jq not available; json_has_key returning false"
    return 1
  fi
  local val
  val=$(jq -e "$key" "$file" 2>/dev/null)
  local rc=$?
  # jq -e returns 1 if value is null/false, 0 otherwise
  return $rc
}

# json_add_key <file> <key_path> <json_value>
# Merges json_value into the object at key_path ONLY if the key does not
# already exist. Uses jq for atomic merge. Creates file if missing.
# Example: json_add_key .mcp.json '.mcpServers.engram' '{"type":"stdio"}'
# NOTE: key_path must address a nested object key (last segment is the new key).
json_add_key() {
  local file="$1"
  local key_path="$2"
  local json_value="$3"

  if ! check_command jq; then
    log_warn "jq not available; skipping json_add_key for $key_path in $file"
    return 0
  fi

  # Build file if it does not exist
  if [ ! -f "$file" ]; then
    echo "{}" > "$file"
  fi

  # Check if key already exists
  if json_has_key "$file" "$key_path" 2>/dev/null; then
    log_skip "JSON key $key_path already present in $file"
    return 0
  fi

  # Merge using jq: walk the key_path and inject the value
  # Build a jq expression that sets the nested key
  local tmp
  tmp=$(mktemp)
  jq --argjson val "$json_value" "$key_path = \$val" "$file" > "$tmp" 2>/dev/null
  local rc=$?
  if [ $rc -eq 0 ]; then
    mv "$tmp" "$file"
    log_ok "Added JSON key $key_path to $file"
  else
    rm -f "$tmp"
    log_error "Failed to merge JSON key $key_path into $file"
    return 1
  fi
}
