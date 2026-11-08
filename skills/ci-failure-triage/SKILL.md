---
name: ci-failure-triage
description: "Token-efficient CI/CD troubleshooting using GitHub CLI (gh run view --log-failed). Isolates runner/environment anomalies from code defects and reproduces failures in clean worktrees."
---

# ci-failure-triage · Token-Efficient CI/CD Diagnostic Protocol

> **Purpose:** Triage and resolve failed continuous integration (CI) workflows rapidly without dumping thousands of lines of raw build runner logs into conversational context.

---

## 1. Targeted Failure Log Extraction

Avoid downloading or viewing the full CI run log. Use targeted GitHub CLI commands to extract **only the failing step**:

```bash
# View only the failed steps from the latest run
gh run view --log-failed

# Filter specifically for the exit code and error trace
gh run view --log-failed | grep -E -C 4 "FAIL|Error:|Exit code [1-9]" | head -n 40
```

---

## 2. Isolating Runner vs. Code Defects

Classify the failure into one of two categories before touching code:

1. **Environment / Runner Issues:**
   - Network timeout downloading dependencies (`npm install`, `apt-get`, Docker pull).
   - Missing environment variables, secrets, or service containers (PostgreSQL, Redis).
   - Disk space exhaustion or runner host CPU limits.
   - *Action:* Re-run failed jobs (`gh run rerun --failed`) or fix workflow YAML configuration without altering application logic.

2. **Genuine Code Regressions:**
   - Unit or integration test assertion failure.
   - Type-checking or lint error (`tsc`, `eslint`, `phpstan`).
   - *Action:* Reproduce locally in an isolated clean worktree.

---

## 3. Clean Worktree Reproduction

Never troubleshoot CI failures in an unclean or dirty working tree:

```bash
# Create an ephemeral worktree identical to the remote CI commit
git worktree add ../ci-triage-temp HEAD
cd ../ci-triage-temp

# Execute the exact failing command from the CI matrix
npm test -- tests/failing.spec.ts

# Clean up after verification
cd -
git worktree remove ../ci-triage-temp
```
