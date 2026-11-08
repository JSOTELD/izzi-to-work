---
name: context-checkpoint
description: "Ultra-lean task state externalization (< 500 tokens) into .claude/checkpoint.md. Applies anti-bloat stdout rules and the Zero-Loss /clear reset protocol for infinite development sessions."
---

# context-checkpoint · Ultra-Lean State Persistence Protocol

> **Purpose:** Prevent context window exhaustion and "compaction thrashing" during long development sessions. Externalize operational state to an ultra-lean disk checkpoint (`< 500` tokens) and maintain complete continuity across session resets (`/clear`).

---

## 1. When to Invoke This Skill

- At the start of any multi-step engineering task (TDD, large refactoring, subagent flows).
- When conversation context exceeds **60% capacity** (~120k tokens) or when compaction latency is observed.
- Before running `/compact` or `/clear` to ensure zero state loss.
- Prior to executing verbose CLI suites (Playwright, Turbo, Vitest, Cypress).

---

## 2. External State vs. In-Context Memory

- **The Failure Mode:** Allowing dozens of turns containing test dumps, verbose stack traces, and multi-thousand-line file reads to pile up in conversation memory. Upon compaction, the model collapses under summarized noise.
- **The Lean Protocol:** Context window RAM is treated as ephemeral. The single source of truth for task progress lives on disk in `.claude/checkpoint.md`.

---

## 3. Mandatory Structure for `.claude/checkpoint.md`

The checkpoint file **MUST NEVER exceed 45 lines** (~300–400 tokens). It strictly follows this structure:

```markdown
# ACTIVE TASK CHECKPOINT
- **Updated:** YYYY-MM-DD HH:mm:ss
- **Objective:** [Single-line description of the active task]
- **Git Branch:** [branch-name] | **Worktree:** [path-or-root]
- **Last Commit:** [short-hash] - [commit message]

## 1. Completed Items
- [x] [Milestone 1: Entities and database migrations created]
- [x] [Milestone 2: Core endpoints implemented and tested]

## 2. Immediate State / Pending Files
- `src/lib/calculator.ts` (modified, uncommitted)
- `tests/calculator.spec.ts` (passing in green)

## 3. Critical Architectural Constraints
- Rule 1: Currency handled via Decimal arithmetic with banker's half-even rounding
- Rule 2: RLS enabled and forced on all tables

## 4. Exact Next Step
- [Immediate actionable instruction to execute upon resuming]
```

---

## 4. Anti-Bloat stdout Rules

1. **Test Suites & Compiler Outputs:**
   - **NEVER** pipe test outputs directly to stdout if they exceed 30 lines.
   - **ALWAYS** redirect to a temp file and read only the summary or failures:
     ```bash
     npx turbo run test > /tmp/run.log 2>&1 || tail -n 30 /tmp/run.log
     ```
2. **Git Diffs:**
   - Run `git diff --stat` first to gauge changed surface area. Only inspect targeted files with `git diff <file>`.
3. **Large File Reads:**
   - Use line ranges (`offset` and `limit`) instead of dumping 500+ lines into memory.

---

## 5. Zero-Loss Reset Protocol (`/clear`)

When context window usage reaches capacity:
1. **Update Checkpoint:** Write fresh state and exact next step into `.claude/checkpoint.md`.
2. **Commit Working Tree:** Ensure stable changes are committed or stashed cleanly.
3. **Execute Reset:** Run `/clear` to reset context to 0 tokens.
4. **Instant Resume:** Instruct the clean agent:
   > *"Read `.claude/checkpoint.md` and execute the 'Exact Next Step'."*

