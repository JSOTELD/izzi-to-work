---
name: owasp-security-audit
description: "Comprehensive software attack-surface vulnerability mapping: OWASP Top 10 (SQLi, XSS, CSRF, IDOR), session hygiene, exposed secrets, N+1 query bottlenecks, and technical debt prioritized by severity."
---

# owasp-security-audit · Attack-Surface & Code Quality Auditor

> **Purpose:** Map and evaluate the full security attack surface, performance bottlenecks, and technical debt of a codebase. Every reported finding must trace a verified path from entry point to execution sink.

---

## 1. Audit Methodology

1. **Map Entry Points:** Catalogue every public route, API endpoint, form input, scheduled job, and webhook consumer.
2. **Trace Untrusted Taint:** Follow untrusted input down to its sink (SQL engine, HTML DOM, shell command, filesystem, network call). Findings are only valid if an end-to-end exploit path exists.
3. **Prioritize by Severity:** Categorize issues as **Critical**, **High**, **Medium**, or **Low**.

---

## 2. Threat Vector Checklist

### Security (OWASP Top 10)
- **SQL Injection (SQLi):** String interpolation/concatenation in SQL statements; dynamic `ORDER BY` or `LIMIT` clauses without whitelisting.
- **Cross-Site Scripting (XSS):** Unescaped output, `dangerouslySetInnerHTML`, or unvalidated user content rendered directly into HTML.
- **Cross-Site Request Forgery (CSRF):** State-changing endpoints accessible via GET or lacking anti-CSRF tokens.
- **Insecure Direct Object References (IDOR):** Endpoints loading records by primary key without checking tenant or user ownership.
- **Authentication & Sessions:** Missing session fixation protection (`session_regenerate_id` after login), cookies missing `HttpOnly`/`Secure`/`SameSite` flags, lack of brute-force rate limits.
- **Secret Leaks:** Hardcoded API keys, JWT secrets, private certificates in source files or client-side bundles.

### Performance & Scalability
- **N+1 Queries:** Database lookups executed inside iteration loops.
- **Missing Indexes:** Columns used in `WHERE`, `JOIN`, or `ORDER BY` lacking database index coverage.
- **Unbounded Queries:** Endpoints returning full tables without mandatory pagination limits.

---

## 3. Standard Finding Report Format

Document findings in `docs/security/audit-<YYYY-MM-DD>.md` using this format:

```markdown
### Finding [SEC-01]: Unauthenticated Tenant Invoice Access (IDOR)
- **Severity:** High
- **Category:** Security / Authorization
- **Location:** `src/api/invoices.ts:88`
- **Taint Path:** `req.params.id` passed directly to `db.findInvoice(id)` without verifying `invoice.tenant_id === req.user.tenant_id`.
- **Remediation:** Scope the database query to the authenticated tenant and return `404 Not Found` if missing.
```
