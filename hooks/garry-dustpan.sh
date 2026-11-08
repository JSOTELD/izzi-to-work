#!/usr/bin/env bash
# Garry Dustpan: Automated Lifecycle Context Cleaner & Memory Restoration
# Supports Stop, PreCompact, and PostCompact modes.

set -euo pipefail

MODE="${1:-Stop}"
WORK_DIR="$(pwd)"
CLAUDE_DIR="${WORK_DIR}/.claude"
CHECKPOINT_PATH="${CLAUDE_DIR}/checkpoint.md"
CONTROL_PATH="${WORK_DIR}/docs/plan/CHECKPOINT.md"

update_checkpoint_meta() {
  mkdir -p "${CLAUDE_DIR}"
  local now
  now="$(date '+%Y-%m-%d %H:%M:%S')"
  local branch
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-git")"
  local last_commit
  last_commit="$(git log -1 --oneline 2>/dev/null || echo "no-commits")"
  local recent_commits
  recent_commits="$(git log -n 5 --oneline 2>/dev/null | sed 's/^/  - /' || echo "  - none")"
  local dirty_files
  dirty_files="$(git status --short 2>/dev/null | sed 's/^/  /' || echo "  (clean tree)")"

  if [ ! -f "${CHECKPOINT_PATH}" ]; then
    cat > "${CHECKPOINT_PATH}" <<EOF
# GARRY DUSTPAN · ACTIVE TASK CHECKPOINT
- **Updated:** ${now}
- **Git Branch:** ${branch}
- **Last Commit:** ${last_commit}

## 1. Completed Items
  - [x] Initial checkpoint created

## 2. Recent Commits
${recent_commits}

## 3. Immediate State / Modified Files
${dirty_files}

## 4. Exact Next Step
  - Continue implementing tasks from spec or plan
EOF
  else
    local tmp="${CHECKPOINT_PATH}.tmp"
    sed -E \
      -e "s/^- \*\*(Timestamp|Updated|Actualizado):\*\*.*$/- **Updated:** ${now}/" \
      -e "s/^- \*\*(Last Commit|Último Commit):\*\*.*$/- **Last Commit:** ${last_commit}/" \
      -e "s/^- \*\*(Git Branch|Rama Git):\*\*.*$/- **Git Branch:** ${branch}/" \
      "${CHECKPOINT_PATH}" > "${tmp}" && mv "${tmp}" "${CHECKPOINT_PATH}"
  fi
}

case "${MODE}" in
  Stop|PreCompact)
    update_checkpoint_meta
    exit 0
    ;;
  PostCompact)
    update_checkpoint_meta
    echo "=== GARRY DUSTPAN: POST-COMPACTION MEMORY RESTORED ==="
    if [ -f "${CHECKPOINT_PATH}" ]; then
      head -n 45 "${CHECKPOINT_PATH}"
    fi
    if [ -f "${CONTROL_PATH}" ]; then
      echo ""
      echo "--- Excerpt from docs/plan/CHECKPOINT.md ---"
      tail -n 25 "${CONTROL_PATH}"
    fi
    echo "=== END GARRY DUSTPAN (Resume from Exact Next Step without rescanning repo) ==="
    exit 0
    ;;
  *)
    echo "Unknown mode: ${MODE}" >&2
    exit 1
    ;;
esac

