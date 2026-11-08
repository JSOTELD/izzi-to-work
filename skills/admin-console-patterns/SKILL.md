---
name: admin-console-patterns
description: "Support and administrative console architecture: RBAC, server-side pagination, CSV injection formula sanitization (sanitizeCsvCell), high-risk actions with re-auth modals (X-Admin-Reauth-Token), and tabular KPI metrics."
---

# admin-console-patterns · Administrative & Support Console Architecture

> **Purpose:** Architectural patterns, security controls, and UX standards for administrative portals, support consoles, and back-office management interfaces.

---

## 1. Core Architectural Standards

### 1. Indexed Server-Side Pagination
- Administrative tables must **never** load unconstrained query sets (`SELECT * FROM table`).
- Enforce strict parameter bounds: `limit` (default 20, max 100), `cursor` or `offset`, and indexed filter attributes (`status`, `date_range`).
- Default order: descending on creation timestamps (`ORDER BY created_at DESC`).

### 2. CSV Formula Injection Defense
- **The Threat:** When operators export customer data into spreadsheet applications (Excel, Google Sheets), malicious entries starting with `=`, `+`, `-`, `@`, `\t`, or `\r` can execute arbitrary commands or trigger DDE remote code execution.
- **Mandatory Sanitization Helper:** Prefix any suspect cell with a single quote (`'`):
  ```typescript
  export function sanitizeCsvCell(value: string): string {
    if (/^[=+\-@\t\r]/.test(value)) {
      return `'${value}`;
    }
    return value;
  }
  ```

### 3. Destructive Actions with Two-Factor Re-authentication
For high-risk operations (account termination, manual balance adjustments, role privilege elevation):
1. **Confirmation Modal:** Display a modal detailing the exact blast radius.
2. **Explicit Affirmation:** Require the operator to type the target account's identifier or their current admin password.
3. **Re-authentication Token:** Transmit header `X-Admin-Reauth-Token` to the backend verifying recent MFA/re-auth.

### 4. Tabular KPI Metrics Cards
- Key performance metrics (revenue, active users, churn, open support tickets) presented with clean typography and delta indicators versus preceding periods.
- Format currency with explicit currency symbols and banker's rounding.
- Avoid resource-heavy charting libraries when lightweight SVG sparklines or tables suffice.

