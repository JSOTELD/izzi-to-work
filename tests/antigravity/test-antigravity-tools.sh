#!/usr/bin/env bash
# Validate the Antigravity (agy) tool mapping: subagent dispatch via
# invoke_subagent (self/research types), task tracking via a task artifact, and
# SKILL.md pointing at the mapping.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

MAPPING="$REPO_ROOT/skills/using-izzi-to-work/references/antigravity-tools.md"
SKILL="$REPO_ROOT/skills/using-izzi-to-work/SKILL.md"

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "test-antigravity-tools: checking Antigravity tool mapping"

[ -f "$MAPPING" ] || fail "tool mapping missing at $MAPPING"

for tool in write_to_file replace_file_content invoke_subagent; do
  grep -q "$tool" "$MAPPING" \
    || fail "mapping does not document the '$tool' tool"
done

grep -q '`self`' "$MAPPING" \
  || fail "mapping does not document the built-in 'self' subagent type"
grep -q '`research`' "$MAPPING" \
  || fail "mapping does not document the built-in 'research' subagent type"

grep -qE 'ArtifactType.*task|task. artifact' "$MAPPING" \
  || fail "mapping does not document task tracking as a 'task' artifact"

grep -q "antigravity-tools.md" "$SKILL" \
  || fail "SKILL.md Platform Adaptation does not reference antigravity-tools.md"

echo "PASS: Antigravity tool mapping valid (subagent dispatch, task artifact, SKILL.md link)"

