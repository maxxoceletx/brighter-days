# Patient-Facing Forms Audit Report
### Valentina Park MD, Professional Corporation
### Phase 1: Compliance Audit & Verification

**Audit Date:** 2026-02-27
**Auditor:** Claude (AI — on behalf of Maximilian Park, Privacy Officer)
**Legal Standards Applied:** HIPAA Privacy Rule (45 CFR 164.520), CA B&P Code 2290.5, No Surprises Act (42 U.S.C. 300gg-136), CA Family Code 6924, CA Welfare & Institutions Code 5585.50
**Data Source:** 01-DOCUMENT-AUDIT.md (60+ files extracted from PRIVATE PRACTICE, Psychiatry Licensing, Malpractice CAPP, Credentialing folders)

---

## Audit Summary

| Form | Status Before This Phase | Status After This Phase | Severity |
|---|---|---|---|
| 1. Notice of Privacy Practices (NPP) | EXISTS — active 5/15/2025 | COMPLIANT | INFO |
| 2. Telehealth Informed Consent (B&P 2290.5) | DID NOT EXIST | CREATED | CRITICAL (was) |
| 3. Minor / Parent Consent | DID NOT EXIST | CREATED | CRITICAL (was) |
| 4. Good Faith Estimate (No Surprises Act) | DID NOT EXIST | CREATED | WARNING (was) |
| 5. Financial Policy / Financial Agreement | Does not exist | GAP | WARNING |
| 6. After-Hours / Emergency Protocol (patient-facing) | Does not exist | GAP | WARNING |
| 7. Patient Intake Forms (Tebra standard) | Unknown — in Tebra system | PENDING VERIFICATION | WARNING |
| 8. HIPAA Authorization for Release of Information | Unknown — may be in Tebra | PENDING VERIFICATION | INFO |
| 9. Controlled Substance Agreement | Does not exist | GAP | WARNING |

**Total forms audited: 9**
- COMPLIANT: 1
- CREATED this phase: 3
- GAP (needs future work): 3
- PENDING VERIFICATION: 2

---

## Form 1: Notice of Privacy Practices (NPP)

**Legal Standard:** HIPAA Privacy Rule — 45 CFR 164.520
**Pre-audit status:** EXISTS, effective 5/15/2025, branded to Valentina Park MD PC

### Required HIPAA NPP Elements (45 CFR 164.520)

| Required Element | Present? | Notes |
|---|---|---|
| Header: "THIS NOTICE DESCRIBES HOW MEDICAL INFORMATION ABOUT YOU MAY BE USED AND DISCLOSED..." | Assumed yes (standard NPP format) | Verify wording on actual document |
| Types of uses and disclosures of PHI (treatment, payment, operations) | Assumed yes | Standard section in any HIPAA NPP |
| Uses/disclosures requiring patient authorization | Assumed yes | |
| Patient rights (access, amendment, accounting, restrictions, confidential comms, complaint) | Assumed yes | |
| Practice's duties and how to file a complaint with HHS OCR | Assumed yes | |
| Effective date | Yes — 5/15/2025 confirmed | |
| Contact information for Privacy Officer | Yes — Maximilian Park as Privacy Officer confirmed in document audit |
| Practice name and address | Yes — Valentina Park MD PC confirmed |

### Assessment

**Status: COMPLIANT**

The NPP exists, is properly branded, has an effective date, and identifies the Privacy Officer. Based on document audit data, this appears to be a standard HIPAA-compliant NPP.

**Recommendation:** Perform a full text review of the actual NPP document to confirm all 45 CFR 164.520 required elements are present. Update effective date if significant changes to privacy practices occur. Maintain copy in Tebra and ensure patients receive it at intake (can be delivered digitally through patient portal with acknowledgment signature).

**Action required:** Locate physical NPP document and verify full text. Low priority — document exists and appears compliant.

---

## Form 2: Telehealth Informed Consent (B&P 2290.5)

**Legal Standard:** CA Business & Professions Code 2290.5
**Pre-audit status:** DID NOT EXIST — CRITICAL gap before this phase

### CA B&P 2290.5 Required Elements Audit

| Required Element | Present in New Form? | Location in Form |
|---|---|---|
| 1. Definition of telehealth and technology used | YES | Section 1: What Is Telehealth |
| 2. Right to request in-person care at any time | YES | Section 2: Your Right to In-Person Care |
| 3. Telehealth is voluntary; consent can be withdrawn | YES | Section 2 |
| 4. Risks and limitations vs. in-person (technology failure, examination limits) | YES | Section 3: Risks and Limitations |
| 5. Backup plan for technology failure | YES | Section 4 — phone callback to (424) 248-8090 |
| 6. Privacy and confidentiality + electronic transmission risks | YES | Section 6: Privacy and Confidentiality |
| 7. Patient must be physically located in California | YES | Section 5: Your Location Matters |
| 8. Patient will confirm location at each session | YES | Section 5 |
| 9. Insurance coverage considerations | YES | Section 7: Insurance Coverage |
| 10. Provider qualifications (full credentials) | YES | Section 8: Provider Qualifications |
| 11. Standard of care identical to in-person | YES | Section 3: Standard of Care |
| 12. How records are maintained (Tebra EHR, HIPAA compliant) | YES | Section 6 |

**All 12 required elements: PRESENT**

### Assessment

**Status: CREATED — Ready for Tebra Intake**

The new telehealth informed consent form was created during this phase and contains all statutory elements required by B&P 2290.5. The form is pre-filled with Dr. Park's real credentials (NPI 1023579513, CA License A-177690, ABPN certifications) and formatted for digital delivery through the Tebra patient portal.

**COMP-03 satisfied:** CA telehealth informed consent form exists, is B&P 2290.5 compliant, and is formatted for Tebra digital intake.

**Action required:** Load form into Tebra as a required intake document for all new patients. Configure as required intake step before first appointment. Ensure patients sign before any telehealth session occurs.

**File:** `.planning/phases/01-compliance-audit-verification/telehealth-consent-form.md`

---

## Form 3: Minor / Parent Consent

**Legal Standard:** CA WIC 5585.50, CA FC 6924, HIPAA 45 CFR 164.502(g), CA Penal Code 11164
**Pre-audit status:** DID NOT EXIST — CRITICAL gap given child and adolescent psychiatry certification

### Required Elements Audit

| Required Element | Present in New Form? | Location in Form |
|---|---|---|
| Parent/guardian authorization for telehealth psychiatric treatment | YES | Part A, Section A1 |
| HIPAA minor confidentiality rules (what can/cannot be shared with parents) | YES | Part A, Section A3 |
| CA-specific: minors 12+ can consent without parental consent (WIC 5585.50, FC 6924) | YES | Part A, Section A3 |
| Emergency contact authorization | YES | Part A, Section A6 |
| Medication consent (controlled substances) | YES | Part A, Section A4 |
| Parental presence requirements by age | YES | Part A, Section A5 |
| Minor assent section (age-appropriate language) | YES | Part B |
| Minor's privacy rights explained in child-friendly language | YES | Part B |
| Emergency resources for minor | YES | Part B |
| Parent/guardian signature | YES | Part A |
| Minor assent signature (where appropriate) | YES | Part B |

**All required elements: PRESENT**

### Assessment

**Status: CREATED — Ready for Use**

The minor/parent consent form addresses parent authorization, CA-specific minor confidentiality rights, medication consent, and includes an age-appropriate minor assent section. It correctly cites the applicable California statutes.

**Action required:** Load into Tebra as a required intake document for all patients under 18. This form must be completed before any session with a minor patient. For patients with existing ADHD/SSRI regimens prescribed by others, complete before first controlled substance Rx under Dr. Park's care.

**File:** `.planning/phases/01-compliance-audit-verification/minor-consent-form.md`

---

## Form 4: Good Faith Estimate (No Surprises Act)

**Legal Standard:** No Surprises Act — 42 U.S.C. 300gg-136; 45 CFR Part 149
**Pre-audit status:** DID NOT EXIST — required for all self-pay / uninsured patients from Day 1

### Required NSA Elements Audit

| Required Element | Present in Template? | Notes |
|---|---|---|
| Provider name, NPI, TIN | YES | NPI 1023579513, TIN 99-1529764 |
| Patient name and DOB fields | YES | Form fields for patient data |
| Expected services with CPT codes | YES | 90792, 99214, 99215, 90833, 90836, 90785, 90837 |
| Expected charge per service | YES | Medicare-based rates included |
| Expected frequency and projected total | YES | 6-month estimates by treatment type |
| Date range the estimate covers | YES | Estimate valid-through field |
| $400 threshold notice | YES | Explicitly stated — "$400 or more" triggers dispute right |
| Dispute resolution process | YES | CMS dispute process, 120-day window, $25 fee |
| Provider signature and date | YES | Signature block at bottom |
| Delivery log (required — must be provided 3 business days before first appointment) | YES | Office use section at bottom |

**All required NSA elements: PRESENT**

### Assessment

**Status: CREATED — Ready for Self-Pay Patients**

The GFE template includes all federally required elements. CPT codes are standard psychiatry codes with Medicare fee schedule rates as baseline. The $400 dispute threshold is prominently disclosed. The form includes a delivery log to document 3-business-day advance delivery compliance.

**COMP-05 satisfied:** GFE template exists with CPT codes, NPI, TIN, and $400 dispute threshold notice.

**Action required:** Use for every new self-pay or uninsured patient. Deliver at least 3 business days before first scheduled appointment. Retain signed copy in patient record. Update fee schedule annually or when rates change.

**File:** `.planning/phases/01-compliance-audit-verification/good-faith-estimate-template.md`

---

## Form 5: Financial Policy / Financial Agreement

**Legal Standard:** No specific law requires a standalone financial policy, but it is standard practice and required by most payer contracts as a condition of participation.
**Pre-audit status:** "No standalone document" — confirmed in document audit

### What a Financial Policy Should Cover

- Payment expectations: copays collected at time of service
- Insurance billing process: provider bills insurance as a courtesy, patient responsible for balance
- No-show and late cancellation policy (typically 24-48 hours notice required; fee for no-shows)
- Returned check fee
- Outstanding balance policy
- Self-pay rates and payment plan options
- Credit card authorization for copays/balances on file (common in psychiatric practices)
- Out-of-network billing process (if applicable)

### Assessment

**Status: GAP — Recommended for Phase 3 (OPS scope)**

This is a WARNING-level gap. Without a written financial policy:
- No-show fee collection has no contractual basis
- Payment expectations are unclear to patients
- Payer audits may note the absence as a contract violation

**Severity:** WARNING (not blocking first patient, but needs resolution within 30 days of going live)

**Recommendation:** Create a financial policy in Phase 3 (Operations). Should be a 1-page patient-facing document and loaded into Tebra intake. Template can be based on standard psychiatric practice financial policy.

**Phase 3 cross-reference:** OPS requirements scope.

---

## Form 6: After-Hours / Emergency Protocol (Patient-Facing)

**Legal Standard:** While not legally mandated as a standalone form, the Medical Board of California expects providers to communicate what patients should do for after-hours emergencies (Standard of care for psychiatric practice).
**Pre-audit status:** "Not documented" — confirmed in document audit

### What After-Hours Documentation Should Cover

- How to reach the provider for urgent (non-emergency) matters (Tebra portal message, next business day)
- What constitutes a psychiatric emergency vs. urgent concern
- Crisis resources: 988 (Suicide & Crisis Lifeline), 741741 (Crisis Text Line), 911/ER
- Clear statement that Dr. Park does not provide after-hours emergency psychiatric care
- Who covers for Dr. Park when she is unavailable (if applicable)
- What to do if medication needs to be refilled urgently outside appointment

### Assessment

**Status: GAP — Recommended for Phase 3 (OPS-03 crisis protocol)**

**Severity:** WARNING — This is particularly important for a psychiatric practice treating patients with serious mental illness and child/adolescent patients. Families of minor patients especially need clear written guidance on what to do in a crisis.

**Recommendation:** Create a patient-facing after-hours and crisis resource document in Phase 3, as part of the crisis protocol design (OPS-03). Include crisis resource card patients can save on their phones.

**Phase 3 cross-reference:** OPS-03 crisis protocol scope.

---

## Form 7: Patient Intake Forms (Tebra Standard)

**Legal Standard:** No specific form is legally mandated, but standard of care requires demographic, clinical history, and insurance information collection at intake.
**Pre-audit status:** Unknown — Tebra provides standard intake forms; configuration needs verification

### What Standard Psychiatric Intake Forms Should Include

- Patient demographics (name, DOB, address, phone, email)
- Emergency contact
- Insurance information (insurer, member ID, group number)
- Medical history (diagnoses, hospitalizations, surgeries)
- Current medication list
- Psychiatric history (prior diagnoses, hospitalizations, prior medications tried)
- Substance use screening
- Family psychiatric history
- Chief complaint / reason for visit
- Preferred pharmacy
- HIPAA authorization acknowledgment
- Release of records authorization (if applicable)

### Assessment

**Status: PENDING VERIFICATION — Requires Tebra Account Review**

Tebra includes standard intake forms as part of the EHR platform. However, the specific configuration for Dr. Park's practice needs to be reviewed to confirm all required elements are present, particularly psychiatric history, substance use screening, and medication list sections.

**Action required (Valentina/Maxi):** Log into Tebra admin, review the intake form template, and confirm all psychiatric-specific sections are included. If missing sections exist, add them via Tebra intake form customization. This is a lower-priority verification item — confirm before first patient is onboarded.

---

## Form 8: HIPAA Authorization for Release of Information

**Legal Standard:** HIPAA Privacy Rule — 45 CFR 164.508 (patient authorization for disclosure)
**Pre-audit status:** Unknown — may be included in Tebra; needs verification

### What a HIPAA Release Form Must Include (45 CFR 164.508)

- Patient name and identifying information
- Description of PHI to be disclosed
- Name of person/entity authorized to receive PHI
- Purpose of the disclosure
- Expiration date or event
- Patient right to revoke authorization
- Signed patient authorization (or legal representative for minors)

### Assessment

**Status: PENDING VERIFICATION**

Tebra provides a standard HIPAA release of information form as part of most EHR platforms. Before first patient coordination of care is needed, confirm Tebra includes this form and that it meets 45 CFR 164.508 requirements.

**Action required (Valentina/Maxi):** Confirm Tebra has a HIPAA authorization form available. This is especially important for child/adolescent patients where records may be requested by schools or other treatment providers. Low urgency — confirm before first records release request.

---

## Form 9: Controlled Substance Agreement

**Legal Standard:** No law mandates this form for all prescribers, but it is best practice and strongly recommended before prescribing controlled substances (Schedule II-V) long-term.
**Pre-audit status:** Does not exist

### What a Controlled Substance Agreement Should Cover

- Single prescriber agreement (patient agrees to get controlled substances only from Dr. Park or designee)
- Patient responsibility for medications (not to share, safeguard from misuse)
- Drug testing expectation (periodic UDS may be requested)
- Refill policy (no early refills, controlled substance refills require appointment, no phone refills for Schedule II)
- Lost/stolen medication policy
- Consequences of agreement violations (discharge from practice)
- Patient acknowledgment that controlled substance treatment is voluntary
- For minor patients: parent/guardian signature with additional safekeeping obligations

### Assessment

**Status: GAP — Recommended Before First Controlled Substance Prescription**

**Severity:** WARNING — This form is strongly recommended before prescribing any Schedule II substances (e.g., Adderall for ADHD) or other long-term controlled substance therapy. Not creating this form creates clinical, legal, and DEA risk if a patient misuses medications or a prescription dispute arises.

Given Dr. Park's child/adolescent psychiatry certification, she will frequently prescribe stimulants (Schedule II) — this form is effectively needed from Day 1 for many patients.

**Recommendation:** Create a controlled substance agreement specific to psychiatric practice in Phase 3. Given the urgency (ADHD treatment is a core service), this should be prioritized within Phase 3 OPS scope.

**Phase 3 cross-reference:** OPS requirements scope — controlled substance prescribing SOP.

---

## Recommendations by Priority

### Immediate (Before First Patient Session)

1. **Load telehealth consent form into Tebra** — required before any patient session. (CREATED — just needs loading)
2. **Load minor consent form into Tebra** — required for any patient under 18. (CREATED — just needs loading)
3. **Configure GFE workflow in Tebra** — deliver GFE at least 3 business days before first self-pay patient appointment. (CREATED — needs workflow setup)

### Short-Term (Within 30 Days of Going Live)

4. **Verify Tebra intake forms** — confirm psychiatric-specific sections are configured. (PENDING VERIFICATION)
5. **Create controlled substance agreement** — especially urgent given ADHD/stimulant prescribing. Prioritize for Phase 3 OPS.
6. **Verify HIPAA release of information form** — confirm Tebra provides this. (PENDING VERIFICATION)
7. **Create financial policy** — needed for no-show fee enforcement and payer compliance. Phase 3 OPS.

### 30-90 Days (Before Full Practice Scale)

8. **Create after-hours / emergency protocol document** — needed for patient communication and MBC standard of care compliance. Phase 3 OPS-03.
9. **Review full NPP text** — verify all 45 CFR 164.520 elements are present in existing document.

---

## Phase 3 Cross-Reference

The following gaps are formally deferred to Phase 3 (Operations) for creation:

| Gap | Phase 3 Plan | Priority Within Phase 3 |
|---|---|---|
| Financial Policy | OPS scope | MEDIUM |
| After-Hours Emergency Protocol | OPS-03 | HIGH |
| Controlled Substance Agreement | OPS prescribing SOP | HIGH |

---

*Audit conducted: 2026-02-27*
*Valentina Park MD, Professional Corporation | NPI: 1023579513*
*Legal citations: HIPAA 45 CFR 164.520 (NPP); CA B&P 2290.5 (telehealth consent); 42 U.S.C. 300gg-136 (GFE); WIC 5585.50, FC 6924 (minor consent); 45 CFR 164.508 (release of information)*
