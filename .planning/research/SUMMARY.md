# Project Research Summary

**Project:** Brighter Days — Telehealth Psychiatry Practice AI Command Center
**Domain:** Solo CA telehealth psychiatry practice operations system
**Researched:** 2026-02-25
**Confidence:** MEDIUM-HIGH

## Executive Summary

Brighter Days is an AI-powered operational command center for a solo California telehealth psychiatry practice. The practice already runs on Tebra (EHR/PM/billing/telehealth) with 17 credentialed payers — the command center is not a replacement for Tebra, but a read layer on top of it that surfaces compliance status, credential expiry tracking, billing intelligence, and administrative automation in one place. Research confirms no equivalent product exists for solo physicians at this scope; EHRs universally handle clinical workflows but leave the compliance lifecycle and operational layer entirely unaddressed. The recommended approach is a Next.js + Supabase + Claude API stack that treats Tebra as the source of truth, caches Tebra data via polling adapter, and exposes AI suggestions only through human-confirmed workflows.

The most important design principle: compliance infrastructure must precede everything else. The practice cannot legally see patients without verified DEA registration, CA medical license currency, CAQH attestation, HIPAA BAAs in place, and CA-specific telehealth informed consent documented. These are not features — they are preconditions for operation. Building the credential vault and compliance dashboard first gives immediate value on day one (Valentina can audit her standing before her first patient) while establishing the authoritative data store that all subsequent automation depends on. Tebra API integration then unlocks the billing and intake phases.

The key risk is compliance theater — creating a dashboard that looks complete while missing critical regulatory details. Research uncovered multiple "looks done but isn't" traps: CAQH attestation assumed done after initial setup, Tebra billing defaults left unconfigured for psychiatry, telehealth informed consent forms missing CA-specific B&P 2290.5 elements, and DEA telehealth prescribing flexibility treated as permanent when it expires December 31, 2026 without finalization of a replacement rule. The mitigation strategy is a structured pre-launch audit checklist covering every pitfall identified, completed before the first patient encounter.

## Key Findings

### Recommended Stack

The stack divides into three tiers: existing non-negotiable infrastructure (Tebra), a custom dashboard layer (Next.js + Supabase), and compliance/AI tooling. Tebra cannot be replaced without re-credentialing all 17 payers, which would take months — it stays as-is. The dashboard is a custom Next.js 15 app reading from Tebra via SOAP polling adapter, storing operational/administrative state in Supabase (HIPAA project with BAA), and using Claude API for AI features. HIPAA compliance is layered: Supabase HIPAA add-on for storage, Google Workspace with signed BAA for email, Resend (with BAA) for transactional alerts, and Accountable HQ for annual risk assessment. PHI never touches the browser — all Tebra API calls and AI calls with patient-adjacent data are server-side only.

**Core technologies:**
- Tebra (existing): EHR/PM/billing/telehealth — locked in; SOAP + FHIR APIs available, polling only (no webhooks)
- Next.js 15 (App Router): Dashboard framework — API routes eliminate separate backend; file-based routing maps naturally to dashboard sections
- TypeScript 5: Type safety — prevents runtime errors on Tebra API response mapping
- Supabase (HIPAA project): Operational database — familiar to dev team; RLS enforces PHI isolation; BAA available with add-on
- shadcn/ui + Tremor 3: UI components — Tremor purpose-built for dashboards with KPI cards, AR aging charts, sparklines; no custom D3 needed
- Claude API (claude-sonnet-4-6): AI layer — Claude for Healthcare launched Jan 2026 with CMS Coverage Database integration; BAA available at enterprise tier
- Supabase Edge Functions + pg_cron: Scheduled jobs — Tebra polling, compliance checks, expiry alerts without separate job scheduler
- Resend: Transactional email — BAA available; React Email integration with Next.js; free tier sufficient for alert volume
- Google Workspace: Practice email + storage — BAA covers Gmail, Calendar, Drive; $6/user/month

**Critical version constraints:** Tailwind must be pinned to 3.x (Tremor not yet on Tailwind 4); use `@supabase/ssr` (not `@supabase/auth-helpers`) for Next.js App Router.

**Estimated monthly cost:** ~$220/month without HIPAA add-ons; ~$600/month with all HIPAA BAA add-ons. Recommend starting without Vercel HIPAA add-on ($350/month) by keeping PHI server-side only — dashboard shows operational metadata, links out to Tebra for clinical data.

### Expected Features

Research reveals a clear three-tier feature structure aligned to operational readiness phases. No direct competitor covers this ground — EHRs universally omit compliance lifecycle management.

**Must have before first patient (table stakes + legal requirements):**
- Compliance audit checklist — verified status of DEA, CA license, CAQH, malpractice, corporate filings, NPI/PTAN
- Credential/password vault — all logins, certificates, license numbers in HIPAA-compliant organized store
- Telehealth informed consent form — CA B&P 2290.5 compliant, with emergency plan, loaded in Tebra
- CURES check workflow SOP — written procedure for mandatory CA PDMP check before controlled substance prescribing
- CPT code + modifier reference sheet — per-payer cheat sheet covering modifier 95/93, POS 02/10 rules for all 17 payers
- Compliance expiry dashboard — visual countdown of every license/cert/filing expiry with alert thresholds
- Prior authorization tracking — per-payer PA requirements documented; process for checking before scheduling

**Should have in first 30-60 days (differentiators):**
- Revenue cycle dashboard — claims submitted/paid/denied by payer, AR aging, weekly view (Tebra API unlock)
- Denial pattern analysis — recurring denial patterns by payer after first 30-60 days of claims data
- Payer credentialing re-verification calendar — re-credentialing deadlines for all 17 payers
- CAQH profile freshness monitor — alert 90 days before 120-day re-attestation deadline
- Automated appointment reminders + intake dispatch — intake forms and telehealth link triggered on booking
- CA regulatory change monitor — RSS monitoring of Medical Board, CURES, DEA, CMS feeds

**Defer to v2+ (post 90-day validation):**
- AI-assisted CPT code suggestion — validate Tebra's native capabilities first; only build if gap confirmed
- AI intake screening (PHQ-9, GAD-7, Columbia) — high clinical value but complex; defer until billing stable
- AI session documentation scribe — mature off-shelf market (Nuance DAX, Nabla); evaluate before building
- AI form-fill for prior authorizations — high ROI but needs PA volume data to optimize; post-launch
- Denial appeal letter generator — requires denial pattern data from v1.x operating period

**Explicit anti-features (do not build):**
- Custom EHR, billing engine, or patient portal — Tebra handles all of these; duplication creates HIPAA surface area
- CURES direct API integration — no public API exists; any "integration" requires ToS-violating screen scraping
- Custom telehealth video platform — Tebra's integrated video ties to billing/encounter automatically

### Architecture Approach

The architecture is a layered read-companion to Tebra, not a replacement system. Four patterns drive all design decisions: (1) Tebra is source of truth — dashboard is read-only except for creating appointments via intake workflow; (2) compliance rules are data-driven — tracked items stored as rows in `compliance_items` table, not hardcoded, so adding a new expiry is one INSERT; (3) PHI firewall — all PHI access goes through Next.js Server Actions or API routes server-side, never through browser Supabase client; (4) AI is a suggestion layer only — Claude suggests, human confirms, human submits in Tebra; no autonomous AI writes to any clinical system.

**Major components:**
1. Command Center Dashboard — single-screen status overview; reads from snapshot tables, not live Tebra calls
2. Compliance Engine — Supabase pg_cron + compliance_items table; generates alerts at 90/60/30/7 days before expiry
3. Credential Vault — encrypted columns in Supabase HIPAA project + private Storage bucket for license PDFs
4. Tebra Adapter — server-side only SOAP client in `lib/tebra/`; polling every 15-60 minutes; caches to snapshot tables
5. Billing Pipeline — AR aging, denial tracking, CPT suggestion from Tebra snapshot data + Claude API
6. Intake Workflow — patient screening forms, eligibility check, Valentina approval gate, then Tebra appointment creation
7. AI Services Layer — Claude API endpoints (server-side only); suggestion-only, no autonomous actions
8. RBAC/Auth — Supabase Auth with MFA; Valentina = clinician role, Maxi = admin role; RLS on all tables

**Data architecture decision:** Two separate Supabase projects — PHI project (HIPAA add-on, credentials, intake forms, billing references) and standard project (compliance rules, alert history, dashboard config, audit log structure). PHI never enters browser code paths.

### Critical Pitfalls

1. **Out-of-state patient prescribing** — Telehealth jurisdiction is the patient's physical location, not the provider's. CA license covers CA patients only; CA does not participate in IMLC as of 2026. Confirm patient location verbally at start of every session; document in session note. Prevention: add location confirmation to note template and SOP before first patient.

2. **DEA telehealth flexibility expiration** — COVID-era Schedule II-V prescribing flexibility expires December 31, 2026. No permanent replacement rule finalized yet (proposed DEA Special Registration rule pending). Practice cannot be built exclusively on telehealth-only controlled substance prescribing without a continuity plan for post-2026. Prevention: calendar alert on Dec 2026 deadline; plan in-person evaluation option; monitor Federal Register 2025-01099.

3. **HIPAA BAA gaps** — Every vendor touching PHI requires a signed BAA: Tebra, Supabase (HIPAA add-on), Anthropic (Claude API, enterprise tier), Resend (email), Google Workspace (Admin Console). Enforcement has been full since August 2023. OCR's 2025 #1 enforcement target was failure to perform HIPAA Security Risk Analysis. Prevention: vendor audit before launch; conduct and document formal SRA.

4. **CAQH re-attestation lapse** — Missing the 120-day CAQH re-attestation cycle silently removes payer access to provider credentialing data, triggering claim rejections and potential panel removal. Re-credentialing takes 90-180 days to recover. Prevention: set quarterly reminders (90-day cadence, not 120); assign Maxi as CAQH owner; verify all 17 payer connections after every attestation.

5. **Medicare billing misconfiguration** — Tebra defaults are not psychiatry-specific. Common systematic errors: wrong POS code (must be 02 or 10 for telehealth, not 11), missing modifier 95 or 93, using new 98000-98015 CPT codes for Medicare (Medicare requires 99202-99215 + modifiers), E/M level based on time when psychotherapy add-on is billed (must use MDM). A high first-pass denial rate from day one compounds cash flow risk. Prevention: Tebra billing configuration audit before first claim; audit first 30 claims manually per payer; target >95% first-pass acceptance.

## Implications for Roadmap

Research from all four files converges on a clear 6-phase build order with hard dependencies between phases. The architecture research explicitly defines this sequence; features research confirms the priority ordering; pitfalls research maps each compliance requirement to early phases.

### Phase 1: Foundation + HIPAA Infrastructure

**Rationale:** No PHI can be stored, no patient can be seen, and no vendor can be configured until auth, HIPAA infrastructure, and BAAs are in place. This phase has zero negotiable shortcuts.
**Delivers:** HIPAA-compliant infrastructure, authentication with MFA for both users, BAAs signed with Supabase and Anthropic, Vercel deployment, role system
**Addresses:** HIPAA BAA requirement, audit logging requirement, MFA enforcement
**Avoids:** Pitfall 3 (HIPAA BAA gaps), Pitfall 3's security risk analysis gap
**Stack:** Next.js 15 scaffold, Supabase Auth + MFA, Supabase HIPAA project setup, Vercel Pro deployment, Google Workspace BAA
**Research flag:** Standard patterns — well-documented Supabase + Next.js Auth setup; skip phase research

### Phase 2: Compliance Audit + Credential Vault

**Rationale:** Before Valentina sees her first patient, every license, registration, credentialing status, and compliance item must be verified and documented. The credential vault is the authoritative data store that all subsequent automation reads from — it must exist before automation is built.
**Delivers:** Compliance audit checklist completed, all credentials organized in vault, compliance_items table with expiry dates loaded, expiry alert engine running (90/60/30/7 day alerts via Resend)
**Addresses:** DEA registration tracking, CA medical license tracking, CAQH profile monitoring, malpractice certificate tracking, corporate filing calendar, NPI/PTAN verification
**Avoids:** Pitfall 1 (out-of-state prescribing — intake SOP added here), Pitfall 2 (DEA extension calendar), Pitfall 4 (CAQH lapse), Pitfall 5 (HIPAA informed consent — CA-specific form reviewed here), Pitfall 11 (malpractice certificate)
**Stack:** Supabase compliance_items table + credentials table, pg_cron alert jobs, Resend email alerts, Tremor KPI cards for expiry dashboard
**Research flag:** Needs phase research on specific CA compliance requirements verification workflow and CAQH ProView re-attestation process details

### Phase 3: Tebra Integration Adapter

**Rationale:** The Tebra adapter is a dependency for both billing and intake phases. Building it once, correctly, in isolation is lower risk than building it as part of a feature phase. Validates API access and capability assumptions before later phases depend on them.
**Delivers:** SOAP client for appointments, patients, and claims; polling cron jobs; snapshot tables in Supabase; command center skeleton with live Tebra data widgets
**Addresses:** Revenue cycle visibility, appointment overview on command center
**Avoids:** Pitfall 10 (Tebra defaults) — this phase reveals what Tebra's API actually surfaces, informing Phase 4 configuration
**Stack:** Tebra SOAP client in `lib/tebra/`, Supabase snapshot tables, Supabase Edge Functions for polling, shadcn/ui dashboard widgets
**Research flag:** Needs phase research — Tebra SOAP API access specifics have LOW confidence; actual capabilities and authentication flow must be validated before building the adapter

### Phase 4: Billing Pipeline Dashboard

**Rationale:** Once the Tebra adapter exists, billing data flows into the dashboard. This phase configures Tebra correctly for psychiatry, establishes denial tracking, and surfaces AR aging — all critical for cash flow in the first months of operation.
**Delivers:** AR aging dashboard by payer, denial tracking with denial code analysis, CPT code reference sheet per payer, Tebra billing configuration audit completed, first 30-claim audit report
**Addresses:** CPT code selection, modifier application, denial management workflow, prior authorization tracking, E/M + psychotherapy note template, No Surprises Act GFE template, Medicare in-person requirement documentation
**Avoids:** Pitfall 4 (Medicare POS/modifier misconfiguration), Pitfall 8 (E/M + psychotherapy miscoding), Pitfall 9 (No Surprises Act GFE)
**Stack:** Tremor charts for AR aging, Claude API for denial pattern suggestions (suggestion-only), payer-specific rule config in Supabase
**Research flag:** Standard patterns for billing dashboard UI; no additional research needed on the dashboard layer. Billing rule specifics per payer need manual verification against payer contracts.

### Phase 5: Patient Intake Workflow

**Rationale:** After billing is validated and running, patient intake automation adds efficiency without introducing early complexity. Requires both the Tebra adapter (to create appointments) and compliance phase (to have consent forms ready).
**Delivers:** Intake form builder, insurance eligibility verification pre-visit, CA telehealth informed consent form in Tebra, CURES check workflow SOP documented, crisis protocol in every chart, appointment creation via Tebra API, Resend confirmation emails
**Addresses:** Telehealth informed consent capture, HIPAA NPP delivery, CURES check workflow, audio-video capability documentation, Good Faith Prior Examination documentation, eligibility verification
**Avoids:** Pitfall 1 (location confirmation on intake), Pitfall 5 (CA telehealth informed consent B&P 2290.5 compliance), Pitfall 6 (emergency/crisis protocol gap — emergency contact + location captured here), Pitfall 12 (eligibility verification)
**Stack:** Intake form components, Tebra SOAP write (CreateAppointment), Resend BAA for confirmation emails, AI screening layer (Claude API, suggestion-only)
**Research flag:** Crisis protocol SOP content needs review with a healthcare attorney or CA medical board guidance; standard form patterns are sufficient for the tech implementation

### Phase 6: Document Library + AI Automation Layer

**Rationale:** Once the practice is operating and billing patterns are established, the document library and AI form-fill features add leverage. Prior auth and denial patterns from Phase 4-5 data inform what to automate first.
**Delivers:** SOP library in Supabase Storage, document version history, AI form-fill for prior authorizations (PA-heavy payers: Magellan, Cigna Behavioral), denial appeal letter drafts, CA regulatory change monitor
**Addresses:** AI form-fill assistant, denial appeal letter generator, insurance billing cheat sheet, payer credentialing timeline tracker, CA regulatory change monitor
**Avoids:** Building AI automation before having real denial and PA data to train prompts against
**Stack:** Supabase Storage private buckets, Claude API with tool use for form-fill, RSS monitoring for regulatory feeds, Resend digest emails
**Research flag:** AI form-fill accuracy for insurance forms needs validation against actual PA forms from Magellan and Cigna Behavioral; may need prompt engineering iteration after launch

### Phase Ordering Rationale

- Auth and HIPAA infrastructure cannot be deferred — any PHI storage without this in place is a violation
- Credential vault precedes all automation because it is the authoritative data source; automation on bad data is worse than no automation
- Tebra adapter is a shared dependency for both billing and intake phases — isolating it in its own phase reduces risk and validates assumptions before other phases depend on it
- Billing pipeline precedes intake automation because billing errors in the first weeks compound into months of cash flow problems; this is the highest financial risk after compliance
- Patient intake in Phase 5 (not Phase 1) is intentional: the practice can use Tebra's native intake tools to start, while the compliance and billing layers are being built
- AI automation deferred to Phase 6 because AI suggestions require real data patterns to be useful; building AI on day one would be suggestion-less noise

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 3 (Tebra Adapter):** Tebra SOAP API specifics rated LOW confidence in research. Actual authentication flow, available SOAP methods, rate limits, and FHIR API access scope need validation before building. Recommend obtaining Tebra API documentation directly from support or testing sandbox credentials before scoping Phase 3 tasks.
- **Phase 2 (Compliance Audit specifics):** CAQH ProView re-attestation workflow and payer-specific re-credentialing cycles are MEDIUM confidence. Recommend confirming current CAQH attestation status and each payer's re-credentialing deadline before building the alert calendar.

Phases with standard patterns (skip research-phase):
- **Phase 1 (Foundation):** Next.js + Supabase Auth with MFA is thoroughly documented; Vercel deployment is zero-config. Standard implementation.
- **Phase 4 (Billing Dashboard):** Dashboard UI patterns are standard; AR aging and denial tracking are well-documented charting problems. The complexity is in the data (Tebra API, Phase 3), not the UI.
- **Phase 6 (Document Library):** Supabase Storage is well-documented. AI form-fill uses standard Claude tool use patterns.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | MEDIUM-HIGH | Next.js/Supabase/Tremor: HIGH confidence (official docs). Tebra API: LOW confidence (marketing pages, no developer sandbox confirmed). Anthropic Claude for Healthcare: HIGH confidence (Jan 2026 launch verified). HIPAA add-on pricing: verified but contact-for-pricing for Supabase. |
| Features | HIGH | Regulatory requirements (CURES, telehealth consent, DEA, CAQH) verified via official CA Medical Board, CMS, and HHS sources. Feature gaps vs EHRs confirmed across Tebra, SimplePractice, Valant — none offer compliance lifecycle tracking. |
| Architecture | HIGH | HIPAA architectural patterns are well-established. PHI isolation via server-side-only architecture is standard. Supabase RLS patterns are documented. Tebra adapter design is sound given SOAP-only polling model. |
| Pitfalls | MEDIUM-HIGH | CA regulatory pitfalls (CURES, B&P 2290.5, IMLC) are HIGH confidence from official sources. Billing pitfalls (Medicare modifier rules, CAQH lapse) are MEDIUM confidence from industry sources. Tebra-specific behavioral (defaults, billing setup) is LOW confidence from vendor sources only. |

**Overall confidence:** MEDIUM-HIGH

### Gaps to Address

- **Tebra API access:** SOAP API capabilities are described in marketing documentation, not verified via developer sandbox. The adapter architecture is correct, but exact method names, authentication fields, and rate limits need confirmation before Phase 3 scoping. Approach: contact Tebra support for API documentation and test credentials early in Phase 3 planning.
- **Vercel HIPAA BAA necessity:** Whether the dashboard will display any PHI (even patient-identifiable billing data) determines if the $350/month Vercel HIPAA BAA is required. Recommend deciding this architecture constraint in Phase 1 before deployment setup. Preferred answer: keep PHI server-side, never render patient-identifiable data in the dashboard, avoid the cost.
- **Anthropic Enterprise BAA:** Claude API BAA requires enterprise agreement (not self-serve like Supabase). Timeline for signing may affect Phase 4+ delivery. Recommend initiating the enterprise agreement inquiry in Phase 1 even if AI features aren't used until Phase 4-6.
- **DEA Special Registration rule status:** The proposed rule (Federal Register 2025-01099) was not finalized as of February 2026. If it is not finalized before December 31, 2026, the practice needs a contingency plan for controlled substance prescribing. This is a practice-operational decision, not a tech decision, but the compliance calendar must track it.
- **CAQH current attestation status:** Research confirms the 120-day cycle but cannot verify whether the current CAQH profile is in good standing. Phase 2 must verify actual status, not assume it.

## Sources

### Primary (HIGH confidence)
- [Supabase HIPAA Projects Docs](https://supabase.com/docs/guides/platform/hipaa-projects) — HIPAA configuration requirements
- [Vercel HIPAA BAA Changelog](https://vercel.com/changelog/hipaa-baas-are-now-available-to-pro-teams) — Pro plan BAA, $350/month add-on
- [Anthropic Claude for Healthcare](https://www.anthropic.com/news/healthcare-life-sciences) — Jan 2026 launch, CMS integration
- [Google Workspace HIPAA BAA](https://support.google.com/a/answer/3407054) — Covered services
- [DEA Telemedicine Extension 2026](https://www.hhs.gov/press-room/dea-telemedicine-extension-2026.html) — Flexibilities through Dec 31, 2026
- [California Medical Board — CURES Mandatory Use](https://www.mbc.ca.gov/Resources/Medical-Resources/CURES/Mandatory-Use.aspx) — Mandatory check requirements
- [CA Medical Board — Telehealth Requirements](https://www.mbc.ca.gov/Resources/Medical-Resources/telehealth.aspx) — B&P 2290.5 consent requirements
- [CMS Telehealth FAQ CY 2026](https://www.cms.gov/files/document/telehealth-faq-updated-02-04-2026.pdf) — Medicare telehealth billing rules
- [DEA Special Registration Proposed Rule](https://www.federalregister.gov/documents/2025/01/17/2025-01099/special-registrations-for-telemedicine-and-limited-state-telemedicine-registrations) — Pending rule status
- [APA — No Surprises Act GFE FAQ](https://www.psychiatry.org/File%20Library/Psychiatrists/Practice/Practice-Management/No-Surprises-Act-Questions-12-29--FAQs-for-website.pdf) — GFE requirements
- [CCHP — CA State Telehealth Laws](https://www.cchpca.org/california/) — CA-specific telehealth consent requirements

### Secondary (MEDIUM confidence)
- [Tebra SOAP API Help Center](https://helpme.tebra.com/Tebra_PM/12_API_and_Integration) — API entities and polling model (marketing documentation, not developer reference)
- [Tebra Psychiatry Telehealth Article](https://www.tebra.com/theintake/ehr-emr/mental-health-practices/the-role-of-telehealth-in-psychiatry-ehrs) — CPT automation, e-prescribing
- [CPT Codes Mental Health 2025](https://medcaremso.com/blog/a-complete-guide-on-cpt-codes-for-mental-health-2025/) — Psychiatry telehealth codes, Modifier 95
- [OCR HIPAA Enforcement 2025](https://ogletree.com/insights-resources/blog-posts/2025-enforcement-trends-risk-analysis-failures-at-the-center-of-hhss-multimillion-dollar-hipaa-penalties/) — SRA as #1 enforcement target
- [CAQH Attestation Requirements](https://primecredential.com/avoid-credentialing-lapses-master-license-and-caqh-tracking-together/) — 120-day re-attestation cycle
- [7 Common Insurance Credentialing Pitfalls](https://www.withassured.com/blog/insurance-credentialing-pitfalls) — CAQH lapse recovery timeline
- [HIPAA Compliant Architecture — F3 Software](https://www.f3software.com/insights/hipaa-compliant-cloud-architecture-deep-dive/) — PHI isolation patterns
- [Wheel — California Telehealth Regulations](https://www.wheel.com/state-telehealth-regulations/california) — CA-specific requirements summary
- [CA Professional Corporation Compliance Guide](https://djholtlaw.com/navigating-governance-and-compliance-in-california-healthcare-corporations/) — Annual filing requirements

### Tertiary (LOW confidence — needs validation during implementation)
- [Tebra Billing Pain Points 2025](https://www.tebra.com/theintake/getting-paid/medical-billing-pain-points-insights-solutions) — Vendor source; default configuration issues
- Tebra API rate limits and sandbox availability — Not documented in any source reviewed; needs direct vendor confirmation

---
*Research completed: 2026-02-25*
*Ready for roadmap: yes*
