# Phase 4 Context: Dashboard Command Center Specification

**Created:** 2026-03-01
**Phase goal:** A complete, implementable specification for the TouchDesigner-based practice command center that a developer can build from without further discovery

---

## Locked Decisions

These decisions were made during the discuss-phase session. Downstream agents (researcher, planner, executor) should treat these as fixed constraints — not re-ask or override.

---

### 1. Panel Layout & Density

**Home screen:** Today's overview — morning briefing format. When Valentina opens the dashboard she sees: today's appointments, overdue obligations, compliance status summary, and recent billing activity. Not a deep-dive into any one area — a situational awareness view.

**Information density:** Dense (6-8 panels visible simultaneously). Think stock trading terminal or NASA mission control. This is intentional — the dashboard should feel like a command center, not a simple status page.

**Display target:** Single external monitor, 24-32 inches. The spec should assume a dedicated display (not squeezed onto a laptop screen). Layout should be designed for ~2560x1440 or 3840x2160 resolution.

**ASCII art aesthetic:** Animated ASCII art — dynamic, flowing, art installation feel. Not static retro terminal. Not clean modern with ASCII accents. The animation IS the aesthetic: spinning indicators, scrolling text banners, animated borders, flowing characters. The spec should describe animation behaviors for each panel — idle state, loading state, alert state, interaction state. This is what makes the dashboard feel alive.

---

### 2. Action Buttons & Triggers

**Enabled actions (all four):**
- Send patient communications (intake packets, reminders, consent forms)
- Run CAQH re-attestation check (one-click workflow)
- Generate compliance reports (current-state snapshot for audits)
- Trigger payer status checks (credentialing status across portals)

**Confirmation behavior:** Tiered.
- **Immediate (no confirm):** Generate report, check status, refresh data
- **Confirm required:** Send email/communication, submit forms, trigger external API calls that modify state

**Status feedback:** Both inline badges AND a dedicated automation panel.
- Inline: small status indicator next to each action button (idle/running/done/failed)
- Dedicated panel (DASH-08): full automation history with timestamps, status, logs, expandable detail

**Tebra write access:** Defer to research. The researcher should investigate Tebra API capabilities (read, write, webhook support, cost). The spec will define the dashboard's Tebra integration based on what's actually possible. Design the spec to accommodate read-only as baseline, read+limited-write as stretch goal.

---

### 3. Tebra Data Integration

**Priority data:** Appointments and billing are equally important — show side by side. Neither takes priority.

**Data freshness:** Near-real-time (every 15-30 minutes). Not live polling every minute. Not daily batch. 15-30 min is the sweet spot — appointments don't change mid-session, billing doesn't need second-by-second updates.

**Fallback strategy (tiered):** The spec must define all three tiers:
- **Tier 1 (preferred):** Tebra API direct integration — real-time data pull
- **Tier 2 (fallback):** Tebra report export (CSV/PDF) with auto-import pipeline
- **Tier 3 (last resort):** Manual data entry panels — Maxi enters key numbers daily

Each tier should be spec'd independently so the developer can implement whichever is feasible based on Tebra API research findings.

**PHI scope on dashboard:** First name + appointment time. Example: "Alex at 2:00 PM, Jordan at 3:30 PM." No full names, no diagnoses, no clinical notes visible on the dashboard. Aggregates for billing (claim counts, denial counts, AR totals — no patient-level billing detail).

**HIPAA note for spec:** The external monitor displaying the dashboard must be in a location where non-authorized individuals cannot view PHI. The spec should note physical security requirements for the display.

---

### 4. Calendar & Obligations UX

**Calendar model:** Hybrid — countdown list as primary view, calendar grid as secondary.
- **Primary (default):** Countdown timers sorted by urgency. Each item shows "X days until [obligation]" with color coding (green > 90 days, yellow 30-90, red < 30, pulsing red = overdue).
- **Secondary (toggle):** Monthly calendar grid for planning. Deadline markers on specific dates. Click a date to see what's due.

**Obligation scope:** Compliance + operations. Not just regulatory items. Includes:
- Regulatory: licenses, certs, BAAs, CAQH attestation, DEA renewals, business license, malpractice
- Operational: monthly biller performance review, quarterly tax filings, annual SOP reviews, payer re-credentialing windows

Does NOT include: individual patient follow-ups, day-to-day clinical tasks. Those stay in Tebra.

**Overdue escalation:** Full treatment.
- Persistent red banner at the top of dashboard (cannot be dismissed until resolved)
- Animated/pulsing ASCII art effect on overdue items (flashing borders, attention-grabbing but on-brand)
- Optional audio alert for critical overdue items (configurable — can be turned on/off, can select chime type)

**Interactivity:** Interactive + auto-update.
- Users can click to mark items complete, snooze reminders, add notes
- Automations can auto-mark obligations complete (e.g., CAQH check runs successfully → CAQH attestation obligation auto-marks done with timestamp)
- The dashboard IS the task management system for compliance obligations — not a mirror of something managed elsewhere

---

## Code Context

**Existing assets from prior phases:**

| Asset | Location | Relevance to Phase 4 |
|-------|----------|----------------------|
| Supabase compliance_items table | Phase 1 schema/seed | Data source for compliance panel (DASH-02) |
| Credential inventory | Phase 2 credential-inventory.md | Data source for credential status, expiry dates |
| Payer tracker (17 payers) | Phase 2 payer-tracker-seed.sql | Data source for billing oversight (DASH-06) |
| Alert architecture spec | Phase 2 alert-architecture-spec.md | Defines alert windows and notification tiers — dashboard implements these |
| 1Password vault structure | Phase 2 1password-vault-spec.md | Credential storage; dashboard references but doesn't access directly |
| All 5 SOPs | Phase 3 sop-01 through sop-05 | Workflows the dashboard supports (intake, CURES, crisis, business, billing) |

**Key technical decisions from prior phases:**
- TouchDesigner is the platform (desktop app, not web)
- n8n is under evaluation as automation backbone (Phase 4/5 decision)
- Tebra is the EHR — complement, don't replace
- Third-party billers handle claims; dashboard provides oversight only
- Supabase is the backend data store

---

## Research Questions for Researcher

These emerged during discussion and need investigation:
1. **Tebra API capabilities** — What endpoints exist? Read-only or read/write? Cost? Rate limits? MCP availability? This is the biggest technical unknown.
2. **TouchDesigner + Supabase connectivity** — How does TouchDesigner pull real-time data from Supabase? WebSocket? REST polling? Python scripting inside TD?
3. **TouchDesigner + n8n integration** — Can n8n trigger TouchDesigner updates? Can TD trigger n8n workflows? What's the communication protocol?
4. **ASCII art animation in TouchDesigner** — What COMP/SOP/TOP nodes are best for text rendering, character animation, and the flowing ASCII aesthetic?
5. **Audio alerts in TouchDesigner** — How to implement configurable audio notifications (CHOP nodes, audio file playback)?

---

## Deferred Ideas

None captured during this discussion — all suggestions stayed within Phase 4 scope.

---

## Next Steps

- `/gsd:plan-phase 4` — create execution plans based on this context
- Researcher will investigate the 5 research questions above during planning
