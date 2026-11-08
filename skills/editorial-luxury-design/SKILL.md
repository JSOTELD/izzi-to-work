---
name: editorial-luxury-design
description: "High-end editorial design system: refined chromatic token architecture, self-hosted serif/sans typography with tabular-nums, accessible warm loading skeletons (aria-busy), and an absolute ban on AI em-dashes."
---

# editorial-luxury-design · High-End Editorial Aesthetics

> **Purpose:** Elevate web applications with editorial luxury design principles: balanced chromatic palettes, artisanal typography hierarchy, warm tactile feedback, and total rejection of sterile AI styling.

---

## 1. Chromatic Token Architecture

Avoid generic gray and neon defaults. Build with rich, cohesive color systems:

```css
:root {
  /* Editorial Palette: Forest, Honey Gold, Warm Cream, Deep Charcoal */
  --color-primary: #1e3a2b;       /* Forest 800 */
  --color-primary-light: #2d543f; /* Forest 700 */
  --color-accent: #d97706;        /* Honey Amber 600 */
  --color-accent-gold: #f59e0b;   /* Honey 500 */
  --color-bg-canvas: #fcfbf9;     /* Warm Alabaster Cream */
  --color-bg-surface: #ffffff;    /* Pure Card Surface */
  --color-text-main: #1c1917;     /* Stone 900 */
  --color-text-muted: #57534e;    /* Stone 600 */
  --color-border: #e7e5e4;        /* Stone 200 */
}
```

---

## 2. Typography & Numerical Precision

- **Editorial Pairing:** Pair an authoritative serif headline font (e.g., Noto Serif, Playfair, Cormorant) with a clean, legible geometric sans-serif for body text (e.g., Inter, Plus Jakarta Sans).
- **Tabular Numerals:** For financial tables, dates, and order totals, always enforce monospace alignment for numbers:
  ```css
  .numeric-figure {
    font-variant-numeric: tabular-nums lining-nums;
  }
  ```

---

## 3. Warm Loading Skeletons (`aria-busy`)

Never use harsh gray flashing pulses. Use gentle warm shimmering skeletons with proper accessibility markers:

```html
<div class="skeleton-card" aria-busy="true" aria-live="polite">
  <div class="skeleton-shimmer h-6 w-3/4 rounded bg-stone-200"></div>
  <div class="skeleton-shimmer h-4 w-1/2 rounded bg-stone-100 mt-2"></div>
</div>
```

---

## 4. The Em-Dash (`—`) Ban

AI language models heavily overuse em-dashes (`—`), giving prose a synthetic, automated feel.
- **Rule:** Eradicate all `—` characters from UI headings, marketing banners, button labels, and alert modals.
- **Replacement:** Use natural editorial punctuation: colons, commas, periods, or clean whitespace.
