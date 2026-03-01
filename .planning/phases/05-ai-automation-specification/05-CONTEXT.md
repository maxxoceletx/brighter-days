# Phase 5: AI Automation Specification - Context

**Gathered:** 2026-03-01
**Status:** Ready for planning

<domain>
## Phase Boundary

Produce a complete specification for AI-powered form filling and compliance monitoring. The spec defines exactly what the AI does, what data it needs, and how humans stay in the loop. This phase produces a specification document for handoff to software development — GSD agents do not build the AI systems.

Four requirements in scope:
- AI-01: AI form pre-fill from credential vault data
- AI-02: Automated regulatory monitoring
- AI-03: Automated insurance/payer monitoring
- AI-04: Automated software/platform monitoring

</domain>

<decisions>
## Implementation Decisions

### Form Pre-fill Intelligence (AI-01)

- **Priority targets:** Both CAQH re-attestation AND insurance credentialing applications are first-tier targets. CAQH for ongoing 120-day maintenance cycle, insurance apps for new panel growth.
- **Review flow:** Confidence-based highlighting. AI fills entire form, color-codes fields: green = pulled directly from credential vault (exact match), yellow = inferred/mapped (field name differs but data matches), red = needs manual input (no data available). Reviewer focuses on yellow/red only.
- **Form interaction method:** Hybrid tiered approach:
  - Tier 1 (baseline): Pre-fill reference document (PDF/spreadsheet) with all answers mapped to form field names. Maxi copy-pastes from document into portal. Always works, no dependencies.
  - Tier 2 (stretch): Browser automation (Playwright/Puppeteer) fills web form fields directly in CAQH ProView and payer portals. Maxi reviews filled page and clicks submit. Requires portal credentials in 1Password.
  - Spec both tiers independently — developer implements Tier 1 first, adds Tier 2 later.
- **Change propagation:** Proactive alerts. When a credential record changes in Supabase, AI identifies which forms/portals reference that field and alerts: "Your malpractice policy changed — CAQH and 3 payer portals need updating." Automatically creates draft obligation in the dashboard obligations checklist.
- **Data source:** Supabase `credentials` table (all fields), `payer_tracker` table (17 payer dossiers), `compliance_items` table (Phase 1 audit data). The credential vault already contains every field that CAQH and most payer applications ask for.

### Regulatory Monitoring (AI-02)

- **Detection method:** Curated source list + AI filter. Define a fixed list of 10-20 regulatory source URLs/feeds to monitor (Federal Register, CA Medical Board, HHS/OCR, DEA, CURES). n8n fetches on schedule. An LLM filters each fetched item: "Is this relevant to a solo CA telehealth psychiatry practice prescribing Schedule II-V controlled substances?"
- **Alert tiers:** Tiered by AI-determined urgency:
  - Immediate email (both Valentina + Maxi): High-impact changes — new prescribing restrictions, license requirement changes, HIPAA enforcement actions affecting telehealth
  - Weekly digest email: Medium/low-impact changes — proposed rules, comment periods, informational updates
- **AI analysis depth:** Full analysis per alert — (1) plain-English summary of the change, (2) specific impact assessment for THIS practice (references Valentina's specific credentials, prescribing patterns, and CA-specific requirements), (3) suggested action
- **Dashboard integration:** Auto-create draft obligations. When AI detects a high-impact regulatory change, it creates a draft obligation in the dashboard (status: "review needed") with suggested action and deadline. Maxi reviews and confirms or dismisses.

### Insurance & Payer Monitoring (AI-03)

- **Change types tracked:** Both credentialing requirement changes AND billing rule changes across all 17 panels. Credentialing: new documentation requirements, updated application forms, changed deadlines. Billing: reimbursement rate changes, prior auth requirement changes, CPT code acceptance changes, timely filing window changes.
- **Discovery approach:** Both individual payer sources AND industry aggregators:
  - Per-payer: Provider bulletin pages, newsletter archives, portal announcements
  - Industry: CMS MLN, CA Medicaid (Medi-Cal) bulletins, MGMA alerts, payer-specific listservs
  - n8n fetches all sources on schedule, LLM filters for relevance to this practice
- **Alert system:** Unified with regulatory monitoring. Same pipeline, same alert tiers (immediate/weekly digest), same obligation auto-creation. One monitoring system for regulatory + payer changes.
- **Per-payer differentiation:** Uniform monitoring across all 17 payers. Same frequency, same sources, same alert rules. No tiering by volume (practice is pre-launch, no patient data to differentiate). Tiering can be added later once patient volume patterns emerge.

### Software/Platform Monitoring (AI-04)

- **Platforms monitored:** Core stack + all dependencies:
  - Core: Tebra (EHR), Supabase (backend), n8n (automation), TouchDesigner (dashboard)
  - Dependencies: 1Password (credential vault), SendGrid (email alerts), Google Workspace (calendar/email), DigitalOcean (hosting)
- **Change types tracked:** Breaking changes + security vulnerabilities + compliance implications. Not routine updates or minor feature additions. The compliance angle is critical — any change that could affect HIPAA compliance (auth defaults, PHI handling, encryption changes) gets elevated.
- **Alert routing:** Separate technical channel — Maxi only. Valentina does not receive software/platform alerts (she doesn't need to know about API deprecations). Separate email/Slack channel. Still creates draft obligations in dashboard for critical items (breaking changes, security vulnerabilities).
- **Detection method:** AI-interpreted changelogs. Fetch all changelogs/release notes regardless of format (GitHub releases for n8n/Supabase, status pages for Tebra/DigitalOcean, RSS feeds where available). LLM interprets each one for: relevance to this practice's stack, severity, compliance impact, and required action.

### Claude's Discretion
- Exact curated source list for regulatory monitoring (which 10-20 URLs/feeds to monitor)
- Specific n8n workflow architecture (number of workflows, polling intervals, node structure)
- LLM model selection for filtering/analysis (cost vs capability tradeoff)
- Pre-fill document format details (PDF vs spreadsheet, field mapping structure)
- Confidence scoring algorithm for form pre-fill (what makes a field green vs yellow vs red)
- Weekly digest email template design

</decisions>

<specifics>
## Specific Ideas

- The form pre-fill tiered approach mirrors the Tebra integration tiers from Phase 4 (API direct → export import → manual entry). Consistent pattern across the spec.
- CAQH re-attestation is the highest-stakes automation target — missing the 120-day cycle can suspend ALL 17 payer contracts simultaneously. This should be the first workflow built.
- Regulatory change alerts should reference Valentina's specific credentials (e.g., "This DEA rule change affects Schedule II prescribing — you hold DEA# [from credentials table]"). Practice-specific analysis, not generic regulatory news.
- The unified monitoring pipeline (regulatory + payer) keeps architecture simple — one n8n workflow template, one alert format, one obligation creation flow. Software monitoring is separate because the audience is different (Maxi only).

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `credentials` table (Supabase): Full credential inventory with 44+ columns — credential_type, credential_number, issuing_body, expiry_date, renewal_portal_url, vault_entry_ref. This is the primary data source for AI form pre-fill.
- `payer_tracker` table (Supabase): 17 payer dossiers with contract dates, re-credentialing deadlines, contact info. Data source for payer-specific form filling and monitoring.
- `compliance_items` table (Supabase): Phase 1 audit findings. Cross-referenced by credentials via compliance_item_id FK.
- `credential_alert_queue` view: Computed alert levels (ALERT_90/60/30/7/EXPIRED) — can be extended for AI monitoring triggers.
- `payer_credentialing_alerts` view: Urgency rankings for 17 payer re-credentialing deadlines.
- Alert architecture spec (Phase 2): Defines email + Google Calendar delivery, alert cadence, and escalation logic. AI monitoring can reuse this delivery infrastructure.

### Established Patterns
- n8n as automation backbone: Self-hosted on DigitalOcean, handles all scheduled polling, webhook processing, and email delivery. AI monitoring workflows will be n8n workflows.
- TouchDesigner as pure display: Reads from Supabase only, sends webhooks to n8n. AI monitoring results write to Supabase, dashboard renders them.
- PHI handling: n8n strips PHI before writing to Supabase (first name + time only for appointments). AI monitoring workflows should follow the same principle — no PHI in monitoring data.
- Tiered integration: Phase 4 established a pattern of Tier 1/2/3 fallback strategies. Phase 5 form pre-fill follows the same pattern.

### Integration Points
- Dashboard `obligations` table: AI monitoring auto-creates draft obligations here (status: "review needed")
- Dashboard `automation_log` table: All AI-triggered actions logged here for the Automation Tracker panel (DASH-08)
- Dashboard Action Buttons (DASH-07): "Trigger payer status checks" button could invoke AI monitoring workflows
- n8n webhook endpoints: Dashboard buttons POST to n8n, which now also handles AI monitoring triggers

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within Phase 5 scope.

</deferred>

---

*Phase: 05-ai-automation-specification*
*Context gathered: 2026-03-01*
