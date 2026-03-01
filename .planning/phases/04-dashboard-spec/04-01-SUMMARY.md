---
phase: 04-dashboard-spec
plan: 01
subsystem: ui
tags: [touchdesigner, supabase, ascii-animation, dashboard, tebra, n8n, compliance]

requires:
  - phase: 02-credential-vault-monitoring
    provides: credential_alert_queue view, payer_credentialing_alerts view, alert color mapping, CAQH NULL pitfall documentation
  - phase: 03-clinical-business-operations
    provides: SOP context for obligations panel; biller onboarding workflow context

provides:
  - Master dashboard spec document with Sections 1-5
  - TD network hierarchy with Container COMP structure and operator inventory
  - ASCII aesthetic rules (color palette, 4 animation states, border characters, overdue banner)
  - Today panel spec (DASH-01): appointments, overdue badge, obligations, billing snapshot, PHI scope
  - Compliance Status panel spec (DASH-02): credential list, CAQH NULL handling, estimated date markers, click-to-detail

affects: [04-02-PLAN, 04-03-PLAN, 05-automation-spec]

tech-stack:
  added: [TouchDesigner Container COMP, Web Client DAT, Timer CHOP, Pattern CHOP, Text TOP, Audio Play CHOP, Button COMP, Window COMP]
  patterns:
    - Supabase-mediated architecture (TD reads only from Supabase, never calls Tebra/external services directly)
    - Timer CHOP + Web Client DAT polling cycle (15-30 min, configurable via dashboard_settings table)
    - Pattern CHOP driving animation state (sine 0.2Hz idle, square 1Hz alert)
    - Four animation states per panel (IDLE/LOADING/ALERT/INTERACTION)
    - Per-row Text TOP composition for color-coded credential lists

key-files:
  created:
    - .planning/phases/04-dashboard-spec/dashboard-command-center-spec.md
  modified: []

key-decisions:
  - "TD never calls external APIs — Supabase is the only data source; n8n is the only action target"
  - "Per-row Text TOP composition (separate Text TOP per credential row) for color-coded compliance panel"
  - "CAQH NULL expiry_date shows [???] AMBER indicator, never defaults to green — explicit unknown state"
  - "Estimated payer re-cred dates must show ~ prefix to distinguish from confirmed dates (9 of 17 payers)"
  - "Overdue banner cannot be dismissed — persists until all EXPIRED rows resolved in credentials table"

patterns-established:
  - "Pattern 1: Supabase REST polling — Timer CHOP onCycle pulses all Web Client DATs simultaneously"
  - "Pattern 2: ASCII animation states — idle=sine 0.2Hz, alert=square 1Hz, loading=square 4Hz spinner"
  - "Pattern 3: PHI scope — first_name_only + appointment_time only, never last name or diagnosis"
  - "Pattern 4: Overdue escalation — EXPIRED items trigger persistent banner, cannot be dismissed"

requirements-completed: [DASH-01, DASH-02]

duration: 5min
completed: 2026-03-01
---

# Phase 4 Plan 01: Dashboard Command Center Spec — Architecture + Panels 1-2 Summary

**TouchDesigner dashboard spec with full system architecture (TD hierarchy, Supabase tables, n8n data flow) and first two panel specs: Today/Morning Briefing (DASH-01) and Compliance Status (DASH-02) with CAQH NULL handling and estimated-date visual treatment**

## Performance

- **Duration:** 5 min
- **Started:** 2026-03-01T10:30:55Z
- **Completed:** 2026-03-01T10:35:59Z
- **Tasks:** 2 (both writing to same file — spec architecture then panel extensions)
- **Files modified:** 1

## Accomplishments

- Created master spec document at `.planning/phases/04-dashboard-spec/dashboard-command-center-spec.md` — 1,038 lines covering Sections 1–5
- Section 1-3 establish full system architecture, TD network hierarchy with pixel-level coordinates for both 2560×1440 and 3840×2160 target resolutions, and ASCII aesthetic rules covering color palette, border characters, and all four animation states
- Section 4 (DASH-01) specifies the Today/Morning Briefing panel with appointments display (PHI-scoped to first name + time), overdue count badge, obligations summary, billing snapshot, and startup "BRIGHTER DAYS" character-reveal animation
- Section 5 (DASH-02) specifies the Compliance Status panel with per-row colored credential indicators, CAQH NULL expiry explicit UNKNOWN state, estimated date `~` prefix for 9 estimated payer re-cred dates, click-to-detail overlay, and row transition pulse animation

## Task Commits

Both tasks extended the same file (task 2 adds Sections 4-5 to the foundation from task 1):

1. **Tasks 1+2: Create spec Sections 1-5** - `ed54588` (feat)

**Plan metadata:** (to be committed with SUMMARY.md)

## Files Created/Modified

- `.planning/phases/04-dashboard-spec/dashboard-command-center-spec.md` — Master spec document, Sections 1-5 complete with placeholder headers for Sections 6-9

## Decisions Made

- **TD as pure display layer:** TouchDesigner never authenticates with or calls external services (Tebra, CAQH, payer portals). It reads from Supabase and sends webhooks to n8n only. This is enforced in the spec architecture diagram and all panel data source tables.
- **Per-row Text TOP composition for compliance panel:** Each credential row gets its own Text TOP, composited via Over TOP, to support per-row colors (GREEN/YELLOW/AMBER/RED). Alternatives (HTML rich text, Lookup TOP) were documented but single-Text-TOP-per-row is simplest to implement for a ~15-20 item list.
- **CAQH NULL = explicit UNKNOWN state:** When `expiry_date IS NULL` for CAQH row, dashboard shows `[???] CAQH Attestation — VERIFY DATE` in AMBER. Dashboard never allows NULL expiry_date to display as green/OK.
- **Estimated dates get `~` prefix:** 9 of 17 payer re-cred dates are estimated (contract_date + 3 years). All estimated dates display as `~847 days` not `847 days` to prevent over-trust.
- **Overdue banner is undismissable:** Persistent until all EXPIRED rows in `credential_alert_queue` are resolved. Banner position shift is handled in Python (shifts `panel_grid` Y coordinate when banner activates).
- **Configuration via dashboard_settings table:** Refresh interval, audio preferences, chime type are stored in Supabase `dashboard_settings` key-value table — no hardcoded values in TD network.

## Deviations from Plan

None — plan executed exactly as written. Both tasks were documentation/spec writing into a single file. No bugs, no blocking issues, no architectural surprises.

## Issues Encountered

None.

## User Setup Required

None for this plan — spec document only. No code or services deployed.

The following pre-launch data entry requirements apply before the dashboard can be built/used (documented in the spec):
- CAQH `expiry_date` must be populated (Valentina logs into proview.caqh.org to find last attestation date; Maxi updates Supabase)
- Five new Supabase tables must be created (DDL specified in Section 9, which will be written in Plan 03)

## Next Phase Readiness

- Plan 02 can now write Sections 6-8 (Credentials/Obligations panel, Calendar, Appointments, Billing) using this document as the established foundation
- Architecture, aesthetic rules, and operator patterns are locked — Plan 02 can reference them directly without re-specifying
- Sections 6-9 placeholder headers are in place for Plans 02 and 03 to fill

---
*Phase: 04-dashboard-spec*
*Completed: 2026-03-01*
