#!/usr/bin/env bash
# Validates that all SKILL.md files are under 20,000 bytes with valid YAML frontmatter.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LIMIT=20000

echo "test-skill-size: validating all SKILL.md files are under $LIMIT bytes"

failed=0
count=0
for skill in "$REPO_ROOT"/skills/*/SKILL.md; do
  count=$((count + 1))
  size=$(wc -c <"$skill" | tr -d ' \r\n')
  if ((size >= LIMIT)); then
    echo "FAIL: ${skill#"$REPO_ROOT"/} is $size bytes (limit: under $LIMIT)" >&2
    failed=1
  fi
  # Validate YAML frontmatter existence
  if ! grep -q "^---" "$skill"; then
    echo "FAIL: ${skill#"$REPO_ROOT"/} missing YAML frontmatter" >&2
    failed=1
  fi
done

if ((count < 25)); then
  echo "FAIL: expected at least 25 skills, found $count" >&2
  exit 1
fi

if ((failed)); then
  exit 1
fi
echo "PASS: all $count SKILL.md files are under $LIMIT bytes with valid frontmatter"

