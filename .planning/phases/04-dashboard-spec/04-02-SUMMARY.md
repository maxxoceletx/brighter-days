---
phase: 04-dashboard-spec
plan: 02
subsystem: ui
tags: [touchdesigner, supabase, tebra, n8n, obligations, calendar, billing, ascii-animation, hipaa]

requires:
  - phase: 04-dashboard-spec
    plan: 01
    provides: Master spec document Sections 1-5, TD hierarchy, ASCII aesthetic rules, Supabase patterns

provides:
  - Obligations Checklist spec (DASH-03): full interactivity, auto-completion, seed SQL, countdown display
  - Compliance Calendar spec (DASH-04): dual view modes, ASCII grid render, audio alert configuration
  - Tebra integration spec (DASH-05): three independent tiers (SOAP API, CSV, manual), HIPAA options
  - Billing Oversight panel spec (DASH-06): ASCII AR aging bars, denial rate color coding, delta display

affects: [04-03-PLAN]

tech-stack:
  added:
    - Audio Play CHOP (chime playback on obligation transitions)
    - n8n SOAP HTTP Request node (Tebra GetAppointments, GetTransactions)
    - fast-xml-parser (n8n Code node XML parsing)
    - Google Drive File Trigger (n8n Tier 2 CSV watch)
  patterns:
    - Obligations merge pattern: Web Client DAT for obligations + credential_alert_queue, merged in Python
    - Calendar dual-mode pattern: Python toggle switches display between list and grid Container COMPs
    - ASCII bar chart pattern: proportional fill using # and . characters, 16-char width
    - Tier badge pattern: dashboard_settings.tebra_integration_tier drives [API]/[CSV]/[MANUAL] indicator
    - Audio transition detection: Python globals track previous alert levels, pulse Audio Play CHOP on severity increase
    - PHI stripping at n8n layer: patient first name only written to Supabase, enforced by schema (no last-name column)

key-files:
  created: []
  modified:
    - .planning/phases/04-dashboard-spec/dashboard-command-center-spec.md

key-decisions:
  - "Obligations panel owns the obligation lifecycle — dashboard IS the task management system (not a mirror of Tebra)"
  - "Three-tier Tebra fallback: SOAP API preferred, CSV export as fallback, manual entry as last resort — each tier independently implementable"
  - "HIPAA for n8n: stateless passthrough (EXECUTIONS_DATA_SAVE_ON_SUCCESS=false) as default; Keragon as upgrade path if BAA coverage required for automation layer"
  - "AR 90+ > $0 is always RED — no threshold, any aged AR is a risk signal"
  - "Denial rate thresholds: < 5% normal, 5-10% AMBER, > 10% RED"
  - "Audio alerts default OFF — configurable per item via dashboard_settings; 5 bundled .wav files"
  - "Calendar grid per-cell colors via composited Over TOP chain, not single Text TOP (single TOP cannot support per-cell colors)"

patterns-established:
  - "Pattern 5: Obligations merge — combine obligations table + credential_alert_queue into single sorted list via script_obligations_merge Python DAT"
  - "Pattern 6: Calendar dual-mode — list and grid Container COMPs both exist, Python toggle switches display parameter"
  - "Pattern 7: ASCII bar chart — ar_bar(amount, total_ar, width=16) proportional fill function"
  - "Pattern 8: Tier indicator — tebra_integration_tier drives [API]/[CSV]/[MANUAL] badge in panel header"

requirements-completed: [DASH-03, DASH-04, DASH-05, DASH-06]

duration: 5min
completed: 2026-03-01
---

# Phase 4 Plan 02: Dashboard Command Center Spec — Obligations, Calendar, Tebra, Billing Summary

**Sections 6-8 added to the master dashboard spec: full obligations checklist with seed SQL and auto-completion, dual-mode compliance calendar with audio alerts, three-tier Tebra integration (SOAP API/CSV/manual) with HIPAA options, and billing oversight panel with ASCII AR aging bars and denial rate color coding**

## Performance

- **Duration:** 5 min
- **Started:** 2026-03-01T10:39:06Z
- **Completed:** 2026-03-01T10:44:34Z
- **Tasks:** 2 (both writing to same spec file)
- **Files modified:** 1

## Accomplishments

- Section 6 (DASH-03): Obligations Checklist with countdown list display (GREEN/YELLOW/RED/PULSING), color-coded rows, three interactive actions (DONE/SNOOZE/NOTES), auto-completion detection by n8n workflows, estimated-date `~` prefix treatment, 18-item seed SQL, and animation state logic
- Section 7 (DASH-04): Compliance Calendar with List mode (grouped by month, chronological) and Grid mode (ASCII 7-column calendar, per-cell count badges), Python calendar rendering function, view toggle implementation, audio alert overlay with 5-chime selector and three trigger levels, and severity transition detection in Python globals
- Section 8A (DASH-05): Three-tier Tebra integration — Tier 1 with full SOAP envelope XML, n8n Code node PHI stripping, credential vault setup steps, and HIPAA options (stateless passthrough vs Keragon); Tier 2 with Google Drive file watch, CSV parse + PHI strip; Tier 3 with manual appointment and billing entry forms
- Section 8B (DASH-05 viz): Appointments panel with PHI-scoped display (first name + time only), weekend/holiday next-business-day logic, refresh indicator, tier badge
- Section 8C (DASH-06): Billing oversight panel with ASCII AR aging bar chart (`ar_bar()` function), month-over-month delta, denial rate color thresholds (5%=AMBER, 10%=RED), stale data detection, manual override mode, and full column reference for `tebra_appointments` and `tebra_billing_summary`

## Task Commits

1. **Task 1: Sections 6-7 — Obligations Checklist and Compliance Calendar** — `94fbba6`
2. **Task 2: Section 8 — Tebra Integration and Billing Oversight** — `9c9e6cd`

## Files Created/Modified

- `.planning/phases/04-dashboard-spec/dashboard-command-center-spec.md` — 948 lines added (Sections 6-8), total now ~1,987 lines

## Decisions Made

- **Obligations as task manager:** The obligations panel is the authoritative system for compliance obligations — not a mirror of something managed elsewhere. Click-to-complete, snooze, and notes interactivity all write back to Supabase `obligations` table directly from TD.
- **Three-tier Tebra (each self-contained):** Tier 1 (SOAP API), Tier 2 (CSV), and Tier 3 (manual) are each fully specified so any one can be implemented without implementing the others. Downstream Supabase schema is identical for all tiers.
- **HIPAA for n8n automation layer:** Two options documented — (A) stateless passthrough with `EXECUTIONS_DATA_SAVE_ON_SUCCESS=false`, (B) Keragon HIPAA-native platform. Developer chooses based on risk tolerance. Option A is sufficient for minimal PHI surface (first name only).
- **AR 90+ always RED:** Any balance in the 90+ day AR bucket is automatically displayed in RED with no threshold. This is intentional — any uncollected 90+d AR is a risk signal regardless of amount.
- **Denial rate thresholds:** < 5% = normal (dim text), 5-10% = AMBER, > 10% = RED. Industry benchmark is ~5% denial rate for a well-run psychiatric practice.
- **Audio alerts default OFF:** Audio alerts are configurable and default to disabled. Five bundled `.wav` files provide chime options. Trigger level is configurable (overdue only / 7-day / 30-day).
- **Calendar grid color via Over TOP compositing:** A single Text TOP cannot apply per-cell colors in TouchDesigner. Badge cells are rendered as separate small Text TOPs composited over the grid background.

## Deviations from Plan

None — plan executed exactly as written. Both tasks were documentation/spec writing into a single existing file. The plan specified "Section 8 combined Tebra integration + billing panel" — the spec uses 8A/8B/8C sub-sections which follows from the plan's own subsection descriptions (8A, 8B, 8C labeling was in the plan task text).

## Issues Encountered

None.

## User Setup Required

None for this plan — spec document only. No code or services deployed.

Pre-launch action items documented in this spec:
- Run seed SQL for `obligations` table (Section 6.9) before first dashboard launch
- Update `due_date` for NULL-dated obligations using Valentina's actual records
- Set `dashboard_settings.tebra_integration_tier` to correct tier before dashboard launch
- Obtain Tebra Customer Key from portal (Help > Get Customer Key) for Tier 1
- Source or create 5 `.wav` audio files for `assets/audio/` (royalty-free chimes, 0.5-2 second duration)

## Next Phase Readiness

- Plan 03 can now write Sections 9 (Actions panel, Automation Tracker, full Supabase DDL, startup/persistence notes)
- All panel specs 1-6 are complete — Plans 01 and 02 cover DASH-01 through DASH-06
- The `tebra_appointments` and `tebra_billing_summary` column reference in Section 8C.9 gives Plan 03 enough context to write complete DDL

---
*Phase: 04-dashboard-spec*
*Completed: 2026-03-01*
