---
name: financial-integrity
description: "Strict monetary engineering rules: absolute ban on floating-point numbers for currency (mandatory Decimal/NUMERIC), banker's half-even rounding, 404 anti-enumeration responses, and mandatory RLS."
---

# financial-integrity · Monetary Precision & Security Guardrails

> **Purpose:** Enforce non-negotiable financial engineering rules: total elimination of floating-point drift in balances and currency calculations, banker's half-even rounding, anti-enumeration HTTP status codes, and mandatory database Row Level Security (RLS).

---

## 1. The 5 Inviolable Rules of Financial Systems

### Rule 1: Money NEVER Uses Floating-Point Numbers
- **Forbidden:** IEEE 754 floats (`number` in TypeScript/JS, `float` in Python/PHP). Example: `0.1 + 0.2 === 0.30000000000000004`.
- **Mandatory:** Arbitrary-precision decimal libraries (`Decimal` in TypeScript/Python, `BigDecimal` in Java, `BCMath` in PHP).
- **Storage:** Database columns must strictly use `NUMERIC(14, 2)` for currency and `NUMERIC(18, 6)` for fractional exchange rates/crypto. Never use `REAL`, `FLOAT`, or `DOUBLE PRECISION`.

### Rule 2: Banker's Rounding (Half-Even) for Currency
- **Forbidden:** Standard `Math.round()` or `toFixed(2)`, which introduce positive cumulative bias over thousands of balance transactions.
- **Mandatory:** Round half to even: when the fraction is exactly halfway (`.005`), round to the nearest even number (`1.245 -> 1.24`, `1.255 -> 1.26`).

### Rule 3: Anti-Enumeration 404 Responses (404 vs. 403)
- **Forbidden:** Returning `403 Forbidden` when an authenticated user attempts to access or query a resource (invoice, wallet, transaction) owned by a different user/tenant.
- **Security Vulnerability:** `403` informs the attacker that the resource ID exists, facilitating IDOR enumeration.
- **Mandatory:** Return `404 Not Found`. To an unauthorized tenant, foreign resources do not exist.

### Rule 4: Mandatory PostgreSQL Row Level Security (RLS)
- Every table holding tenant, user, or financial records must enforce database-level isolation:
  ```sql
  ALTER TABLE public.wallets ENABLE ROW LEVEL SECURITY;
  ALTER TABLE public.wallets FORCE ROW LEVEL SECURITY;
  ```

### Rule 5: Immutable Financial Ledgers
- Financial balances must never be mutated via arbitrary `UPDATE balance = balance + X` without an immutable ledger entry.
- Every balance mutation must have a corresponding signed transaction record with an idempotency key.

