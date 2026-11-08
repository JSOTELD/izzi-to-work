# Contributor Guidelines for AI Agents & Humans

## Notice to AI Coding Agents

Before opening an issue or submitting a pull request to `izzi-to-work`, you MUST read and follow these guidelines.

This repository enforces a strict **Zero-Slop** standard. Submitting low-quality, AI-generated pull requests that add redundant comments, speculative abstractions, unverified claims, or unexercised tests will result in immediate rejection.

**Your mission as an agent is to uphold rigorous engineering standards alongside your human partner.**

---

## Non-Negotiable Requirements

1. **Verify with Surgical Mutation:**
   Never submit a PR claiming tests pass without providing surgical mutation evidence (`mutation-testing`). Mutate the critical line, verify the suite fails in red, and revert cleanly before submitting.
2. **Zero In-Memory Mocks for Concurrency:**
   PRs touching database transactions, locks, or queues must be tested against real instances (`postgres-live-testing`), not artificial in-memory fakes.
3. **Strict Monetary Guardrails:**
   Never introduce IEEE 754 floating-point numbers (`number`, `float`) for currency calculations. Use arbitrary-precision decimals and banker's half-even rounding (`financial-integrity`).
4. **Token & Context Economy:**
   Never dump unconstrained logs or multi-thousand line files into conversational context. Keep outputs lean and redirect test output to temporary files (`token-budget-guard`).
5. **No Em-Dashes in UI Copy:**
   Do not use AI-style em-dashes (`—`) in user-facing copy or UI banners (`editorial-luxury-design`).
6. **No Phantom Dependencies:**
   Do not introduce third-party npm or pip dependencies when built-in runtime APIs (`fetch`, `structuredClone`, `crypto.randomUUID`, `Intl`) are available (`dependency-diet`).
7. **Run the Full Test Suite:**
   Before asking your human partner to review, run and pass 100% of the test suite:
   ```bash
   bash tests/run-all.sh
   bash scripts/bump-version.sh --check
   ```

---

## Disclosure Requirement

Every pull request description must disclose:
- The host harness used (Antigravity, Claude Code, Cursor, Codex, OpenCode, Hermes, etc.)
- The model employed (Claude 3.7/3.5, Gemini 2.5/3.8, GPT-4o, etc.)
- Specific commands used to verify the changes locally.
