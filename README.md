# Izzi to Work

[![Release](https://img.shields.io/github/v/release/JSOTELD/izzi-to-work?color=blue)](https://github.com/JSOTELD/izzi-to-work)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Google Antigravity](https://img.shields.io/badge/Google_Antigravity-native-0ea5e9.svg)](https://github.com/JSOTELD/izzi-to-work)
[![Claude Code](https://img.shields.io/badge/Claude_Code-compatible-7c3aed.svg)](https://github.com/JSOTELD/izzi-to-work)
[![Cursor](https://img.shields.io/badge/Cursor-compatible-10b981.svg)](https://github.com/JSOTELD/izzi-to-work)
[![Codex](https://img.shields.io/badge/Codex-compatible-f59e0b.svg)](https://github.com/JSOTELD/izzi-to-work)
[![OpenCode](https://img.shields.io/badge/OpenCode-v1_&_v2-ec4899.svg)](https://github.com/JSOTELD/izzi-to-work)
[![Hermes](https://img.shields.io/badge/Hermes-plugin-6366f1.svg)](https://github.com/JSOTELD/izzi-to-work)
[![Pi](https://img.shields.io/badge/Pi-extension-14b8a6.svg)](https://github.com/JSOTELD/izzi-to-work)

**Izzi to Work** is a production-grade, multi-harness agentic skills framework and engineering discipline suite. Built for the global open-source developer community, it brings uncompromising software engineering standards to AI coding assistants: ultra-lean context externalization, surgical mutation testing, real PostgreSQL concurrency verification, monetary safety guards, 11-section spec-driven architecture, and multi-agent blind voting governance.

---

## The 25 Skills Catalog Across 5 Engineering Pillars

| Pillar | # | Skill | Purpose & Core Protocol |
|:-------|:-:|:------|:------------------------|
| **1. Context & Token Economy** | 01 | `using-izzi-to-work` | Master bootstrap skill. Maps platform tools and prevents rationalized bypass of engineering rules. |
| | 02 | `context-checkpoint` | Ultra-lean task state externalization (`< 500` tokens) into `.claude/checkpoint.md` with Zero-Loss `/clear` reset. |
| | 03 | `auto-compact-dustpan` | Automated lifecycle context cleaner using system hooks (`Stop`, `PreCompact`, `SessionStart:compact`) at 65% capacity. |
| | 04 | `token-budget-guard` | Redirects verbose test runs to temporary logs, greps for `FAIL\|ERR`, and enforces chunked reads (`offset`/`limit`). |
| **2. Testing, Database & Git Rigor** | 05 | `mutation-testing` | 4-step surgical mutation verification: mutate 1 line, verify test fails red, and cleanly revert (`git checkout`). |
| | 06 | `lean-playwright-e2e` | Silent, anti-bloat Playwright execution with dual-viewport WCAG verification: Mobile 360px (`360x800`) & Desktop 1280px (`1280x720`). |
| | 07 | `postgres-live-testing` | Local real PostgreSQL integration testing: `SELECT ... FOR UPDATE SKIP LOCKED`, live RLS under `SET ROLE`, and orphaned DB cleanup. |
| | 08 | `zero-downtime-migrations` | Non-blocking database schema evolution: expand-contract migrations, `CREATE INDEX CONCURRENTLY`, and lock timeouts. |
| | 09 | `ci-failure-triage` | Token-efficient CI/CD troubleshooting (`gh run view --log-failed`), isolating runner anomalies from code regressions. |
| | 10 | `git-rebase-conflict-resolver` | Surgical Git conflict resolution: merge-base inspection, semantic reconciliation, and zero leftover markers. |
| **3. Architecture, Finance & Security** | 11 | `financial-integrity` | Absolute ban on IEEE 754 floats for currency (mandatory `Decimal`/`NUMERIC`), banker's half-even rounding, and 404 anti-enumeration. |
| | 12 | `admin-console-patterns` | Back-office patterns: indexed server-side pagination, CSV injection neutralization (`sanitizeCsvCell`), and MFA modals (`X-Admin-Reauth-Token`). |
| | 13 | `idempotent-transactions` | Payment webhook safety, mandatory `Idempotency-Key` tracking, constant-time HMAC validation, and parallel concurrency tests. |
| | 14 | `spec-driven-architecture` | Generates 11-section system engineering specs: functional/NFR requirements, Mermaid `erDiagram`, DDL, sequences, and UI states. |
| | 15 | `owasp-security-audit` | End-to-end attack surface auditing: SQLi, XSS, CSRF, IDOR, session hygiene, exposed secrets, and N+1 query bottlenecks. |
| | 16 | `secret-leak-sentinel` | Pre-commit diff scanner detecting leaked credentials and tokens (OpenAI, Anthropic, AWS, GCP, Stripe, private keys). |
| | 17 | `privacy-compliance` | Consumer data protection (GDPR, CCPA): unbundled consent without pre-checked boxes, Consent Mode v2 gating, and PII log masking. |
| | 18 | `api-contract-and-error-resilience` | Type-safe API contracts via OpenAPI, functional error handling (`Result<T, E>`), zero silent catches, and semantic HTTP codes. |
| **4. UI/UX, Anti-Slop & Design** | 19 | `anti-slop-pruner` | Detects and removes AI code bloat: redundant obvious comments, micro-abstractions, and cliché AI styling. |
| | 20 | `editorial-luxury-design` | Refined chromatic tokens, self-hosted serif/sans typography (`tabular-nums`), warm accessible skeletons (`aria-busy`), and total ban on em-dashes (`—`). |
| | 21 | `ux-heuristic-audit` | Senior UI review applying Nielsen's 10 heuristics, UX laws (Fitts, Hick, Proximity), measured contrast, and mandatory 4-state handling. |
| | 22 | `responsive-pixel-police` | Mobile layout enforcement: zero horizontal scroll at 360px viewport width, >= 44x44px touch targets, and iOS Safari zoom prevention. |
| | 23 | `dependency-diet` | Enforces modern native runtime APIs (`fetch`, `structuredClone`, `crypto.randomUUID`, `Intl`) before approving external packages. |
| **5. Multi-Agent Governance** | 24 | `blind-voting-board` | Multi-agent blind-voting protocol for irreversible architectural decisions: independent 2-round voting across specialized seats producing an `ADR-00X.md`. |
| | 25 | `zero-trust-squad` | Decoupled multi-agent squad: task implementer, lightweight test runner, independent PR verifier, and user profile simulator. |

---

## Installation Across Harnesses

### Google Antigravity CLI / IDE (`agy`)
Clone or install into your Antigravity plugins directory:
```bash
agy plugin install https://github.com/JSOTELD/izzi-to-work.git
```
Or clone directly into your workspace:
```bash
git clone https://github.com/JSOTELD/izzi-to-work.git .antigravity-plugin/izzi-to-work
```

### Claude Code
Install as a Claude Code plugin:
```bash
claude plugins install https://github.com/JSOTELD/izzi-to-work.git
```

### Cursor
Add to your project's `.cursor/settings.json` or link in `.cursor-plugin/plugin.json`:
```json
{
  "cursor.plugin": "./.cursor-plugin/plugin.json"
}
```

### Codex CLI
```bash
codex plugins install https://github.com/JSOTELD/izzi-to-work.git
```

### OpenCode (v1 & v2)
Add to your `opencode.json`:
```json
{
  "plugins": [
    "https://github.com/JSOTELD/izzi-to-work.git"
  ]
}
```

### Hermes Agent
```bash
hermes plugins install https://github.com/JSOTELD/izzi-to-work.git
```

### Pi Coding Agent
Add to `package.json`:
```json
{
  "pi": {
    "extensions": ["./.pi/extensions/izzi-to-work.ts"],
    "skills": ["./skills"]
  }
}
```

---

## Automated Verification Suite

Run the full test suite locally:
```bash
bash tests/run-all.sh
bash scripts/bump-version.sh --check
```

Validate with the Antigravity CLI:
```bash
agy plugin validate .
```

---

## Philosophy & Core Values

1. **Uncompromising Discipline:** We do not skip tests, ignore race conditions, or accept unverified assumptions.
2. **Token Economy:** AI agent context is finite and valuable. Protect memory with checkpoints and anti-bloat stdout rules.
3. **Zero Slop:** We reject conversational clutter, redundant comments, and performative boilerplate. Code must be clean, dense, and human.
4. **Zero Trust Verification:** An agent cannot objectively review its own code. Verification must be independent, adversarial, and backed by surgical mutation evidence.

---

## License

MIT © 2026 [JSOTELD](mailto:j.soteld@gmail.com). Free and open-source software for the global developer community.
