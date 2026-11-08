---
name: api-contract-and-error-resilience
description: "Type-safe API contracts via OpenAPI/schemas, functional error handling (Result<T, E>), absolute ban on silent catch blocks, and semantic HTTP status codes."
---

# api-contract-and-error-resilience · Contracts & Robust Error Handling

> **Purpose:** Build rock-solid backend and client communication through schema-driven type-safe API contracts, explicit functional error representations, and zero unhandled exceptions or swallowed errors.

---

## 1. The Result<T, E> Pattern (No Unchecked Exceptions)

Instead of scattering uncontrolled `throw new Error()` throughout business logic, use explicit Result types:

```typescript
export type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

export const Ok = <T>(value: T): Result<T, never> => ({ ok: true, value });
export const Err = <E>(error: E): Result<never, E> => ({ ok: false, error });
```

Callers are compelled by the TypeScript compiler to branch on `result.ok` before accessing `result.value`.

---

## 2. Absolute Ban on Silent Catch Blocks

- **Forbidden Pattern:**
  ```typescript
  try {
    await performCriticalTask();
  } catch (err) {
    // Silent catch — swallowed error!
  }
  ```
- **Rule:** Every catch block must either rethrow, log with structured context, or return an explicit `Err` result to the caller.

---

## 3. Semantic HTTP Status Codes Matrix

| Code | Semantics | When to Use |
|:-----|:----------|:------------|
| `200 OK` | Success | Successful read or synchronous update |
| `201 Created` | Resource Created | New record generated (include `Location` header) |
| `400 Bad Request` | Validation Failure | Malformed body, missing schema fields |
| `401 Unauthorized` | Missing Authentication | User session expired or unauthenticated |
| `404 Not Found` | Absent / Obscured | Resource does not exist or belongs to another tenant |
| `409 Conflict` | State Collisions | Idempotency collision, duplicate unique key |
| `422 Unprocessable` | Domain Rule Violation | Valid syntax but invalid business state |
| `500 Server Error` | Unexpected Crash | Unhandled defect in system infrastructure |
