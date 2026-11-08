---
name: postgres-live-testing
description: "Local real PostgreSQL integration testing instead of in-memory mocks. Tests real concurrency (SELECT ... FOR UPDATE SKIP LOCKED), live RLS policies via SET ROLE, EXCLUDE constraints, and orphaned test DB cleanup."
---

# postgres-live-testing · Real PostgreSQL Integration Testing

> **Purpose:** Test database interactions against a live, genuine PostgreSQL instance instead of in-memory emulators or mocks. In-memory databases do not replicate real transactional locking, PostgreSQL-specific concurrency semantics, or native Row Level Security (RLS) enforcement.

---

## 1. When to Invoke This Skill

- Before opening or merging any PR touching SQL migrations, database schemas, or query repositories.
- When validating concurrency behavior: `SELECT ... FOR UPDATE SKIP LOCKED`, concurrent job queues, duplicate webhook idempotency, or simultaneous balance updates.
- When testing live RLS policies under authenticated database roles.

---

## 2. Real PostgreSQL vs. In-Memory Mocks

| Capability | In-Memory Emulators (Mock/SQLite) | Real Live PostgreSQL |
|:-----------|:----------------------------------|:---------------------|
| Row Level Security (RLS) | Simulated or absent | Genuine kernel enforcement via `SET ROLE` |
| Concurrency Locking | Table-level or fake locks | `SELECT ... FOR UPDATE SKIP LOCKED` |
| Advanced Constraints | Unsupported | `EXCLUDE USING gist`, partial unique indexes |
| Native Types | Emulated strings | Real UUIDv7, CITEXT, JSONB operators |

---

## 3. Dynamic Ephemeral Test Databases

Each test runner creates a dynamically named database (e.g., `test_db_<hash>`), applies migrations, executes tests, and drops the database on teardown:

```typescript
// Setup
const dbName = `test_db_${crypto.randomBytes(4).toString('hex')}`;
await adminClient.query(`CREATE DATABASE ${dbName}`);
// Run migrations & execute tests...
// Teardown
await adminClient.query(`DROP DATABASE ${dbName} WITH (FORCE)`);
```

---

## 4. Cleaning Orphaned Test Databases

If a test process terminates abruptly (SIGINT or out-of-memory), ephemeral databases may remain. Clean them using this procedural SQL:

```sql
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT datname FROM pg_database WHERE datname LIKE 'test_db_%') LOOP
        EXECUTE 'DROP DATABASE ' || quote_ident(r.datname) || ' WITH (FORCE)';
        RAISE NOTICE 'Dropped orphaned test DB: %', r.datname;
    END LOOP;
END $$;
```
