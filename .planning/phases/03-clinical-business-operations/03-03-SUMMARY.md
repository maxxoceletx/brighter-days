---
phase: 03-clinical-business-operations
plan: "03"
subsystem: operations
tags: [sop, business-structure, billing, tebra, hipaa, professional-corporation, nexus-billing]

# Dependency graph
requires:
  - phase: 02-credential-vault-monitoring
    provides: "credential-inventory.md (NPI, DEA, EIN, CAQH ID, license numbers), payer-tracker-seed.sql (17 payer IDs), 1password-vault-spec.md (vault category structure)"
  - phase: 01-compliance-audit-verification
    provides: "business license status (EXPIRED BL-LIC-051057), malpractice policy verification"
provides:
  - "SOP-04: Business structure reference for Valentina Park MD, PC — CA Professional Corporation with S-Corp election, all three officer roles, Maxi W-2 employee relationship, compliance obligations, deferred Brighter Days entity plan"
  - "SOP-05: Complete biller onboarding SOP covering Tebra Biller role setup, data packet delivery (NPI, DEA, all 17 payer IDs, CPT codes), HIPAA minimum necessary rationale, per-claim reporting, same-day denial notification, escalation path"
affects:
  - "Phase 4 dashboard spec — both SOPs structured for machine-readable parsing"
  - "Any future biller onboarding — SOP-05 is the repeatable playbook"
  - "Any attorney, CPA, or auditor reviewing practice structure"

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "SOP heading structure: Purpose, Roles, Procedure (numbered checkboxes), supporting sections, Action Items, Annual Review"
    - "Reference document pattern: Entity Overview table + explanatory sections + Action Items with checkboxes (vs procedural SOP pattern)"
    - "HIPAA minimum necessary documented inline within access control SOP sections"

key-files:
  created:
    - ".planning/phases/03-clinical-business-operations/sop-04-business-structure.md"
    - ".planning/phases/03-clinical-business-operations/sop-05-biller-onboarding.md"
  modified: []

key-decisions:
  - "Tebra Biller role (not Billing Manager or System Admin) is the only acceptable access level for any third-party biller per HIPAA minimum necessary — accommodate task-specific needs without upgrading the role"
  - "Brighter Days entity decision (rename existing PC vs. new S-Corp) is deferred pending attorney/CPA guidance and hiring timeline"
  - "Brighter Days is informal branding only — no registered DBA; no separate legal entity"
  - "SOP-04 formatted as a reference document (not procedural) because business structure is factual not operational"

patterns-established:
  - "Reference document pattern for non-procedural SOPs: Entity Overview table + explanatory sections + numbered checkbox Action Items at end"
  - "HIPAA minimum necessary tables: explicit 'can access' / 'cannot access' tables for system roles"
  - "Secure data delivery requirement: all PHI-containing packets (NPI, DEA, EIN) delivered via 1Password shared link or encrypted transfer — never email"

requirements-completed: [OPS-04, OPS-05]

# Metrics
duration: 3min
completed: 2026-03-01
---

# Phase 03 Plan 03: Business Structure + Biller Onboarding Summary

**CA Professional Corporation S-Corp structure documented with all three officer roles per CA Corp. Code 312, plus complete Nexus Billing onboarding SOP covering Tebra Biller role (HIPAA minimum necessary), all 17 payer IDs, and same-day denial notification requirement**

## Performance

- **Duration:** 3 min
- **Started:** 2026-03-01T09:35:43Z
- **Completed:** 2026-03-01T09:39:17Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

- SOP-04 gives any attorney, CPA, or auditor a complete reference for the Valentina Park MD, PC entity structure — S-Corp election, all officer roles (President/Treasurer/Secretary held simultaneously by Valentina per CA Corp. Code 312), Maxi as W-2 employee CTO, ongoing compliance obligations, and deferred Brighter Days entity decision
- SOP-05 gives Maxi a complete, self-contained playbook to onboard Nexus Billing (or any replacement biller) — Tebra Biller role creation, full data packet delivery (NPI, DEA, EIN, all 17 payer IDs, CPT codes), HIPAA minimum necessary rationale, per-claim reporting, same-day denial notification, and escalation path with 5-business-day threshold
- Both documents are production-ready for day-one use and structured with consistent headings for Phase 4 dashboard parsing

## Task Commits

Each task was committed atomically:

1. **Task 1: Write SOP-04 Business Structure Documentation** - `dc7611f` (feat)
2. **Task 2: Write SOP-05 Biller Onboarding and Oversight** - `ce0e56e` (feat)

## Files Created/Modified

- `.planning/phases/03-clinical-business-operations/sop-04-business-structure.md` — Business structure reference: entity overview table, S-Corp and PC explanation, officer roles per CA Corp. Code 312, Maxi W-2 employee relationship, compliance obligations, deferred Brighter Days entity plan, and Action Items with expired business license flagged as IMMEDIATE
- `.planning/phases/03-clinical-business-operations/sop-05-biller-onboarding.md` — Biller onboarding SOP: BAA verification, Tebra Biller role creation (not Billing Manager/System Admin), 1Password documentation, data packet delivery (all 17 payer IDs + NPI + DEA + EIN + CPT codes), HIPAA minimum necessary rationale with can/cannot access tables, per-claim visibility, same-day denial notification, monthly reporting benchmarks, escalation path, and documentation requirements

## Decisions Made

- Tebra Biller role is the correct and only acceptable access level for any third-party biller. HIPAA minimum necessary standard requires the minimum PHI necessary — Biller role exposes financial/admin data but blocks clinical notes, prescriptions, and documentation. This is enforced at the system level.
- Brighter Days entity decision (rename existing PC vs. create new S-Corp) deferred until hiring timeline is clear and attorney/CPA guidance is obtained. Neither option should be executed without professional guidance.
- SOP-04 uses a reference document format (not procedural) because business structure is factual information, not a repeatable operational procedure. Action Items section provides the checkbox format for follow-through items.
- EIN 99-1529764 sourced directly from Phase 2 credential-inventory.md — consistent with credential vault as single source of truth.

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None — no external service configuration required by this plan.

## Next Phase Readiness

- All five Phase 3 SOPs (OPS-01 through OPS-05) are complete
- Phase 3 is fully complete — ready to proceed to Phase 4 (Dashboard Spec)
- Active blockers from STATE.md that carry forward to Phase 4:
  - Torrance business license BL-LIC-051057 EXPIRED — Valentina must renew at torranceca.gov
  - CAQH attestation date unknown — Valentina must verify in proview.caqh.org
  - Consumer Gmail BAA gap — must migrate to Google Workspace by 2026-03-15
  - DEA address mismatch (Walnut Creek vs. Torrance) — must update per 21 CFR 1301.51

## Self-Check: PASSED

- FOUND: sop-04-business-structure.md
- FOUND: sop-05-biller-onboarding.md
- FOUND: 03-03-SUMMARY.md
- FOUND: commit dc7611f (SOP-04)
- FOUND: commit ce0e56e (SOP-05)
- FOUND: commit 9027420 (metadata/docs)

---
*Phase: 03-clinical-business-operations*
*Completed: 2026-03-01*
