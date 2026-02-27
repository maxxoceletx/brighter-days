# Phase 1: Compliance Audit & Verification - Context

**Gathered:** 2026-02-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Verify every legal, regulatory, and insurance obligation for operating a CA telehealth psychiatry practice under Valentina Park MD, PC. Produce documented proof of compliance for each item, produce compliant documents where missing, and fix gaps immediately. All compliance data feeds into the TouchDesigner command center as an interactive compliance tab.

</domain>

<decisions>
## Implementation Decisions

### Document Structure & Data Layer
- Single master compliance system — not separate documents per topic
- All compliance data lives in a **dedicated Brighter Days Supabase project** (NOT shared with FindItNOW or Momo)
- Compliance data is structured in Supabase tables so TouchDesigner can query and display it
- The compliance audit outputs are consumed as an interactive tab in the TouchDesigner command center — not static files
- Everything routes through TD — this is the primary interface for viewing and managing compliance

### Verification Depth
- Verify status AND produce the actual compliant document for each item (not just a status check)
- All produced documents are practice-ready — pre-filled with Valentina's real info (NPI 1023579513, entity name, payer list, etc.), not templates with blanks
- HIPAA Security Risk Analysis uses the HHS SRA Tool format (most defensible if audited by OCR)
- Informed consent form formatted for Tebra's patient intake system (digital, not PDF)

### Gap Handling
- Gaps are fixed immediately during the audit — audit = remediation in one pass
- Human-required tasks (e.g., "log into CAQH and re-attest") surface as actionable items in the TD action queue
- System drafts all outreach (emails, letters, scripts) for external parties — Valentina reviews and sends
- Three severity levels for compliance items: CRITICAL (blocks first patient), WARNING (needs attention within 30 days), INFO (nice to have) — color-coded in TD display

### ASCII Visual Aesthetic
- Modern and dynamic ASCII art — not basic retro terminal
- Think animated, flowing, styled text-based UI — visually impressive, not plain monospace
- This applies to the compliance tab and all other TD panels

### Current Status (Known Inputs)
- CAQH ProView: Active login, accessible — attestation status needs verification
- DEA registration: Active, details known (number, schedules, address)
- Malpractice insurance: Confirmed active, covers telehealth psychiatry + controlled substance prescribing
- Tebra BAA: Likely signed during onboarding — needs confirmation and locating the actual agreement
- 17 insurance payers credentialed (full list in PROJECT.md)
- NPI: 1023579513

### Claude's Discretion
- Supabase table schema design for compliance data
- Compliance panel layout design within TD (user said "you decide" on display style)
- How to structure the HHS SRA Tool assessment for a solo telehealth practice
- Technical approach to querying compliance data from Supabase into TD

</decisions>

<specifics>
## Specific Ideas

- The entire Brighter Days system runs through TouchDesigner — every output from every phase should be designed with TD consumption in mind
- ASCII art should look modern and dynamic, not basic — think stylized, animated, flowing text-based UI
- Dedicated Supabase project for Brighter Days (separate from all other projects)
- When drafting outreach for Valentina, make it ready to send — not a template she has to rewrite

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-compliance-audit-verification*
*Context gathered: 2026-02-27*
