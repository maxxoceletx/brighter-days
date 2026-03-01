# SOP-01: Patient Intake Workflow

**Version:** 1.0
**Effective Date:** 2026-03-01
**Owner:** Maxi (Admin) and Valentina Park, MD (Clinical)
**Review Cycle:** Annual (or upon any change to Tebra intake forms, consent forms, or insurance workflow)

---

## Purpose

Ensure every new patient is booked, verified, consented, and clinically evaluated in a consistent, legally compliant sequence — from initial booking through the conclusion of the first psychiatric session.

---

## Scope

This SOP applies to every new patient entering the practice. It covers all steps from the moment a patient schedules an appointment through the completion of the first clinical session. It applies to all staff performing intake duties (currently Maxi as admin and Valentina Park, MD as the treating clinician).

**Population note:** This practice serves youth psychiatric patients (minors). Every step involving forms, consent, and clinical assessment must account for parental or guardian involvement requirements.

---

## Roles and Responsibilities

| Task | Admin (Maxi) | Clinical (Valentina) |
|------|-------------|---------------------|
| Review new booking in Tebra within 24 hours | X | |
| Run Tebra eligibility check (1-3 days before appointment) | X | |
| Call payer if eligibility returns "Not Determined" | X | |
| Contact patient if eligibility returns "Not Eligible" | X | |
| Send Tebra intake packet to patient portal | X | |
| Monitor for completed intake forms (Tebra notification) | X | |
| Flag clinical alerts in completed forms to Valentina | X | |
| Confirm intake forms received before session | X | |
| Confirm patient location at session start (per SOP-referenced protocol) | | X |
| Administer PSC-17 and/or PHQ-A screening (if not completed pre-session) | | X |
| Administer CRAFFT v2.1 substance use screening (ages 12+) | | X |
| Conduct full psychiatric evaluation | | X |
| Administer C-SSRS suicide risk baseline (clinician-administered) | | X |
| Document clinical note in Tebra (assessment, diagnosis, treatment plan) | | X |
| Enter diagnosis and CPT codes in Tebra | X (enters) | X (approves) |
| Initiate CURES check if controlled substance anticipated | | X (see SOP-02) |

---

## Procedure

### Phase 1: Booking

**1.1 — Patient initiates appointment**
- [ ] Patient self-schedules via the Tebra patient portal, OR
- [ ] Patient is referred via Psychology Today and calls or emails to book
- [ ] If booking comes in by phone or email: Admin (Maxi) enters the appointment into Tebra on the patient's behalf

**1.2 — Admin reviews new booking**
- [ ] Admin reviews the new booking in Tebra within 24 hours of it appearing
- [ ] Confirm the patient's listed insurance matches a payer Valentina is contracted with (reference: `.planning/phases/02-credential-vault-monitoring/credential-inventory.md`)
- [ ] If insurance is not on the contracted payer list: contact patient to discuss self-pay or alternate insurance before proceeding

---

### Phase 2: Pre-Intake (1-3 Days Before First Appointment)

**2.1 — Run Tebra eligibility check**

Tebra's eligibility check is a manual step — it does not run automatically when a patient books.

- [ ] In Tebra, open the patient's upcoming appointment from the Dashboard or Calendar
- [ ] Click "Verify Eligibility" to send an ANSI-X12 270 inquiry (an electronic insurance coverage request) to the payer
- [ ] Wait for the 271 response (typically returns within seconds to minutes)
- [ ] Review the result: active coverage, copay amount, deductible status, and coinsurance

**Eligibility result — take action based on status:**

| Tebra Status | Color | Meaning | Action Required |
|-------------|-------|---------|-----------------|
| Verified | Green | Patient is covered under listed insurance | No action needed — proceed with intake |
| Not Determined | Yellow | Payer did not respond or does not support electronic eligibility | Call payer directly to verify coverage manually; document result in Tebra notes |
| Not Eligible | Red | Patient is not covered under that insurance | Contact patient before the appointment to discuss self-pay rate or alternate insurance; do not let patient arrive expecting coverage |

- [ ] Document the eligibility result and any follow-up action in Tebra patient notes

**2.2 — Send Tebra intake packet to patient portal**

- [ ] In Tebra, send the intake packet to the patient's portal account. The intake packet must include all of the following:

  - [ ] **Demographics form** — full legal name, date of birth, address, phone
  - [ ] **Emergency contact form** — must include:
    - Patient's full physical address (street + city + state + zip — required for 911 dispatch)
    - Patient's county of residence (for county-specific crisis routing)
    - Nearest emergency department (ED) to patient's home address
    - Primary parent/guardian: full name, phone number, relationship
    - Secondary emergency contact: name and phone
  - [ ] **Insurance and financial information form**
  - [ ] **Telehealth Informed Consent Form** (Phase 1 deliverable: `.planning/phases/01-compliance-audit-verification/telehealth-consent-form.md`)
  - [ ] **Minor Consent Form — Part A (parent/guardian authorization) and Part B (minor assent)** (Phase 1 deliverable: `.planning/phases/01-compliance-audit-verification/minor-consent-form.md`) — required for all patients under 18
  - [ ] **Good Faith Estimate (GFE) / Financial Policy** (Phase 1 deliverable: `.planning/phases/01-compliance-audit-verification/good-faith-estimate-template.md`) — required for self-pay patients and must be provided at least 3 business days before the appointment for scheduled services
  - [ ] **Release of Information (ROI) form** — include if prior records or coordination with another provider is anticipated

**2.3 — Confirm intake forms completed**
- [ ] Monitor Tebra for notification that patient has submitted all intake forms
- [ ] If forms are not completed 24 hours before the appointment: send a reminder to the patient via the Tebra portal
- [ ] If forms are still incomplete at the time of the session: see Decision Points — Incomplete Forms

---

### Phase 3: First Session (Clinical — Valentina)

**3.1 — Confirm patient location**
- [ ] At the start of every session, confirm the patient is currently in California (required for telehealth licensure)
- [ ] Use the verbal confirmation script and decision table in the Patient Location Protocol: `.planning/phases/01-compliance-audit-verification/patient-location-protocol.md`
- [ ] If patient is not in California: follow the out-of-state procedure in the Patient Location Protocol before proceeding

**3.2 — Administer youth screening instruments**

All instruments below are validated for youth psychiatric populations, clinician-recommended, and free to use. Tebra does not have these instruments pre-built — administer at the start of the clinical session or send as supplemental forms via Tebra portal prior to the session.

- [ ] **PSC-17 (Pediatric Symptom Checklist, 17-item version)**
  - Age range: 3-17
  - Screens for: broad psychosocial problems (internalizing, externalizing, attention)
  - Administration: parent report for patients under 12; self-report for patients 11-17
  - Cost: free (Massachusetts General Hospital)
  - Can be sent as a supplemental form via Tebra patient portal

- [ ] **PHQ-A (Patient Health Questionnaire — Adolescent version)**
  - Age range: 11-17
  - Screens for: depression severity
  - Administration: self-report, 9 items
  - Cost: free (National Institute of Mental Health)
  - Can be sent as a supplemental form via Tebra patient portal

- [ ] **CRAFFT v2.1 (Car, Relax, Alone, Forget, Friends, Trouble)**
  - Age range: 12-21
  - Screens for: substance use disorder risk
  - Administration: self-report — Part A (3 items on use frequency) + Part B (6 items on problem indicators)
  - Cost: free (Center for Adolescent Substance Use Research, Boston Children's Hospital)
  - Administer at start of session for all patients 12 and older

**3.3 — Full psychiatric evaluation**
- [ ] Conduct the full psychiatric intake evaluation, including:
  - Chief complaint and presenting symptoms
  - Psychiatric history (prior diagnoses, hospitalizations, medications)
  - Family psychiatric history
  - Social history (school, home environment, peer relationships)
  - Medical history and current medications
  - Substance use history
  - Developmental history
  - Mental status examination

**3.4 — C-SSRS suicide risk baseline (clinician-administered)**
- [ ] Administer the **C-SSRS Youth Version (Columbia Suicide Severity Rating Scale)**
  - Age range: 5 and older
  - Purpose: establishes baseline suicide risk severity and ideation level for every new patient
  - Administration: clinician-administered (6 items); must be delivered by Valentina during the session — not sent via portal
  - Cost: free (Columbia University)
  - Source: https://cssrs.columbia.edu/
- [ ] Document C-SSRS result (ideation level, behavior history) in Tebra clinical note
- [ ] If C-SSRS indicates active suicidal ideation with plan or intent: activate Crisis Protocol (SOP-03)

**3.5 — Clinical documentation in Tebra**
- [ ] After the session (within 24 hours), document in Tebra:
  - [ ] Clinical note: assessment findings, summary of session content
  - [ ] Diagnosis codes (ICD-10)
  - [ ] Treatment plan: goals, modality, frequency of sessions
  - [ ] Screening instrument results (PSC-17, PHQ-A, CRAFFT, C-SSRS scores)
  - [ ] CPT billing code for the session (admin enters, Valentina approves)

**3.6 — Controlled substance prescribing (if applicable)**
- [ ] If Valentina anticipates prescribing a Schedule II-V controlled substance (stimulants, benzodiazepines, opioids, etc.) at or following this session:
  - [ ] Initiate CURES PDMP check before writing the prescription — follow SOP-02: `.planning/phases/03-clinical-business-operations/sop-02-cures-database-check.md`
  - [ ] Do not issue any controlled substance prescription before the CURES check is complete and documented

---

## Decision Points

### DP-01: Eligibility Check Returns "Not Determined"

```
Tebra returns "Not Determined" (yellow)
  └── Is this payer on the Tebra-supported payer list?
      └── YES → Call payer directly at provider services number
                Document result in Tebra patient notes
                If covered: proceed with intake
                If not covered: go to DP-02
      └── NO (payer not in Tebra network) → Call payer manually
                Document result in Tebra patient notes
                If covered: proceed; note that electronic verification is unavailable for this payer
```

### DP-02: Eligibility Check Returns "Not Eligible"

```
Tebra returns "Not Eligible" (red)
  └── Contact patient immediately (before appointment date)
      └── Offer options:
          1. Patient provides alternate insurance → re-run eligibility check for new policy
          2. Patient accepts self-pay → provide Good Faith Estimate (3 business days required)
          3. Patient reschedules until insurance issue is resolved
      └── Document patient's choice in Tebra notes
      └── Do NOT allow patient to arrive expecting coverage they do not have
```

### DP-03: Intake Forms Incomplete at Session Time

```
Patient has not completed all intake forms by session time
  └── Are the missing forms safety-critical?
      └── YES (Telehealth Consent, Minor Consent, Emergency Contact not completed):
          → Do not begin the clinical session until Telehealth Consent and Minor Consent are signed
          → Offer to have parent/patient complete emergency contact verbally with Admin; enter in Tebra
          → Reschedule session only if patient/parent declines to complete minimum required forms
      └── NO (supplemental screening forms or ROI only):
          → Proceed with session
          → Clinician administers PSC-17, PHQ-A, CRAFFT at start of session if not pre-submitted
          → Note incomplete forms in Tebra; follow up after session
```

### DP-04: Patient Is Under 18 — Minor Consent and Parent Involvement

```
Patient is under 18
  └── Minor Consent Form required:
      - Part A: parent or legal guardian must sign before first session (authorization to treat)
      - Part B: minor assent form appropriate for patient's age and developmental level
  └── Emergency contact form must include:
      - Primary parent/guardian with phone and authority to receive crisis notifications
  └── First session parent presence guidelines (see research):
      - Under 8: parent present in session or confirmed immediately accessible
      - Ages 8-12: parent present in home and available to join if needed; confirm at session start
      - Ages 13-17: begin session alone with patient; confirm parent/guardian contact is reachable
  └── Exceptions to parental consent (CA law permits minor to consent independently for):
      - Outpatient mental health services if minor is 12+ and sufficiently mature (CA W&I Code 5850.1)
      - Discuss any consent exceptions with Valentina before proceeding — document decision in chart
```

### DP-05: Controlled Substance Anticipated — Trigger SOP-02

```
Valentina anticipates prescribing a Schedule II-V controlled substance
  └── STOP — do not write prescription
  └── Complete CURES PDMP check per SOP-02 FIRST
      Reference: .planning/phases/03-clinical-business-operations/sop-02-cures-database-check.md
  └── Document CURES check result in Tebra clinical note
  └── THEN proceed with prescribing decision
```

---

## Documentation Requirements

The following must be recorded in Tebra within the timeframes shown:

| Item | Where in Tebra | Deadline |
|------|---------------|----------|
| Eligibility check result and follow-up action | Patient notes | Same day as eligibility check |
| Intake forms sent to patient portal | Tebra auto-logs this | Automatic |
| Emergency contact details (physical address, county, nearest ED) | Patient demographic record | Before first session |
| Telehealth Consent Form signed | Patient documents | Before first session |
| Minor Consent (Part A + Part B) signed | Patient documents | Before first session |
| Good Faith Estimate delivered (self-pay) | Patient financial record | At least 3 business days before first session |
| Session clinical note (assessment, diagnosis, treatment plan) | Clinical note | Within 24 hours of session |
| Screening instrument scores (PSC-17, PHQ-A, CRAFFT, C-SSRS) | Clinical note | Within 24 hours of session |
| Diagnosis codes (ICD-10) | Clinical note | Within 24 hours of session |
| CPT billing codes | Billing record | Within 24 hours of session |
| CURES check documentation (if controlled substance prescribed) | Clinical note | Same day as prescription (see SOP-02) |

---

## Appendix A: Screening Instrument Reference

| Instrument | Ages | Screens For | Who Administers | Time | Source |
|-----------|------|-------------|-----------------|------|--------|
| PSC-17 | 3-17 | Broad psychosocial problems | Self or parent report | 5 min | Massachusetts General Hospital (free) |
| PHQ-A | 11-17 | Depression severity | Patient self-report | 5 min | NIMH (free) |
| CRAFFT v2.1 | 12-21 | Substance use disorder | Self-report (Part A + B) | 5-10 min | CEASAR / Boston Children's Hospital (free) |
| C-SSRS Youth | 5+ | Suicide risk severity | Clinician-administered | 5-10 min | Columbia University (free) |

**Tebra note:** Tebra does not include psychiatric screening instruments by default. PHQ-A, PSC-17, and CRAFFT can be configured as supplemental forms in Tebra and sent to patients via the portal. C-SSRS must be administered by Valentina during the session — it cannot be self-administered via portal.

---

## References

| Document | Location | Purpose in This SOP |
|---------|----------|---------------------|
| Telehealth Informed Consent Form | `.planning/phases/01-compliance-audit-verification/telehealth-consent-form.md` | Required consent form sent in intake packet |
| Minor Consent Form (Part A + Part B) | `.planning/phases/01-compliance-audit-verification/minor-consent-form.md` | Required for all patients under 18 |
| Good Faith Estimate Template | `.planning/phases/01-compliance-audit-verification/good-faith-estimate-template.md` | Required for self-pay patients |
| Patient Location Protocol | `.planning/phases/01-compliance-audit-verification/patient-location-protocol.md` | Location confirmation script used at every session start |
| Credential Inventory | `.planning/phases/02-credential-vault-monitoring/credential-inventory.md` | Verify patient's payer is on contracted payer list |
| CURES Database Check SOP (SOP-02) | `.planning/phases/03-clinical-business-operations/sop-02-cures-database-check.md` | Triggered when controlled substance prescribing is anticipated |
| Crisis Protocol (SOP-03) | `.planning/phases/03-clinical-business-operations/sop-03-crisis-protocol.md` | Triggered when C-SSRS or session indicates patient is in crisis |

---

*SOP-01 — Version 1.0 — Valentina Park MD, PC — Effective 2026-03-01*
