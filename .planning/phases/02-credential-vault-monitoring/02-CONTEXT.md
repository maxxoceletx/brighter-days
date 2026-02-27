# Phase 2: Credential Vault & Monitoring - Context

**Gathered:** 2026-02-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Organize every practice credential, login, license, and certificate into a structured system with a 1Password vault, a Supabase-backed credential inventory, and a payer credentialing tracker for all 17 panels. Alert architecture is specified but not built — TD dashboard (Phase 4/5) implements the live alert system.

This phase produces: data structures, seed data, printable exports, vault organization specs, and alert architecture specs. NO working software — all engineering is architecture/spec only, handed off to Superpowers sessions for implementation.

</domain>

<decisions>
## Implementation Decisions

### 1Password Vault Structure
- Valentina already has a 1Password account — create a new shared "Brighter Days Practice" vault inside it
- Shared vault for all practice logins (Tebra, CAQH, DEA, payer portals, state boards, email, etc.)
- Personal items (banking, SSN, personal accounts) stay in Valentina's personal vault — NOT in the shared vault
- Both Maxi and Valentina have access to the shared practice vault
- Claude decides optimal vault category organization (by functional grouping based on how credentials are actually used)

### Credential Inventory
- Supabase is the source of truth — extend Phase 1 compliance tables with credential-specific fields (expiry dates, renewal cycles, payer IDs)
- Generate a printable export (markdown/PDF) that Valentina can hand to an auditor, payer, or credentialing body
- Inventory covers: every license, certification, NPI (1023579513), DEA# (FP3833933), and all 17 payer IDs with expiry dates
- Dedicated Brighter Days Supabase project (same one from Phase 1 — NOT shared with FindItNOW or Momo)

### Alert Delivery & Cadence
- Alerts go to BOTH Maxi and Valentina — both handle all credential tasks (no role split)
- Delivery channels: Google Calendar events + email (belt and suspenders for high-stakes deadlines)
- Standard alert cadence: 90/60/30/7 days before expiry
- CAQH 120-day re-attestation uses the same standard cadence (90/60/30/7)
- Alerts STOP once the task is marked complete — no continued nagging after resolution
- Alert system is a SPEC for Phase 4/5 TD dashboard — Phase 2 documents the architecture, Phase 4/5 builds it
- No working calendar events or email automation in Phase 2 — spec only

### Payer Credentialing Tracker
- Full dossier per payer: contract status, credentialing date, re-credentialing deadline, portal login reference, provider relations phone/email, credentialing rep name, portal URL, fee schedule notes, claim submission method, timely filing limits, denial patterns, network type (PPO/HMO/EPO)
- Lives in BOTH Supabase (live queryable data for TD) AND markdown snapshot (reference document)
- Unknown fields: fill with best estimates based on industry norms (typically 3-year re-cred cycles), flag as "ESTIMATED" — not left blank
- All 17 panels: Aetna, Blue Cross CA, Blue Shield CA, CA Health & Wellness, Cigna, Cigna Behavioral Health, Coastal Communities, Facey Medical, Health Net CA, Hoag, Kaiser Southern CA, Magellan Behavioral, Medicaid CA, Medicare CA Southern, Providence Health Plan, Torrance Hospital IPA, Torrance Memorial MC

### Corrections from Phase 1
- **Medicare is ACTIVE/ENROLLED** — Phase 1 flagged it as "DEACTIVATED 1/31/2026" but this is incorrect. Medicare enrollment is current. Phase 2 tracker should reflect active status.

### Engineering Handoff Rule
- All software engineering work (Supabase schema, queries, automation code) produces architecture specs and seed data only
- Actual implementation is handed off to fresh Superpowers sessions
- GSD does NOT spawn coding subagents

### Claude's Discretion
- 1Password vault category naming and grouping logic
- Supabase table schema design for credential inventory and payer tracker
- Printable export format and layout
- Alert architecture spec format (what the TD team needs to build from)
- How to structure estimated re-credentialing dates when actuals are unknown

</decisions>

<specifics>
## Specific Ideas

- Payer tracker should include Tebra payer IDs (already known: 60054, 47198, 94036, 68069, 62308, MCCBV, CCPN1, 95432, 95567, HPPZZ, 94134, 01260, 00148, 01182, PHP01, THIPA, TMMC1)
- NPI 1023579513 and DEA FP3833933 are confirmed and should be pre-filled everywhere
- Phase 1 compliance-data-seed.sql and baa-tracker-seed.sql contain credential data that Phase 2 should build on, not duplicate
- The credential inventory printable export is an auditor-facing document — professional formatting, not internal notes

</specifics>

<deferred>
## Deferred Ideas

- Working alert automation (Phase 4/5 — TD dashboard + n8n)
- Google Calendar integration for live alerts (Phase 4/5)
- Automated CAQH re-attestation reminder emails (Phase 4/5)
- Provider re-credentialing automation (v2 — multi-provider expansion)

</deferred>

---

*Phase: 02-credential-vault-monitoring*
*Context gathered: 2026-02-27*
