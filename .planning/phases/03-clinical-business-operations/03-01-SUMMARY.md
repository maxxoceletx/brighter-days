---
phase: 03-clinical-business-operations
plan: "01"
subsystem: clinical-sop
tags: [sop, patient-intake, CURES, PDMP, youth-psychiatry, telehealth, compliance]
dependency_graph:
  requires:
    - 01-compliance-audit-verification/telehealth-consent-form.md
    - 01-compliance-audit-verification/minor-consent-form.md
    - 01-compliance-audit-verification/good-faith-estimate-template.md
    - 01-compliance-audit-verification/patient-location-protocol.md
    - 02-credential-vault-monitoring/credential-inventory.md
  provides:
    - 03-clinical-business-operations/sop-01-patient-intake-workflow.md
    - 03-clinical-business-operations/sop-02-cures-database-check.md
  affects:
    - 03-clinical-business-operations/sop-03-crisis-protocol.md (SOP-01 references SOP-03 for crisis trigger)
tech_stack:
  added: []
  patterns:
    - Standard SOP heading structure (Title, Version, Purpose, Scope, Roles, Procedure, Decision Points, Documentation Requirements, References)
    - Numbered checklist format with checkboxes for Phase 4 dashboard parsing
    - Decision tree format using inline code blocks for branching logic
key_files:
  created:
    - .planning/phases/03-clinical-business-operations/sop-01-patient-intake-workflow.md
    - .planning/phases/03-clinical-business-operations/sop-02-cures-database-check.md
  modified: []
decisions:
  - "SOP-01 emergency contact form requires patient's full physical address, county of residence, and nearest ED — not just city — to enable 911 dispatch from telehealth sessions"
  - "CURES SOP-02 clarifies previous business day interpretation: a Friday check satisfies Monday prescribing"
  - "EPCS (electronic prescribing for controlled substances) noted as required for Schedule II in CA effective 2025-01-01 per CA H&S Code 11162.1"
  - "Minor consent exception documented: CA W&I Code 5850.1 allows 12+ minors to consent to outpatient mental health services independently if sufficiently mature"
metrics:
  duration: "~3 minutes"
  completed: "2026-03-01"
  tasks_completed: 2
  files_created: 2
  files_modified: 0
---

# Phase 3 Plan 01: Patient Intake Workflow and CURES Database Check SOPs Summary

**One-liner:** Two production-ready SOPs covering every-patient intake workflow (booking through first session with Tebra eligibility check, youth screening instruments, and minor consent) and mandatory CURES PDMP check procedure per CA H&S Code 11165.4 with all timing rules, exemptions, and documentation template.

---

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Write SOP-01 Patient Intake Workflow | fef3f1c | sop-01-patient-intake-workflow.md |
| 2 | Write SOP-02 CURES Database Check | 3cfd64d | sop-02-cures-database-check.md |

---

## Verification Results

All 10 verification checks passed:

1. Both SOP files exist
2. SOP-01 contains all required sections (Purpose, Scope, Roles, Procedure, Decision Points, Documentation Requirements, References)
3. SOP-01 covers full intake sequence (Booking, Pre-Intake, First Session)
4. SOP-01 references all four Phase 1 forms by file path (telehealth-consent-form, minor-consent-form, good-faith-estimate-template, patient-location-protocol)
5. SOP-01 documents all three Tebra eligibility statuses (Verified/green, Not Determined/yellow, Not Eligible/red) with fallback actions
6. SOP-01 includes all four youth screening instruments (PHQ-A, PSC-17, CRAFFT v2.1, C-SSRS Youth)
7. SOP-02 contains all required sections including Exemptions
8. SOP-02 specifies correct CURES timing rules (24-hour/previous business day; 6-month continuing treatment)
9. SOP-02 includes CURES documentation template (Appendix A) with all required fields
10. SOP-02 references CA H&S Code 11165.4 as statutory basis

---

## What Was Built

### SOP-01: Patient Intake Workflow (298 lines)

A complete, self-contained patient intake SOP covering three phases:

**Phase 1 — Booking:** Patient self-schedules via Tebra patient portal or Psychology Today referral. Admin reviews within 24 hours and confirms payer is on the contracted list.

**Phase 2 — Pre-Intake (1-3 days before appointment):** Manual Tebra eligibility check with documented three-status response procedure. Intake packet delivery including all Phase 1 consent forms. Emergency contact form specifically requires physical address, county of residence, and nearest ED for telehealth crisis readiness.

**Phase 3 — First Session:** Patient location confirmation per Patient Location Protocol, administration of four youth-specific screening instruments (PSC-17, PHQ-A, CRAFFT, C-SSRS), full psychiatric evaluation, Tebra documentation within 24 hours.

Key structural elements:
- Roles and Responsibilities table with admin/clinical duty split across 12 task categories
- Five Decision Trees (DP-01 through DP-05) covering eligibility failures, incomplete forms, minor consent exceptions, and controlled substance triggers
- Documentation requirements table with 11 line items and deadlines
- Screening instrument appendix with administration details, age ranges, and free sources
- References section cross-linking all six upstream Phase 1/2 deliverables

### SOP-02: CURES Database Check (285 lines)

A prescriber-only (Valentina) CURES PDMP check SOP covering the full mandatory use procedure under CA H&S Code 11165.4:

**8-step procedure:** Determine requirement, confirm timing, log in to CURES 2.0 (cures.doj.ca.gov), search patient, review PAR, document in Tebra, make prescribing decision, write prescription.

**Timing rules:** Clearly documented 24-hour / previous-business-day rule for first and each subsequent prescription; 6-month minimum for continuing treatment monitoring.

**Five Decision Trees (DP-01 through DP-05):** No red flags (proceed), multiple prescribers (coordinate first), benzo+opioid combination (peer consultation required), diversion suspicion (do not prescribe), CURES system down (5-day non-refillable supply + document outage).

**Five Exemptions:** Inpatient, emergency department (7-day max), post-surgical (5-day max), hospice, technical difficulties (5-day max).

**Appendix A — CURES Documentation Template:** All required fields including date/time of query, PAR date range, substances reviewed, findings summary, clinical decision, and DEA FP3833933.

---

## Decisions Made

1. **Emergency contact form specificity:** The intake emergency contact form explicitly requires full physical address (street + city + state + zip), county of residence, and nearest ED — not just city. This is the pre-session safety information needed to dispatch 911 during a telehealth crisis without knowing the patient's location in real time.

2. **Previous business day interpretation:** SOP-02 explicitly documents that a CURES check performed Friday satisfies a Monday prescription. This is the edge case most likely to cause confusion in day-to-day practice.

3. **EPCS requirement noted:** California requires electronic prescribing for controlled substances (EPCS) for Schedule II as of January 1, 2025 per CA H&S Code 11162.1. This was added to SOP-02 Step 8 as a legal compliance note.

4. **Minor consent exception documented:** CA Welfare and Institutions Code 5850.1 allows minors 12+ to consent to outpatient mental health services independently if they are sufficiently mature. Added to DP-04 in SOP-01 with instruction to discuss exceptions with Valentina and document the decision.

---

## Deviations from Plan

None — plan executed exactly as written.

---

## Success Criteria Assessment

- [x] SOP-01 is a standalone document that a new admin hire could follow to onboard a patient from booking through first session
- [x] SOP-02 is a standalone document that Valentina can follow for any controlled substance prescribing decision
- [x] Both documents reference upstream Phase 1/2 deliverables without duplicating them
- [x] Both documents use consistent heading structure for Phase 4 dashboard parsing

---

## Self-Check: PASSED

- FOUND: .planning/phases/03-clinical-business-operations/sop-01-patient-intake-workflow.md
- FOUND: .planning/phases/03-clinical-business-operations/sop-02-cures-database-check.md
- FOUND: .planning/phases/03-clinical-business-operations/03-01-SUMMARY.md
- FOUND commit fef3f1c: feat(03-01): write SOP-01 patient intake workflow
- FOUND commit 3cfd64d: feat(03-01): write SOP-02 CURES database check SOP
