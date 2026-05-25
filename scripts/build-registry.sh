#!/usr/bin/env bash
# scripts/build-registry.sh — Scan ldd-* skills and build .atl/skill-registry.md
#
# Usage:
#   ./scripts/build-registry.sh [REPO_ROOT] [--dry-run]
#
# Arguments:
#   REPO_ROOT   Path to the repository root. Defaults to the parent of this
#               script's directory (i.e., the repo root when the script lives
#               in scripts/).
#   --dry-run   Print the generated registry to stdout instead of writing it.
#
# Output file: <REPO_ROOT>/.atl/skill-registry.md
# All paths in the output file are relative to REPO_ROOT.

set -euo pipefail

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

REPO_ROOT=""
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    *)
      if [ -z "$REPO_ROOT" ]; then
        REPO_ROOT="$arg"
      fi
      ;;
  esac
done

# Default repo root: parent of the scripts/ directory
if [ -z "$REPO_ROOT" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

HEADER_FILE="$REPO_ROOT/skills/_shared/skill-registry.header.md"
OUTPUT_FILE="$REPO_ROOT/.atl/skill-registry.md"
SKILLS_DIR="$REPO_ROOT/skills"

# ---------------------------------------------------------------------------
# Validate prerequisites
# ---------------------------------------------------------------------------

if [ ! -f "$HEADER_FILE" ]; then
  echo "[error] Header template not found: $HEADER_FILE" >&2
  exit 1
fi

if [ ! -d "$SKILLS_DIR" ]; then
  echo "[error] Skills directory not found: $SKILLS_DIR" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Helper: extract a single-value YAML frontmatter field from a SKILL.md file.
# Handles both inline values ("field: value") and the first item of a list.
# Usage: extract_field <file> <field_name>
# ---------------------------------------------------------------------------

extract_field() {
  local file="$1"
  local field="$2"
  local value=""

  # Read only between the first pair of --- delimiters
  value=$(awk '
    /^---/ { fm++; next }
    fm == 1 { print }
    fm >= 2 { exit }
  ' "$file" | grep -E "^${field}:" | head -1 | sed "s/^${field}:[[:space:]]*//" | tr -d '"'"'")

  # If value is empty, try reading the next non-empty line as a list item
  if [ -z "$value" ]; then
    value=$(awk '
      /^---/ { fm++; next }
      fm == 1 { print }
      fm >= 2 { exit }
    ' "$file" | grep -A1 "^${field}:" | tail -1 | sed 's/^[[:space:]]*-[[:space:]]*//' | tr -d '"'"'")
  fi

  echo "$value"
}

# ---------------------------------------------------------------------------
# Scan skills and build table rows
# ---------------------------------------------------------------------------

DATE_NOW=$(date '+%Y-%m-%d')

# Replace {DATE} placeholder in header
HEADER_CONTENT=$(sed "s/{DATE}/$DATE_NOW/" "$HEADER_FILE")

TABLE_ROWS=""

# Find all ldd-*/SKILL.md files, sorted by skill name
while IFS= read -r skill_file; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"

  # Extract description and first trigger from frontmatter
  description=$(extract_field "$skill_file" "description")
  trigger=$(extract_field "$skill_file" "triggers")

  # Fallback: use trigger if description is empty
  if [ -z "$description" ]; then
    description="$trigger"
  fi

  # Build relative path (relative to REPO_ROOT)
  rel_path="${skill_file#$REPO_ROOT/}"
  # Normalize path separators to forward slashes
  rel_path="${rel_path//\\//}"

  # Truncate description to 80 chars for table readability
  if [ "${#description}" -gt 80 ]; then
    description="${description:0:77}..."
  fi

  TABLE_ROWS="${TABLE_ROWS}| ${skill_name} | ${rel_path} | ${description} |"$'\n'
done < <(find "$SKILLS_DIR" -maxdepth 3 -name "SKILL.md" -path "*/ldd-*" | sort)

# ---------------------------------------------------------------------------
# Compose final output
# ---------------------------------------------------------------------------

REGISTRY_CONTENT="${HEADER_CONTENT}
${TABLE_ROWS}"

# ---------------------------------------------------------------------------
# Write or print
# ---------------------------------------------------------------------------

if [ "$DRY_RUN" = true ]; then
  echo "$REGISTRY_CONTENT"
  echo ""
  echo "[ok]    dry-run — no files written"
else
  # Ensure output directory exists
  mkdir -p "$(dirname "$OUTPUT_FILE")"

  # Hash-based idempotency: skip write if content unchanged
  EXISTING_HASH=""
  NEW_HASH=""
  if [ -f "$OUTPUT_FILE" ]; then
    EXISTING_HASH=$(echo "$REGISTRY_CONTENT" | sha256sum 2>/dev/null | awk '{print $1}' || \
                    echo "$REGISTRY_CONTENT" | shasum -a 256 2>/dev/null | awk '{print $1}' || \
                    echo "")
    FILE_HASH=$(sha256sum "$OUTPUT_FILE" 2>/dev/null | awk '{print $1}' || \
                shasum -a 256 "$OUTPUT_FILE" 2>/dev/null | awk '{print $1}' || \
                echo "different")
    # Compare content hash (not file hash, since file includes trailing newline)
    EXPECTED_HASH=$(printf '%s\n' "$REGISTRY_CONTENT" | sha256sum 2>/dev/null | awk '{print $1}' || \
                    printf '%s\n' "$REGISTRY_CONTENT" | shasum -a 256 2>/dev/null | awk '{print $1}' || \
                    echo "")

    if [ -n "$EXPECTED_HASH" ] && [ "$FILE_HASH" = "$EXPECTED_HASH" ]; then
      echo "[skip]  skill-registry.md is already up to date"
      exit 0
    fi
  fi

  printf '%s\n' "$REGISTRY_CONTENT" > "$OUTPUT_FILE"
  echo "[ok]    skill-registry.md written to $OUTPUT_FILE"
  echo "[ok]    $(echo "$TABLE_ROWS" | grep -c '|' || true) skill(s) indexed"
fi
