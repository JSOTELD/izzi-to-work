---
name: lean-playwright-e2e
description: "Silent, anti-bloat Playwright E2E execution with mandatory dual-viewport visual WCAG verification: Mobile 360px (360x800) and Desktop 1280px (1280x720)."
---

# lean-playwright-e2e · Silent E2E & Dual-Viewport Visual Verification

> **Purpose:** Execute visual verification and end-to-end (E2E) browser flows with Playwright to enforce WCAG 2.2 AA accessibility across standard viewports without overflowing token context.

---

## 1. When to Invoke This Skill

- Delivering new user-facing screens, modals, checkout steps, or admin dashboards.
- Validating visual accessibility: color contrast, minimum 44x44px touch targets, responsive adaptivity.
- Running local Playwright suites without generating massive terminal logs.

---

## 2. Standard Dual Viewports

All visual evidence for UI deliveries must capture both extremes:

1. **Mobile Viewport (360px):**
   - Width: `360px` | Height: `800px`
   - Checks: **Zero horizontal overflow**, touch targets >= 44x44px, legible typography without pinching/zooming, uncluttered layout.
2. **Desktop Viewport (1280px):**
   - Width: `1280px` | Height: `720px`
   - Checks: Balanced multi-column distribution, centered modals, functional sidebars, proper data grids.

---

## 3. Silent Execution Pattern (Anti-Bloat)

**Rule:** NEVER run `npx playwright test` without redirecting stdout to a temporary log. A single headless browser run can produce megabytes of trace text.

```bash
# Execute to temporary log file and display only the tail on failure
npx playwright test e2e/checkout.spec.ts --reporter=list > /tmp/e2e.log 2>&1 || tail -n 25 /tmp/e2e.log
```

---

## 4. Visual Evidence Reporting

Save evidence screenshots to `scratchpad/evidence/<module>/<screen>-360.png` and `-1280.png`. Report using this concise block:

```markdown
### Visual E2E Evidence (lean-playwright-e2e)
- **Executed Suite:** `e2e/checkout.spec.ts` (Exit 0, 4/4 passing)
- **Mobile Capture (360x800):** `scratchpad/evidence/checkout/summary-360.png`
- **Desktop Capture (1280x720):** `scratchpad/evidence/checkout/summary-1280.png`
- **WCAG Verification:** Zero horizontal scroll at 360px, visible focus states verified on all interactable elements.
```
