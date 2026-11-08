---
name: ux-heuristic-audit
description: "UI review applying Nielsen's 10 heuristics, UX laws (Fitts, Hick, Jakob, Proximity), measured WCAG AA color contrast, and verification of all 4 required states: loading, empty, error, and data."
---

# ux-heuristic-audit · Senior UI/UX & Heuristic Review

> **Purpose:** Evaluate and refine user interfaces through Nielsen's 10 Usability Heuristics, foundational laws of human-computer interaction, measured WCAG accessibility contrast, and mandatory multi-state coverage.

---

## 1. The UX Law & Heuristic Checklist

### Nielsen's 10 Usability Heuristics
1. **Visibility of System Status:** Immediate feedback for user actions (loaders, progress bars, disabled submit states during transit).
2. **Match Between System and Real World:** Conversational, human terminology rather than internal database keys or technical error strings.
3. **User Control and Freedom:** Easy undo, clear cancel buttons, and safe exit paths from modal dialogs (Esc key support).
4. **Consistency and Standards:** Universal placement of primary actions; consistent button hierarchies (`primary`, `secondary`, `destructive`).
5. **Error Prevention:** Confirmation for irreversible actions; format masking on phone/currency inputs.
6. **Recognition Rather than Recall:** Visible options, autocomplete helpers, and prominent breadcrumbs.
7. **Flexibility and Efficiency of Use:** Keyboard shortcuts (`Enter`, `Tab`, `Esc`) and streamlined workflows for power users.
8. **Aesthetic and Minimalist Design:** Eliminate visual noise; use whitespace instead of extraneous dividing borders.
9. **Help Users Recognize and Recover from Errors:** Clear error explanations explaining *why* an error occurred and *what* to do next.
10. **Help and Documentation:** Contextual tooltips and reachable documentation without leaving the current view.

### Foundational Interaction Laws
- **Fitts's Law:** Primary call-to-action buttons must be prominent and easily reached. Minimum touch target size: **44x44px**.
- **Hick's Law:** Minimize simultaneous choices to prevent decision paralysis. Use progressive disclosure.
- **Law of Proximity (Gestalt):** Group related fields using spatial spacing (multiples of 8px).

---

## 2. Mandatory 4-State Verification

Every view, component, and data table **MUST** implement and verify all four states:

1. **Loading State:** Smooth skeleton or spinner with `aria-busy="true"`.
2. **Empty State:** Friendly illustration/icon, clear message ("No invoices yet"), and a primary action button ("Create Your First Invoice").
3. **Error State:** Human-readable explanation and an instant retry button ("Try Again").
4. **Data / Success State:** Clean data presentation with tabular numbers and responsive wrapping.

