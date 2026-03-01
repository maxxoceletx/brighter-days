---
phase: 04-dashboard-spec
plan: "03"
subsystem: dashboard-spec
tags: [touchdesigner, n8n, supabase, hipaa, automation, webhooks, sql, dashboard]

# Dependency graph
requires:
  - phase: 04-dashboard-spec
    plan: "02"
    provides: "Spec sections 6-8 — obligations, calendar, appointments, billing panels"
  - phase: 04-dashboard-spec
    plan: "01"
    provides: "Spec sections 1-5 — architecture, aesthetic, today panel, compliance panel"
provides:
  - "Section 9: Panel 7 Action Buttons (DASH-07) — 4 buttons with full webhook + payload + confirmation + state machine specs"
  - "Section 10: Panel 8 Automation Tracker (DASH-08) — scrolling ASCII log, expandable detail, animation states"
  - "Section 10.9/10.10: Complete Phase 4 Supabase DDL migration — all 5 new tables with RLS policies"
  - "Section 11: Developer implementation guide — setup checklist, pre-launch blockers, n8n workflow inventory, HIPAA summary, open questions, Phase 5 handoff"
  - "Complete dashboard-command-center-spec.md covering DASH-01 through DASH-08"
affects: [05-ai-automation, developer-handoff]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Action button state machine: IDLE → RUNNING → DONE/FAILED (badge driven by automation_log polling)"
    - "Two-step n8n write pattern: INSERT 'running' on webhook receive → UPDATE 'completed'/'failed' on finish"
    - "Dot-leader ASCII log format for automation tracker with per-status color coding"
    - "Confirmation dialog overlay for CONFIRM REQUIRED actions (Send Comms button)"
    - "Quick-poll on button press (5s timer) for fast RUNNING→DONE badge transition"
    - "automation_log as shared surface between dashboard display layer and n8n automation layer"

key-files:
  created: []
  modified:
    - ".planning/phases/04-dashboard-spec/dashboard-command-center-spec.md"

key-decisions:
  - "Four action buttons use IMMEDIATE confirmation (CAQH, Report, Payer Status) or CONFIRM REQUIRED (Send Comms — external email)"
  - "recipient_email for Send Comms is NOT stored in Supabase — transient in n8n webhook payload only"
  - "automation_log.triggered_by distinguishes 'dashboard_button' from 'scheduled' from 'ai_triggered' for Phase 5 compatibility"
  - "Phase 4 Supabase DDL included directly in spec — developer runs as single migration script"
  - "8 n8n workflows required: 2 scheduled (Tebra sync), 4 webhook (action buttons), 1 daily email alert, 1 internal auto-complete"

patterns-established:
  - "setBadgeState() shared utility function handles all four button badges consistently"
  - "Quick-poll after button press (timer_post_action_poll, 5s) bridges the gap between webhook fire and global refresh cycle"
  - "automation_log write sequence: INSERT running → execute → UPDATE completed/failed (ensures RUNNING badge state is visible)"

requirements-completed: [DASH-07, DASH-08]

# Metrics
duration: 9min
completed: 2026-03-01
---

# Phase 4 Plan 03: Dashboard Spec Completion Summary

**Action buttons (CAQH, Report, Payer Status, Send Comms) and automation tracker fully spec'd with webhook URLs, JSON payloads, badge state machines, ASCII log format, DDL for all 5 Phase 4 tables, and complete developer guide covering setup, blockers, 8 n8n workflows, HIPAA compliance, and Phase 5 handoff**

## Performance

- **Duration:** 9 min
- **Started:** 2026-03-01T10:47:53Z
- **Completed:** 2026-03-01T10:56:38Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments

- Section 9 (DASH-07): All four action buttons fully specified — label, n8n webhook URL, JSON payload schema, confirmation tier, Python implementation, and per-button result display
- Section 10 (DASH-08): Automation tracker with dot-leader ASCII log, per-entry color coding, expandable detail overlay, scroll behavior, running spinner, full `automation_log` DDL with indexes and RLS policies
- Section 10.10: Complete Phase 4 Supabase DDL migration script for all 5 new tables (`tebra_appointments`, `tebra_billing_summary`, `automation_log`, `dashboard_settings`, `obligations`) with RLS policies
- Section 11: Developer guide — numbered setup checklist (9 steps), 5 pre-launch blockers with exact resolution steps, 8-workflow n8n inventory table, HIPAA compliance consolidated summary, 6 open questions, Phase 5 handoff notes connecting automation_log and obligations to AI layer

## Task Commits

1. **Task 1 + Task 2: Sections 9-11 complete** - `2087b13` (feat)

## Files Created/Modified

- `.planning/phases/04-dashboard-spec/dashboard-command-center-spec.md` — Added 1,044 lines: Sections 9 (Action Buttons), 10 (Automation Tracker + full DDL), and 11 (Developer Guide)

## Decisions Made

- The `[ SEND COMMS ]` button is the only CONFIRM REQUIRED button — the other three are IMMEDIATE because they are read-only checks or document generators
- `recipient_email` is intentionally excluded from `automation_log` storage (only `comm_type` + `action_type` logged) to minimize PHI exposure
- Two-step n8n automation_log write pattern (INSERT 'running' first, then UPDATE to 'completed'/'failed') is required by spec to ensure the RUNNING badge state is visible to Valentina during automation execution
- Phase 4 DDL is included directly in the spec document rather than a separate migration file — developer can run it as one block

## Deviations from Plan

None — plan executed exactly as written. All four action buttons, the automation tracker, and all developer guide subsections (11A through 11F) were completed as specified.

## Issues Encountered

None.

## User Setup Required

None — this plan produces spec documentation only. Developer setup requirements are documented in Section 11 of the spec itself.

## Next Phase Readiness

- **Phase 4 complete:** The `dashboard-command-center-spec.md` is a fully self-contained handoff artifact covering DASH-01 through DASH-08. A TouchDesigner developer needs nothing else to build the dashboard.
- **Phase 5 readiness:** The `automation_log` table (Section 10.9) and `obligations` table (Section 10.10) are designed as shared surfaces for Phase 5 AI automation. The `triggered_by` column distinguishes sources (`dashboard_button`, `scheduled`, `ai_triggered`). Section 11F documents the exact integration points.
- **Pre-launch blockers (Valentina action required):**
  1. CAQH attestation date — log into proview.caqh.org, find last attestation date, report to Maxi
  2. Tebra Customer Key — retrieve from Tebra portal and give to developer for n8n vault storage
  3. Business license renewal — City of Torrance BL-LIC-051057 at torranceca.gov
  4. Google Workspace migration — required for SEND COMMS button (patient email)
  5. Nine payer contract date confirmations (estimated dates marked with `~`)

---

## Self-Check: PASSED

- FOUND: `.planning/phases/04-dashboard-spec/dashboard-command-center-spec.md`
- FOUND: `.planning/phases/04-dashboard-spec/04-03-SUMMARY.md`
- FOUND: commit `2087b13` (feat(04-03): action buttons, automation tracker, developer guide)

---
*Phase: 04-dashboard-spec*
*Completed: 2026-03-01*
