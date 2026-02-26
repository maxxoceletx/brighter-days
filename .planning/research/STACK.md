# Stack Research

**Domain:** Telehealth psychiatry practice operations + AI-powered command center
**Researched:** 2026-02-25
**Confidence:** MEDIUM (operational platforms verified via official sources; dashboard tech HIGH; DEA/compliance rules MEDIUM due to active regulatory flux)

---

## Recommended Stack

### Tier 1 — Existing Platform (Non-Negotiable)

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Tebra (EHR + PM) | Current SaaS | EHR, scheduling, billing, e-prescribing, telehealth video | Already deployed, credentialed payers connected through it, switching would require re-credentialing all 17 payers. SOAP API + FHIR API available for custom dashboard integration |

**Tebra API capabilities confirmed:**
- SOAP API: read/write patients, appointments, encounters, charges, payments, providers, service locations, procedure codes
- Authentication: customer key + Tebra credentials over HTTPS/TLS
- Polling model only (no webhooks/push); recommended pull interval 5-15 minutes
- External ID fields allow mapping Tebra records to external system IDs
- FHIR API also available (via SmileCDR partnership) for standards-based access
- Telehealth built in: video sessions, automated CPT code suggestions, modifier 95 applied automatically, direct pharmacy integration for e-prescribing

---

### Tier 2 — Dashboard / Command Center (Custom Build)

The "TouchDesigner-inspired visual command center" means a custom web app that reads Tebra via API and surfaces compliance, billing, and ops data in one place. This is NOT replacing Tebra — it's a read layer on top of it.

#### Core Framework

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Next.js | 15.x (App Router) | Dashboard web app framework | Industry standard for React dashboards; file-based routing; built-in API routes eliminate need for separate backend; Vercel deployment is frictionless |
| TypeScript | 5.x | Type safety | Prevents runtime errors on API data mapping from Tebra; essential when handling billing data |
| Tailwind CSS | 3.x | Styling | Pairs with shadcn/ui; faster than writing custom CSS for a dashboard |

#### UI Component Layer

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| shadcn/ui | Latest | Base UI components | Copy-paste component model; no vendor lock-in; accessible by default; designed for dashboards |
| Tremor | 3.x | Dashboard-specific charts + KPI cards | Built on top of Recharts + Tailwind; purpose-built for data dashboards; provides area charts, bar charts, KPI cards, sparklines out of the box without custom D3 work |
| Recharts | 2.x | Chart primitives (via Tremor) | Powers Tremor; used when Tremor abstractions need customization |

#### Database (Command Center State)

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Supabase | SaaS (HIPAA add-on required) | Operational database for dashboard state, compliance tracking, credential registry, audit logs | Already used in Maxi's other projects (familiarity); signs BAA; HIPAA add-on enables high-compliance mode with continuous security checks; Postgres with row-level security |

**IMPORTANT:** Supabase HIPAA requires: signed BAA (contact Supabase sales) + HIPAA add-on enabled + Point in Time Recovery + SSL Enforcement + Network Restrictions. Contact Supabase for current pricing on HIPAA add-on.

**What goes in Supabase (not Tebra):** compliance checklist state, credential expiry dates, license renewal tracking, document vault metadata, alert history, SOP library, internal notes. PHI stays in Tebra — Supabase holds operational/administrative data only.

#### Hosting

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Vercel | Pro plan | Next.js hosting | BAA available on Pro plan ($350/month add-on); tight Next.js integration; zero-config deployment; HIPAA-eligible for frontend + API routes |

**Note on Vercel HIPAA:** BAA is self-serve on Pro plan. Cost is $350/month for the BAA add-on on top of standard Pro pricing ($20/month). If the dashboard does NOT process or display PHI directly (i.e., it only shows metadata and links out to Tebra for clinical data), Vercel HIPAA BAA may not be strictly required. Assess data flow before paying for it.

#### AI Integration

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| Anthropic Claude API | claude-sonnet-4-6 / claude-opus-4-6 | AI assistant for billing coding suggestions, compliance Q&A, form automation, denial analysis | Anthropic launched Claude for Healthcare in Jan 2026 with HIPAA-ready products and CMS Coverage Database integration; directly relevant to prior auth and billing workflows; Claude signs BAA through enterprise agreements |

**Claude for Healthcare specific capabilities (verified Jan 2026):**
- CMS Coverage Database integration (Local + National Coverage Determinations)
- Prior authorization workflow support
- Clinical documentation automation
- Claim denial analysis

---

### Tier 3 — Compliance + Credential Management

#### Credential Vault

| Technology | Purpose | Why Recommended |
|------------|---------|-----------------|
| 1Password Teams | Store all practice logins, licenses, DEA registration, CAQH credentials, payer portals, NPI | Already used by Maxi per CLAUDE.md context; strong security (dual-key encryption); Watchtower for breach monitoring. NOTE: 1Password does not sign a BAA because they cannot access encrypted data — this is acceptable for credential/password storage because the vault contents are encrypted at rest and 1Password never sees plaintext. Do NOT store PHI here. |

**Credential Vault Contents:** All portal logins (Tebra, CAQH, payer portals, DEA, BreEZe, Availity), license certificates (CA medical license, DEA, NPI, malpractice), expiry dates, renewal deadlines.

#### License + Credential Expiry Tracking

Rather than purchasing a dedicated credentialing platform (MedTrainer, Modio Health — both designed for multi-provider organizations), build this into the Supabase dashboard. For a solo practice, a structured database with expiry alerts (email via Supabase Edge Functions + Resend) is sufficient and much cheaper.

**Key expiry dates to track:**
- CA Medical License (biennial, $1,206 renewal fee, renew online via BreEZe starting 180 days before expiry)
- DEA Registration (3-year renewal)
- CAQH ProView attestation (every 120 days — CRITICAL, payers stop verifying if lapsed)
- Malpractice insurance (annual)
- NPI — no expiry but address/info must be kept current
- 17 payer credentialing re-attestations (varies by payer, typically annual)

#### Email (HIPAA-Compliant Communication)

| Technology | Purpose | Why Recommended |
|------------|---------|-----------------|
| Google Workspace Business Starter | Practice email (@brighterdayspractice.com or similar), calendar, drive | Signs BAA for covered services (Gmail, Calendar, Drive, Meet, Chat); $6/user/month; sufficient for a solo practice; familiar tooling |

**Configuration required for HIPAA:** Sign Google BAA in Admin Console, set calendar visibility to private, enable 2FA for all accounts.

#### Document Storage

| Technology | Purpose | Why Recommended |
|------------|---------|-----------------|
| Google Drive (within Google Workspace) | Compliance documents, SOPs, credentialing packets, insurance correspondence | Covered under Google BAA; already included with Workspace; sufficient for document storage without paying for additional HIPAA storage vendor |

---

### Tier 4 — Compliance Tooling

#### Telehealth Video (within Tebra)

Tebra includes integrated HIPAA-compliant telehealth video — use it. Do NOT add Doxy.me or Zoom for Healthcare as a separate tool. Tebra's integrated video ties session timestamps and duration directly to the encounter for billing, which is the key advantage.

#### HIPAA Risk Assessment + Policy Templates

| Technology | Purpose | Why Recommended |
|------------|---------|-----------------|
| HIPAA One / Accountable HQ | Annual HIPAA risk assessment, policy templates, workforce training | Solo practices must conduct annual HIPAA risk assessments. Accountable HQ is purpose-built for small practices and includes California-specific requirements (AB 352 for sensitive services). ~$99/month |

**California-specific compliance requirements beyond HIPAA:**
- AB 352: Segmentation requirements for sensitive services (mental health qualifies as sensitive under CA law)
- Telehealth Advancement Act (AB 415): Verbal or written informed consent before first session, documented in chart
- Medicare in-person requirement: Established patients before Oct 1, 2025 are grandfathered; new Medicare patients need in-person visit within 6 months of starting telehealth
- DEA controlled substance prescribing: Flexibilities extended through Dec 31, 2026 (no prior in-person required for Schedule II-V via audio-video). Advanced Telemedicine Prescribing Registration proposed for psychiatrists — monitor for finalization

#### Billing + Claims Workflow

Stay within Tebra for all insurance claim submission. Key CPT codes for psychiatry telehealth (2025):

- 99213/99214 — E&M visit (medication management), Modifier 95 for telehealth
- 90791 — Psychiatric diagnostic evaluation
- 90792 — Psychiatric diagnostic evaluation with medical services
- 90832/90834/90837 — Psychotherapy (30/45/60 min)
- 90833/90836/90838 — Psychotherapy add-on to E&M
- 96130/96131 — Psychological testing
- All require Modifier 95 (synchronous audio-video telehealth) for insurance submission

#### Notifications + Automation

| Technology | Purpose | Why Recommended |
|------------|---------|-----------------|
| Resend | Transactional email from dashboard (compliance alerts, license expiry warnings) | Developer-friendly email API; HIPAA BAA available; simple React Email template integration with Next.js; $0 for first 3,000 emails/month |
| Supabase Edge Functions | Scheduled jobs for expiry alerts, daily Tebra API polling, compliance checks | Already in Supabase stack; cron scheduling built in; eliminates need for separate job scheduler |

---

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| SimplePractice / TheraNest / TherapyNotes as EHR replacement | Would require re-credentialing all 17 payers — months of work. Tebra is already set up | Stay on Tebra |
| Doxy.me or Zoom for Healthcare as standalone video | Tebra telehealth video is already integrated with billing and documentation | Tebra built-in telehealth |
| MedTrainer / Modio Health for credentialing | Built for multi-provider orgs; pricing reflects that; overkill for solo practice | Custom Supabase tracking with expiry alerts |
| Notion/Airtable as primary database | Neither signs a BAA; not appropriate for storing anything adjacent to PHI; limited programmatic access | Supabase with RLS |
| Separate HIPAA-compliant email vendor (Paubox, etc.) | Google Workspace already signs a BAA and includes Gmail; adding a second email system creates confusion | Google Workspace with BAA signed |
| TouchDesigner (actual) | Overkill — it's a node-based visual programming environment for installations and real-time video, not dashboards | Next.js + Tremor achieves the "visual command center" aesthetic without TouchDesigner's complexity |
| OpenAI API | Anthropic Claude now has explicit Claude for Healthcare with CMS integration and HIPAA-ready products; better fit for this domain | Claude API (Anthropic) |

---

## Alternatives Considered

| Category | Recommended | Alternative | When Alternative is Better |
|----------|-------------|-------------|---------------------------|
| Dashboard framework | Next.js 15 | Remix | If you need streaming SSR extensively — not the case here |
| Chart library | Tremor + Recharts | D3.js direct | If you need custom visualizations beyond standard charts — adds complexity not justified for practice dashboard |
| Database | Supabase | PlanetScale / Neon | If Postgres isn't needed — it is here (RLS, PostgREST) |
| AI | Claude API | GPT-4o | If OpenAI has healthcare products; Claude for Healthcare is current and specific |
| Hosting | Vercel | Railway / Fly.io | If avoiding $350/month HIPAA add-on and dashboard handles no PHI |
| Password vault | 1Password Teams | Keeper Security | Keeper signs a BAA; use Keeper if you want formal BAA on the password manager. 1Password is fine for credentials only (no PHI) |
| Email | Google Workspace | Microsoft 365 | If already on M365 ecosystem |

---

## Stack Patterns by Scenario

**If dashboard only shows metadata (no PHI displayed):**
- Vercel Pro without HIPAA add-on ($20/month) is sufficient
- Supabase HIPAA add-on still recommended for credential data integrity
- This is the preferred architecture: keep PHI in Tebra only, dashboard shows operational metrics

**If dashboard must display patient-identifiable data (e.g., billing aging report with patient names):**
- Vercel Pro + HIPAA BAA add-on ($350/month) required
- Supabase HIPAA add-on required
- Additional access controls: SSO, MFA enforced, audit logging

**For AI form-filling automation:**
- Claude API with tool use (function calling)
- Forms rendered in Next.js, data pre-filled from Supabase credential store
- Do NOT send PHI to Claude unless Anthropic BAA is signed at enterprise tier

---

## Cost Summary (Monthly, Solo Practice)

| Tool | Cost | Notes |
|------|------|-------|
| Tebra | Existing subscription | Already paid |
| Next.js dashboard | $0 | Open source |
| Vercel Pro | $20/month | + $350/month if HIPAA BAA needed |
| Supabase | $25/month (Pro) | + HIPAA add-on (contact for pricing) |
| 1Password Teams | ~$4/user/month | |
| Google Workspace | $6/user/month | 2 users = $12/month |
| Anthropic Claude API | ~$50-200/month | Depends on automation volume |
| Accountable HQ (HIPAA compliance) | ~$99/month | |
| Resend (email alerts) | $0-20/month | |
| **Estimated total (no HIPAA add-ons)** | **~$220/month** | |
| **Estimated total (with HIPAA add-ons)** | **~$600/month** | |

---

## Version Compatibility

| Package | Compatible With | Notes |
|---------|-----------------|-------|
| Next.js 15 (App Router) | React 19, TypeScript 5 | Use App Router, not Pages Router |
| Tremor 3.x | Recharts 2.x, Tailwind 3.x | Must pin Tailwind to 3.x; Tremor not yet on Tailwind 4 |
| shadcn/ui | Tailwind 3.x, Radix UI 2.x | Same Tailwind version constraint as Tremor |
| Supabase JS | 2.x | Use `@supabase/ssr` for Next.js App Router server components |

---

## Installation

```bash
# Core dashboard
npx create-next-app@latest brighter-days-dashboard --typescript --tailwind --app

# UI components
npx shadcn@latest init
npx shadcn@latest add button card table badge

# Dashboard charts
npm install @tremor/react recharts

# Supabase
npm install @supabase/supabase-js @supabase/ssr

# AI
npm install @anthropic-ai/sdk

# Email notifications
npm install resend react-email

# Dev dependencies
npm install -D @types/node prettier eslint-config-next
```

---

## Sources

- [Tebra EHR Integrations](https://www.tebra.com/ehr-integrations) — Integration overview (MEDIUM confidence — marketing page, no specific list)
- [Tebra SOAP API Help Center](https://helpme.tebra.com/Tebra_PM/12_API_and_Integration) — API entities and capabilities (MEDIUM confidence — confirmed SOAP + FHIR, polling model)
- [Tebra Psychiatry Telehealth Article](https://www.tebra.com/theintake/ehr-emr/mental-health-practices/the-role-of-telehealth-in-psychiatry-ehrs) — CPT automation, e-prescribing (MEDIUM confidence)
- [Supabase HIPAA Projects Docs](https://supabase.com/docs/guides/platform/hipaa-projects) — Official HIPAA configuration requirements (HIGH confidence)
- [Vercel HIPAA BAA Changelog](https://vercel.com/changelog/hipaa-baas-are-now-available-to-pro-teams) — Pro plan BAA, $350/month (HIGH confidence)
- [Anthropic Claude for Healthcare](https://www.anthropic.com/news/healthcare-life-sciences) — Jan 2026 launch, CMS integration (HIGH confidence)
- [Google Workspace HIPAA BAA](https://support.google.com/a/answer/3407054) — Covered services list (HIGH confidence)
- [DEA Telemedicine Extension 2026](https://www.hhs.gov/press-room/dea-telemedicine-extension-2026.html) — Flexibilities through Dec 31, 2026 (HIGH confidence)
- [California Medical Board License Renewal](https://www.mbc.ca.gov/Licensing/Physicians-and-Surgeons/Renew/) — Biennial renewal, BreEZe portal (HIGH confidence)
- [CPT Codes Mental Health 2025](https://medcaremso.com/blog/a-complete-guide-on-cpt-codes-for-mental-health-2025/) — Psychiatry telehealth codes, Modifier 95 (MEDIUM confidence)
- [Tremor v3 Docs](https://www.tremor.so/) — Dashboard component library (HIGH confidence)
- [1Password HIPAA Status](https://support.1password.com/hipaa/) — No BAA required for password vault (HIGH confidence)
- [Keeper Security Healthcare](https://www.keepersecurity.com/healthcare-password-management.html) — Alternative with BAA option (MEDIUM confidence)
- [CAQH Attestation Requirements](https://primecredential.com/avoid-credentialing-lapses-master-license-and-caqh-tracking-together/) — 120-day re-attestation cycle (MEDIUM confidence)

---
*Stack research for: Brighter Days — Telehealth Psychiatry Practice AI Command Center*
*Researched: 2026-02-25*
