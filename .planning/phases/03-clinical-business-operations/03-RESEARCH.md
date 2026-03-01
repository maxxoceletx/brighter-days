# Phase 3: Clinical & Business Operations - Research

**Researched:** 2026-03-01
**Domain:** Clinical SOP Authoring — CA Telehealth Youth Psychiatry, CURES PDMP, Crisis Protocol, Business Entity Documentation, Third-Party Biller Oversight
**Confidence:** HIGH (regulatory requirements well-sourced from official CA and federal authorities; clinical best-practice recommendations sourced from AACAP and SAMHSA; Tebra specifics sourced from official Tebra help documentation)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- Patient intake channel: Tebra patient portal (patients find via insurance directories or Psychology Today)
- No free pre-screening call — anyone who books gets seen; clinical assessment happens during first session
- Admin/clinical duty split between Maxi and Valentina: SOP should propose a clean split as a recommendation, not document an existing arrangement
- Prescribing posture: conservative start (SSRIs, SNRIs, non-stimulant ADHD meds); controlled substances deferred until practice established. CURES SOP must cover full Schedule II-V requirements regardless.
- Solo practitioner with no formal clinical backup: SOP must include a peer consultation / backup protocol recommendation
- Crisis protocol accounts for telehealth-specific constraints: cannot physically intervene, may not know patient's exact location, need parent/guardian contact info pre-populated
- CANRA: Valentina is familiar — include quick-reference only (phone numbers, timelines, SS 8572 form), not a full training document
- Safety plan: include BOTH a provider-side crisis protocol AND a patient-facing safety plan template
- Post-crisis protocol: full documentation — charting requirements, parent/guardian notification policy, mandatory follow-up timeline (24-48 hrs), provider self-care
- Biller: Nexus Billing (already selected); BAA already signed; reference in SOP, do not create new BAA checklist
- Biller payment model: percentage of collections
- Tebra biller access: recommend the most HIPAA-restrictive role that still lets biller function
- Biller reporting: per-claim visibility — Valentina wants to see every claim status, not just monthly summaries
- SOP audience: written for future staff who cannot assume shared context; must be self-explanatory
- SOP format: step-by-step checklists with numbered steps and checkboxes
- SOP destination: structured for Phase 4 dashboard integration (machine-readable structure) while remaining standalone documents now
- Polish level: production-ready — usable on day one without further editing
- Tone: professional, clear, no jargon without definition

### Claude's Discretion

- Exact checklist formatting and section structure within each SOP
- How to structure the business entity document (OPS-04) — straightforward factual documentation
- CURES SOP (OPS-02) step-by-step formatting — clinical workflow is well-defined by CA law
- How to organize crisis resources by region for statewide telehealth coverage
- Which youth-specific screening instruments to recommend for intake forms

### Deferred Ideas (OUT OF SCOPE)

- None — discussion stayed within phase scope

</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| OPS-01 | Patient intake workflow documented (screening → eligibility check → scheduling → consent → intake forms → first session) | Tebra eligibility check is manual (1-3 days before appointment); intake form sections configurable; standard youth psychiatry screeners identified (PHQ-A, PSC-17, CRAFFT); parental consent requirements documented |
| OPS-02 | CURES database check SOP for controlled substance prescribing (required before every Rx in CA) | Mandatory use law (CA H&S Code 11165.4) fully documented; specific timing rules (within 24 hours / previous business day); exemptions catalogued; step-by-step workflow defined from official Medical Board of CA sources |
| OPS-03 | Crisis protocol for telehealth sessions (what happens when patient is in crisis, emergency contacts, 988 referral, documentation) | Telehealth crisis pre-session setup requirements sourced from PMC/AACAP; C-SSRS identified as gold-standard youth suicide risk instrument; 988 CA resources documented; CANRA quick-reference requirements documented; post-crisis documentation requirements established |
| OPS-04 | Business structure documentation (current Valentina Park MD, PC S-Corp structure, roles, Maxi as CTO, future Brighter Days entity plan) | CA Professional Medical Corporation S-Corp structure requirements sourced from Secretary of State + legal sources; sole-shareholder officer requirements documented; future entity planning deferred per project decision |
| OPS-05 | Third-party biller onboarding and oversight process (what data they need, how they access Tebra, reporting expectations) | Tebra "Biller" role permissions fully documented; billing manager vs. biller role distinction identified; HIPAA minimum necessary standard research complete; data handoff list compiled |

</phase_requirements>

---

## Summary

Phase 3 is a pure documentation sprint producing five standalone SOP documents. Unlike Phases 1 and 2, which produced Supabase schemas, seed files, and living data, this phase produces human-readable checklists that serve as day-one operational reference materials. All five SOPs must be self-explanatory for future staff who were not part of building the practice, and structurally consistent so Phase 4's TouchDesigner dashboard can parse them.

The regulatory backbone for this phase is already established in Phase 1. The compliance checklist, telehealth consent form, minor consent form, and patient location protocol are all upstream deliverables that the Phase 3 SOPs must reference, not recreate. The Phase 3 risk is not regulatory gaps — it is operational clarity gaps: ambiguous steps, missing decision trees, and no protocol for edge cases (disconnection during crisis, parent refuses emergency services, biller gets a denial flood).

The most complex deliverable is OPS-03 (Crisis Protocol). Telehealth crisis management with youth requires pre-session information gathering, a multi-tier escalation sequence, parent notification procedures, mandatory reporter obligations (CANRA), and post-crisis documentation — all without the ability to physically intervene. The C-SSRS (Columbia Suicide Severity Rating Scale) is the validated gold-standard instrument for this population, with a specific child/adolescent version available free from Columbia University. The 988 Lifeline and California's AB 988-funded Mobile Response and Stabilization Services (MRSS) for youth ages 4-18 are the primary crisis resources.

**Primary recommendation:** Write all five SOPs as numbered checklists with consistent heading structure (Title > Purpose > Scope > Roles > Procedure Steps > Decision Points > Documentation Requirements). Use the same format convention across all five so Phase 4 parsing is straightforward.

---

## Standard Stack

### Documents to Produce (Five SOPs)

| SOP | Requirement | Primary Audience | Core Regulatory Authority |
|-----|------------|------------------|--------------------------|
| Patient Intake Workflow | OPS-01 | Admin (Maxi), future admin staff | Tebra portal; CA B&P 2290.5 (telehealth consent); HIPAA |
| CURES Database Check | OPS-02 | Valentina (prescriber) | CA H&S Code 11165.4; Medical Board of CA mandatory use policy |
| Crisis Protocol | OPS-03 | Valentina (clinician), Maxi (admin support) | AACAP telepsychiatry guidelines; CANRA; 988 Lifeline CA |
| Business Structure | OPS-04 | Maxi (CTO), Valentina, future attorney/CPA | CA Corp. Code; CA Secretary of State; IRS S-Corp election |
| Biller Onboarding | OPS-05 | Nexus Billing, Valentina (oversight) | HIPAA minimum necessary; Tebra Biller role permissions |

### Upstream Deliverables to Reference (Do Not Recreate)

| Deliverable | Phase | Reference In |
|------------|-------|-------------|
| Telehealth Informed Consent Form | Phase 1 | OPS-01 intake flow |
| Minor Consent Form (Part A + Part B) | Phase 1 | OPS-01 intake flow |
| Patient Location Protocol | Phase 1 | OPS-01 intake flow, OPS-03 crisis protocol |
| Good Faith Estimate Template | Phase 1 | OPS-01 intake flow |
| HIPAA BAA with Nexus Billing (already signed) | Phase 1/2 | OPS-05 (reference only) |
| 1Password Vault Spec | Phase 2 | OPS-05 (Tebra credentials location) |
| Payer Tracker (17 payers) | Phase 2 | OPS-01 (eligibility verification) |
| Credential Inventory | Phase 2 | OPS-04 (officer credentials list) |

### Screening Instruments for OPS-01 Intake Forms

| Instrument | Age Range | Screens For | Admin Method | Cost |
|-----------|-----------|-------------|--------------|------|
| PHQ-A (PHQ-9 Modified for Adolescents) | 11-17 | Depression severity | Self-report, 9 items | Free (NIMH) |
| PSC-17 (Pediatric Symptom Checklist) | 3-17 | Broad psychosocial problems | Parent report (< 12), self-report (≥ 11) | Free (MGH) |
| CRAFFT v2.1 | 12-21 | Substance use disorder | Self-report, 9 items Part A + 6 items Part B | Free (CEASAR) |
| C-SSRS Screener (Youth version) | 5+ | Suicide risk | Clinician-administered, 6 items | Free (Columbia University) |

**Note:** Tebra supports custom intake form sections. The default form covers demographics, emergency contact, financial information. Psychiatric-specific screening instruments (PHQ-A, PSC-17, CRAFFT) should be added as supplemental forms in Tebra or administered at the start of the first session as part of the clinical evaluation. Tebra does not natively have psychiatric screening tools pre-built — Valentina will administer C-SSRS clinician-side during the first appointment.

### Crisis Resources (OPS-03)

| Resource | Contact | Scope | Notes |
|---------|---------|-------|-------|
| 988 Suicide & Crisis Lifeline | Call or text 988 | Nationwide; CA-specific routing | Available 24/7; CA-funded via AB 988 |
| Mobile Response and Stabilization Services (MRSS) | Via 988 dispatch or county DCFS | Ages 4-18, mobile crisis team | Dispatched by 988 for youth in crisis; not all counties equally funded yet |
| 911 | 911 | Emergency services (police, fire, EMS) | Use when patient location is known and immediate danger; requires knowing patient's address |
| LA County Crisis Line | (800) 854-7771 | LA County residents | 24/7 county line |
| 988california.org | Online chat | CA statewide | Web-based option for patients who cannot call |

**Statewide telehealth note:** Because Valentina serves patients statewide (any CA county), the crisis SOP cannot be county-specific. The protocol must instruct the patient to call 911 using their physical location or use 988, which automatically routes to their local crisis center. Gathering the patient's county of residence and local emergency number during intake reduces response time in a crisis.

---

## Architecture Patterns

### SOP Document Structure (All Five SOPs Use This)

Every SOP follows this consistent heading structure to enable Phase 4 parsing:

```
# SOP-[NUMBER]: [Title]
**Version:** 1.0
**Effective Date:** [date]
**Owner:** [role — Valentina / Maxi / Both]
**Review Cycle:** Annual

## Purpose
[1-2 sentence statement]

## Scope
[Who this applies to and when]

## Roles and Responsibilities
| Role | Responsibilities in This SOP |
...

## Procedure
### Step 1: [Step name]
- [ ] Action item
- [ ] Action item
### Step 2: [Step name]
...

## Decision Points
[If/then decision trees for edge cases]

## Documentation Requirements
[What must be recorded, where, within what timeframe]

## References
[Links to upstream documents this SOP depends on]
```

**Why this structure:** Numbered steps with checkboxes are unambiguous for future staff. Section headers are consistent so Phase 4 parsing knows where to find the procedure steps, decision points, and documentation requirements for dashboard display.

### OPS-01: Patient Intake Workflow — Key Design Decisions

**Eligibility verification in Tebra is manual, not automatic.** Tebra sends an ANSI-X12 270 inquiry to 2,700+ payers and returns a 271 response showing active coverage, copay, deductible, and coinsurance. This is a manual step initiated from the Dashboard or Calendar — it does not run automatically when a patient books. Best practice per Tebra: check eligibility 1-3 days before the appointment.

**Three-point eligibility verification approach:**
1. During pre-intake (1-3 days before visit): run Tebra eligibility check
2. At check-in: confirm insurance at session start
3. Directly with insurer if Tebra returns "Not Determined" status

**Tebra eligibility check statuses:**
- Verified (green) — patient is covered
- Not Determined (yellow) — payer did not respond or does not support electronic eligibility
- Not Eligible (red) — patient is not covered under that insurance

**Intake sequence for youth psychiatry:**

```
BOOKING (via Tebra patient portal or Psychology Today referral)
  └── Patient self-schedules via Tebra portal
  └── Admin (Maxi) reviews new booking within 24h

PRE-INTAKE (1-3 days before first appointment)
  └── [ ] Run Tebra eligibility check
  └── [ ] If "Not Determined" — call payer to verify manually
  └── [ ] Send Tebra intake packet to patient (portal link)
       └── Demographics form
       └── Emergency contact form
       └── Insurance/financial information
       └── Telehealth Informed Consent Form (Phase 1)
       └── Minor Consent Form — Part A (parent) + Part B (minor assent) (Phase 1)
       └── Financial policy / Good Faith Estimate (Phase 1 GFE template)
       └── Release of Information form (if applicable)
  └── [ ] Confirm patient has completed intake forms (Tebra notification)

FIRST SESSION (clinical, performed by Valentina)
  └── [ ] Confirm patient location (CA only — patient location protocol)
  └── [ ] Administer PSC-17 and/or PHQ-A (if not completed pre-session)
  └── [ ] Administer CRAFFT (if applicable — ages 12+)
  └── [ ] Full psychiatric evaluation
  └── [ ] C-SSRS clinician-administered (suicide risk baseline)
  └── [ ] Document in Tebra: assessment, diagnosis codes, treatment plan
  └── [ ] If controlled substance anticipated: initiate CURES check (SOP-02)
```

**Admin/Clinical duty split (recommended):**

| Task | Admin (Maxi) | Clinical (Valentina) |
|------|-------------|---------------------|
| Book appointment in Tebra | X | |
| Run eligibility check (Tebra) | X | |
| Send intake forms to patient | X | |
| Review completed intake forms | X | Flag clinical alerts to Valentina |
| Verify forms returned before session | X | |
| Conduct session | | X |
| Document clinical note | | X |
| Order labs / CURES check | | X |
| Submit diagnosis + CPT codes | X (enters) | X (approves) |

### OPS-02: CURES Database Check — Regulatory Backbone

**Legal authority:** CA Health & Safety Code § 11165.4 — mandatory use law.

**When Valentina must check CURES:**

| Situation | Requirement |
|-----------|------------|
| First time prescribing any Schedule II-IV controlled substance to a patient | Check CURES no earlier than 24 hours (or previous business day) before prescribing |
| Continuing treatment with controlled substance | Check at least every 6 months |
| Each subsequent prescription (not just first) | Check within 24 hours / previous business day before each Rx |

**Schedule coverage:** II, III, IV, V — all scheduled substances. Valentina's conservative posture (SSRIs, SNRIs first) means CURES checks are deferred until controlled substances are considered, but the SOP must be ready from day one.

**CURES check step-by-step:**

```
1. Log in to CURES 2.0 at https://cures.doj.ca.gov/
   - Use DEA-registered practitioner credentials
   - MFA may be required

2. Search patient record
   - Enter patient: first name, last name, date of birth
   - Enter date range for Patient Activity Report (PAR)

3. Review Patient Activity Report (PAR)
   - Look for: other prescribers, pharmacy patterns, controlled substance history
   - Flag: multiple prescribers for same substance class, high-dose opioids, benzodiazepine + opioid combinations

4. Document CURES check in Tebra clinical note
   - Record: date of CURES query, patient PAR findings (summary)
   - "CURES checked [date]. No concerning patterns identified." or specific findings.

5. If red flags found:
   - Do not prescribe without clinical justification documented
   - Consider: contact prior prescriber, request pharmacy records, discuss with patient
```

**Exemptions (document these in SOP for edge case clarity):**
- Patient admitted to inpatient hospital or clinic
- Emergency department: non-refillable 7-day supply
- Post-surgical acute pain: non-refillable 5-day supply
- Patient in hospice care
- Technical difficulties accessing CURES: 5-day supply allowed; document the outage

**Non-compliance consequence:** Referral to Medical Board of California for administrative sanctions.

### OPS-03: Crisis Protocol — Telehealth-Specific Design

**Pre-session safety setup (must happen at booking or intake, not during crisis):**

```
Collect at intake (Tebra emergency contact form):
  - Patient's full physical address (not just city — needed for 911 dispatch)
  - Patient's county of residence (for county-specific crisis routing)
  - Primary parent/guardian: name, phone, relationship, authorized to receive crisis notification
  - Secondary emergency contact: name, phone
  - Patient's local emergency number if different from 911 (rare but document)
  - Local hospital / nearest ED to patient's home address
```

**Parent presence by age (research-based recommendation, Claude's discretion):**

| Age Group | Recommended Practice | Rationale |
|-----------|---------------------|-----------|
| Under 8 | Parent present in session or nearby; provider confirms parent location at session start | Young children cannot reliably manage crisis communications independently |
| 8-12 | Parent nearby (in home); confirm parent can enter if needed | Developmental capacity varies; parent availability reduces delay in emergency |
| 13-17 | Start session alone with patient; parent available to join; confirm parent contact at session start | Adolescent confidentiality and therapeutic alliance; parent backup required for crisis |
| Sources | AACAP telepsychiatry policy statement 2017, PMC telehealth crisis literature | MEDIUM confidence — no single authoritative standard by exact age; AACAP endorses age-appropriate involvement |

**Crisis tier system:**

```
TIER 1: Passive Suicidal Ideation — No Plan, No Intent
  └── Actions:
      - [ ] Administer C-SSRS to document current severity
      - [ ] Safety planning conversation (collaboratively build safety plan)
      - [ ] Contact parent/guardian to inform (for minors — always)
      - [ ] Schedule follow-up within 48 hours
      - [ ] Document in Tebra: C-SSRS score, safety plan, parent notification

TIER 2: Active Suicidal Ideation — Plan OR Intent (not both)
  └── Actions:
      - [ ] Administer C-SSRS
      - [ ] Contact parent/guardian immediately (during session if possible)
      - [ ] Recommend 988 call or county crisis line with parent/patient
      - [ ] Recommend voluntary crisis evaluation at nearest ED
      - [ ] Document: C-SSRS, clinical reasoning, referrals made
      - [ ] Follow-up within 24 hours (call next day)

TIER 3: Imminent Risk — Plan AND Intent AND Means OR In-Progress
  └── Actions:
      - [ ] Do NOT end the video call if patient is actively in danger
      - [ ] Instruct patient to call 911 (provide address if known)
      - [ ] Call 911 yourself using patient's address — identify as patient's treating psychiatrist
      - [ ] Contact parent/guardian immediately
      - [ ] Stay on video/audio with patient until emergency services arrive if possible
      - [ ] Document everything in real time or immediately after
      - [ ] Peer consultation call within same day if available
```

**Telehealth-specific edge cases:**

| Scenario | Protocol |
|---------|---------|
| Patient disconnects during crisis | Call patient immediately; call parent/guardian; if no contact in 5 minutes, call 911 using address on file |
| Patient location unknown (different from address on file) | Ask patient to state current address before calling 911; if patient refuses, 911 with last known address and note uncertainty |
| Parent refuses emergency services for patient | Document refusal; consult CANRA obligation if abuse suspected; contact peer consultant; follow up with DCFS if needed |
| Minor patient discloses abuse (CANRA trigger) | See CANRA quick-reference below; do NOT promise confidentiality before disclosure |

**CANRA Quick Reference (mandatory reporter obligation):**
- Who: Valentina is a mandatory reporter under California Penal Code § 11165.7
- Report to: Local law enforcement or DCFS (LA County: 1-800-540-4000)
- Timeline: Report verbally by telephone immediately upon reasonable suspicion. Written SS 8572 form submitted within 36 hours of verbal report.
- Form: BCIA 8572 (download from CA DOJ: https://oag.ca.gov/sites/all/files/agweb/pdfs/childabuse/ss_8572.pdf)
- Immunity: No civil or criminal liability for good-faith reports

**Suicide risk instrument — C-SSRS:**
- Full name: Columbia Suicide Severity Rating Scale
- Population: Validated for children as young as 5; adolescent studies (adolescent depression, adolescent suicide attempters)
- Evidence base: 600+ peer-reviewed studies; NIMH-funded development; FDA and SAMHSA recommended
- Versions: Screener (6 yes/no items, < 3 minutes); Full Clinical Version; Lifetime Baseline; Recent version
- Recommendation for this practice: Use C-SSRS Lifetime Baseline at first session; C-SSRS Recent at each follow-up for any patient with prior ideation
- Child/adolescent version: Available free from Columbia University (cssrs.columbia.edu) and APNA
- Administration: Clinician-administered; plain language; does not require specialized training beyond clinical judgment
- Source: Columbia University Psychiatry, SAMHSA, APNA (HIGH confidence)

**Patient-facing safety plan template (to be included in OPS-03 appendix):**
```
MY SAFETY PLAN
Patient name: _______________   Date: _______________

1. WARNING SIGNS (things that tell me a crisis is coming):
   _______________________________________________

2. THINGS I CAN DO ON MY OWN TO FEEL BETTER:
   - Internal coping strategies (distraction, grounding):
   _______________________________________________
   - Places I can go that feel safe:
   _______________________________________________

3. PEOPLE I CAN TALK TO:
   - Person 1: _______________ Phone: _______________
   - Person 2: _______________ Phone: _______________

4. PROFESSIONAL HELP:
   - Dr. Park: (424) 248-8090
   - If can't reach Dr. Park: 988 (call or text)
   - Emergency: 911

5. THINGS I CAN DO TO MAKE MY ENVIRONMENT SAFER:
   - Remove or secure: _______________________________________________

Patient signature: _______________ Date: _______________
Provider signature: _______________ Date: _______________
```

### OPS-04: Business Structure Documentation

**Current legal entity facts (from Phase 1 and 2 deliverables):**

| Item | Value |
|------|-------|
| Legal entity name | Valentina Park MD, Professional Corporation |
| Entity type | California Professional Corporation (medical) |
| Tax election | S-Corporation (federal IRS election) |
| Sole shareholder | Valentina Park, MD |
| Officer roles | Valentina Park, MD — President, Treasurer, Secretary (CA corp. law: sole shareholder must hold all three officer positions) |
| Employee (CTO) | Maxi (full name to be inserted) |
| NPI | 1023579513 |
| EIN | [Valentina to provide — not in project docs] |
| CA Secretary of State filing | [Statement of Information — current status per Phase 1] |
| Business license | Torrance BL-LIC-051057 — EXPIRED 12/31/2025 per Phase 1 STATE.md; immediate renewal required at torranceca.gov |
| Branding / DBA | Brighter Days (not a registered DBA — used informally) |

**S-Corp structure explanation (for future staff clarity):**

A Professional Corporation (PC) is the required entity type for solo physician practices in California — physicians cannot practice through a standard LLC or general corporation. The S-Corp tax election means corporate income flows through to Valentina's personal return (no double taxation). As sole shareholder, Valentina serves as President, Treasurer, and Secretary simultaneously.

**Maxi's role as CTO/employee:** Maxi is a W-2 employee of Valentina Park MD, Professional Corporation. As CTO, Maxi's responsibilities cover technology infrastructure, administrative operations, practice management systems, and biller oversight. This is a standard employee relationship, not a partner or shareholder relationship.

**Future Brighter Days entity plan (deferred — document for awareness):**
Per project decisions, forming a separate "Brighter Days" S-Corp entity is deferred until hiring timeline is clear. Two options under evaluation: (a) rename Valentina Park MD, PC to Brighter Days; (b) create new Brighter Days S-Corp with Valentina as sole owner. Requires attorney/CPA guidance. Neither option is in scope for Phase 3 — the SOP documents the current structure only.

### OPS-05: Biller Onboarding — Tebra Biller Role

**Tebra user roles (official documentation):**

Tebra offers six web user roles. For Nexus Billing, the correct role is **Biller**:

| Role | Access Level | Appropriate For |
|------|-------------|-----------------|
| System Admin | Full access including user management | Maxi (CTO) |
| Provider | Clinical tasks + rendering provider on claims | Valentina |
| Clinical Assistant | Basic clinical tasks | Future clinical staff |
| Office Staff | Front office, admin | Future admin staff |
| **Biller** | Billing tasks only — no clinical access | **Nexus Billing** |
| Business Manager | Bookkeeping, accounting | Not currently needed |

**Biller role specific permissions:**
- Manage charge entries
- View claims status
- View patient collections status
- View payout report
- Manage Patient Demographics (limited)
- Manage Patient Appointments (limited)
- Manage Insurance
- Messages

**What billers CANNOT access:** Clinical notes, prescriptions, clinical documentation, advanced engagement features. This satisfies HIPAA's minimum necessary standard.

**HIPAA minimum necessary rationale:** Nexus Billing needs billing and claims data — not clinical information. The Biller role exposes financial and administrative PHI (name, insurance, claim status) but not clinical PHI (diagnoses in clinical notes, prescriptions). This is the correct balance.

**Data Nexus Billing needs to start:**

| Data Element | Source | Delivery Method |
|-------------|--------|----------------|
| Tebra practice login (Biller role) | Maxi creates in Tebra Settings > Users | Send via secure channel (not email) |
| NPI: 1023579513 | Credential inventory (Phase 2) | Include in onboarding packet |
| DEA number: FP3833933 | Credential inventory (Phase 2) | Include in onboarding packet |
| Tax ID / EIN | Valentina to provide | Include in onboarding packet |
| All 17 payer IDs and contracts | Payer tracker (Phase 2) | Export from payer-tracker-seed.sql |
| CPT codes used (standard psych codes) | Provide baseline list (90791, 99213-99215, 90833, 90836, 90838) | Include in onboarding packet |
| Fee schedule | Valentina to provide or use Medicare rates as baseline | Include in onboarding packet |
| Claim submission address (Tebra handles EDI) | Tebra EDI enrollment | Nexus uses Tebra portal directly |

**Standard psychiatry CPT codes (reference for onboarding packet):**

| CPT Code | Description | Typical Use |
|---------|-------------|-------------|
| 90791 | Psychiatric diagnostic evaluation | Initial intake session |
| 99213 | E&M established patient, low complexity | Brief follow-up |
| 99214 | E&M established patient, moderate complexity | Standard follow-up (30 min) |
| 99215 | E&M established patient, high complexity | Complex follow-up |
| 90833 | Psychotherapy add-on, 16-37 min (with E&M) | Combined med mgmt + therapy |
| 90836 | Psychotherapy add-on, 38-52 min (with E&M) | Extended session |
| 90838 | Psychotherapy add-on, 53+ min (with E&M) | Long combined session |

**Reporting requirements (Valentina's expectations):**

- Per-claim visibility: every claim status visible in Tebra (Nexus submits through Tebra — all data flows back)
- Denial notification: same-day contact when denial received (not batched monthly)
- Monthly summary: submitted claims, paid claims, outstanding AR, denial rate
- Escalation path: Nexus primary contact name + phone (to be inserted at onboarding) → if unresolved 5 business days → Valentina reviews claim directly in Tebra + contacts payer

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Suicide risk assessment instrument | Custom questionnaire | C-SSRS (child/adolescent version) | 600+ validation studies; FDA-recommended; free; clinician-administered plain language; works ages 5+ |
| Safety plan format | Novel template | Stanley-Brown Safety Planning Intervention format (adapted) | Evidence-based; familiar to other providers who may see patient in emergency; legally defensible |
| CURES check procedure | Internal protocol invented from scratch | CA H&S Code 11165.4 + Medical Board of CA mandatory use guidelines | Law specifies the exact requirements; custom protocol risks non-compliance with specific timing rules |
| Biller Tebra onboarding | Custom permission set | Tebra built-in Biller role | Role is designed for this exact purpose; already limits clinical access per HIPAA minimum necessary |
| Eligibility verification | External tool or phone calls | Tebra built-in eligibility check (270/271 ANSI-X12 standard) | Already included in Tebra subscription; returns response in seconds; covers all 17 credentialed payers |
| Depression screening for adolescents | Practice-developed tool | PHQ-A (PHQ-9 Modified for Adolescents) | NIMH-endorsed; free; widely used; validated ages 11-17; includes suicidality item |
| Substance use screening | Practice-developed tool | CRAFFT v2.1 | Validated for ages 12-21; free; widely used in adolescent primary care and psychiatry; aligns with SAMHSA recommendations |

---

## Common Pitfalls

### Pitfall 1: Collecting Patient Address Incorrectly at Intake
**What goes wrong:** The standard Tebra demographic form collects a mailing address, but for telehealth crisis response, the critical field is the patient's current physical location during sessions — which may differ from the mailing address (e.g., patient is at school, a different parent's home, or travelling within CA).
**Why it happens:** Address fields are set up once at intake and not revisited.
**How to avoid:** OPS-01 must specify that the intake emergency contact section asks for: (1) primary home address, (2) instruction that patient must state current physical location at every session start, and (3) a note that the patient location protocol (Phase 1) governs this.
**Warning signs:** Crisis escalates and provider does not know patient's physical address for 911 dispatch.

### Pitfall 2: CURES Check Timing Error
**What goes wrong:** Provider checks CURES on Monday, then patient appointment is on Wednesday — the check was done too early. CURES must be checked within 24 hours (or the previous business day) of prescribing.
**Why it happens:** Batching CURES checks with routine admin, not tying them to the prescription event.
**How to avoid:** OPS-02 must specify: CURES check happens at the appointment where the Rx decision is made, not days in advance. Acceptable: check Monday morning for a Monday afternoon appointment. Not acceptable: check on Monday for a Wednesday appointment.
**Warning signs:** Note documentation shows CURES checked 2+ days before prescription date.

### Pitfall 3: Crisis Protocol Skips Parent Notification
**What goes wrong:** Provider follows crisis escalation steps but delays or omits parental notification for a minor patient — either out of respect for adolescent privacy or forgetting the HIPAA minors exception.
**Why it happens:** Confidentiality norms from adult psychiatry bleed into youth psychiatry practice.
**How to avoid:** OPS-03 must explicitly state: for patients under 18, parent/guardian notification is required in any Tier 2 or Tier 3 crisis event, regardless of the patient's preference. This is not a HIPAA violation — disclosures to protect minors from imminent harm are permitted.
**Warning signs:** Crisis charting shows crisis escalation without corresponding parent contact note.

### Pitfall 4: Biller Gets System Admin Role "For Convenience"
**What goes wrong:** During onboarding, Tebra admin creates a Billing Manager or System Admin role for Nexus Billing to avoid back-and-forth when biller needs more access. This exposes clinical records, user management, and all practice settings.
**Why it happens:** Biller requests more access; admin accommodates without considering HIPAA implications.
**How to avoid:** OPS-05 must state: Nexus Billing receives the Biller role only. If Nexus requests elevated access, Maxi reviews the specific need and accommodates it at the task level rather than by upgrading the role. No third-party vendor receives System Admin or Billing Manager access.
**Warning signs:** Tebra user list shows Nexus Billing account with Billing Manager or System Admin role.

### Pitfall 5: SOP Documents Age Quickly Without Review Cycle
**What goes wrong:** SOPs written at launch become stale as practice grows, regulations change, and Tebra updates its interface. Staff follow outdated procedures without knowing.
**Why it happens:** SOPs are created as one-time artifacts without an update discipline.
**How to avoid:** Every SOP includes an explicit Review Cycle (Annual) and Owner. Phase 4 dashboard should surface SOP review dates as compliance items. The Pending Todos from STATE.md that touch OPS territory (load consent forms into Tebra, configure GFE workflow) should be tracked as OPS-01 action items.
**Warning signs:** SOP references Tebra screens that no longer exist; procedures describe steps the practice no longer follows.

### Pitfall 6: Business Entity Document Is Incomplete on Officer Roles
**What goes wrong:** OPS-04 describes Valentina as "owner" and Maxi as "CTO" without specifying the CA corporate law requirement that as sole shareholder, Valentina must hold President, Treasurer, and Secretary simultaneously.
**Why it happens:** Most documentation focuses on the business relationship, not the legal structure.
**How to avoid:** OPS-04 explicitly lists all three officer titles for Valentina and documents that this is a CA corporate compliance requirement for sole-shareholder professional corporations (CA Corp. Code § 312).
**Warning signs:** Corporate records show blank Treasurer or Secretary officer fields.

---

## Code Examples

### SOP Header Template (Markdown — All Five SOPs)
```markdown
# SOP-[01|02|03|04|05]: [Title]

**Version:** 1.0
**Effective Date:** [YYYY-MM-DD]
**Owner:** [Valentina Park, MD | Maxi (CTO) | Both]
**Review Cycle:** Annual (due [YYYY-MM-DD])
**Supersedes:** N/A (first version)

## Purpose
[One sentence statement of what this SOP accomplishes]

## Scope
[Who this SOP applies to and when it is triggered]

## Roles and Responsibilities
| Role | Responsibility |
|------|---------------|
| [Role] | [Tasks] |

## Procedure
[Numbered steps with checkboxes]

## Decision Points
[If/then table for edge cases]

## Documentation Requirements
| What to Document | Where | By When |
|-----------------|-------|---------|
| [item] | Tebra clinical note | Within 24h of session |

## References
- [Upstream document name] — [location]
```

### CURES Check Documentation Template (for clinical note)
```
CURES PDMP Check — [Date]
Patient: [Name] | DOB: [DOB]
Query date: [date] | Query time: [time]
Substances reviewed: Schedule II-V (all)
Date range reviewed: [range]
Findings: [No concerning patterns identified / Findings: describe]
Clinical decision: [Proceeding with Rx for X | Deferred pending discussion | Contacted prior prescriber]
Provider: Valentina Park, MD (DEA: FP3833933)
```

### Tebra User Creation for Biller (Checklist)
```
Steps to create Nexus Billing user in Tebra:
1. Login to Tebra as System Admin (Maxi)
2. Navigate to: Settings > Users > Add User
3. Enter: Nexus Billing contact name, work email
4. Role: Select "Biller" (not Billing Manager, not System Admin)
5. Practice access: Enable access to Valentina Park MD, PC only
6. Send invitation via Tebra (user sets own password)
7. Verify: Nexus Billing confirms they can access charge entries and claims status
8. Document: User creation date, Nexus contact name, Tebra username in 1Password vault
   (Category: Billing & Revenue > Nexus Billing)
```

### Patient Intake Pre-Session Checklist (Admin — Maxi)
```
PRE-INTAKE CHECKLIST — New Patient
Patient name: _______________   Appointment date: _______________

ELIGIBILITY
[ ] Run Tebra eligibility check (1-3 days before appointment)
[ ] Result: [ ] Verified  [ ] Not Determined  [ ] Not Eligible
[ ] If Not Determined: called payer at _______________  Result: _______________
[ ] If Not Eligible: contacted patient at _______________ on _______________

INTAKE FORMS (sent via Tebra portal)
[ ] Demographics form sent to patient
[ ] Emergency contact form sent to patient (includes physical address field)
[ ] Financial/insurance form sent to patient
[ ] Telehealth Informed Consent Form sent (Phase 1 document)
[ ] Minor Consent Form — Part A and Part B sent (if patient is under 18)
[ ] Good Faith Estimate sent (if self-pay)

FORMS RETURNED (confirm before session)
[ ] All forms returned by patient/guardian
[ ] Emergency contact includes full physical address
[ ] Insurance information matches what was entered in Tebra

READY FOR FIRST SESSION
[ ] Patient portal account active
[ ] Valentina notified: intake forms complete, any flags noted
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Paper intake forms mailed or faxed | Digital intake via EHR patient portal (Tebra) | Post-COVID standard | Patients complete forms before appointment; no paper handling; automatic form merge into chart |
| Phone-based eligibility verification | Real-time electronic eligibility (270/271 ANSI-X12) via Tebra | Industry standard ~2015, now universal | Response in seconds vs. 20+ minutes on hold; automated status tracking |
| Columbia Protocol (call 911 immediately) | Tiered crisis response with 988 integration | 988 launched July 2022; AB 988 CA-funded | 988 routes to crisis counselors before law enforcement; less traumatic for youth; mobile crisis teams (MRSS) dispatched by 988 in most CA counties |
| Paper CURES 1.0 (decommissioned 2018) | CURES 2.0 — web-based, single sign-on, real-time | 2018 | Fully online; faster queries; integrated with some EHRs; CA DOJ administers |
| Biller operates on all practice systems | HIPAA minimum necessary + EHR role-based access | HIPAA Security Rule (2013 Omnibus Rule) | Billers access only what they need; clinical records protected |

**Deprecated / Outdated:**
- CURES 1.0: Completely replaced by CURES 2.0 in 2018. Any reference to CURES 1.0 procedures is obsolete.
- ASQ (Ask Suicide-Screening Questions): Valid instrument, but designed for emergency/primary care settings. C-SSRS is preferred for ongoing psychiatric care.
- Columbia Protocol (call 911 immediately for any suicidal ideation): Replaced by tiered approach. Immediate 911 for passive ideation can traumatize patients and damage the therapeutic relationship. Reserve 911 for Tier 3 imminent risk.

---

## Open Questions

1. **Tebra custom intake form — psychiatric screening tool configuration**
   - What we know: Tebra allows custom form creation via Navigate Patient Intake Settings; default sections cover demographics, emergency contact, financial information
   - What's unclear: Whether PHQ-A, PSC-17, or CRAFFT can be built as Tebra custom forms, or whether Valentina must administer these clinician-side at the first appointment
   - Recommendation: Plan the SOP assuming screeners are administered clinician-side at the first session (low risk); if Tebra supports custom scoring forms, they can be added to the intake packet as an enhancement. This does not block SOP completion.

2. **Patient's county of residence — crisis routing**
   - What we know: 988 routes by area code, then by the caller's county; MRSS availability varies by county; LA County has robust resources; rural CA counties have less coverage
   - What's unclear: Whether Valentina will see patients across all 58 CA counties or primarily Southern CA / LA County
   - Recommendation: SOP uses 988 as the universal first-line resource (routes automatically to local crisis services statewide); include LA County Crisis Line (800-854-7771) as secondary; note that MRSS availability varies by county and 988 dispatch determines this automatically.

3. **EIN / Tax ID for OPS-04 and OPS-05**
   - What we know: EIN is assigned to Valentina Park MD, PC; required for biller onboarding packet
   - What's unclear: EIN value is not in any project document
   - Recommendation: Valentina provides EIN before OPS-04 and OPS-05 are finalized. Placeholder in both documents.

4. **Nexus Billing contact name and escalation contact**
   - What we know: Nexus Billing is selected; BAA is signed
   - What's unclear: Primary contact name, phone, escalation contact at Nexus
   - Recommendation: Gather from Valentina before OPS-05 is finalized. Placeholder in document.

5. **Maxi's full legal name for OPS-04**
   - What we know: Maxi is the CTO/employee
   - What's unclear: Legal name for formal employment documentation
   - Recommendation: Gather before finalizing OPS-04. Document treats "Maxi" as a placeholder until provided.

---

## Validation Architecture

> Skipped — workflow.nyquist_validation is not present in config.json (field absent, treated as false). This is a documentation-only phase with no software tests.

---

## Sources

### Primary (HIGH confidence)
- CA Health & Safety Code § 11165.4 — CURES mandatory use law (via Medical Board of CA official page)
- Medical Board of California — CURES Mandatory Use: https://www.mbc.ca.gov/Resources/Medical-Resources/CURES/Mandatory-Use.aspx
- CA DOJ — CURES FAQ: https://oag.ca.gov/cures/faqs
- Tebra Help Center — Web User Roles and Permissions: https://helpme.tebra.com/Tebra_PM/04_Settings/Users/Web_User_Roles_and_Permissions
- Tebra Help Center — Check Patient Insurance Eligibility: https://helpme.tebra.com/Platform/Dashboard/Check_Patient_Insurance_Eligibility
- Columbia Lighthouse Project — C-SSRS: https://cssrs.columbia.edu/the-columbia-scale-c-ssrs/about-the-scale/
- SAMHSA — C-SSRS: https://www.samhsa.gov/resource/dbhis/columbia-suicide-severity-rating-scale-c-ssrs
- CA DOJ — CANRA Form SS 8572: https://oag.ca.gov/sites/all/files/agweb/pdfs/childabuse/ss_8572.pdf
- 988 California — AB 988 implementation: https://www.chhs.ca.gov/988california/

### Secondary (MEDIUM confidence)
- AACAP — Delivery of Child and Adolescent Psychiatry Services Through Telepsychiatry (2017 policy statement): https://www.aacap.org/aacap/Policy_Statements/2017/Delivery_of_Child_and_Adolescent_Psychiatry_Services_Through_Telepsychiatry.aspx
- APNA — Child version C-SSRS: https://www.apna.org/resources/child-version-columbia-suicide-severity-rating-c-ssrs/
- PMC — C-SSRS adolescent validation: https://pmc.ncbi.nlm.nih.gov/articles/PMC3893686/
- Tebra — Insurance eligibility verification overview: https://www.tebra.com/billing-payments/insurance-eligibility
- Tebra — Navigate Patient Intake Settings: https://helpme.tebra.com/Engage/Patient_Intake/Patient_Intake/Navigate_Patient_Intake_Settings
- UCSF CAPP — Screening Tools: https://capp.ucsf.edu/content/screening-tools
- NIMH — PHQ-A: https://www.nimh.nih.gov/research/research-conducted-at-nimh/asq-toolkit-materials/asq-tool/phq-9-modified-for-adolescents-phq-a
- San Diego Corporate Law — CA Medical PC S-Corp: https://sdcorporatelaw.com/business-newsletter/can-a-california-professional-medical-corporation-be-an-s-corp/

### Tertiary (LOW confidence — verify directly)
- Parent presence by exact age (under 8 / 8-12 / 13-17): Age groupings are research-informed recommendations (AACAP guidelines, PMC literature), not a single authoritative standard. Valentina should review and confirm these thresholds match her clinical judgment.
- CRAFFT v2.1 current version: Version confirmed from CEASAR resources; verify current version at ceasar.org before including in patient-facing materials.
- MRSS availability by CA county: Varies significantly and evolves as AB 988 implementation progresses through 2030. Recommend using 988 dispatch as the universal routing mechanism rather than county-specific contact lists.

---

## Metadata

**Confidence breakdown:**
- CURES SOP (OPS-02): HIGH — sourced directly from Medical Board of CA and CA DOJ official pages; law is explicit on timing and requirements
- Crisis protocol clinical content (OPS-03): MEDIUM-HIGH — C-SSRS is definitively the right instrument; 988 resources are confirmed; tiered crisis protocol structure reflects AACAP/SAMHSA guidance; age-specific parent presence thresholds are LOW confidence (no single authoritative standard)
- Tebra Biller role permissions (OPS-05): HIGH — sourced directly from Tebra official help documentation
- Tebra eligibility verification (OPS-01): HIGH — sourced from Tebra official documentation
- Business structure facts (OPS-04): HIGH for CA corporate law requirements; some values (EIN, Maxi full name) are placeholders pending Valentina's input
- Screening instrument selection (OPS-01): HIGH for PHQ-A, PSC-17, CRAFFT — all are validated, widely used, free instruments with strong evidence base in the target population

**Research date:** 2026-03-01
**Valid until:** 2026-09-01 (stable regulatory domain; CURES law does not change frequently; Tebra UI may change but role structure is stable; AB 988 MRSS rollout continues through 2030 — county resource availability may improve)
