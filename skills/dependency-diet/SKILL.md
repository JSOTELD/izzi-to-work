---
name: dependency-diet
description: "Dependency bloat auditor: enforcing modern native runtime APIs (fetch, structuredClone, crypto.randomUUID, Intl) before approving any new third-party npm/pip packages."
---

# dependency-diet · Dependency Bloat Auditor

> **Purpose:** Prevent software supply chain inflation, slow cold starts, and security vulnerabilities by enforcing modern built-in runtime APIs before accepting any third-party library dependencies.

---

## 1. Native API Substitution Matrix

Before adding any external package to `package.json` or `pyproject.toml`, check whether a built-in native API exists:

| Deprecated / Bloated Library | Modern Built-in Native API | Runtime Availability |
|:-----------------------------|:---------------------------|:---------------------|
| `axios`, `request`, `got` | `fetch()` | Node 18+, Browsers, Bun, Deno |
| `lodash.clonedeep` | `structuredClone()` | Node 17+, Modern Browsers |
| `uuid` | `crypto.randomUUID()` | Node 15.6+, Modern Browsers |
| `moment.js`, `dayjs` | `Intl.DateTimeFormat`, `Temporal` | Modern Standard Engines |
| `numeral.js` | `Intl.NumberFormat` | Modern Standard Engines |
| `querystring` | `URLSearchParams` | Universal Web Standard |
| `rimraf` | `fs.rmSync(path, { recursive: true, force: true })` | Node 14.14+ |
| `mkdirp` | `fs.mkdirSync(path, { recursive: true })` | Node 10.12+ |

---

## 2. Dependency Vetting Checklist

If a library must be considered, it must satisfy all 4 criteria:
1. **Zero Alternatives:** Cannot be implemented in under 50 lines of native code.
2. **Maintenance Health:** Actively maintained with releases in the last 6 months.
3. **No Heavy Transitive Trees:** Inspect dependency count with `npm view <package> dependencies`.
4. **License Compliance:** Permissive open-source license (MIT, Apache-2.0, BSD-3-Clause).
