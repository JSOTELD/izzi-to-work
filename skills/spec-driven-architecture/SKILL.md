---
name: spec-driven-architecture
description: "Generates comprehensive 11-section system engineering specifications: functional/non-functional requirements, Mermaid erDiagram, DDL with index justifications, sequence diagrams, endpoint matrices, 4 UI states, and phased implementation plans."
---

# spec-driven-architecture · 11-Section System Engineering Specification

> **Purpose:** Transform raw feature requests into rigorous, end-to-end system engineering specifications before writing production code. Prevents rework, unaligned schemas, and missing edge cases.

---

## 1. Specification Workflow

Before writing implementation code:
1. Explore existing codebases (schemas, API routes, shared models) to ensure alignment.
2. Resolve ambiguous assumptions with the team or product owner.
3. Generate the 11-section blueprint document and save it in `docs/specs/<NN-feature-name>.md`.

---

## 2. The 11 Mandatory Specification Sections

1. **Context & Problem Statement:** High-level problem definition, affected user personas, and explicit out-of-scope boundaries.
2. **Functional Requirements (FR):** Numbered requirement list (`FR-1`, `FR-2`, ...) paired with unambiguous acceptance criteria.
3. **Non-Functional Requirements (NFR):** Security threat model, throughput/latency limits, availability SLA, accessibility (WCAG AA), and tenant isolation.
4. **Data Model:**
   - Visual Mermaid `erDiagram`.
   - Proposed SQL DDL: types, `NOT NULL`, foreign keys with `ON DELETE` semantics, and explicit justification for every created index.
   - Migration strategy from existing schemas.
5. **System Flow:** Mermaid `sequenceDiagram` or `flowchart` mapping primary success and failure loops.
6. **API / Endpoint Matrix:** Table defining Method, Path, Auth Level, Input Validation, Output Payload, and HTTP error codes.
7. **Security Architecture:** Resource-level authorization (IDOR protection), CSRF guards, input sanitization, output escaping, and secret management.
8. **UI & Interaction Design:** Layout components and explicit visual handling for all **4 Required States**:
   - `Loading` (accessible warm skeleton)
   - `Empty` (instructional guidance)
   - `Error` (actionable recovery message)
   - `Data / Success` (primary presentation)
9. **Edge Cases & Failure Modes:** Network outages, duplicate submissions, partial transactions, timezones, leap years, and currency precision.
10. **Phased Implementation Plan:** Step-by-step milestones with affected files, acceptance tests, and verification commands.
11. **Open Questions & Risk Assessment:** Unresolved technical trade-offs and rollback strategy.
