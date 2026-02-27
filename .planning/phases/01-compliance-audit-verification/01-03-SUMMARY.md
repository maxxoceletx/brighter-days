---
phase: 01-compliance-audit-verification
plan: 03
subsystem: compliance
tags: [telehealth-consent, minor-consent, good-faith-estimate, patient-location, forms-audit, B&P-2290.5, No-Surprises-Act, HIPAA, child-adolescent-psychiatry]

# Dependency graph
requires:
  - phase: 01-compliance-audit-verification
    provides: Research data on B&P 2290.5, No Surprises Act GFE requirements, CA minor confidentiality law, CPT codes and fee schedule from document audit

provides:
  - Telehealth informed consent form (B&P 2290.5 compliant, all 12 statutory elements, pre-filled with real provider data, formatted for Tebra)
  - Minor/parent consent form (parent authorization + minor assent, CA WIC 5585.50 and FC 6924 compliance)
  - Good Faith Estimate template (No Surprises Act, CPT codes, NPI, EIN, $400 dispute threshold)
  - Patient location verification protocol (SOP with verbal script, edge case table, documentation instructions)
  - Forms audit report (9 forms audited, gaps documented with severity, Phase 3 cross-references)

affects: [Phase 3 OPS, TouchDesigner compliance panel, Tebra intake configuration]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "All compliance documents pre-filled with real provider data — NPI 1023579513, EIN 99-1529764, CA License A-177690"
    - "Three severity levels for gaps: CRITICAL (blocks first patient), WARNING (30 days), INFO (best practice)"
    - "Forms audit pattern: pre-audit status + legal standard + element-by-element check + post-audit status + action items"
    - "SOP pattern: legal basis + why it matters + step-by-step procedure + edge case table + documentation instructions"

key-files:
  created:
    - .planning/phases/01-compliance-audit-verification/telehealth-consent-form.md
    - .planning/phases/01-compliance-audit-verification/minor-consent-form.md
    - .planning/phases/01-compliance-audit-verification/good-faith-estimate-template.md
    - .planning/phases/01-compliance-audit-verification/patient-location-protocol.md
    - .planning/phases/01-compliance-audit-verification/forms-audit-report.md
  modified: []

key-decisions:
  - "Telehealth consent uses 12-element structure matching B&P 2290.5 statutory requirements, patient-friendly language throughout"
  - "Minor consent splits into Part A (parent) and Part B (minor assent) — Part B uses age-appropriate language, optional signature"
  - "GFE uses Medicare fee schedule rates as baseline for self-pay estimates, with 6-month projection tables by treatment intensity"
  - "Location protocol includes edge case decision table covering border towns, child travelers, and refusal scenarios"
  - "Forms audit defers financial policy, after-hours protocol, and controlled substance agreement to Phase 3 OPS"

patterns-established:
  - "Compliance documents: real data pre-filled, only patient fields left as form fields"
  - "Audit format: Status Before | Status After | Severity per form"
  - "Gap documentation: always includes severity rating + phase cross-reference for remediation"

requirements-completed: [COMP-03, COMP-05, COMP-06, COMP-07]

# Metrics
duration: 6min
completed: 2026-02-27
---

# Phase 1 Plan 03: Patient-Facing Compliance Documents Summary

**Five practice-ready compliance documents: telehealth consent (B&P 2290.5, 12 elements), minor/parent consent (WIC 5585.50), GFE template (No Surprises Act, 8 CPT codes), location verification SOP, and a 9-form audit with gap severity ratings**

## Performance

- **Duration:** ~6 min
- **Started:** 2026-02-27T11:12:36Z
- **Completed:** 2026-02-27T11:18:00Z
- **Tasks:** 2 of 2
- **Files created:** 5

## Accomplishments

- Telehealth informed consent form: all 12 B&P 2290.5 statutory elements present, pre-filled with Dr. Park's credentials, formatted for Tebra digital intake — Valentina can load this directly into Tebra before her first patient session
- Minor/parent consent form: parent authorization with CA-specific confidentiality disclosures (WIC 5585.50, FC 6924), medication consent, minor assent in age-appropriate language — covers a critical gap for child and adolescent psychiatry practice
- Good Faith Estimate template: No Surprises Act compliant with 8 CPT codes (90792, 99214, 99215, 90833, 90836, 90785, 90837), NPI and EIN pre-filled, 6-month cost projections by treatment type, $400 dispute threshold notice and CMS dispute process
- Patient location verification SOP: verbal confirmation script, decision table for 8 edge cases (border towns, minor travelers, refusal scenarios), Tebra documentation instructions
- Forms audit: 9 forms rated — 1 COMPLIANT (NPP), 3 CREATED this phase, 3 GAPS formally deferred to Phase 3, 2 PENDING VERIFICATION in Tebra

## Task Commits

Each task was committed atomically:

1. **Task 1: Telehealth consent, minor consent, GFE template** - `d80a4f4` (feat)
2. **Task 2: Patient location protocol and forms audit report** - `3a5d6b5` (feat)

**Plan metadata:** *(this SUMMARY commit)*

## Files Created

- `.planning/phases/01-compliance-audit-verification/telehealth-consent-form.md` — CA B&P 2290.5 compliant telehealth informed consent, 176 lines, all 12 statutory elements, Tebra-formatted
- `.planning/phases/01-compliance-audit-verification/minor-consent-form.md` — Parent authorization + minor assent, 230 lines, CA WIC 5585.50 and FC 6924, medication consent, session logistics
- `.planning/phases/01-compliance-audit-verification/good-faith-estimate-template.md` — No Surprises Act GFE, 168 lines, 8 CPT codes, Medicare rates, $400 dispute threshold, delivery log
- `.planning/phases/01-compliance-audit-verification/patient-location-protocol.md` — Location verification SOP, 140 lines, verbal script, edge case table, Tebra documentation procedure
- `.planning/phases/01-compliance-audit-verification/forms-audit-report.md` — 9-form audit, 353 lines, COMPLIANT/CREATED/GAP/PENDING statuses, severity ratings, Phase 3 cross-references

## Decisions Made

- Medicare fee schedule rates used as baseline for GFE (99214 = $137.58, 90833 = $77.86, 90785 = $15.21) — matches actual contracted rates from document audit; rate noted as adjustable
- Minor assent section (Part B) written in direct, child-friendly language rather than legal language — appropriate for developmental context
- Location protocol uses city-level documentation (not full address) to protect patient privacy while satisfying the legal requirement
- Financial policy, after-hours protocol, and controlled substance agreement formally deferred to Phase 3 — none blocks first patient session (WARNING severity), and Phase 3 is the appropriate operational scope

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

**Three forms need to be loaded into Tebra before first patient session:**

1. **Telehealth Informed Consent** — Add to Tebra intake as required form for all new patients (all ages)
2. **Minor/Parent Consent** — Add to Tebra intake as required form triggered for patients under 18
3. **Good Faith Estimate** — Configure workflow to deliver to self-pay patients at least 3 business days before first appointment

**Verification tasks (lower priority, before patient onboarding):**
- Log into Tebra admin and confirm psychiatric intake form sections are configured
- Confirm Tebra provides a HIPAA authorization for release of information form

## Next Phase Readiness

Phase 1, Plan 03 is the final plan in Phase 1. All COMP requirements are now satisfied:

- **COMP-03:** Telehealth consent form exists and is B&P 2290.5 compliant — ready for Tebra
- **COMP-05:** GFE template exists with all No Surprises Act required elements
- **COMP-06:** Patient location protocol is documented with per-session verification procedure
- **COMP-07:** All 9 patient-facing forms audited; gaps documented with severity and Phase 3 cross-references

Phase 1 is complete. Phase 2 (Credentialing) is the next phase.

---
*Phase: 01-compliance-audit-verification*
*Completed: 2026-02-27*
