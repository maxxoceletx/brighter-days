---
phase: 02-credential-vault-monitoring
plan: 01
subsystem: database
tags: [supabase, postgresql, credentials, 1password, hipaa, healthcare, credentialing]

# Dependency graph
requires:
  - phase: 01-compliance-audit-verification
    provides: compliance_items table and Phase 1 seed data that credentials table FK-references via compliance_item_id

provides:
  - credential-schema.sql — DDL for credentials + payer_tracker tables and credential_alert_queue + payer_credentialing_alerts views
  - credential-seed.sql — 12 credential INSERT statements with real numbers from Phase 1 document audit
  - 1password-vault-spec.md — complete vault organization guide with migration checklist for Valentina

affects: [02-02, 02-03, 04-dashboard, 05-ai]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "FK extension pattern: credentials table links to Phase 1 compliance_items via compliance_item_id — no data duplication, only enrichment"
    - "Subselect FK insert pattern: (SELECT id FROM compliance_items WHERE req_id = 'COMP-XX' LIMIT 1) for linking Phase 1 rows"
    - "Estimated-but-flagged pattern: unknown fields use industry norms with recred_is_estimated=true / timely_filing_is_estimated=true — never left NULL"
    - "vault_entry_ref cross-reference: Supabase field stores 1Password item name, connecting DB records to physical vault without storing credentials in DB"

key-files:
  created:
    - .planning/phases/02-credential-vault-monitoring/credential-schema.sql
    - .planning/phases/02-credential-vault-monitoring/credential-seed.sql
    - .planning/phases/02-credential-vault-monitoring/1password-vault-spec.md
  modified: []

key-decisions:
  - "Medicare PTANs CB496693/CB496694 set to ACTIVE per CONTEXT.md correction — Phase 1 showed DEACTIVATED 1/31/2026 which was incorrect per Valentina's confirmation"
  - "CAQH expiry_date left NULL with required action note — last attestation date unknown from Phase 1; Valentina must verify in CAQH portal and update the row"
  - "Business License Torrance BL-LIC-051057 flagged EXPIRED status with immediate renewal note — expired 2025-12-31"
  - "DEA address mismatch documented in renewal_notes — Walnut Creek vs Torrance; must correct in DEA portal per 21 CFR 1301.51"
  - "ABPN certifications have alert_90/60/30/7 all set to false — Continuous Certification has no expiry date to alert on"
  - "S-Corp entity coverage and CA Statement of Information seeded even without Phase 1 compliance_items rows (compliance_item_id = NULL)"
  - "1Password vault spec uses functional grouping (7 categories by use pattern), not alphabetical ordering — reduces time-to-find under deadline pressure"

patterns-established:
  - "Phase extension pattern: Phase 2 adds new tables without modifying Phase 1 tables — all enrichment via FK and new table structure"
  - "Alert threshold pattern: alert_90/60/30/7 booleans control which alert windows fire per credential — set to false for credentials with no expiry"
  - "vault_entry_ref pattern: stores 1Password item name as text — TD dashboard can display it, n8n can include it in alert payload"

requirements-completed: [CRED-01, CRED-02]

# Metrics
duration: 6min
completed: 2026-02-27
---

# Phase 2 Plan 01: Credential Schema and 1Password Vault Spec Summary

**PostgreSQL credential schema extending Phase 1 with 12 real-data seed rows, 2 TD-ready alert views, and a complete 1Password vault migration guide for Valentina**

## Performance

- **Duration:** 6 min
- **Started:** 2026-02-27T12:36:28Z
- **Completed:** 2026-02-27T12:42:34Z
- **Tasks:** 2
- **Files created:** 3

## Accomplishments

- `credentials` table with full renewal metadata (12 fields), FK to Phase 1 compliance_items, and per-credential alert threshold booleans (alert_90/60/30/7)
- `payer_tracker` table with full 17-panel dossier structure (31 fields) covering contract status, credentialing dates, timely filing, portal refs, and provider contacts
- Two TD-ready views: `credential_alert_queue` (alert_level + display_color from days_until_expiry) and `payer_credentialing_alerts` (recred_urgency)
- 12 credential seed rows with real numbers from Phase 1 audit — CA license A-177690, DEA FP3833933, both ABPN certs, CAQH 16149210, malpractice #48289, entity coverage #10709, business license BL-LIC-051057, CA Statement of Information, both Medicare PTANs (CB496693/CB496694), and Medi-Cal PAVE 100517999
- Medicare corrected to ACTIVE status per CONTEXT.md — Phase 1 DEACTIVATED flag was incorrect
- 1Password vault spec with 7 functional categories, all 17 payer portal entries with Tebra IDs, step-by-step migration instructions from plaintext Word docs, and cross-reference table matching vault_entry_ref values to physical vault entries

## Task Commits

Each task committed atomically:

1. **Task 1: Create Supabase credential schema and seed all known credentials** - `05b93f3` (feat)
2. **Task 2: Create 1Password vault structure spec with migration instructions** - `5b2b92a` (feat)

**Plan metadata:** (this summary commit — see final commit below)

## Files Created

- `.planning/phases/02-credential-vault-monitoring/credential-schema.sql` — DDL: credentials table, payer_tracker table, credential_alert_queue view, payer_credentialing_alerts view, 7 indexes
- `.planning/phases/02-credential-vault-monitoring/credential-seed.sql` — 12 INSERT statements with real credential numbers, FK links to Phase 1 compliance_items, Medicare ACTIVE correction, CAQH 120-day cycle with action note
- `.planning/phases/02-credential-vault-monitoring/1password-vault-spec.md` — Complete 1Password vault org guide: 7 categories, 17 payer portals, migration checklist, exclusion list, cross-reference table, maintenance section

## Decisions Made

- Medicare PTANs CB496693 and CB496694 seeded as ACTIVE per CONTEXT.md correction (Phase 1 showed DEACTIVATED — incorrect per Valentina's confirmation on 2026-02-27)
- CAQH expiry_date set to NULL with required action note — last attestation date not captured in Phase 1 docs; Valentina must verify in CAQH portal and set expiry_date = last_attestation_date + 120 days
- Business License seeded with EXPIRED status and immediate renewal note — expired 2025-12-31; action item carried from Phase 1
- DEA address mismatch (Walnut Creek vs Torrance) documented in renewal_notes rather than blocking the seed row — not a Phase 2 blocker but must be corrected before re-credentialing
- ABPN certifications use alert_90/60/30/7 = false — Continuous Certification has no fixed expiry, so alert booleans are meaningless and off by default
- 1Password vault grouped by functional use (7 categories), not alphabetically — matches how credentials are accessed under time pressure

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

**Valentina must complete one manual step before credential monitoring is fully functional:**

1. Log into https://proview.caqh.org with CAQH ID 16149210
2. Find the last attestation date on the Attestation tab
3. Calculate expiry: last_attestation_date + 120 days
4. Update the CAQH row in the `credentials` Supabase table: set `expiry_date` to the calculated date and `updated_at` to current timestamp

**Also required (from Phase 1 action items):**
- Renew Torrance Business License BL-LIC-051057 at https://www.torranceca.gov/ — EXPIRED 2025-12-31
- Follow 1password-vault-spec.md Section 3 to migrate credentials from Master Key.docx and liscensing notes.docx into the "Brighter Days Practice" shared vault, then delete both plaintext files

## Next Phase Readiness

- `credential-schema.sql` is ready to execute via Supabase Management API (same pattern as Phase 1 compliance-schema.sql)
- `credential-seed.sql` is ready to execute after schema DDL runs
- Plan 02 can proceed: payer tracker seed data for all 17 panels
- Plan 03 can proceed after Plan 02: printable credential inventory + alert architecture spec

---

*Phase: 02-credential-vault-monitoring*
*Completed: 2026-02-27*
