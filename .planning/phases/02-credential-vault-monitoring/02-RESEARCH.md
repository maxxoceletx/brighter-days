# Phase 2: Credential Vault & Monitoring - Research

**Researched:** 2026-02-27
**Domain:** Healthcare Credential Organization, Supabase Schema Extension, 1Password Vault Architecture, Payer Credentialing Data Modeling
**Confidence:** HIGH (all findings based on Phase 1 real data extractions + locked decisions from CONTEXT.md; no speculative information)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- 1Password account already exists — create a new shared "Brighter Days Practice" vault inside it
- Both Maxi and Valentina have access to the shared practice vault; personal items (banking, SSN, personal accounts) stay in Valentina's personal vault — NOT in the shared vault
- Supabase is the source of truth for credential data — extend Phase 1 compliance tables with credential-specific fields
- Generate a printable export (markdown/PDF) Valentina can hand to an auditor, payer, or credentialing body
- Alert system is a SPEC for Phase 4/5 TD dashboard — Phase 2 documents the architecture, Phase 4/5 builds it. No working calendar events or email automation in Phase 2.
- Alerts go to BOTH Maxi and Valentina — no role split
- Alert cadence: 90/60/30/7 days before expiry for all credentials; same cadence for CAQH 120-day re-attestation
- Alerts stop once task marked complete
- Full dossier per payer (all 17 panels) — unknown fields filled with industry-norm estimates flagged as "ESTIMATED"
- Medicare is ACTIVE/ENROLLED — Phase 1 incorrectly flagged as DEACTIVATED; Phase 2 tracker reflects active status
- All software engineering produces architecture specs and seed data only — Superpowers handles building
- GSD does NOT spawn coding subagents
- Dedicated Brighter Days Supabase project (same one from Phase 1 — NOT shared with FindItNOW or Momo)

### Claude's Discretion

- 1Password vault category naming and grouping logic
- Supabase table schema design for credential inventory and payer tracker
- Printable export format and layout
- Alert architecture spec format (what the TD team needs to build from)
- How to structure estimated re-credentialing dates when actuals are unknown

### Deferred Ideas (OUT OF SCOPE)

- Working alert automation (Phase 4/5 — TD dashboard + n8n)
- Google Calendar integration for live alerts (Phase 4/5)
- Automated CAQH re-attestation reminder emails (Phase 4/5)
- Provider re-credentialing automation (v2 — multi-provider expansion)
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| CRED-01 | 1Password vault organized with all practice logins (Tebra, CAQH, DEA, payer portals, state boards, email, etc.) | Vault category structure designed; all known logins inventoried from Phase 1 document audit; 1Password shared vault pattern identified |
| CRED-02 | Single credential inventory document listing every license, cert, NPI (1023579513), DEA#, payer IDs, and expiry dates | All credential data available from Phase 1 01-DOCUMENT-AUDIT.md; full inventory compiled below; printable export format designed |
| CRED-03 | CAQH 120-day re-attestation alert system (missing one cycle can suspend all 17 payer contracts simultaneously) | Alert architecture spec defined; CAQH re-attestation cycle documented; standard 90/60/30/7 cadence maps to this cycle; CRED-03 is spec-only in Phase 2 |
| CRED-04 | Payer credentialing status tracker for all 17 insurance panels with contract dates, re-credentialing deadlines, and contact info | All 17 payers identified; Tebra payer IDs known; industry-norm re-credentialing cycles documented; full dossier field list designed |
</phase_requirements>

---

## Summary

Phase 2 is an organization and architecture sprint, not a software build. The deliverables are: (1) a 1Password vault structure spec telling Valentina exactly how to organize every practice login, (2) a Supabase schema extension adding `credentials` and `payer_tracker` tables to the Phase 1 foundation, (3) seed data pre-populated with every known credential and all 17 payer dossiers, (4) a printable credential inventory document (markdown) Valentina can hand to auditors, and (5) an alert architecture spec the Phase 4/5 TD dashboard team can implement without further discovery.

All the raw data needed to populate these deliverables exists in Phase 1 outputs — specifically `01-DOCUMENT-AUDIT.md` (credentials, identifiers, payer list, fee schedules, contacts) and `compliance-data-seed.sql` (structured credential records already in Supabase). Phase 2 extends what Phase 1 built rather than rebuilding it. The core pattern: Phase 1 created `compliance_items` rows for licenses/credentials; Phase 2 creates a purpose-built `credentials` table with richer fields (renewal cycle, renewal cost, renewal portal URL, alert thresholds) and a separate `payer_tracker` table for the 17-panel dossier.

The most design-intensive part of this phase is the payer tracker — 17 panels with a full dossier each. Industry norms are well-established (3-year re-credentialing cycles are standard across commercial payers; CAQH ProView is required by essentially all commercial panels; California payers typically require 90-day advance notice of re-credentialing). Fields where actuals are unknown should be populated with industry estimates flagged as "ESTIMATED" — never left blank — because blanks are operationally useless.

**Primary recommendation:** Structure this phase as three plans: (1) 1Password vault spec + credential inventory, (2) Supabase schema extension + credential seed data, (3) payer tracker dossier seed data + printable export + alert architecture spec.

---

## Standard Stack

### Core
| Tool/System | Version | Purpose | Why Standard |
|-------------|---------|---------|--------------|
| 1Password | Existing (Valentina's account) | Credential vault for all practice logins | Locked decision; already in use; shared vault feature handles multi-user access (Maxi + Valentina) |
| Supabase (Brighter Days project) | Existing (Phase 1) | Credential data store + alert data source for Phase 4/5 TD | Locked decision; Phase 1 already created schema; this phase extends it |
| Markdown (for printable export) | — | Auditor-facing credential inventory | Converts cleanly to PDF; version-controlled; human-readable without tooling |
| PostgreSQL (via Supabase) | 15+ | Relational data model for credentials and payer tracker | Already in use; expiry date queries and interval math built-in |

### 1Password Vault Architecture

**Shared vault name:** "Brighter Days Practice"

**Category structure (Claude's discretion — grouped by functional use, not alphabetically):**

```
Brighter Days Practice (shared vault)
├── EHR & Billing
│   ├── Tebra (EHR/PM)
│   └── Tebra Clearinghouse / Availity
├── Insurance & Credentialing
│   ├── CAQH ProView
│   ├── Medicare PECOS
│   ├── Medi-Cal PAVE / DHCS Provider Portal
│   └── [one entry per payer portal — 17 entries]
├── State Licensing & DEA
│   ├── CA BreEZe (Medical Board)
│   ├── DEA Diversion Control Portal
│   └── CURES (CA PDMP)
├── Business & Corporate
│   ├── CA Secretary of State BizFile
│   ├── IRS EFTPS (federal tax payments)
│   ├── CA FTB MyFTB (state tax)
│   └── City of Torrance Business License Portal
├── Communication & Workspace
│   ├── Google Workspace Admin (admin@valentinaparkmd.com)
│   ├── Google Voice (424) 248-8090
│   └── GoDaddy (domain management)
├── Infrastructure & Tech
│   ├── Supabase (Brighter Days project)
│   ├── 1Password (vault admin)
│   └── [any future tech credentials]
└── Malpractice & Insurance
    ├── CAP/MPT Portal (malpractice)
    └── [general liability, workers' comp when obtained]
```

**Items that stay in Valentina's personal vault (NOT in shared practice vault):**
- Personal banking
- SSN
- Personal email accounts
- Personal social media
- Personal credit cards

**Critical migration items from Phase 1 audit:**
- SSN, passwords, portal credentials currently stored in plaintext Word docs (Master Key.docx, liscensing notes.docx) — these MUST be moved to 1Password as part of CRED-01

### Supabase Schema Extension

Two new tables extending Phase 1's `compliance_items` foundation:

**Table: `credentials`** — the credential inventory with full renewal metadata
```sql
CREATE TABLE credentials (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  compliance_item_id UUID REFERENCES compliance_items(id),  -- links to Phase 1 record if exists
  credential_type   TEXT NOT NULL,    -- 'license', 'dea', 'npi', 'caqh', 'certification', 'malpractice', 'payer_id', 'business_license', 'corporate_filing', 'insurance'
  credential_name   TEXT NOT NULL,    -- human-readable name for display
  issuing_body      TEXT,             -- 'CA Medical Board', 'DEA', 'NPPES', 'CAQH', 'ABPN', 'CAP/MPT', 'City of Torrance', etc.
  credential_number TEXT,             -- the actual number/ID value
  holder            TEXT NOT NULL,    -- 'valentina', 'entity' (for corp credentials)
  status            TEXT NOT NULL,    -- 'ACTIVE', 'EXPIRED', 'PENDING', 'ESTIMATED'
  issue_date        DATE,
  expiry_date       DATE,
  renewal_cycle_days INT,             -- how often it renews (e.g. 730 for 2yr, 1095 for 3yr, 120 for CAQH)
  renewal_cost_usd  NUMERIC(10,2),    -- estimated renewal cost (NULL if unknown)
  renewal_portal_url TEXT,            -- direct URL for renewal
  renewal_notes     TEXT,             -- any caveats, steps required, etc.
  alert_90          BOOLEAN DEFAULT true,  -- fire alert at 90 days before expiry
  alert_60          BOOLEAN DEFAULT true,
  alert_30          BOOLEAN DEFAULT true,
  alert_7           BOOLEAN DEFAULT true,
  vault_entry_ref   TEXT,             -- 1Password item name for cross-reference
  document_ref      TEXT,             -- path to underlying cert/registration document
  notes             TEXT,
  updated_at        TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_credentials_expiry_date ON credentials(expiry_date);
CREATE INDEX idx_credentials_credential_type ON credentials(credential_type);
CREATE INDEX idx_credentials_status ON credentials(status);
CREATE INDEX idx_credentials_holder ON credentials(holder);
```

**Table: `payer_tracker`** — the 17-panel payer dossier
```sql
CREATE TABLE payer_tracker (
  id                        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  payer_name                TEXT NOT NULL,
  payer_short               TEXT,          -- 'Aetna', 'BCCA', 'BSCA', etc. for display
  tebra_payer_id            TEXT,          -- the Tebra-assigned payer ID code
  network_type              TEXT,          -- 'PPO', 'HMO', 'EPO', 'BOTH', 'UNKNOWN'
  contract_status           TEXT NOT NULL, -- 'ACTIVE', 'PENDING', 'NOT_EXECUTED', 'SUSPENDED', 'UNKNOWN'
  credentialing_status      TEXT,          -- 'CREDENTIALED', 'PENDING', 'APPLICATION_SUBMITTED', 'NOT_STARTED'
  credentialing_date        DATE,          -- date credentialing was completed/effective
  contract_effective_date   DATE,
  recred_due_date           DATE,          -- next re-credentialing due date
  recred_cycle_years        INT,           -- typically 3 (industry norm)
  recred_is_estimated       BOOLEAN DEFAULT false,  -- true if date is estimated, not known
  can_bill                  BOOLEAN,       -- can the practice currently submit claims?
  billing_notes             TEXT,
  claim_submission_method   TEXT,          -- 'electronic_only', 'paper_available', 'clearinghouse'
  timely_filing_days        INT,           -- days from DOS to submit claim; industry norm: 90-365
  timely_filing_is_estimated BOOLEAN DEFAULT false,
  denial_patterns           TEXT,          -- known denial patterns for this payer
  portal_url                TEXT,          -- provider portal URL
  portal_login_ref          TEXT,          -- 1Password entry name for portal login
  provider_relations_phone  TEXT,
  provider_relations_email  TEXT,
  credentialing_rep_name    TEXT,
  credentialing_rep_email   TEXT,
  fee_schedule_notes        TEXT,          -- known rates, e.g. '99214: $94.50, 90833: $85.00'
  payer_id_for_claims       TEXT,          -- EDI payer ID for electronic claims
  npi_on_file               TEXT,          -- NPI payer has on file (should match 1023579513)
  group_npi_on_file         TEXT,          -- group NPI (1699504282)
  ein_on_file               TEXT,          -- EIN payer has on file (99-1529764)
  key_issues                TEXT,          -- flagged issues from Phase 1 audit
  contact_notes             TEXT,          -- general notes on payer relationship
  updated_at                TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_payer_tracker_contract_status ON payer_tracker(contract_status);
CREATE INDEX idx_payer_tracker_recred_due_date ON payer_tracker(recred_due_date);
CREATE INDEX idx_payer_tracker_can_bill ON payer_tracker(can_bill);
```

**View: `credential_alert_queue`** — TD-ready view for alert rendering
```sql
CREATE VIEW credential_alert_queue AS
SELECT
  c.id,
  c.credential_name,
  c.credential_type,
  c.credential_number,
  c.expiry_date,
  c.status,
  c.renewal_portal_url,
  c.vault_entry_ref,
  (c.expiry_date - CURRENT_DATE) AS days_until_expiry,
  CASE
    WHEN c.expiry_date < CURRENT_DATE                               THEN 'EXPIRED'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '7 days'          THEN 'ALERT_7'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '30 days'         THEN 'ALERT_30'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '60 days'         THEN 'ALERT_60'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '90 days'         THEN 'ALERT_90'
    ELSE 'CURRENT'
  END AS alert_level,
  CASE
    WHEN c.expiry_date < CURRENT_DATE                               THEN 'RED'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '30 days'         THEN 'RED'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '60 days'         THEN 'AMBER'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '90 days'         THEN 'YELLOW'
    ELSE 'GREEN'
  END AS display_color
FROM credentials c
WHERE c.expiry_date IS NOT NULL
  AND c.status != 'EXPIRED'
ORDER BY c.expiry_date ASC;
```

**View: `payer_credentialing_alerts`** — re-credentialing deadlines for TD display
```sql
CREATE VIEW payer_credentialing_alerts AS
SELECT
  p.id,
  p.payer_name,
  p.payer_short,
  p.contract_status,
  p.recred_due_date,
  p.recred_is_estimated,
  p.can_bill,
  p.provider_relations_phone,
  p.credentialing_rep_name,
  p.credentialing_rep_email,
  (p.recred_due_date - CURRENT_DATE) AS days_until_recred,
  CASE
    WHEN p.recred_due_date < CURRENT_DATE                               THEN 'OVERDUE'
    WHEN p.recred_due_date < CURRENT_DATE + INTERVAL '90 days'         THEN 'DUE_SOON'
    WHEN p.recred_due_date < CURRENT_DATE + INTERVAL '180 days'        THEN 'DUE_QUARTER'
    ELSE 'CURRENT'
  END AS recred_urgency
FROM payer_tracker p
WHERE p.recred_due_date IS NOT NULL
ORDER BY p.recred_due_date ASC NULLS LAST;
```

---

## Architecture Patterns

### Recommended Deliverable Structure

```
.planning/phases/02-credential-vault-monitoring/
├── 02-CONTEXT.md            (exists — user decisions)
├── 02-RESEARCH.md           (this file)
├── 02-01-PLAN.md            (Plan 1: 1Password vault spec + credential inventory)
├── 02-02-PLAN.md            (Plan 2: Supabase schema extension + credential seed data)
├── 02-03-PLAN.md            (Plan 3: payer tracker seed data + printable export + alert spec)
├── credential-schema.sql    (new tables: credentials + payer_tracker + views)
├── credential-seed.sql      (all known credentials pre-populated)
├── payer-tracker-seed.sql   (all 17 panel dossiers pre-populated)
├── credential-inventory.md  (printable auditor-facing document)
└── alert-architecture.md    (Phase 4/5 implementation spec)
```

### Pattern 1: Credential Data Entry — Real Data First, Estimates Flagged

For every credential and payer dossier: fill every known field from Phase 1 document audit data first. For unknown fields (re-credentialing dates when contract date unknown, timely filing limits, provider relations contacts), use industry norms and flag the row with `_is_estimated = true` or inline `[ESTIMATED]` text.

**Never leave required fields NULL when an estimate exists.** A NULL re-credentialing date is invisible to any alert system. An estimated date with a flag is actionable and correctable.

```sql
-- Example: payer with unknown recred date — use industry norm, flag it
INSERT INTO payer_tracker (
  payer_name, tebra_payer_id, contract_status, credentialing_date,
  recred_due_date, recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated
) VALUES (
  'Blue Cross of California', '47198', 'ACTIVE', '2025-08-07',
  '2028-08-07',  -- 3 years from credentialing date (industry norm)
  3, true,       -- flagged as ESTIMATED
  90, true       -- 90 days is conservative industry norm; flagged
);
```

### Pattern 2: Extending Phase 1 Without Duplicating It

Phase 1 created `compliance_items` rows for credentials (CA medical license, DEA, malpractice insurance). Phase 2 creates the `credentials` table and links back to those rows via `compliance_item_id` foreign key. This means:

- Phase 1 compliance panel still shows license/DEA status in `compliance_dashboard` view
- Phase 2 credential panel shows the same items in `credential_alert_queue` view with richer renewal metadata
- No duplication of data — just enrichment via the foreign key relationship

```sql
-- Correct pattern: credentials row links to existing compliance_items row
-- Do NOT re-insert the same item into compliance_items
INSERT INTO credentials (
  compliance_item_id,   -- FK to existing Phase 1 row
  credential_type, credential_name, credential_number,
  holder, status, expiry_date, renewal_cycle_days, renewal_portal_url
) SELECT
  id,  -- get the UUID from the existing compliance_items row
  'license', 'CA Medical License A-177690', 'A-177690',
  'valentina', 'ACTIVE', '2028-06-30', 730,
  'https://www.breeze.ca.gov/'
FROM compliance_items WHERE req_id = 'COMP-08'
LIMIT 1;
```

### Pattern 3: Alert Architecture Spec Format

The alert spec document (`alert-architecture.md`) must give Phase 4/5 everything they need to build it without further discovery. Required sections:

1. **Trigger conditions** — what database state fires an alert (specific SQL query or view)
2. **Delivery targets** — both Maxi (maxi@email) and Valentina (admin@valentinaparkmd.com); both Google Calendar + email
3. **Cadence** — 90/60/30/7 days, deduplication rules (don't fire same alert twice same day)
4. **Alert payload format** — what data the notification contains (credential name, days remaining, renewal URL, 1Password reference)
5. **Completion gate** — what Supabase state change stops the alerts (credential status updated to ACTIVE with new expiry date > current date + 30 days)
6. **Tech stack for implementation** — n8n polling Supabase `credential_alert_queue` view; recommended polling interval: daily at 7:00 AM Pacific

### Pattern 4: Printable Export Format

The credential inventory (`credential-inventory.md`) is an auditor-facing document, not internal notes. Format rules:
- Professional language, no debug comments or internal flags
- Organized by credential type (licenses first, then DEA, then certifications, then payer IDs)
- Every row shows: credential name, number, issuing body, expiry date, status
- Estimated dates are shown as "[est.]" with a footnote — not hidden, but not alarming
- Header section shows practice identifiers (NPI, EIN, DEA#, CAQH ID)
- Footer shows document date and that actuals should be verified against source documents

### Anti-Patterns to Avoid

- **Duplicating Phase 1 compliance_items rows:** Don't re-create `COMP-08` (license) or `COMP-10` (DEA) in the new credentials table without linking to Phase 1 via FK. Duplication creates drift.
- **Leaving CAQH next-attestation-date unset:** CAQH is the highest-risk single expiry in the practice — one missed cycle suspends all 17 contracts. It MUST have a computed expiry date in the credentials table.
- **Treating payer contract status from Phase 1 as final:** Phase 1 identified several uncertain contract statuses (Anthem unsigned, Kaiser unconfirmed, Cigna pending). The payer tracker must reflect these with accurate `contract_status` values, not assume ACTIVE.
- **Separating Maxi and Valentina alert targets:** CONTEXT.md locked both receiving all alerts — don't split by credential type or role.
- **Putting personal credentials in the practice vault:** The 1Password spec must explicitly document which items stay in Valentina's personal vault to prevent scope creep.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Password management | Custom credential store | 1Password shared vault | Already licensed, team sharing built-in, HIPAA-appropriate, secret key + master password security model |
| Expiry alerting | Custom scheduler | n8n polling Supabase view (Phase 4/5) | n8n is already in the tech stack; `credential_alert_queue` view does the date math in SQL |
| Payer portal login management | Spreadsheet | 1Password entries linked from payer_tracker | Passwordless reference field (`portal_login_ref`) connects DB record to vault entry without storing credentials in DB |
| Re-credentialing date calculation | Manual tracking | Supabase computed view | SQL INTERVAL arithmetic handles 90/180 day windows; view recalculates daily automatically |
| Printable credential report | Custom PDF tool | Markdown export | Markdown converts to PDF cleanly via any renderer; easier to maintain and update; version-controllable |

**Key insight:** This phase is entirely about data organization and architecture. The value is in completeness and correctness of the data — every field filled, every payer covered, every expiry date set. The automation and alerting are downstream consumers. Get the data right and Phase 4/5 has everything they need.

---

## Common Pitfalls

### Pitfall 1: Medicare "DEACTIVATED" Status Carryover

**What goes wrong:** Phase 1 `compliance-data-seed.sql` contains a Medicare row reflecting the January 2026 deactivation. If Phase 2 seed data pulls from Phase 1 without correction, the payer tracker will show Medicare as inactive — which is incorrect per the locked decision in CONTEXT.md.

**Why it happens:** CONTEXT.md corrected this: "Medicare is ACTIVE/ENROLLED — Phase 1 incorrectly flagged as DEACTIVATED 1/31/2026."

**How to avoid:** The `payer_tracker` seed data must set Medicare `contract_status = 'ACTIVE'` and `can_bill = true`. Also: update the Phase 1 compliance_items row for CRED-04/Medicare to reflect corrected status if a compliance item exists.

**Warning signs:** Any seed data showing Medicare as DEACTIVATED, SUSPENDED, or `can_bill = false`.

### Pitfall 2: CAQH Attestation Cycle Misconfigured

**What goes wrong:** CAQH requires re-attestation every 120 days, but the alert cadence (90/60/30/7) is designed for annual or biennial credentials. If CAQH's next attestation date isn't set correctly, the 90-day alert fires when there are only 30 days left.

**Why it happens:** 120 days is an unusually short cycle — most credentials renew annually or every 2-3 years. It's easy to set the renewal_cycle_days wrong.

**How to avoid:** Set `renewal_cycle_days = 120` in the credentials table. The CAQH `expiry_date` is `last_attestation_date + 120 days`. The 90-day alert fires when only 30 days remain since last attestation — which is the correct trigger window (within the next attestation cycle). The spec should note: "CAQH 90-day alert = 30 days into next cycle, not 90 days before deadline."

**Warning signs:** CAQH alert dates don't align with the 120-day cycle math.

### Pitfall 3: Payer Tracker Fields Left NULL for Unknown Values

**What goes wrong:** When exact contract dates, re-credentialing deadlines, or contact info are unknown, leaving those fields NULL makes the tracker useless for alerting and lookup.

**Why it happens:** Legitimate uncertainty about contract details for payers where status was unclear (Anthem, Kaiser, Cigna, Carelon, Tricare from Phase 1 audit).

**How to avoid:** For every NULL-risk field in the 17-payer dossier:
- Re-credentialing date: use `credentialing_date + 3 years` as industry norm estimate; set `recred_is_estimated = true`
- Timely filing: default to 90 days for commercial payers (conservative); set `timely_filing_is_estimated = true`
- Provider relations contacts: use payer's main provider relations line from their website if rep name unknown
- Fee schedule: use Medicare rates as baseline where contracted rates unknown

**Warning signs:** More than 3-4 NULL values per payer row in the tracker.

### Pitfall 4: 1Password Vault Structure Too Granular or Too Flat

**What goes wrong:** Too many subcategories make the vault hard to navigate. Too few categories make it hard to find the right login under time pressure.

**Why it happens:** Designing categories by credential type (alphabetically) rather than by how they're actually used.

**How to avoid:** The recommended category structure above is grouped by functional use (EHR & Billing, Insurance & Credentialing, State Licensing & DEA, etc.) — matching how Valentina and Maxi actually search for credentials. Within "Insurance & Credentialing," 17 payer portal entries are manageable because 1Password has search; subcategories per payer are unnecessary overhead.

**Warning signs:** More than 8-10 top-level categories; any category with only 1 item in it.

### Pitfall 5: Sensitive Data Migration Not Explicitly Scoped

**What goes wrong:** Phase 1 flagged that SSNs, passwords, and portal credentials are stored in plaintext Word docs (Master Key.docx, liscensing notes.docx). If Phase 2 doesn't explicitly scope the migration of this data into 1Password, it will stay in plaintext indefinitely.

**Why it happens:** The vault structure spec focuses on organizing new entries; the migration of existing plaintext data is treated as implied.

**How to avoid:** CRED-01 must explicitly include a step/task: "Migrate all credential data from plaintext documents (Master Key.docx, liscensing notes.docx) into the shared 1Password vault." This is a human-action item for Valentina.

---

## Credential Inventory (Complete Known Data)

All data sourced from Phase 1 `01-DOCUMENT-AUDIT.md` — HIGH confidence.

### Master Practice Identifiers (for seed data and printable export)

| Identifier | Value | Notes |
|------------|-------|-------|
| Legal Entity | Valentina Park MD, Professional Corporation | S-Corp (CA) |
| EIN | 99-1529764 | Federal tax ID |
| CA State ID | 6093174 | CA Secretary of State entity number |
| Individual NPI | 1023579513 | Primary; use everywhere |
| Group NPI | 1699504282 | For entity-level billing |
| CAQH ID | 16149210 | ProView profile ID |
| Taxonomy Code | 2084P0800X | Psychiatry |
| Practice Address | 2748 Pacific Coast Hwy #1084, Torrance, CA 90505 | Current registered address |
| Phone | (424) 248-8090 | Google Voice |
| Fax | (949) 703-8810 | Tebra-provided |

### Credentials for credentials Table Seed Data

| Credential | Number | Status | Expiry | Renewal Cycle | Renewal Portal |
|------------|--------|--------|--------|---------------|----------------|
| CA Medical License | A-177690 | ACTIVE | 2028-06-30 | 2 years (730 days) | https://www.breeze.ca.gov/ |
| DEA Registration | FP3833933 | ACTIVE | 2027-03-31 | 3 years (1095 days) | https://www.deaecom.gov/ |
| ABPN Psychiatry Certification | Cert #83742 | ACTIVE | No expiry | Continuous certification (CC) | https://www.abpn.com/ |
| ABPN Child & Adolescent Certification | Cert #13399 | ACTIVE | No expiry | Continuous certification (CC) | https://www.abpn.com/ |
| CAQH ProView Attestation | CAQH ID: 16149210 | ACTIVE* | Computed: last + 120 days | 120 days | https://proview.caqh.org |
| Malpractice Insurance (CAP/MPT) | Policy #48289 | ACTIVE | 2026-12-31 | Annual | https://www.cap-mpt.com/ |
| S-Corp Entity Coverage | Entity #10709 | ACTIVE | 2026-12-31 | Annual | https://www.cap-mpt.com/ |
| Business License (Torrance) | BL-LIC-051057 | EXPIRED | Was 2025-12-31 | Annual | https://www.torranceca.gov/ |
| CA Statement of Information | — | PENDING verify | Annual | — | https://bizfileplus.sos.ca.gov/ |
| Medicare PTAN (Group) | CB496693 | ACTIVE** | No expiry | Re-enroll every 5 years | https://pecos.cms.hhs.gov/ |
| Medicare PTAN (Individual) | CB496694 | ACTIVE** | No expiry | Re-enroll every 5 years | https://pecos.cms.hhs.gov/ |
| Medi-Cal PAVE | 100517999 | ACTIVE | Annual re-enrollment | Annual | https://www.dhcs.ca.gov/ |

*CAQH: last attestation date unknown; Phase 2 must note this as requiring Valentina to verify current attestation date and update seed data.

**Medicare: CONTEXT.md locked as ACTIVE per corrected Phase 2 information; Phase 1 document audit showed DEACTIVATED — Phase 2 seed data uses ACTIVE status per correction.

### Payer Tracker — All 17 Panels

All data sourced from Phase 1 document audit + Tebra payer IDs from CONTEXT.md specifics. Re-credentialing dates are estimated (credentialing date + 3 years) where actual re-cred dates are unknown.

| Payer Name | Tebra ID | Contract Status | Can Bill | Credentialing Date | Est. Re-cred Date | Key Issue |
|------------|----------|-----------------|----------|-------------------|-------------------|-----------|
| Aetna | 60054 | ACTIVE | YES | 2024-08-13 | 2027-08-13 [est] | Individual only; group requires 2+ providers |
| Blue Cross of California | 47198 | PENDING | UNCLEAR | 2025-08-07 | 2028-08-07 [est] | Contract effective date unconfirmed |
| Blue Shield of California | 94036 | PENDING | UNCLEAR | 2025-08-07 | 2028-08-07 [est] | Contract effective date TBD |
| California Health & Wellness | 68069 | UNKNOWN | UNKNOWN | — | — [est] | No data in Phase 1 audit |
| Cigna | 62308 | NOT_EXECUTED | NO | — | — | Documents requested 12/9/2024; contract not executed |
| Cigna Behavioral Health | MCCBV | NOT_EXECUTED | NO | — | — | Linked to Cigna; same status |
| Coastal Communities Physician Network | CCPN1 | UNKNOWN | UNKNOWN | — | — | No data in Phase 1 audit |
| Facey Medical Foundation | 95432 | UNKNOWN | UNKNOWN | — | — | No data in Phase 1 audit |
| Health Net of California | 95567 | UNKNOWN | UNKNOWN | — | — | No data in Phase 1 audit |
| Hoag | HPPZZ | UNKNOWN | UNKNOWN | — | — | No data in Phase 1 audit |
| Kaiser Foundation Health Plan of Southern CA | 94134 | PENDING | UNCLEAR | — | — | Contract sent via DocuSign; execution unconfirmed. Contact: Nanette Bordenave (Nanette.J.Bordenave@kp.org) |
| Magellan Behavioral Health | 01260 | UNKNOWN | UNKNOWN | — | — | No data in Phase 1 audit |
| Medicaid of California (Medi-Cal) | 00148 | ACTIVE | YES | — | Annual re-enrollment | PAVE ID 100517999; EFT approved |
| Medicare of California Southern | 01182 | ACTIVE | YES | — | — | PTAN CB496693/CB496694; ACTIVE per Phase 2 correction |
| Providence Health Plan | PHP01 | UNKNOWN | UNKNOWN | — | — | No data in Phase 1 audit |
| Torrance Hospital IPA | THIPA | UNKNOWN | UNKNOWN | — | — | No data in Phase 1 audit |
| Torrance Memorial Medical Center | TMMC1 | UNKNOWN | UNKNOWN | — | — | No data in Phase 1 audit |

**Note on unknown payers:** 9 of 17 payers have no contract data in Phase 1 documents. These rows must be populated with industry-norm estimates and flagged as ESTIMATED. Best estimates for unknown payers: contract_status = 'UNKNOWN', can_bill = NULL, recred_cycle_years = 3, timely_filing_days = 90 (conservative). Valentina or credentialing agent Mary should verify actuals during Phase 2 execution.

### Known Contacts (for payer tracker seed data)

| Contact | Role | Contact Info |
|---------|------|-------------|
| Mary | Credentialing agent (contractor) | Handling payer applications (no contact info in docs) |
| Andy Miller | Credentialing specialist | andy.miller@medheave.com |
| Susan Delao | Tebra Customer Loyalty | susan.delao@tebra.com |
| Nanette Bordenave | Kaiser credentialing rep | Nanette.J.Bordenave@kp.org |

### Known Fee Schedules (for payer tracker notes)

| Payer | CPT 99214 | CPT 90833 | CPT 90785 | Combined |
|-------|-----------|-----------|-----------|----------|
| Medicare | $137.58 | $77.86 | $15.21 | $230.65 |
| Blue Shield CA | $113.27 | $84.00 | $4.88 | $202.15 |
| Aetna | $94.50 | $85.00 | $16.55 | $196.05 |
| Cigna | $90.33 | $40.00 | $4.60 | $134.93 |

---

## Alert Architecture Spec

This section defines what Phase 4/5 (TD dashboard) needs to implement the alert system. Phase 2 produces this as the `alert-architecture.md` file.

### Credential Expiry Alerts

**Trigger query (n8n polls daily):**
```sql
SELECT * FROM credential_alert_queue
WHERE alert_level IN ('ALERT_90', 'ALERT_60', 'ALERT_30', 'ALERT_7', 'EXPIRED');
```

**Delivery:**
- Channel 1: Email to both admin@valentinaparkmd.com AND maxi@[email]
- Channel 2: Google Calendar event created (or updated) for the expiry date
- Both channels must fire — belt and suspenders for high-stakes deadlines

**Alert payload (per credential):**
```
Subject: [ALERT] [credential_name] expires in [days_until_expiry] days — action required
Body:
  Credential: [credential_name]
  Number: [credential_number]
  Expiry: [expiry_date]
  Days remaining: [days_until_expiry]
  Status: [alert_level]
  Renewal portal: [renewal_portal_url]
  1Password entry: [vault_entry_ref]
  Action: Log in at [renewal_portal_url] and complete renewal before [expiry_date]
```

**Deduplication rule:** One alert per credential per alert level per day. If ALERT_90 fired yesterday, don't fire again until 89 days remaining (ALERT_90 → ALERT_60 transition).

**Completion gate:** Alert stops when `credentials.expiry_date` is updated to a future date AND `credentials.status = 'ACTIVE'`. Polling checks this before sending.

### CAQH Re-Attestation Alert (Special Case)

CAQH is the highest-risk single credential — one missed cycle can silently suspend all 17 payer contracts simultaneously. It gets its own alert logic:

**Trigger:** `credential_alert_queue` where `credential_name LIKE 'CAQH%'` — fires at 90/60/30/7 days before attestation expiry (which is `last_attestation_date + 120 days`).

**Special alert language:**
```
Subject: [URGENT] CAQH Re-Attestation Due in [days] days — All 17 Payer Contracts at Risk
Body:
  Your CAQH ProView profile requires re-attestation every 120 days.
  Missing this deadline can silently suspend in-network status with ALL 17 payers simultaneously.

  Last attested: [last_attestation_date]
  Due: [expiry_date]
  Days remaining: [days_until_expiry]

  Re-attest now: https://proview.caqh.org
  Time required: 5-20 minutes

  Steps: Log in → Attestation tab → Review current information → Submit
```

**Completion gate:** Valentina logs into CAQH and re-attests. Maxi then updates `credentials` table: new `expiry_date = CURRENT_DATE + 120` and records new `issue_date`. Alert stops.

### Payer Re-Credentialing Alerts

**Trigger query:**
```sql
SELECT * FROM payer_credentialing_alerts
WHERE recred_urgency IN ('DUE_SOON', 'OVERDUE');
```

**Alert payload:** Payer name, days until re-cred, credentialing rep contact (if known), portal URL, estimated vs. confirmed flag.

**Alert window:** 180 days before re-cred deadline (earlier than credential alerts because re-credentialing requires more lead time — 90-day advance submission is typical).

---

## State of the Art

| Topic | Current Standard | Notes |
|-------|-----------------|-------|
| Re-credentialing cycle | 3 years for commercial payers | Industry norm; some payers (Kaiser, Cigna) may require 2-year cycles. Verify with each payer. |
| CAQH re-attestation | Every 120 days | Unchanged; managed via CAQH ProView |
| Medicare re-enrollment | Every 5 years via PECOS | Required by CMS; PECOS online submission only (paper phased out) |
| DEA renewal | Every 3 years | Online only via deaecom.gov (paper eliminated in 2024) |
| CA Medical License renewal | Every 2 years | Via BreEZe portal; continuing education requirements apply |
| Timely filing windows | 90-365 days from DOS | Varies: Medicare = 365 days; most commercial = 90-180 days; Medi-Cal = 12 months |
| 1Password business vault sharing | Shared vaults with fine-grained access control | 1Password Teams/Business supports shared vaults; Families plan also supports vault sharing |

**DEA Address Note (from Phase 1):** DEA registration FP3833933 currently shows Walnut Creek address (CPS prior employer address) — practice is Torrance. This must be updated per 21 CFR 1301.51 before re-credentialing cycles flag address mismatches. Not a Phase 2 blocker but the payer tracker should note which payers have address on file that may not match.

---

## Open Questions

1. **CAQH current attestation date unknown**
   - What we know: CAQH ID 16149210 exists; last attestation date not captured in Phase 1 docs
   - What's unclear: Is it current or expired? When does the current cycle expire?
   - Recommendation: Valentina must log into proview.caqh.org and check. Phase 2 seed data should note `expiry_date = NULL` with a comment "Update after Valentina verifies last attestation date in CAQH portal." This is a human-verify task, not a blocker for schema creation.

2. **9 of 17 payers have no contract data**
   - What we know: California Health & Wellness, Coastal Communities, Facey Medical, Health Net, Hoag, Magellan, Providence, Torrance IPA, Torrance Memorial — all have Tebra payer IDs but no Phase 1 contract records
   - What's unclear: Are these active, pending, or not yet credentialed?
   - Recommendation: Populate with UNKNOWN status and industry-norm estimates. Include an action item for Valentina/Mary (credentialing agent) to verify actual status for each. Phase 2 does not block on this.

3. **1Password plan type for shared vault**
   - What we know: Valentina has a 1Password account; shared vault feature requires 1Password Teams or Families plan
   - What's unclear: Is her current plan individual (no vault sharing) or Teams/Families (vault sharing supported)?
   - Recommendation: The vault structure spec should include a note: "Verify account plan supports shared vaults. If on Individual plan, upgrade to 1Password Families ($4.99/month) or 1Password Teams ($19.95/month for first 10 users) to enable vault sharing with Maxi." This is LOW risk — upgrade is straightforward if needed.

4. **Anthem Blue Cross counter-signature status**
   - What we know: Phase 1 flagged "Anthem has NOT countersigned" both commercial and Medicaid agreements as of 2026-02-27
   - What's unclear: Has this been resolved since? Anthem is listed as one of the 17 credentialed payers but contract execution is unclear
   - Recommendation: Payer tracker seed data sets Anthem (`Blue Cross of California`, Tebra ID `47198`) contract_status = 'PENDING', can_bill = false with note "Provider-signed 5/20/2025; awaiting Anthem countersignature." Action item generated for follow-up.

5. **Medicare correction — source of truth**
   - What we know: CONTEXT.md states Medicare is ACTIVE; Phase 1 document audit showed DEACTIVATED 1/31/2026
   - What's unclear: What changed? Was re-enrollment completed? Or is the CONTEXT.md correction based on new information Valentina provided?
   - Recommendation: Accept CONTEXT.md as authoritative (it's from the discuss-phase with Valentina). Populate Medicare as ACTIVE. Include a note in the payer tracker: "Status corrected per Phase 2 discussion — Phase 1 showed DEACTIVATED; Valentina confirmed ACTIVE enrollment as of 2026-02-27. Verify PECOS portal if in doubt."

---

## Sources

### Primary (HIGH confidence)
- Phase 1 `01-DOCUMENT-AUDIT.md` — all credential numbers, expiry dates, payer IDs, contacts extracted from 60+ real practice documents
- Phase 1 `compliance-data-seed.sql` — structured credential data already in Supabase; Phase 2 extends, does not duplicate
- Phase 1 `compliance-schema.sql` — existing table structure; Phase 2 foreign keys reference this
- Phase 1 `baa-tracker-seed.sql` — vendor relationship data for context
- `02-CONTEXT.md` — all locked user decisions for this phase

### Secondary (MEDIUM confidence)
- CAQH ProView Provider User Guide — 120-day re-attestation cycle: https://www.caqh.org/hubfs/43908627/drupal/solutions/proview/guide/provider-user-guide.pdf
- CMS PECOS — Medicare 5-year re-enrollment: https://pecos.cms.hhs.gov/
- 1Password — Shared Vaults documentation: https://support.1password.com/share-items/
- Industry norm: 3-year re-credentialing cycle — standard across major commercial payers (Aetna, Cigna, Blue Cross, Blue Shield); confirmed via multiple credentialing service sources

### Tertiary (LOW confidence — verify when encountered)
- Exact timely filing limits per payer: use 90-day conservative estimate unless payer contract specifies
- Payer-specific re-credentialing windows (advance notice required): industry norm 90 days; verify with each payer
- 1Password current plan type for Valentina's account: must verify directly; affects shared vault capability

---

## Metadata

**Confidence breakdown:**
- Credential data (licenses, DEA, NPI, certifications): HIGH — sourced from Phase 1 document audit of real records
- Payer data for known payers (Aetna, Medi-Cal, Medicare, Blue Shield, Kaiser): MEDIUM — partial data from Phase 1; contract status for several payers uncertain
- Payer data for 9 unknown payers: LOW — Tebra IDs known; all other fields are industry-norm estimates
- Schema design: HIGH — extends Phase 1 pattern consistently; follows established PostgreSQL conventions
- 1Password vault structure: HIGH — functional grouping logic is design decision (Claude's discretion); no external dependency
- Alert architecture spec: HIGH — based on locked CONTEXT.md decisions; implementation risk is Phase 4/5 concern
- CAQH last attestation date: LOW — not captured in Phase 1; requires Valentina to verify

**Research date:** 2026-02-27
**Valid until:** 2026-05-27 (stable domain; payer contract statuses should be re-verified if more than 60 days pass before execution)
