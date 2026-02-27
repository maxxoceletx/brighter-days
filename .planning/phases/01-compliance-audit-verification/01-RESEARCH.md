# Phase 1: Compliance Audit & Verification - Research

**Researched:** 2026-02-27
**Domain:** California Telehealth Psychiatry Compliance Law & Regulatory Requirements
**Confidence:** MEDIUM-HIGH (regulatory requirements well-sourced; some practice-specific details require Valentina's verification)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Single master compliance system — not separate documents per topic
- All compliance data lives in a **dedicated Brighter Days Supabase project** (NOT shared with FindItNOW or Momo)
- Compliance data is structured in Supabase tables so TouchDesigner can query and display it
- The compliance audit outputs are consumed as an interactive tab in the TouchDesigner command center — not static files
- Everything routes through TD — this is the primary interface for viewing and managing compliance
- Verify status AND produce the actual compliant document for each item (not just a status check)
- All produced documents are practice-ready — pre-filled with Valentina's real info (NPI 1023579513, entity name, payer list, etc.), not templates with blanks
- HIPAA Security Risk Analysis uses the HHS SRA Tool format (most defensible if audited by OCR)
- Informed consent form formatted for Tebra's patient intake system (digital, not PDF)
- Gaps are fixed immediately during the audit — audit = remediation in one pass
- Human-required tasks (e.g., "log into CAQH and re-attest") surface as actionable items in the TD action queue
- System drafts all outreach (emails, letters, scripts) for external parties — Valentina reviews and sends
- Three severity levels for compliance items: CRITICAL (blocks first patient), WARNING (needs attention within 30 days), INFO (nice to have) — color-coded in TD display
- ASCII art aesthetic: Modern and dynamic, not basic retro terminal — animated, flowing, styled text-based UI

### Claude's Discretion
- Supabase table schema design for compliance data
- Compliance panel layout design within TD (user said "you decide" on display style)
- How to structure the HHS SRA Tool assessment for a solo telehealth practice
- Technical approach to querying compliance data from Supabase into TD

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| COMP-01 | HIPAA Security Risk Analysis formally documented (OCR's #1 enforcement target, $25K-$3M penalties) | HHS SRA Tool v3.6 is the standard format; 156-question structured assessment; produces exportable report |
| COMP-02 | BAAs signed and tracked with all vendors handling PHI (Tebra, Supabase, email provider, etc.) | Tebra BAA: incorporated into customer agreement (needs confirmation). Supabase: requires Team/Enterprise plan + HIPAA add-on. Full vendor list needs audit |
| COMP-03 | CA telehealth informed consent form per B&P Code 2290.5 (required before first session) | B&P 2290.5 requirements documented; specific consent elements identified; must be formatted for Tebra digital intake |
| COMP-04 | License and certification expiry tracking with automated alerts | CA medical license: renews every 2 years via BreEZe; DEA: renews every 3 years; CAQH: re-attest every 120 days |
| COMP-05 | Good Faith Estimate template compliant with No Surprises Act (self-pay patients) | Federal NSA requirements documented; requires CPT codes, NPI, projected sessions; due within 3 business days of scheduling |
| COMP-06 | Patient location verification protocol documented (CA only, no interstate) | CA law: patient must be in CA at time of service; requires verbal confirmation + documentation at each session |
| COMP-07 | Audit all existing patient-facing forms against current CA law and federal requirements | Forms to audit: intake, financial agreement, consent. Standard elements documented from research |
| COMP-08 | Full CA telehealth psychiatry compliance checklist — every legal obligation verified | Master checklist items documented in this research; covers licensing, DEA, CAQH, corporate, tax, OSHA, employment law |
| COMP-09 | Malpractice insurance verification — confirm coverage includes telehealth psychiatry and controlled substance prescribing | Known active; needs written confirmation of telehealth + controlled substance scope; carrier contact needed |
| COMP-10 | DEA registration audit — active, correct address, Schedule II-V coverage, Ryan Haight Act compliance | DEA flexibilities extended through Dec 31, 2026; current practice: no in-person visit required for controlled substance Rx via audio-video telehealth |
</phase_requirements>

---

## Summary

Phase 1 is a documentation and verification sprint, not a software build. The work is: (1) pull every compliance item into a structured audit, (2) verify current status against actual records, (3) produce the missing documents (HIPAA SRA, consent form, GFE template, etc.), and (4) load all results into a Supabase schema that TouchDesigner will later read. No coding beyond Supabase table creation is needed in this phase.

The regulatory landscape for California telehealth psychiatry has two layers. The federal layer governs HIPAA (Security Rule, Privacy Rule), DEA controlled substance prescribing (Ryan Haight Act flexibilities, extended through Dec 31, 2026), and the No Surprises Act (Good Faith Estimates). The California state layer adds B&P Code 2290.5 (telehealth informed consent), the CURES database mandate (check before every controlled substance Rx), the Medical Board of California's standard of care rules, and corporate filing obligations for Valentina Park MD, PC as a California professional corporation.

The biggest risk in this phase is not finding a gap — it's failing to close gaps before the first patient. Research confirms the three-severity model (CRITICAL/WARNING/INFO) is the right framing: CRITICAL items are anything that would make the first patient session legally or ethically impossible (no signed consent, no HIPAA SRA, DEA lapsed, BAA missing from Tebra). WARNING items are ongoing obligations that decay without attention (CAQH re-attestation every 120 days, CA medical license every 2 years, DEA every 3 years). INFO items are best practices that reduce risk but don't block launch.

**Primary recommendation:** Execute the compliance audit as a structured data entry process — for each of the 10 requirements, record status, document location, expiry date, and remediation task directly into Supabase tables. The human-facing output is the TD compliance panel, not PDFs.

---

## Standard Stack

### Core
| Tool/Library | Version/Date | Purpose | Why Standard |
|---------|---------|---------|--------------|
| HHS SRA Tool | v3.6 (released Sept 2025) | HIPAA Security Risk Analysis | OCR-developed, most defensible format for audits; produced jointly by OCR + ONC; 156 structured questions |
| Supabase (dedicated project) | Current | Compliance data store | Locked decision; enables TD queries; HIPAA-compliant via BAA + add-on |
| Tebra | Existing | EHR + digital patient intake for consent form | Already onboarded; BAA incorporated into customer agreement |
| California BreEZe portal | Online | Medical license verification and renewal | MBC's official system |
| DEA Diversion Control | Online | DEA registration verification | Official DEA portal |
| CAQH ProView | Online | Credentialing profile + re-attestation | Required by all 17 payers |

### Compliance Item Inventory (What Gets Audited)

This is the complete domain for this phase — every item maps to a Supabase row.

**CRITICAL severity (blocks first patient):**
- HIPAA Security Risk Analysis — completed document on file
- BAAs with all PHI-handling vendors (Tebra confirmed, email provider, Supabase)
- CA telehealth informed consent form — compliant with B&P 2290.5, loaded in Tebra
- DEA registration — active, correct address, Schedules II-V
- CA medical license — active, not expired
- Malpractice insurance — active, covers telehealth psychiatry + controlled substances

**WARNING severity (30-day window):**
- CAQH ProView re-attestation — must not be in "Expired" state at launch
- Good Faith Estimate template — required for self-pay patients from day 1
- Patient location verification protocol — documented SOP for each session
- CURES database registration and access confirmed active
- CA professional corporation Statement of Information — filed, not lapsed

**INFO severity (best practice, not blocking):**
- Corporate compliance: annual shareholder meeting documented
- Employment law readiness for future CTO hire (Maxi)
- Cal/OSHA IIPP (Injury and Illness Prevention Program) — written plan
- Federal and state tax obligations reviewed

---

## Architecture Patterns

### Supabase Table Schema Design

Claude's discretion — recommended schema for TD consumption:

**Table: `compliance_items`** — the master registry
```sql
CREATE TABLE compliance_items (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  req_id          TEXT NOT NULL,          -- 'COMP-01', 'COMP-02', etc.
  category        TEXT NOT NULL,          -- 'hipaa', 'licensing', 'credentialing', 'corporate', 'prescribing', 'forms'
  title           TEXT NOT NULL,          -- human-readable name
  severity        TEXT NOT NULL,          -- 'CRITICAL', 'WARNING', 'INFO'
  status          TEXT NOT NULL,          -- 'VERIFIED', 'GAP', 'PENDING', 'NOT_APPLICABLE'
  description     TEXT,
  legal_citation  TEXT,                   -- e.g. 'B&P Code 2290.5', 'HHS 45 CFR 164.308'
  verified_date   DATE,
  expiry_date     DATE,                   -- for items that expire (license, DEA, CAQH, insurance)
  document_ref    TEXT,                   -- path or name of the actual document produced
  notes           TEXT,
  updated_at      TIMESTAMPTZ DEFAULT now()
);
```

**Table: `action_items`** — human-required tasks surfaced in TD action queue
```sql
CREATE TABLE action_items (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  compliance_item_id UUID REFERENCES compliance_items(id),
  title             TEXT NOT NULL,
  description       TEXT,
  priority          TEXT NOT NULL,        -- 'URGENT', 'SOON', 'WHENEVER'
  status            TEXT NOT NULL DEFAULT 'OPEN',  -- 'OPEN', 'IN_PROGRESS', 'DONE'
  assigned_to       TEXT,                 -- 'valentina', 'maxi'
  due_date          DATE,
  completed_date    DATE,
  draft_content     TEXT,                 -- pre-drafted email/letter/script if applicable
  created_at        TIMESTAMPTZ DEFAULT now(),
  updated_at        TIMESTAMPTZ DEFAULT now()
);
```

**Table: `documents`** — compliance documents produced during audit
```sql
CREATE TABLE documents (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  compliance_item_id UUID REFERENCES compliance_items(id),
  document_type     TEXT NOT NULL,        -- 'hipaa_sra', 'baa_tracker', 'consent_form', 'gfe_template', 'checklist'
  title             TEXT NOT NULL,
  content           TEXT,                 -- full document text for documents Claude drafts
  status            TEXT NOT NULL,        -- 'DRAFT', 'READY', 'ACTIVE'
  created_at        TIMESTAMPTZ DEFAULT now(),
  updated_at        TIMESTAMPTZ DEFAULT now()
);
```

**Table: `baa_tracker`** — dedicated BAA status per vendor
```sql
CREATE TABLE baa_tracker (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vendor_name     TEXT NOT NULL,
  vendor_type     TEXT,                  -- 'ehr', 'database', 'email', 'video', 'billing'
  handles_phi     BOOLEAN DEFAULT true,
  baa_status      TEXT NOT NULL,         -- 'SIGNED', 'INCORPORATED_IN_TOS', 'NOT_SIGNED', 'NOT_REQUIRED'
  baa_date        DATE,
  baa_location    TEXT,                  -- where to find the actual agreement
  notes           TEXT,
  updated_at      TIMESTAMPTZ DEFAULT now()
);
```

### Compliance Audit Workflow Pattern

Each compliance item follows this pattern during the audit:

```
1. VERIFY: Check actual current status (login, document, portal)
2. RECORD: Write status row to compliance_items table
3. PRODUCE (if gap): Draft the missing document or action item
4. REMEDIATE: For human-required tasks, create action_items row with draft content
5. CONFIRM: Mark verified_date once complete
```

### Severity Color Mapping for TD Display

```
CRITICAL = RED   (#FF3333 or equivalent ASCII emphasis)
WARNING  = AMBER (#FFAA00 or equivalent ASCII emphasis)
INFO     = CYAN  (#00CCFF or equivalent ASCII emphasis)
VERIFIED = GREEN (#33FF33 or equivalent ASCII emphasis)
```

### Anti-Patterns to Avoid
- **Status-only auditing:** Recording "active" or "inactive" without producing the actual document. Every CRITICAL item needs the artifact, not just the status.
- **Blanks in documents:** All produced documents (SRA, consent form, GFE template) must be pre-filled with Valentina's real data — NPI 1023579513, "Valentina Park MD, PC", LA County CA, actual payer list. No template placeholders.
- **Treating the Tebra BAA as confirmed without checking:** Tebra incorporates the BAA into its Terms of Service, but the actual agreement must be located and dated in the BAA tracker.
- **Ignoring CAQH expiry window:** If CAQH is currently in "Expired" state, all 17 payer contracts are at risk. This is CRITICAL, not WARNING.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| HIPAA risk assessment | Custom questionnaire | HHS SRA Tool v3.6 | OCR-developed, 156 questions covering all Security Rule domains, produces defensible audit-ready report |
| Telehealth consent form language | Write from scratch | Use B&P 2290.5 statutory language + DHCS model language | Legal standard requires specific disclosures; custom language risks omissions |
| Good Faith Estimate | Custom template | Follow APA/CMS model template with CPT codes | Federal NSA has specific required fields (CPT, NPI, tax ID, projected sessions, $400 dispute threshold notice) |
| BAA drafting | Write custom BAA | Use vendor-provided BAAs (Tebra, Supabase) | Vendors carry their own compliance certifications; custom BAAs introduce liability gaps |
| Compliance checklist | Invent categories | Follow established frameworks: Medical Board of CA + HIPAA Security Rule + DEA regulations | Regulatory bodies define what "complete" means |

**Key insight:** This phase is about verification and documentation, not invention. Every compliance standard has an official source. The value is in applying those standards to Valentina's specific situation with her real data, not in creating new compliance frameworks.

---

## Common Pitfalls

### Pitfall 1: CAQH Profile in "Expired" State
**What goes wrong:** CAQH requires re-attestation every 120 days. If the profile shows "Expired," payers cannot verify credentials, which can silently disable in-network status across all 17 contracts simultaneously.
**Why it happens:** Easy to miss the 120-day window during practice setup.
**How to avoid:** Check CAQH ProView status first in the audit. If expired, re-attest immediately (takes 5-20 minutes).
**Warning signs:** Last attestation date > 120 days ago; any payer claims rejected with credentialing errors.

### Pitfall 2: Treating Tebra BAA as "Probably Signed" Without Evidence
**What goes wrong:** Tebra incorporates its BAA into the Terms of Service — it exists, but a paper trail showing the date and Valentina's acceptance is needed for an OCR audit.
**Why it happens:** BAA is not separately signed; it's part of account setup terms.
**How to avoid:** Log into Tebra, locate the Terms of Service acceptance record, screenshot or export the agreement, note the effective date. Store in BAA tracker table.
**Warning signs:** No record of when terms were accepted; cannot produce the BAA on demand.

### Pitfall 3: DEA Flexibility Assumption
**What goes wrong:** The DEA's COVID telehealth flexibility (prescribe Schedule II-V without in-person visit) expires December 31, 2026. Permanent rules are not yet finalized.
**Why it happens:** Providers assume the flexibility is permanent.
**How to avoid:** Document the current status explicitly: "Operating under Fourth Temporary Extension, expires Dec 31, 2026." Mark this as a WARNING item with a 2026-Q3 review date. Compliance calendar must track this.
**Warning signs:** Treating the extension as permanent without tracking the expiry.

### Pitfall 4: Supabase HIPAA Add-On Not Enabled
**What goes wrong:** Supabase HIPAA compliance requires the HIPAA add-on to be enabled on a Team or Enterprise plan. Storing PHI in Supabase without a signed BAA + add-on is a HIPAA violation.
**Why it happens:** Supabase works fine technically without the add-on; the gap is invisible.
**How to avoid:** Before loading any PHI into the Brighter Days Supabase project: (1) upgrade to Team plan, (2) submit HIPAA add-on request, (3) sign BAA. HIPAA add-on costs approximately $350/month additional. The compliance data itself (item names, statuses) may not be PHI, but the `documents` table content (consent forms with patient data) eventually will be.
**Warning signs:** Supabase project on Free or Pro plan; no BAA signed with Supabase.

**IMPORTANT CAVEAT:** For Phase 1, the Supabase project stores compliance audit structure and documents, not patient PHI yet. The BAA + HIPAA add-on becomes CRITICAL before patient data enters the system (Phase 3 onwards). However, the BAA should be established now to avoid retrofitting later.

### Pitfall 5: Incomplete Informed Consent Elements
**What goes wrong:** Creating a consent form that mentions "telehealth" but omits required B&P 2290.5 elements.
**Why it happens:** Generic consent forms don't address telehealth-specific requirements.
**Required elements (B&P 2290.5):**
  - Right to in-person care alternative
  - Limitations and risks of telehealth vs. in-person
  - Confidentiality risks specific to telehealth (data security)
  - Right to withdraw consent at any time
  - Provider identity and qualifications
  - Risk of connection disruption and what happens
  - Insurance coverage considerations for telehealth
  - Patient location confirmation (CA only)
  - Standard of care is identical to in-person

### Pitfall 6: California S-Corp Annual Filing Lapse
**What goes wrong:** Valentina Park MD, PC must file a Statement of Information (Form SI-200 for for-profit corporations) annually with the California Secretary of State. Missing this triggers $250 late fees and potential suspension.
**Why it happens:** Annual deadline tied to the corporation's anniversary month — easy to miss without a calendar.
**How to avoid:** Verify current filing status on the CA Secretary of State BizFile portal; add expiry to compliance_items with WARNING severity.

### Pitfall 7: CURES Registration Without Active Access Verification
**What goes wrong:** CURES registration exists but provider cannot actually log in and run a check — system access issues, password reset, or MFA problems that would block prescribing at the wrong moment.
**Why it happens:** System access is assumed, not verified.
**How to avoid:** Verify CURES access by actually running a test lookup during the audit.

---

## Code Examples

### Supabase: Inserting a Compliance Item
```sql
-- Source: Supabase PostgREST API (REST insert)
INSERT INTO compliance_items (
  req_id, category, title, severity, status,
  legal_citation, verified_date, expiry_date, document_ref, notes
) VALUES (
  'COMP-10',
  'prescribing',
  'DEA Registration - Active, Schedule II-V, Ryan Haight Compliance',
  'CRITICAL',
  'VERIFIED',
  '21 U.S.C. 831; DEA Fourth Temporary Extension (expires 2026-12-31)',
  '2026-02-27',
  '2026-12-31',  -- DEA flexibility expiry (not DEA registration expiry)
  'DEA_registration_certificate.pdf',
  'Fourth Temporary Extension of COVID-19 Telemedicine Flexibilities active through Dec 31, 2026. Permanent rules pending.'
);
```

### Supabase: Querying Compliance Dashboard Data for TD
```sql
-- Source: PostgREST query pattern for TouchDesigner HTTP DAT
SELECT
  req_id,
  title,
  severity,
  status,
  expiry_date,
  CASE
    WHEN status = 'VERIFIED' THEN 'GREEN'
    WHEN status = 'GAP' AND severity = 'CRITICAL' THEN 'RED'
    WHEN status = 'GAP' AND severity = 'WARNING' THEN 'AMBER'
    WHEN status = 'PENDING' THEN 'YELLOW'
    ELSE 'CYAN'
  END AS display_color
FROM compliance_items
ORDER BY
  CASE severity
    WHEN 'CRITICAL' THEN 1
    WHEN 'WARNING' THEN 2
    WHEN 'INFO' THEN 3
  END,
  status;
```

### HHS SRA Tool: Output Structure to Mirror in Supabase
The SRA Tool produces an assessment report organized into these Security Rule domains — each domain should map to a section in the compliance_items table:
```
1. Administrative Safeguards
   - Security Management Process
   - Assigned Security Responsibility
   - Workforce Security
   - Information Access Management
   - Security Awareness and Training
   - Security Incident Procedures
   - Contingency Plan
   - Evaluation
2. Physical Safeguards
   - Facility Access Controls
   - Workstation Use
   - Workstation Security
   - Device and Media Controls
3. Technical Safeguards
   - Access Control
   - Audit Controls
   - Integrity
   - Person or Entity Authentication
   - Transmission Security
4. Organizational Requirements (BAAs)
5. Policies and Procedures
```
For a solo telehealth practice, many "Facility Access Controls" and "Workstation Security" items will apply to Valentina's home office setup.

### B&P 2290.5 Informed Consent Template Elements
```
Required consent document sections for Tebra digital intake:

1. WHAT IS TELEHEALTH
   - Definition: delivery of health care via electronic communications
   - Technology being used (video platform)

2. YOUR RIGHT TO IN-PERSON CARE
   - You may request an in-person visit at any time
   - Telehealth is voluntary and you may withdraw consent

3. TELEHEALTH RISKS AND LIMITATIONS
   - Technology failures (connection loss) and backup plan
   - Privacy risks inherent to electronic transmission
   - Limitations compared to in-person examination

4. YOUR LOCATION MATTERS
   - Services are only available when you are physically in California
   - You will be asked to confirm your location at each session

5. PRIVACY AND CONFIDENTIALITY
   - Same confidentiality protections as in-person care
   - Recommendations for a private setting during sessions

6. INSURANCE AND BILLING
   - Your insurance coverage for telehealth services

7. PROVIDER INFORMATION
   - Valentina Park, MD — Psychiatrist
   - NPI: 1023579513
   - CA Medical License: [number]
   - Contact: [phone/email]

8. CONSENT ACKNOWLEDGMENT
   - Patient signature field
   - Date
   - Option to withdraw at any time
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| In-person visit required before any controlled substance Rx | Schedule II-V via audio-video telehealth without prior in-person visit | COVID PHE → extensions through Dec 31, 2026 | Valentina can prescribe stimulants, benzodiazepines, etc. via telehealth with no in-person requirement — until Dec 31, 2026 |
| Paper-only HIPAA SRA | HHS SRA Tool v3.6 (digital, exportable report) | Sept 2025 update | Structured 156-question format with NIST scoring alignment; more defensible than narrative-only assessments |
| Geographic/originating site restrictions for Medicare behavioral health telehealth | No geographic restriction; patient's home is valid originating site | Consolidated Appropriations Act 2021 (permanent) | Medicare patients in LA County can receive telehealth psychiatry at home |
| Audio-only telehealth unclear status | Schedule III-V narcotic medications for OUD approved via audio-only | DEA Fourth Extension, 2026 | Audio-only still limited; audio-video required for Schedule II |
| DEA online renewal optional | All DEA registrations and renewals must be completed online | DEA final rule (2024) | No paper renewals |

**Expiring flexibilities to track on compliance calendar:**
- DEA Fourth Temporary Extension: expires **December 31, 2026** — permanent rules not yet finalized
- Medicare telehealth waivers (non-behavioral-health): January 30, 2026 — behavioral health exempt (permanent)

---

## Regulatory Reference Map

Complete legal citation inventory for this phase:

| Requirement | Legal Authority | Enforcement Body |
|-------------|----------------|-----------------|
| HIPAA Security Risk Analysis | 45 CFR 164.308(a)(1) | HHS Office for Civil Rights (OCR) |
| Business Associate Agreements | 45 CFR 164.308(b), 164.502(e) | HHS OCR |
| Telehealth Informed Consent | CA B&P Code 2290.5 | Medical Board of California |
| Patient Location (CA-only) | CA B&P Code 2290.5(a)(1) | Medical Board of California |
| DEA Registration | 21 U.S.C. 823; 21 CFR 1301.11 | DEA Diversion Control Division |
| Ryan Haight Act Flexibility | Fourth Temporary Extension (Fed. Register 2025-12-31) | DEA |
| CURES Mandatory Consultation | CA Health & Safety Code 11165.4 | CA Dept of Justice |
| Good Faith Estimate | No Surprises Act (42 U.S.C. 300gg-136) | CMS |
| CA Medical License | CA B&P Code 2050 et seq. | Medical Board of California |
| Professional Corporation Filing | CA Corp. Code 13406 | CA Secretary of State |
| CAQH Re-attestation | CAQH ProView participation agreements with payers | 17 individual payer contracts |
| IIPP (Cal/OSHA) | T8CCR 3203 | Cal/OSHA |
| Malpractice (not mandated, but standard) | — | Voluntary; insurance carrier |

---

## BAA Vendor Audit List

Complete list of vendors that likely handle or will handle PHI — every row needs a BAA status:

| Vendor | PHI Exposure | Expected BAA Status |
|--------|-------------|---------------------|
| Tebra | HIGH — EHR, all patient records | Incorporated in Terms of Service (confirm date) |
| Supabase (Brighter Days project) | MEDIUM — compliance data; future patient docs | Requires Team plan + HIPAA add-on + signed BAA |
| Email provider (Gmail/Google Workspace or other) | MEDIUM — patient communications | Google Workspace for Business: BAA available; Gmail consumer: NO BAA possible |
| Video platform for telehealth | HIGH — live sessions | Identify platform; confirm HIPAA BAA |
| Any AI tool used in clinical context | POTENTIAL | Identify and audit |
| 1Password | LOW — stores credentials, not patient records | Likely not a BA; credentials ≠ PHI |

**Email provider is a likely gap:** If Valentina uses a personal Gmail account for patient communication, that is a HIPAA violation. Must identify actual email setup.

---

## Open Questions

1. **Current email provider for patient communication**
   - What we know: Not specified in project docs
   - What's unclear: Is it Gmail consumer, Google Workspace, or something else?
   - Recommendation: Verify in Phase 1 audit. If Gmail consumer, flag as CRITICAL gap — must switch to a HIPAA-compliant provider with BAA (Google Workspace Business, Paubox, etc.)

2. **Video platform for telehealth sessions**
   - What we know: Not specified — Tebra may have a built-in telehealth module
   - What's unclear: Is Tebra's telehealth video feature being used? Or a separate platform (Zoom, Doxy.me)?
   - Recommendation: Confirm in Phase 1. Tebra's telehealth module is likely covered by the existing Tebra BAA. Separate platforms need their own BAAs.

3. **Supabase HIPAA add-on timing for this phase**
   - What we know: HIPAA add-on requires Team plan (~$599/mo + ~$350/mo HIPAA add-on); only needed when PHI is stored
   - What's unclear: Is Phase 1 compliance data (item names, statuses, drafted consent forms) considered PHI?
   - Recommendation: Phase 1 data is NOT PHI (it's practice management data, not patient records). Use Pro plan for now. Flag HIPAA add-on as WARNING item to address before first patient session when PHI might enter the system.

4. **CA medical license expiry date**
   - What we know: License is active (confirmed); exact expiry not in project docs
   - What's unclear: When does it expire? (2-year cycle)
   - Recommendation: Look up via BreEZe portal during audit. Record expiry in compliance_items.

5. **DEA permanent rule status (post-Dec 31, 2026)**
   - What we know: Fourth Extension expires Dec 31, 2026; permanent rules are proposed but not finalized
   - What's unclear: What the permanent rules will require (special registration? in-person visit requirement?)
   - Recommendation: Document current status accurately. Flag Dec 31, 2026 as a WARNING deadline. Permanent rule monitoring is an AI-02 (Phase 5) automation concern.

6. **CAQH ProView current attestation status**
   - What we know: Active login exists; attestation status needs verification
   - What's unclear: Last attestation date; is it current or expired?
   - Recommendation: First action item in the audit. If expired, re-attest immediately before any other work.

---

## Sources

### Primary (HIGH confidence)
- HHS Office for Civil Rights — HIPAA Security Risk Analysis guidance: https://www.hhs.gov/hipaa/for-professionals/security/guidance/guidance-risk-analysis/index.html
- HealthIT.gov — Security Risk Assessment Tool: https://www.healthit.gov/topic/privacy-security-and-hipaa/security-risk-assessment-tool
- Medical Board of California — Telehealth guidance: https://www.mbc.ca.gov/Resources/Medical-Resources/telehealth.aspx
- HHS.gov — DEA Telemedicine Extension 2026: https://www.hhs.gov/press-room/dea-telemedicine-extension-2026.html
- Federal Register — Fourth Temporary Extension: https://www.federalregister.gov/documents/2025/12/31/2025-24123/fourth-temporary-extension-of-covid-19-telemedicine-flexibilities-for-prescription-of-controlled
- HHS — Business Associate Contracts: https://www.hhs.gov/hipaa/for-professionals/covered-entities/sample-business-associate-agreement-provisions/index.html
- Supabase — HIPAA Compliance documentation: https://supabase.com/docs/guides/security/hipaa-compliance
- Tebra — Business Associate Agreement: https://www.tebra.com/business-associate-agreement

### Secondary (MEDIUM confidence)
- CCHP — California Consent Requirements: https://www.cchpca.org/?policy=consent-requirements-24
- APA — No Surprises Act Implementation: https://www.psychiatry.org/psychiatrists/practice/practice-management/no-surprises-act-implementation
- California Telehealth Resource Center — DEA Rule Extension: https://caltrc.org/blog/dea-telehealth-rule-extension-understanding-the-2026-landscape/
- Medical Board of California — CURES Mandatory Use: https://www.mbc.ca.gov/Resources/Medical-Resources/CURES/Mandatory-Use.aspx
- HIPAA Journal — SRA Tool v3.6: https://www.hipaajournal.com/hhs-updated-security-risk-assessment-tool-3-6/
- CAQH — Provider User Guide: https://www.caqh.org/hubfs/43908627/drupal/solutions/proview/guide/provider-user-guide.pdf
- CA Secretary of State — Statement of Information: https://www.sos.ca.gov/business-programs/business-entities/statements

### Tertiary (LOW confidence — verify directly)
- Supabase HIPAA add-on pricing (~$350/month): Multiple sources with conflicting info; contact Supabase sales to confirm current pricing
- Cal/OSHA IIPP exemption for true self-employed (no employees): Search results indicate all employers covered; verify if Maxi as CTO-employee changes obligations

---

## Metadata

**Confidence breakdown:**
- HIPAA requirements (SRA, BAA): HIGH — official HHS sources
- CA telehealth law (B&P 2290.5): HIGH — Medical Board of California + statute
- DEA Ryan Haight Act status: HIGH — Federal Register + HHS press release confirming 2026 extension
- CAQH re-attestation requirements: HIGH — CAQH official guide
- No Surprises Act / GFE: HIGH — CMS + APA sources
- Supabase HIPAA add-on details: MEDIUM — official docs confirm BAA requirement; pricing/plan specifics need direct verification
- CA corporate filing obligations: MEDIUM — Secretary of State + multiple secondary sources
- IIPP applicability to solo practice: LOW — conflicting signals on whether true solo (no employees) is exempt

**Research date:** 2026-02-27
**Valid until:** 2026-08-27 (stable regulatory domain; DEA extension status should be re-verified Q4 2026)
