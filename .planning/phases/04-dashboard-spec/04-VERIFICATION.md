---
phase: 04-dashboard-spec
verified: 2026-03-01T12:00:00Z
status: passed
score: 12/12 must-haves verified
re_verification: false
---

# Phase 4: Dashboard Command Center Specification — Verification Report

**Phase Goal:** A complete, implementable specification exists for the TouchDesigner-based practice command center that a developer can build from without further discovery
**Verified:** 2026-03-01
**Status:** PASSED
**Re-verification:** No — initial verification

---

## Goal Achievement

### Success Criteria from ROADMAP.md

| # | Success Criterion | Status | Evidence |
|---|-------------------|--------|----------|
| 1 | Spec defines TD command center layout with ASCII art visual aesthetic — all panels, data sources, and interaction patterns documented | VERIFIED | Sections 1-3 define Container COMP hierarchy (Section 2.1), pixel-level grid coordinates for both 2560x1440 and 3840x2160 (Section 2.3), 4 animation states (Section 3.4), border characters, and color palette (Section 3.2) |
| 2 | Spec includes compliance status panel showing green/yellow/red for every tracked license, cert, BAA, and CAQH status | VERIFIED | Section 5 (DASH-02) defines `panel_compliance`, `credential_alert_queue` data source, per-row color indicators `[###]`, CAQH NULL handling as `[???]` AMBER, estimated date `~` prefix, and click-to-detail overlay |
| 3 | Spec covers obligations checklist, compliance calendar, and billing oversight with data flow from Tebra API | VERIFIED | Section 6 (DASH-03) — full obligations panel with mark-complete/snooze/auto-complete; Section 7 (DASH-04) — dual-mode calendar with list and grid views; Section 8C (DASH-06) — billing panel with AR aging ASCII bar chart |
| 4 | Spec documents Tebra API integration requirements (endpoints, polling frequency, data mapping) including research findings on API capabilities | VERIFIED | Section 8A defines all three tiers: Tier 1 SOAP API with full SOAP envelope examples for GetAppointments/GetTransactions, Tier 2 CSV export with n8n workflow steps, Tier 3 manual entry forms. PHI stripping Code node documented. |
| 5 | Spec defines functional action buttons and automation tracking — what each button does, what triggers automations, how status is displayed | VERIFIED | Section 9 defines all 4 buttons (CAQH CHECK, COMPLIANCE REPORT, PAYER STATUS, SEND COMMS) with webhook URLs, JSON payload schemas, confirmation tiers, Python implementations, and IDLE→RUNNING→DONE/FAILED state machines. Section 10 defines scrolling ASCII automation log with expandable detail. |

**Score:** 5/5 success criteria verified

---

### Observable Truths (Derived from Plan must_haves)

#### Plan 01 Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | A developer can read the spec and know the exact TD Container COMP hierarchy | VERIFIED | Section 2.1: exact hierarchy from Window COMP through dashboard_root → overdue_banner, panel_grid, and 8 panel Container COMPs. Section 2.4: every operator inside each Container listed by name, type, and purpose. |
| 2 | Spec defines 8-panel layout with pixel-level grid coordinates for 2560x1440 and 3840x2160 | VERIFIED | Section 2.3: pixel tables for both resolutions. At 2560x1440 — e.g., panel_today: x=0, y=60, w=853, h=440. At 3840x2160 — full table with all 8 panels. |
| 3 | Every panel has four ASCII animation states with specific TD operator references | VERIFIED | Section 3.4: IDLE (Pattern CHOP sine 0.2Hz), LOADING (spinner list `\|/-\\`, Pattern CHOP square 4Hz), ALERT (Pattern CHOP square 1Hz, color toggle Python), INTERACTION (single WHITE flash + CYAN hold 2s). Python code included for each. |
| 4 | Compliance status panel maps every credential from Phase 2 credential_alert_queue to green/yellow/red | VERIFIED | Section 5.4-5.6: data source is `credential_alert_queue` view. Color mapping table: GREEN 90+ days `(0.0, 0.9, 0.2)`, YELLOW 30-90 days, AMBER 7-30 days, RED <7 or EXPIRED. Python `buildCredentialList()` function included. |
| 5 | Overdue banner behavior fully specified: trigger, ASCII pattern, pulsing animation, dismissal rules | VERIFIED | Section 3.5: trigger = EXPIRED rows in credential_alert_queue. Pattern CHOP square 1Hz drives RED background pulse. Scrolling text via Ramp CHOP Translate X. Python builds text from `table_expired_items`. Dismissal: cannot dismiss — only resolves when ALL EXPIRED rows removed. |

#### Plan 02 Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 6 | Obligations checklist spec defines how items are added, marked complete (manual and auto), snoozed, and sorted by urgency | VERIFIED | Section 6.7: DONE button → PATCH to Supabase, ZZZ snooze picker → PATCH with snoozed_until, NOTE button → inline text area. Section 6.8: auto-complete detects n8n writing `status='completed'`, animates GREEN flash, adds "Auto-completed by [action_type]" note. Overdue items pinned to top. |
| 7 | Calendar spec describes both views (countdown list and monthly grid) with toggle behavior and data source | VERIFIED | Section 7.4: Mode A countdown list grouped by month with `[R]/[O]/[C]/[P]` category badges. Mode B monthly ASCII grid with `[N]` count badges and `[!]` for overdue. Toggle via Button COMP. Python `render_calendar_grid()` provided (Section 7.6). |
| 8 | Tebra integration spec covers all three tiers with enough detail to implement any tier independently | VERIFIED | Section 8A.2 (Tier 1): full SOAP envelope XML, n8n Code node JavaScript for PHI stripping, Supabase upsert pattern. Section 8A.3 (Tier 2): Google Drive trigger, CSV parsing JavaScript. Section 8A.4 (Tier 3): manual entry form with Text COMPs. All three write to same Supabase schema. |
| 9 | Billing oversight spec defines exactly which aggregate metrics are shown with no patient-level detail | VERIFIED | Section 8C.4: claims_submitted (count + delta vs last month), claims_denied (count + denial rate %), AR aging ASCII bar chart with 4 buckets (current/<30d, 30-60d, 60-90d, 90+d), total AR. Python `ar_bar()` function provided. HIPAA note: no patient names, CPT codes, or individual claim detail. |
| 10 | PHI scope is explicit in every data display section | VERIFIED | Section 4.4 (Today panel): PHI scope callout — first_name_only + appointment_time only. Section 8B.3 (Appointments panel): "PHI scope reminder (spec note for developer)" explicitly listed. Section 8C.7 (Billing): "aggregates only" note. Section 11D: HIPAA Compliance Summary consolidates all PHI rules. |

#### Plan 03 Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 11 | Every action button has complete spec: label, webhook URL pattern, payload schema, confirmation tier, and inline status state machine | VERIFIED | Section 9.4-9.7: each button has label, webhook URL (`https://{n8n_host}/webhook/{path}`), JSON payload, confirmation tier (IMMEDIATE or CONFIRM REQUIRED), n8n workflow steps, and result display. Section 9.8: `setBadgeState()` Python utility function with IDLE/RUNNING/DONE/FAILED states. |
| 12 | Spec defines exactly how a button press flows from TD through n8n back to TD | VERIFIED | Section 9.3: numbered 12-step flow — click → Panel Execute DAT → build payload → set URL → pulse Web Client DAT → badge RUNNING → timer 5s → n8n executes → writes automation_log → quick-poll → read status → badge DONE/FAILED. |

**Score:** 12/12 truths verified

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|---------|--------|---------|
| `.planning/phases/04-dashboard-spec/dashboard-command-center-spec.md` | Master spec covering DASH-01 through DASH-08 | VERIFIED | File exists, 3030 lines, 157KB. Sections 1-11 all present and substantive. All 8 DASH requirements addressed. |
| `.planning/phases/04-dashboard-spec/04-01-SUMMARY.md` | Summary of Plan 01 | VERIFIED | File exists, 120 lines. Documents decisions, commits, and requirements completed. |
| `.planning/phases/04-dashboard-spec/04-02-SUMMARY.md` | Summary of Plan 02 | VERIFIED | File exists, 8613 bytes. |
| `.planning/phases/04-dashboard-spec/04-03-SUMMARY.md` | Summary of Plan 03 | VERIFIED | File exists, 7078 bytes. Lists 9-step setup checklist, 5 pre-launch blockers, 8 n8n workflows. |

---

### Key Link Verification

| From | To | Via | Status | Details |
|------|-----|-----|--------|---------|
| spec (compliance panel) | Supabase `credential_alert_queue` view | Web Client DAT REST polling | VERIFIED | Section 5.4: explicit GET query to `/rest/v1/credential_alert_queue`, response fields consumed listed, Web Client DAT operator named `webClient_credentials` in `panel_grid`. |
| spec (overdue banner) | `credential_alert_queue WHERE alert_level='EXPIRED'` | Python callback checking EXPIRED rows | VERIFIED | Section 3.5: `execute_banner_visibility` DAT Execute watches `table_expired_items`, checks `alert_level='EXPIRED'` rows, drives banner visibility. Python code provided. |
| spec (obligations panel) | Supabase `obligations` table | Web Client DAT REST polling + POST for status updates | VERIFIED | Section 6.3: `dat_obligations` polls `obligations` table. Section 6.7: PATCH requests with `status='completed'` or snooze date. Web Client DAT PATCH pattern documented. |
| spec (calendar panel) | Supabase `obligations` + `credential_alert_queue` | Combined query via Python merge | VERIFIED | Section 7.3: three sources listed (`obligations`, `credential_alert_queue`, `payer_credentialing_alerts`). Python `CalendarItem` struct and `script_calendar_merge` described. |
| spec (Tebra integration) | n8n → Tebra SOAP API → Supabase `tebra_appointments` + `tebra_billing_summary` | n8n HTTP Request node with SOAP envelope | VERIFIED | Section 8A.2: complete SOAP envelope XML for GetAppointments/GetTransactions, Code node JavaScript for PHI stripping, Supabase upsert target tables specified. |
| spec (billing panel) | Supabase `tebra_billing_summary` | Web Client DAT REST polling | VERIFIED | Section 8C.3: `dat_billing` Web Client DAT polls `/rest/v1/tebra_billing_summary?order=period.desc&limit=2`. Response consumed by `compute_billing_display()` Python function. |
| spec (action buttons) | n8n webhook URLs | Web Client DAT POST with JSON payload | VERIFIED | Section 9.3: `webClient_action_post` DAT with dynamic URL and body. Step-by-step flow documented. Python code for each button in Sections 9.4-9.7. |
| spec (automation tracker) | Supabase `automation_log` table | Web Client DAT GET polling | VERIFIED | Section 10.3: `webClient_automation_log` in panel_grid, query to `/rest/v1/automation_log?order=triggered_at.desc&limit=20`. Quick-poll 5s after button press also specified. |
| spec (button state machine) | `automation_log.status` column | Latest row matching action_type determines button visual state | VERIFIED | Section 9.8: `execute_action_state` DAT Execute watches `webClient_action_poll`, reads `status` field, maps to button badge via `setBadgeState()`. IDLE/RUNNING/DONE/FAILED state machine Python provided. |

---

### Requirements Coverage

All 8 DASH requirements claimed in plan frontmatter are addressed:

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|---------|
| DASH-01 | 04-01-PLAN.md | TouchDesigner command center with real-time visual interface | SATISFIED | Section 4: Today/Morning Briefing panel fully specified with appointments, overdue badge, obligations summary, billing snapshot, "BRIGHTER DAYS" startup animation. |
| DASH-02 | 04-01-PLAN.md | Compliance status panel with visual indicators for all credentials | SATISFIED | Section 5: per-row `[###]` colored indicators, `[???]` CAQH NULL state, `~` estimated-date prefix, click-to-detail overlay, row transition pulse animation. |
| DASH-03 | 04-02-PLAN.md | Running obligations checklist with status and priority | SATISFIED | Section 6: countdown list sorted by urgency, mark-complete (PATCH), snooze picker, notes expansion, auto-complete on n8n write, seed SQL provided. |
| DASH-04 | 04-02-PLAN.md | Compliance and operations calendar with deadlines and renewals | SATISFIED | Section 7: dual-mode (countdown list + monthly ASCII grid), toggle Button COMP, month navigation, audio alert configuration overlay. |
| DASH-05 | 04-02-PLAN.md | Tebra API integration for appointment and billing data | SATISFIED | Section 8A-8B: three-tier Tebra strategy (SOAP API, CSV export, manual entry), full SOAP envelopes, PHI stripping Code nodes, appointments display panel. |
| DASH-06 | 04-02-PLAN.md | Billing oversight view with claims submitted, denials, AR aging | SATISFIED | Section 8C: AR aging ASCII bar chart, month-over-month delta, denial rate color coding (>5% AMBER, >10% RED), `ar_bar()` Python function, tier indicator badge. |
| DASH-07 | 04-03-PLAN.md | Functional action buttons triggering automations | SATISFIED | Section 9: 4 buttons with webhook URLs, JSON payload schemas, confirmation tiers, full Python implementation, IMMEDIATE vs CONFIRM REQUIRED distinction. |
| DASH-08 | 04-03-PLAN.md | Automation process tracker with status of running/completed automations | SATISFIED | Section 10: scrolling ASCII dot-leader log, per-status color coding, expandable detail overlay, `format_log_line()` Python, running spinner, auto-scroll on new entry. |

**Requirements from REQUIREMENTS.md traceability table:** All 8 DASH requirements (DASH-01 through DASH-08) are mapped to Phase 4 and marked Complete. No orphaned requirements.

---

### Anti-Patterns Found

The spec document has a structural note: the table of contents (lines 537-558) contains four placeholder stub lines (`*[Placeholder — to be filled by Plan 02]*` and `*[Placeholder — to be filled by Plan 03]*`). These are TOC stubs, NOT implementation stubs. Immediately after these lines, the complete specifications for those sections appear (Sections 6-11 start at line 1042 and continue to line 3030). This is a document organization artifact — the spec was built incrementally across three plans and the TOC headers from Plan 01 were not updated when Plans 02 and 03 added content.

| File | Lines | Pattern | Severity | Impact |
|------|-------|---------|----------|--------|
| `dashboard-command-center-spec.md` | 539, 545, 551, 557 | Placeholder TOC entries in mid-document table of contents | INFO | None — full content for all sections follows immediately at lines 1042+. Does not block developer use of the spec. |

No actual implementation stubs, empty function bodies, TODO comments, or missing content was found.

---

### Human Verification Required

This is a specification document, not running code. There are no automated tests to run. The following items require human judgment to fully verify:

**1. Specification Completeness for a Real TD Developer**
- **Test:** Have a TouchDesigner developer (or experienced TD user) read Section 2 and confirm the Container COMP hierarchy is buildable without ambiguity
- **Expected:** Developer can build the project structure from Section 2 alone without questions
- **Why human:** Requires TD domain expertise to evaluate whether operator specifications are sufficiently detailed

**2. n8n Workflow Buildability**
- **Test:** Have an n8n developer review Section 11C's 8-workflow inventory and confirm each workflow can be built from the spec information provided
- **Expected:** Developer can stand up all 8 workflows from the spec without consulting external Tebra documentation (beyond the WSDL URL open question acknowledged in Section 11E)
- **Why human:** Requires n8n and Tebra API domain expertise

**3. HIPAA Compliance Assessment**
- **Test:** Have a HIPAA compliance reviewer read Section 11D and confirm the PHI scope and safeguard documentation is sufficient for a risk assessment
- **Expected:** All PHI exposure vectors are identified and mitigation strategies are specified
- **Why human:** Requires HIPAA compliance domain expertise to evaluate adequacy

---

## Document Structure Note

The spec file contains a redundant set of section headers (lines 537-558) from Plan 01's initial skeleton that were not removed when Plans 02 and 03 added full content. This creates a TOC-like stub block followed by the actual spec content. While this is cosmetically imperfect, it does not impair usability — the full content for all sections is present and complete. A developer reading from start to finish would encounter the stubs and then immediately find the full specifications. The spec could be cleaned up by removing lines 537-558 and the corresponding section headers at lines 525-534 (which are duplicated by the full content below).

---

## Gaps Summary

None. All 12 must-haves are verified. All 8 DASH requirements are satisfied. The spec document is substantive (3030 lines, 157KB) and covers every panel, data source, interaction pattern, animation state, webhook, SQL DDL, and developer setup step required for a TouchDesigner developer to build the dashboard.

The spec is a complete, self-contained handoff artifact. Phase 4 goal achieved.

---

_Verified: 2026-03-01_
_Verifier: Claude (gsd-verifier)_
