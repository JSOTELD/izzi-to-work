---
name: responsive-pixel-police
description: "Strict mobile layout auditing: zero horizontal overflow at 360px viewport width, minimum 44x44px touch targets, and iOS Safari auto-zoom prevention."
---

# responsive-pixel-police · Mobile Layout & Viewport Enforcement

> **Purpose:** Enforce strict mobile layout standards. Guarantees that mobile web applications remain flawlessly responsive down to 360px viewports without horizontal scroll leaks, clipped text, or broken touch interaction.

---

## 1. The 360px Zero-Overflow Rule

Any horizontal scrolling on a standard mobile screen is a defect:
- Test at exactly **360px width** (the minimum width for modern smartphones).
- Verify in browser devtools or automated Playwright:
  ```javascript
  const hasHorizontalScroll = document.documentElement.scrollWidth > document.documentElement.clientWidth;
  console.assert(!hasHorizontalScroll, "FAIL: Horizontal scroll detected on mobile!");
  ```

---

## 2. Touch Target Standards

- Every interactive button, toggle, and tab must possess an effective hit area of at least **44x44px** (WCAG 2.5.5 / Apple Human Interface Guidelines).
- If the visual icon is small (e.g., 20x20px close icon), expand the clickable area via padding:
  ```css
  .icon-button {
    width: 20px;
    height: 20px;
    padding: 12px; /* Total touch target = 44x44px */
    box-sizing: content-box;
  }
  ```

---

## 3. iOS Safari Auto-Zoom Prevention

iOS Safari automatically zooms into the viewport when an `<input>` element has a font size smaller than 16px.
- **Rule:** All mobile form inputs must have a font size of at least `16px` (or `1rem` on 16px base):
  ```css
  input, select, textarea {
    font-size: 16px;
  }
  ```
- **Viewport Meta:**
  ```html
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  ```
