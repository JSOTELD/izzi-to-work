---
name: token-budget-guard
description: "Enforces strict token budget conservation. Mandates redirecting verbose CLI test outputs to temp logs, filtering for failures via grep, and using targeted file reads with offset and limit."
---

# token-budget-guard · CLI & Context Window Protection

> **Purpose:** Protect the agent's context window from explosive token consumption caused by verbose CLI outputs (package installations, test runners, build logs) and oversized file inspections.

---

## 1. Golden Rules of Token Budgeting

1. **Stdout Capping:** Any command likely to produce more than 25 lines of terminal output must be redirected to a temporary log file.
2. **Failure-Only Grepping:** Never read full raw log files into context. Search specifically for failure indicators (`FAIL`, `ERR`, `AssertionError`, `exit code`).
3. **Chunked Reading:** Use `offset` and `limit` on file reads. Never load a 1,000-line file when only a 30-line function is needed.

---

## 2. Command Redirection Patterns

### Test Suites (Jest, Vitest, Pytest, Go Test, PHPUnit)
```bash
# Unix / Git Bash
npm test > /tmp/run.log 2>&1 || grep -E -C 3 "FAIL|ERR|AssertionError" /tmp/run.log | head -n 35

# Windows PowerShell
npm test > "$env:TEMP\run.log" 2>&1; if ($LASTEXITCODE -ne 0) { Select-String -Path "$env:TEMP\run.log" -Pattern "FAIL|ERR" -Context 2 | Select-Object -First 30 }
```

### Builds and Bundlers (Webpack, Vite, Turbo, Next.js)
```bash
# Capture full output, display only final exit status and summary line
npx turbo build > /tmp/build.log 2>&1 || tail -n 25 /tmp/build.log
```

---

## 3. Pre-Read File Size Auditing

Before issuing a file read tool call:
- If file length is unknown, run a quick line count:
  ```bash
  wc -l path/to/file.ts
  ```
- If line count exceeds 300 lines, use targeted grep (`grep -n "symbolName" path/to/file.ts`) to locate the line number, followed by targeted reading:
  - `StartLine = match_line - 10`
  - `EndLine = match_line + 40`

