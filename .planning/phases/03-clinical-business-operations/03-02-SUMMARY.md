---
phase: 03-clinical-business-operations
plan: "02"
subsystem: clinical-operations
tags: [crisis-protocol, telehealth, youth-psychiatry, CANRA, C-SSRS, 988, SOP, mandatory-reporting]

# Dependency graph
requires:
  - phase: 01-compliance-audit-verification
    provides: patient-location-protocol.md — patient address verification prerequisite for 911 dispatch
  - phase: 03-clinical-business-operations
    provides: SOP-01 patient intake workflow — emergency contact and physical address fields collected at intake
provides:
  - SOP-03 complete crisis protocol with three-tier escalation, CANRA quick-reference, safety plan template, and post-crisis documentation
  - Patient-facing safety plan template (Appendix A) ready for clinical use
  - Telehealth edge case decision table (4 scenarios)
  - CANRA quick-reference with LA County DCFS contact, 36-hour timeline, BCIA 8572 form URL
  - Post-crisis documentation checklist (Appendix B)
  - Peer consultation recommendation with placeholder fields for consultant info
affects: [03-03-biller-onboarding, 04-dashboard-spec, 05-ai-assistant-spec]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "SOP heading structure: Purpose > Scope > Roles > Procedure Sections > Appendices — consistent with all Phase 3 SOPs"
    - "Three-tier escalation: Tier 1 (passive ideation) / Tier 2 (plan or intent) / Tier 3 (plan + intent + means / in-progress)"
    - "C-SSRS as standard youth suicide risk instrument across all crisis events"
    - "988 as primary statewide crisis resource (auto-routes to local CA crisis center)"

key-files:
  created:
    - .planning/phases/03-clinical-business-operations/sop-03-crisis-protocol.md
  modified: []

key-decisions:
  - "Three-tier crisis model adopted: Tier 1 (passive ideation), Tier 2 (plan OR intent), Tier 3 (plan AND intent AND means / in-progress) — distinct actions at each tier"
  - "C-SSRS (Columbia Suicide Severity Rating Scale) selected as standard youth suicide assessment instrument — validated for age 5+, free from Columbia University, no specialized training required"
  - "988 is primary statewide crisis resource — auto-routes to local CA crisis center, resolves county-specific routing problem for statewide telehealth practice"
  - "Parent notification is mandatory for ALL Tier 1+ events involving minors — Tier 1 before session ends, Tier 2 within 30 minutes, Tier 3 concurrent with 911 call"
  - "CANRA quick-reference only (not training document) — Valentina is already familiar; operational contacts and timelines are the value-add"
  - "Peer consultation recommendation placed in SOP with placeholder fields — not yet established; pre-launch action required"

patterns-established:
  - "SOP Appendix pattern: patient-facing template (Appendix A) + provider documentation checklist (Appendix B) for clinical SOPs"
  - "Pre-populated contacts pattern: all crisis SOPs have emergency numbers filled in, not blank fields, so a covering provider can use without lookup"

requirements-completed: [OPS-03]

# Metrics
duration: 3min
completed: 2026-03-01
---

# Phase 3 Plan 02: SOP-03 Crisis Protocol Summary

**Three-tier telehealth crisis protocol for youth patients with CANRA quick-reference, C-SSRS instrument guide, patient safety plan template, and post-crisis documentation requirements — covering four telehealth-specific edge cases and pre-populated with all CA crisis contacts**

## Performance

- **Duration:** ~3 min
- **Started:** 2026-03-01T09:35:36Z
- **Completed:** 2026-03-01T09:38:33Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- Complete SOP-03 crisis protocol document (445 lines) covering all plan-specified sections
- Three-tier crisis escalation with distinct numbered checklists per tier and 24/48-hour follow-up requirements
- Telehealth edge case decision table covering disconnect, unknown location, parent refusal, and CANRA trigger scenarios
- Patient-facing safety plan template (Appendix A) with Dr. Park's direct number and all crisis contacts pre-populated
- Post-crisis documentation checklist (Appendix B) for use immediately following Tier 2/3 events
- Peer consultation recommendation with placeholder fields for pre-launch completion
- Provider self-care guidance including CA Physicians Health Program contact (800) 657-2472

## Task Commits

Each task was committed atomically:

1. **Task 1: Write SOP-03 Crisis Protocol** - `36c90da` (feat)

**Plan metadata:** pending final commit

## Files Created/Modified

- `.planning/phases/03-clinical-business-operations/sop-03-crisis-protocol.md` - Complete SOP-03 including pre-session setup, parent presence guidance by age, three-tier escalation, telehealth edge cases, CANRA quick-reference, C-SSRS instrument reference, crisis resources table, peer consultation recommendation, patient-facing safety plan template, post-crisis documentation protocol, and provider self-care guidance

## Decisions Made

- **Tier boundary clarification:** Tier 2 requires plan OR intent (not both); Tier 3 requires plan AND intent AND means (or in-progress event). This distinction from the plan spec was maintained exactly — it is clinically critical.
- **C-SSRS version guidance added:** Screener for routine sessions, Lifetime Baseline for first session and post-crisis, Recent version for follow-ups — matches Columbia's recommended usage pattern.
- **Parent notification timing specified precisely:** Tier 1 before session ends, Tier 2 during session or within 30 minutes, Tier 3 concurrent with 911 call — fills a gap the plan left open.
- **Video-freeze edge case added:** Added beyond the plan's four edge cases (Rule 2 — missing critical functionality) — clinician needs guidance when video freezes but audio continues, a common telehealth failure mode.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Added video-freeze edge case to telehealth edge case table**
- **Found during:** Task 1 (writing edge case decision table)
- **Issue:** Plan specified four edge cases (disconnect, unknown location, parent refusal, CANRA trigger). Video freeze with audio continuing is a fifth common telehealth scenario that a covering provider would not know how to handle.
- **Fix:** Added "Video freezes but audio continues" row to edge case table with specific action (continue by audio, request verbal location confirmation) and escalation path (if audio also lost, treat as disconnect).
- **Files modified:** sop-03-crisis-protocol.md
- **Verification:** Edge case table has 5 rows covering all specified scenarios plus freeze scenario
- **Committed in:** 36c90da (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (Rule 2 — missing critical)
**Impact on plan:** Minor scope addition that strengthens the SOP. No plan requirements removed or modified. The four required edge cases are all present.

## Issues Encountered

None — research file contained all required clinical details (C-SSRS, CANRA contacts, 988 resources, MRSS, LA County crisis line). Plan spec was complete and unambiguous.

## User Setup Required

**Pre-launch action required (not blocking SOP creation):** Establish peer consultation agreement with 1-2 board-certified psychiatrists. Section 8 of SOP-03 contains placeholder fields for consultant name, phone, email, and agreement date. Once established, update the SOP and store contact info in 1Password Clinical Operations category.

## Next Phase Readiness

- SOP-03 is complete and ready for use as of 2026-03-01
- Phase 3 Plan 03 (SOP-04: Business Structure + SOP-05: Biller Onboarding) is next
- Cross-references in SOP-03 point to SOP-01 (intake fields) and Phase 1 patient location protocol — both upstream documents exist
- No blockers for Plan 03 execution

---
*Phase: 03-clinical-business-operations*
*Completed: 2026-03-01*
