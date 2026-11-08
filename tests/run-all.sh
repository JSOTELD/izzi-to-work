#!/usr/bin/env bash
# Master test runner for izzi-to-work
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "================================================="
echo "  Running izzi-to-work test suite"
echo "================================================="

# 1. Antigravity plugin manifest & layout tests
echo ""
echo "--- [1/5] Running Antigravity plugin tests ---"
bash "$SCRIPT_DIR/antigravity/test-plugin-manifest.sh"
bash "$SCRIPT_DIR/antigravity/test-antigravity-tools.sh"
bash "$SCRIPT_DIR/antigravity/test-logo.sh"

# 2. Skill size & frontmatter validation
echo ""
echo "--- [2/5] Running Skill size and frontmatter tests ---"
bash "$SCRIPT_DIR/skill-size/test-skill-size.sh"

# 3. Version bump & manifest synchronization
echo ""
echo "--- [3/5] Running Version synchronization tests ---"
bash "$SCRIPT_DIR/version-bump/test-bump-version.sh"

# 4. Session start & cross-platform hooks
echo ""
echo "--- [4/5] Running Hook dispatch and session start tests ---"
bash "$SCRIPT_DIR/hooks/test-session-start.sh"

# 5. CLI version audit
echo ""
echo "--- [5/5] Running repo-wide version audit ---"
bash "$REPO_ROOT/scripts/bump-version.sh" --audit

echo ""
echo "================================================="
echo "  ALL TESTS PASSED WITH FLYING COLORS (Exit 0)   "
echo "================================================="
exit 0
