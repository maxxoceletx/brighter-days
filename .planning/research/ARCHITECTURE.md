# Architecture Research

**Domain:** Telehealth psychiatry practice operations — AI command center dashboard
**Researched:** 2026-02-25
**Confidence:** MEDIUM (Tebra API specifics LOW; HIPAA patterns HIGH; overall system design HIGH)

---

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │  Command     │  │  Compliance  │  │  Billing     │              │
│  │  Center      │  │  Dashboard   │  │  Dashboard   │              │
│  │  (Overview)  │  │  (Alerts)    │  │  (AR/Claims) │              │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘              │
│  ┌──────┴───────┐  ┌──────┴───────┐  ┌──────┴───────┐              │
│  │  Credential  │  │  Patient     │  │  Document    │              │
│  │  Vault       │  │  Intake      │  │  Library     │              │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘              │
└─────────┼─────────────────┼─────────────────┼────────────────────-─┘
          │                 │                 │
┌─────────▼─────────────────▼─────────────────▼────────────────────-─┐
│                        API GATEWAY LAYER                            │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  Next.js API Routes / Server Actions (auth checked here)    │    │
│  │  RBAC enforcement — all PHI requests validated server-side  │    │
│  └─────────┬──────────────┬──────────────────┬────────────────┘    │
└────────────┼──────────────┼──────────────────┼─────────────────────┘
             │              │                  │
┌────────────▼──┐  ┌────────▼──────┐  ┌───────▼─────────────────────┐
│  CORE DOMAIN  │  │  INTEGRATION  │  │  AI SERVICES LAYER          │
│  SERVICES     │  │  ADAPTERS     │  │                             │
│               │  │               │  │  ┌────────┐  ┌──────────┐   │
│ Compliance    │  │ Tebra         │  │  │ Claude │  │ CPT Code │   │
│ Engine        │  │ SOAP/FHIR     │  │  │ AI     │  │ Suggester│   │
│               │  │ Adapter       │  │  └────────┘  └──────────┘   │
│ Credential    │  │               │  │  ┌────────┐  ┌──────────┐   │
│ Manager       │  │ CAQH          │  │  │ Alert  │  │ Form     │   │
│               │  │ Adapter       │  │  │ Engine │  │ Filler   │   │
│ Billing       │  │               │  │  └────────┘  └──────────┘   │
│ Pipeline      │  │ Scheduler     │  │                             │
│               │  │ (cron jobs)   │  └─────────────────────────────┘
│ Intake        │  └───────────────┘
│ Workflow      │
└──────┬────────┘
       │
┌──────▼────────────────────────────────────────────────────────────-─┐
│                        DATA LAYER                                    │
│  ┌─────────────────────┐  ┌─────────────────────┐                   │
│  │   Supabase (PHI)    │  │  Supabase (non-PHI) │                   │
│  │   HIPAA project     │  │  Standard project   │                   │
│  │   BAA + High Comp.  │  │  (audit logs,       │                   │
│  │                     │  │   config, UI state) │                   │
│  │  - credentials      │  │                     │                   │
│  │  - intake forms     │  │  - compliance rules │                   │
│  │  - billing data     │  │  - alert history    │                   │
│  │  - patient refs     │  │  - dashboard config │                   │
│  └─────────────────────┘  └─────────────────────┘                   │
│  ┌─────────────────────────────────────────────────────────────┐     │
│  │  File Storage (Supabase Storage — private buckets, BAA)     │     │
│  │  - insurance certificates, DEA registration, licenses       │     │
│  │  - signed forms, intake documents                           │     │
│  └─────────────────────────────────────────────────────────────┘     │
└──────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Implementation |
|-----------|----------------|----------------|
| Command Center Dashboard | Single-screen status overview: compliance health, open billing items, pending intake tasks, expiry alerts | Next.js page, widget grid, server-side data fetch |
| Compliance Engine | Tracks expiry dates for DEA, CA medical license, malpractice insurance, CAQH re-attestation, payer credential renewals | Supabase cron + notification service |
| Credential Vault | Stores all logins, certificates, API keys, payer IDs in encrypted format with role access | Supabase encrypted columns + private file storage |
| Billing Pipeline | Tracks claim status across 17 payers, surfaces denials, tracks AR aging, suggests CPT codes | Tebra integration adapter + AI layer |
| Intake Workflow | Patient screening forms, scheduling handoff to Tebra, intake document collection | Form builder + Tebra appointment API |
| Tebra Adapter | Abstraction over Tebra SOAP API and FHIR endpoints; normalizes data for internal use | Server-side only adapter module |
| AI Services | CPT code suggestions from session notes, form auto-fill, alert summarization, compliance Q&A | Claude API (HIPAA-eligible endpoint) |
| Alert/Scheduler | Runs periodic checks, generates expiry warnings 90/60/30/7 days out, emails Valentina and Maxi | Supabase pg_cron or Vercel cron |
| Document Library | Organized repository of SOPs, forms, certificates, templates with version history | Supabase Storage + metadata table |
| RBAC / Auth Layer | Valentina = clinician role, Maxi = admin role; PHI access gated by role | Supabase Auth + Row Level Security policies |

---

## Recommended Project Structure

```
brighter-days/
├── src/
│   ├── app/                      # Next.js App Router
│   │   ├── (dashboard)/          # Auth-protected route group
│   │   │   ├── page.tsx          # Command center overview
│   │   │   ├── compliance/       # Compliance dashboard
│   │   │   ├── billing/          # Billing pipeline views
│   │   │   ├── credentials/      # Credential vault UI
│   │   │   ├── intake/           # Patient intake workflow
│   │   │   └── documents/        # Document library
│   │   ├── api/                  # API routes (server-only)
│   │   │   ├── tebra/            # Tebra integration endpoints
│   │   │   ├── compliance/       # Compliance check endpoints
│   │   │   ├── ai/               # AI service endpoints
│   │   │   └── cron/             # Cron job handlers
│   │   └── auth/                 # Auth pages (login, MFA)
│   │
│   ├── lib/
│   │   ├── tebra/                # Tebra SOAP/FHIR adapter
│   │   │   ├── client.ts         # SOAP client setup
│   │   │   ├── patients.ts       # Patient data operations
│   │   │   ├── appointments.ts   # Appointment operations
│   │   │   └── billing.ts        # Billing/claims operations
│   │   ├── supabase/
│   │   │   ├── server.ts         # Server-side Supabase client
│   │   │   ├── client.ts         # Browser Supabase client
│   │   │   └── admin.ts          # Admin client (service role)
│   │   ├── ai/
│   │   │   ├── cpt-suggester.ts  # CPT code suggestion logic
│   │   │   ├── form-filler.ts    # AI form auto-fill
│   │   │   └── compliance-qa.ts  # Compliance Q&A prompts
│   │   └── compliance/
│   │       ├── rules.ts          # Compliance rule definitions
│   │       └── expiry-checker.ts # License/cert expiry logic
│   │
│   ├── components/
│   │   ├── dashboard/            # Command center widgets
│   │   ├── compliance/           # Compliance UI components
│   │   ├── billing/              # Billing table/chart components
│   │   ├── credentials/          # Credential form/display
│   │   └── ui/                   # Shared shadcn/ui components
│   │
│   └── types/                    # TypeScript types
│       ├── tebra.ts              # Tebra API response types
│       ├── compliance.ts         # Compliance domain types
│       └── billing.ts            # Billing domain types
│
├── supabase/
│   ├── migrations/               # Database schema migrations
│   └── seed.sql                  # Initial compliance rules seed
│
└── .env.local                    # Never committed, all secrets here
```

### Structure Rationale

- **`lib/tebra/`:** All Tebra communication is isolated here. If Tebra is replaced or their API changes, only this layer changes.
- **`api/` routes (server-only):** PHI never passes through client-side code. All Tebra calls and AI calls with patient data happen server-side only.
- **`lib/supabase/server.ts` vs `client.ts`:** Separate clients enforce that PHI queries only run in server context. Browser client only touches non-PHI tables.
- **`compliance/rules.ts`:** Compliance rules are data-driven (stored in DB) with a thin code layer. Adding a new expiry to track is a data change, not a code change.

---

## Architectural Patterns

### Pattern 1: Tebra as Source of Truth, Dashboard as Read-Only Companion

**What:** The dashboard pulls data from Tebra but does not attempt to become a second EHR. Patient records, appointment notes, and clinical documentation live in Tebra exclusively. The dashboard surfaces aggregated views, alerts, and operational metrics derived from Tebra data.

**When to use:** Always — Tebra is already paid for and credentialed. Duplicating clinical data creates HIPAA surface area and sync problems.

**Tradeoffs:** Dashboard depends on Tebra API being available. Mitigate with cached snapshots (refreshed every 15 minutes) so the dashboard is usable even if Tebra has downtime.

```typescript
// lib/tebra/appointments.ts — server-side only
export async function getTodaysAppointments(): Promise<TebraAppointment[]> {
  const client = getTebraSoapClient()
  const result = await client.GetAppointments({
    FromDate: startOfDay(new Date()),
    ToDate: endOfDay(new Date()),
    PracticeID: env.TEBRA_PRACTICE_ID,
  })
  return normalizeAppointments(result)
}
```

### Pattern 2: Compliance Rules as Data, Not Code

**What:** Store all tracked compliance items (DEA expiry, CA medical license expiry, malpractice renewal date, CAQH re-attestation cycle, each payer credential renewal) as rows in a `compliance_items` table. The compliance engine reads rules from the DB, not from hardcoded logic.

**When to use:** Always — the list of tracked items will grow over time. New payer, new certification, new state requirement = one INSERT, no deployment.

**Tradeoffs:** Slightly more complex initial setup than hardcoding. Worth it by month 3.

```typescript
// compliance_items table schema
// id, name, category (license|dea|insurance|credential),
// expiry_date, alert_days_before (90,60,30,7),
// last_verified_at, notes, document_url

export async function getExpiringItems(daysWindow: number) {
  const cutoff = addDays(new Date(), daysWindow)
  return supabase
    .from('compliance_items')
    .select('*')
    .lte('expiry_date', cutoff.toISOString())
    .order('expiry_date', { ascending: true })
}
```

### Pattern 3: PHI Firewall — Server Actions as the Only PHI Gateway

**What:** Any data that could constitute PHI (patient names, appointment details, intake form responses) is accessed exclusively through Next.js Server Actions or `/api` route handlers. These run on the server, check auth + role, then either serve data to the UI or pass it to the AI layer. PHI never touches the browser Supabase client.

**When to use:** Always — this is the core HIPAA architectural requirement. One PHI leak to client-side code invalidates the entire compliance posture.

**Tradeoffs:** Some friction during development (can't use browser devtools to inspect Supabase queries). Catch this with server-side logging.

```typescript
// app/api/intake/[id]/route.ts — PHI boundary
export async function GET(req: Request, { params }: { params: { id: string } }) {
  const session = await getServerSession()
  if (!session) return new Response('Unauthorized', { status: 401 })
  if (!hasRole(session, 'clinician', 'admin')) return new Response('Forbidden', { status: 403 })

  // Only runs on server — PHI stays server-side
  const form = await getIntakeForm(params.id)
  return Response.json(redactForRole(form, session.role))
}
```

### Pattern 4: AI as a Suggestion Layer, Not Autonomous Actor

**What:** AI (Claude API) provides suggestions — CPT code recommendations, form pre-fill values, compliance summaries — but Valentina or Maxi always confirm before anything is saved or submitted. No AI writes to Tebra directly. No AI sends communications to patients.

**When to use:** Always for this phase. Autonomous AI actions in healthcare require extensive validation and are a rewrite risk if implemented wrong early.

**Tradeoffs:** Slightly slower workflows (human confirmation step). Dramatically lower risk of incorrect billing codes or unauthorized communications.

---

## Data Flow

### Compliance Monitoring Flow

```
Supabase pg_cron (daily at 7am PT)
    ↓
compliance_items table — query items with expiry_date <= 90 days
    ↓
Alert Engine — categorize severity (critical/warning/info)
    ↓
Notification Service — email Valentina + Maxi via Resend
    ↓
Dashboard cache update — compliance_status snapshot table
    ↓
Command Center widget reads snapshot (no live query on page load)
```

### Billing Pipeline Flow

```
Tebra (source) — claim status changes
    ↓
Tebra Adapter — polls GetClaims SOAP endpoint (hourly cron)
    ↓
Billing snapshot table (non-PHI aggregate: claim count, denial rate, AR aging)
    ↓
Billing Dashboard — reads snapshot
    ↓
[On denial] AI suggestion — "Check modifier 25 on DOS 2026-03-01, common denial pattern"
    ↓
Valentina reviews → manual correction in Tebra (dashboard links to Tebra claim view)
```

### Patient Intake Flow

```
New patient referral / self-inquiry
    ↓
Intake form (hosted on dashboard or Tebra Patient Portal)
    ↓
Intake form response stored in Supabase (PHI project, private)
    ↓
AI screening — flag complexity, insurance eligibility check against 17 payer list
    ↓
Valentina reviews screening result → approves intake
    ↓
Appointment created in Tebra (via Tebra Adapter — POST appointment)
    ↓
Intake confirmation email via Resend (HIPAA BAA required)
```

### Credential Vault Flow

```
Maxi adds credential (login, certificate, API key)
    ↓
Encrypted at application layer before write (pgcrypto or app-level AES-256)
    ↓
Stored in credentials table (Supabase HIPAA project)
    ↓
File attachments (certificates, license PDFs) → Supabase Storage private bucket
    ↓
Compliance engine reads credential expiry_date → feeds compliance_items
```

---

## HIPAA Security Architecture

### Required Controls (Non-Negotiable)

| Control | Implementation | Confidence |
|---------|----------------|------------|
| Data at rest encryption | Supabase HIPAA project (AES-256 by default) + PITR enabled | HIGH |
| Data in transit encryption | TLS 1.2+ enforced on all connections; SSL enforcement on in Supabase | HIGH |
| Access controls | Supabase Row Level Security (RLS) policies + Next.js server-side role checks | HIGH |
| Audit logging | Supabase audit log (all table access) + application-level access log (who viewed what) | HIGH |
| MFA | Supabase Auth MFA for both users (Valentina + Maxi) — required before first patient | HIGH |
| BAAs | Supabase (HIPAA add-on, Team plan minimum), Resend (email), Claude/Anthropic (API) | MEDIUM — verify each vendor |
| PHI isolation | PHI Supabase project separate from non-PHI config; no PHI in browser code paths | HIGH |
| Network restrictions | Supabase network restrictions enabled; service role key only in server environment | HIGH |

### BAA Requirements by Component

| Vendor | PHI Contact | BAA Status | Notes |
|--------|-------------|------------|-------|
| Supabase | Yes (stores patient intake, credentials) | Must sign before launch | Requires HIPAA add-on + Team plan |
| Anthropic (Claude API) | Yes (session notes passed for CPT suggestions) | Available — must request | Do not use if BAA not in place |
| Vercel (hosting) | No direct PHI (server-side only, no storage) | Verify with Vercel | HIPAA Secure Compute available on Enterprise; confirm with legal |
| Resend (email) | Yes (appointment confirmations) | Must sign before patient communications | Alternative: AWS SES with BAA |
| Cloudflare | No PHI in transit (encrypted) | Standard terms likely sufficient | Verify with legal |

### What NOT to Store in PHI Project

- Compliance rule definitions (no patient data — use standard project)
- Dashboard layout preferences (use standard project)
- Audit log structure/schema (use standard project, PHI values redacted from log content)
- System configuration, API keys for third-party services (use standard project or secrets manager)

---

## Integration Points

### Tebra Integration

| Operation | API Type | Direction | Notes |
|-----------|----------|-----------|-------|
| Get patients | SOAP (GetPatients) | Read | Supports date-range filter; use for incremental sync |
| Get appointments | SOAP (GetAppointments) | Read | Daily sync for command center overview |
| Get claims / billing | SOAP | Read | Hourly sync for AR aging dashboard |
| Create appointment | SOAP | Write | Used by intake workflow after Valentina approves |
| FHIR patient data | FHIR R4 (USCDIv1) | Read | GET only; for clinical data access; requires patient OAuth consent |

**Tebra integration strategy:** Build a polling adapter (not webhook-based — Tebra does not appear to offer outbound webhooks). Cache results in Supabase snapshot tables. Never call Tebra on page load; always serve from cache, refresh on schedule.

**Tebra API access:** SOAP API requires practice credentials (username, password, practice ID). Store in environment secrets (Vercel env vars + 1Password). FHIR API requires OAuth 2.0 three-legged flow for patient data. For admin/billing reads, SOAP is simpler.

### External Regulatory Sources (Future)

| Source | Purpose | Integration Method |
|--------|---------|-------------------|
| CAQH ProView | Re-attestation cycle tracking | Manual entry (no public API); scrape or manual date tracking |
| NPDB | Adverse action monitoring | Not needed for solo practice unless self-query; manual |
| California Medical Board | License status verification | No API; check manually quarterly or use a credentialing service |
| DEA website | Registration status | No API; track expiry date manually in compliance_items |

---

## Build Order (Phase Dependencies)

Build in this sequence — each phase unlocks the next:

```
Phase 1: Foundation
├── Supabase setup (HIPAA project + standard project)
├── Next.js app scaffold with auth (Supabase Auth + MFA)
├── Role system (Valentina = clinician, Maxi = admin)
└── BAAs signed (Supabase, Anthropic)
        ↓
Phase 2: Credential Vault + Compliance Engine
├── credentials table + encrypted storage
├── compliance_items table + expiry rules
├── Alert engine (cron + email)
└── Command center skeleton with compliance widget
        ↓
Phase 3: Tebra Integration Adapter
├── Tebra SOAP client
├── Appointment and patient sync (read-only)
├── Billing claim sync (read-only)
└── Dashboard widgets pulling from Tebra cache
        ↓
Phase 4: Billing Pipeline Dashboard
├── AR aging views
├── Denial tracking
├── AI CPT code suggestion (Claude API)
└── Links back to Tebra for corrections
        ↓
Phase 5: Patient Intake Workflow
├── Intake form builder
├── AI screening layer
├── Appointment creation (write to Tebra)
└── Confirmation communications (Resend)
        ↓
Phase 6: Document Library + SOP Management
├── File storage organization
├── SOP templates
└── AI form auto-fill for insurance applications
```

**Why this order:**
- Auth + HIPAA infrastructure must exist before any PHI is stored — no shortcuts.
- Credential vault gives immediate value (Valentina can organize logins on day 1) while heavier integrations are built.
- Tebra adapter is a dependency for both billing and intake phases — build it once, use everywhere.
- Billing and intake are independent after the adapter exists — could be parallelized.

---

## Anti-Patterns

### Anti-Pattern 1: Storing PHI in Tebra AND Dashboard Database

**What people do:** Copy patient names, DOBs, and clinical data into their custom database to make queries easier.

**Why it's wrong:** Doubles the HIPAA surface area, creates data sync problems, multiplies breach risk, and requires maintaining two sources of truth. If Tebra is the EHR, clinical data lives in Tebra.

**Do this instead:** Store only non-PHI references in the dashboard DB (Tebra patient ID, appointment ID), fetch live PHI from Tebra when needed, and cache only aggregate/non-PHI summaries.

### Anti-Pattern 2: AI Calls with PHI from the Browser

**What people do:** Call Claude API directly from client-side JavaScript, passing session notes or patient details for CPT suggestions.

**Why it's wrong:** Browser network tab exposes PHI, client-side code is inspectable, and this violates HIPAA minimum necessary standard. Also requires exposing API keys in client code.

**Do this instead:** All AI calls with any patient-adjacent data go through server-side API routes. The browser sends only non-PHI context (e.g., visit duration, session type) or sends a server-side document ID that the server fetches and processes.

### Anti-Pattern 3: Treating Tebra as Replaceable on Day 1

**What people do:** Abstract Tebra so heavily that the architecture becomes bloated with unnecessary abstraction layers in anticipation of switching EHRs.

**Why it's wrong:** Tebra is already set up, credentialed, and paid for. Over-abstracting adds complexity with no near-term payoff. The practice is too small to consider EHR migration any time soon.

**Do this instead:** Build a clean Tebra adapter (`lib/tebra/`), but keep it practical. If Tebra ever needs replacing, the adapter is the only thing to swap. Don't build a generic "EHR abstraction layer."

### Anti-Pattern 4: Autonomous AI Billing Submission

**What people do:** Let AI suggest and then auto-submit billing codes to payers without human review.

**Why it's wrong:** Insurance fraud (even unintentional) is a federal offense. Incorrect CPT codes result in denied claims, audits, and potential exclusion from Medicare/Medicaid. AI coding accuracy is not 100%.

**Do this instead:** AI suggests, human confirms, human submits via Tebra. Log all AI suggestions and the human's final action for audit purposes.

---

## Scaling Considerations

This is a solo practice. Scale is not the concern — reliability and correctness are.

| Concern | At current scale (1 provider, <50 patients/month) | If expanded (5+ providers, 500+ patients/month) |
|---------|---------------------------------------------------|------------------------------------------------|
| Database | Single Supabase instance is more than sufficient | Add read replicas; consider per-provider data partitioning |
| Tebra polling | Hourly cron for billing, daily for appointments — fine | More frequent polling; investigate Tebra webhook alternatives |
| AI cost | Negligible at solo scale (<100 AI calls/month) | Add caching for common CPT patterns; batch processing |
| Auth complexity | Two users (Valentina + Maxi) — simple | Add provider roles, staff roles, billing specialist role |

---

## Sources

- [Tebra SOAP API Overview — Tebra Help Center](https://helpme.tebra.com/Tebra_PM/12_API_and_Integration)
- [Tebra FHIR API Documentation (PDF)](https://www.tebra.com/wp-content/uploads/2023/08/FHIR_API_Documentation_01.pdf)
- [Tebra General API Documentation (PDF)](https://www.tebra.com/wp-content/uploads/2023/10/General_API_Documentation-Tebra.pdf)
- [Supabase HIPAA Projects — Official Docs](https://supabase.com/docs/guides/platform/hipaa-projects)
- [Supabase Shared Responsibility Model](https://supabase.com/docs/guides/deployment/shared-responsibility-model)
- [HIPAA Compliant Architecture Best Practices — Swovo](https://swovo.com/blog/hipaa-compliant-architecture-best-practices/)
- [HIPAA Compliant App Architecture — F3 Software AWS Deep Dive](https://www.f3software.com/insights/hipaa-compliant-cloud-architecture-deep-dive/)
- [PHI vs Non-PHI Data Handling for Developers — Neon](https://neon.com/blog/hipaa-best-practices-for-developers)
- [Telemedicine System Architecture Components — s-pro.io](https://s-pro.io/blog/telemedicine-system-components-architecture)
- [AI CPT Code Suggestions for Psychiatry — mdhub.ai](https://www.mdhub.ai/blog-posts/the-complete-guide-to-psychiatric-billing-from-e-m-to-psychotherapy-with-ai-powered-support)
- [Healthcare Credentialing Software Technology — Medwave](https://medwave.io/2025/04/technologies-transforming-medical-credentialing/)
- [Compliance Dashboard Architecture — MetricStream](https://www.metricstream.com/learn/compliance-dashboard.html)
- [NCQA 2025 License Monitoring Updates — Medallion](https://medallion.co/resources/blog/compliance-confidence-how-to-prepare-for-upcoming-changes-to-ncqa-license-monitoring-requirements)

---

*Architecture research for: Brighter Days — Telehealth Psychiatry Practice Operations*
*Researched: 2026-02-25*
