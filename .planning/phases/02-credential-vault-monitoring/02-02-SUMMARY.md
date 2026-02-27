---
phase: 02-credential-vault-monitoring
plan: 02
subsystem: data-and-documentation
tags: [credentialing, payer-tracker, postgresql, n8n, alerting, hipaa, healthcare, audit]

# Dependency graph
requires:
  - phase: 02-01
    provides: credential-schema.sql (payer_tracker DDL) and credential-seed.sql that this plan extends

provides:
  - payer-tracker-seed.sql — INSERT statements for all 17 payer dossiers with Tebra IDs, contract status, re-credentialing dates, contacts, and fee schedules
  - credential-inventory.md — Auditor-facing printable credential inventory with all practice identifiers and 17-panel summary
  - alert-architecture.md — Phase 4/5 build spec for credential expiry, CAQH, and payer re-credentialing alert system

affects: [02-03, 04-dashboard, 05-ai]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Estimated-but-flagged pattern: 9 UNKNOWN payers populated with industry-norm estimates (recred_cycle_years=3, timely_filing_days=90) and flagged with _is_estimated=true — never left NULL"
    - "Dual-target alert pattern: all credential and payer alerts go to both admin@valentinaparkmd.com and Maxi — no role split"
    - "CAQH 90-day alert math: ALERT_90 fires at 30 days elapsed (120-90=30) — correctly within the 120-day cycle, not 90 days before deadline"
    - "NULL expiry = silent failure pattern: CAQH with NULL expiry_date disappears from credential_alert_queue — explicitly documented as pre-launch blocker"

key-files:
  created:
    - .planning/phases/02-credential-vault-monitoring/payer-tracker-seed.sql
    - .planning/phases/02-credential-vault-monitoring/credential-inventory.md
    - .planning/phases/02-credential-vault-monitoring/alert-architecture.md
  modified: []

key-decisions:
  - "9 of 17 payers have UNKNOWN contract status — populated with industry-norm estimates and flagged, not left NULL, per plan requirement"
  - "Medicare confirmed ACTIVE in both payer-tracker-seed.sql and credential-inventory.md — consistent with Phase 2 correction"
  - "CAQH alert is highest-risk credential: missing one 120-day cycle can silently suspend all 17 payer contracts simultaneously — documented with dedicated urgent alert language"
  - "Alert spec is Phase 2 output only — no working n8n workflows, no calendar events, no email automation built in Phase 2"
  - "payer re-credentialing alert window is 180 days (vs 90 for credentials) because re-cred requires 90-day advance submission to payers"

# Metrics
duration: 5min
completed: 2026-02-27
---

# Phase 2 Plan 02: Payer Tracker Seed Data, Credential Inventory, and Alert Architecture Summary

**17 payer dossiers with industry-norm estimates for UNKNOWN panels, an auditor-facing credential inventory, and a complete Phase 4/5 alert architecture spec covering credential expiry, CAQH 120-day re-attestation, and payer re-credentialing deadlines**

## Performance

- **Duration:** 5 min
- **Started:** 2026-02-27T12:49:12Z
- **Completed:** 2026-02-27T12:54:00Z
- **Tasks:** 2
- **Files created:** 3

## Accomplishments

- `payer-tracker-seed.sql`: 17 INSERT statements covering all insurance panels with Tebra IDs, contract status, can_bill, fee schedules (where known), portal URLs, portal_login_ref values, and key_issues for each payer. UNKNOWN payers (9 of 17) populated with industry norms (recred_cycle_years=3, timely_filing_days=90) flagged as estimated.
- `credential-inventory.md`: Professional auditor-facing document with practice identifiers block, 8 credential sections (licenses, DEA, board certs, CAQH, malpractice, government programs, business/corporate, and 17-panel insurance status table). Estimated dates marked [est.] with footnote disclaimer.
- `alert-architecture.md`: Phase 4/5 build specification with trigger SQL, delivery targets (both admin@valentinaparkmd.com and Maxi), alert cadence (90/60/30/7), dedup rules, payload formats, completion gates, implementation stack, data flow diagram, and 6 documented edge cases with mitigations.
- Medicare correctly ACTIVE in both seed and inventory — Phase 1 DEACTIVATED flag was incorrect per Valentina's Phase 2 confirmation.
- CAQH documented as highest-risk credential with dedicated urgent alert language and NULL expiry = silent failure warning for Phase 5 builders.

## Task Commits

Each task committed atomically:

1. **Task 1: Populate all 17 payer dossiers and create printable credential inventory** - `0815665` (feat)
2. **Task 2: Write alert architecture spec for Phase 4/5 TouchDesigner implementation** - `5605bd9` (feat)

**Plan metadata:** (this summary commit — see final commit below)

## Files Created

- `.planning/phases/02-credential-vault-monitoring/payer-tracker-seed.sql` — 17 INSERT statements with Tebra IDs, contract status, fee schedules, portal refs, key issues, standard NPIs/EIN on all rows
- `.planning/phases/02-credential-vault-monitoring/credential-inventory.md` — 8-section auditor document: licenses, DEA, board certs, CAQH, malpractice, government programs, business/corporate, 17-payer panel table
- `.planning/phases/02-credential-vault-monitoring/alert-architecture.md` — 6-section Phase 4/5 build spec: credential alerts, CAQH alerts, payer re-cred alerts, implementation stack, data flow diagram, edge cases

## Decisions Made

- UNKNOWN payers populated with industry-norm estimates and flagged (recred_is_estimated=true, timely_filing_is_estimated=true) — never left NULL per plan requirement
- Medicare set to ACTIVE in both seed and inventory, consistent with Phase 2 correction from CONTEXT.md
- Alert architecture is spec-only in Phase 2 — no working automation built, per locked decision in 02-CONTEXT.md
- CAQH 120-day alert cadence explained explicitly: ALERT_90 fires at 30 days elapsed (120-90=30), not 90 days before deadline — different from annual credential math
- Payer re-credentialing alert window extended to 180 days (beyond the 90-day standard) because re-credentialing requires 90-day advance submission to payers
- NULL CAQH expiry documented as pre-launch blocker for Phase 5 — must be resolved before enabling automated CAQH alerts

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

**Before Phase 5 alert automation can go live:**

1. Valentina must log into https://proview.caqh.org (CAQH ID 16149210), find the last attestation date, and notify Maxi
2. Maxi updates `credentials` table: `expiry_date = last_attestation_date + 120`, `updated_at = now()`
3. Verify CAQH row appears in `credential_alert_queue` view before Phase 5 deployment

**Ongoing (9 UNKNOWN payers):**
- Valentina and/or credentialing agent Mary must verify actual contract status for the 9 UNKNOWN payers (California Health & Wellness, Coastal Communities, Facey Medical, Health Net CA, Hoag, Magellan, Providence, Torrance IPA, Torrance Memorial MC)
- Update `payer_tracker` rows with confirmed contract dates and set `recred_is_estimated = false` when actual re-credentialing dates are obtained

## Next Phase Readiness

- `payer-tracker-seed.sql` is ready to execute in Supabase after `credential-schema.sql` (Plan 01) has been applied
- `credential-inventory.md` is ready to print or share with auditors/payers immediately
- `alert-architecture.md` is the complete handoff document for Phase 4 and Phase 5 builders
- Phase 2 Plan 03 (if any) or Phase 3 (Operations) can proceed

---

*Phase: 02-credential-vault-monitoring*
*Completed: 2026-02-27*
