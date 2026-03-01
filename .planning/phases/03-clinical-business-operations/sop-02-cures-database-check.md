# SOP-02: CURES Database Check

**Version:** 1.0
**Effective Date:** 2026-03-01
**Owner:** Valentina Park, MD (Prescriber)
**Review Cycle:** Annual (or upon any change to CA H&S Code 11165.4 or Medical Board of CA mandatory use policy)

---

## Purpose

Ensure compliance with California Health and Safety Code Section 11165.4, which mandates that every prescriber check the California Controlled Substances Utilization Review and Evaluation System (CURES) Prescription Drug Monitoring Program (PDMP) before prescribing or dispensing any Schedule II-V controlled substance. This SOP documents the step-by-step CURES check procedure, timing requirements, exemptions, and documentation standards required to avoid administrative sanctions.

**Important:** This SOP applies regardless of prescribing posture. Although Valentina Park MD currently uses a conservative prescribing approach (SSRIs, SNRIs, and non-stimulant ADHD medications as first-line), the CURES check SOP must be followed from day one whenever any Schedule II-V controlled substance is considered.

---

## Scope

This SOP applies whenever Valentina Park, MD prescribes or continues a Schedule II-V controlled substance for any patient.

**Schedule coverage:**
- Schedule II: Stimulants (amphetamines, methylphenidate), opioids (oxycodone, hydrocodone), and others
- Schedule III: Buprenorphine, testosterone, ketamine, and others
- Schedule IV: Benzodiazepines (alprazolam, clonazepam, diazepam), sleep aids (zolpidem), and others
- Schedule V: Low-dose codeine cough preparations, pregabalin, and others

**Who performs this SOP:** Valentina Park, MD only. Admin (Maxi) cannot log in to CURES and cannot perform or proxy CURES checks on the prescriber's behalf. CURES accounts are individual and tied to the prescriber's DEA registration.

---

## Roles and Responsibilities

| Role | Responsibilities in This SOP |
|------|------------------------------|
| Valentina Park, MD (Prescriber) | Perform CURES check; review Patient Activity Report; document findings in Tebra clinical note; make prescribing decision; retain DEA credentials for CURES login |
| Admin (Maxi) | No role in performing CURES check. May flag scheduling reminders if CURES check is due for continuing treatment (6-month cycle). |

---

## Procedure

### Step 1: Determine Whether CURES Check Is Required

Before the appointment where a controlled substance prescription may be written:

- [ ] Confirm the substance being considered is Schedule II, III, IV, or V
- [ ] Confirm no exemption applies (see Exemptions section below)
- [ ] Confirm timing requirement is met (see timing table in Step 2)

If no exemption applies and the substance is Schedule II-V: the CURES check is **mandatory**. Proceed to Step 2.

---

### Step 2: Confirm CURES Check Timing

The CURES check must occur within the following time windows relative to the prescription being written:

| Situation | CURES Timing Requirement |
|-----------|--------------------------|
| First prescription of any Schedule II-IV controlled substance to this patient | Check CURES no earlier than 24 hours (or the previous business day) before writing the prescription |
| Continuing treatment — each subsequent prescription | Check within 24 hours (or the previous business day) before each prescription |
| Continuing treatment — ongoing monitoring requirement | Check CURES at minimum every 6 months even if Rx is not being changed |

**Critical rule:** The CURES check must happen at or immediately before the appointment where the prescribing decision is made — not days in advance. A check performed 3 days before the prescription is written does not satisfy the requirement.

**"Previous business day" interpretation:** If prescribing on Monday, a check performed Friday of the preceding week satisfies the 24-hour requirement.

- [ ] Confirm that the CURES check will be performed at today's appointment (or on the previous business day at the earliest)

---

### Step 3: Log In to CURES 2.0

- [ ] Open a browser and navigate to: **https://cures.doj.ca.gov/**
- [ ] Log in using your CURES practitioner account credentials
  - Username: [DEA-registered practitioner username — stored in 1Password shared vault under "CURES 2.0"]
  - Password: [stored in 1Password shared vault under "CURES 2.0"]
- [ ] Complete multi-factor authentication (MFA) if prompted
- [ ] If you have not registered for CURES 2.0: register at https://cures.doj.ca.gov/ using DEA registration number **FP3833933**

---

### Step 4: Search the Patient Record

- [ ] From the CURES 2.0 dashboard, select "Patient Activity Report" or "PAR"
- [ ] Enter the patient's information exactly as it appears in their pharmacy records:
  - [ ] First name (legal name)
  - [ ] Last name (legal name)
  - [ ] Date of birth
- [ ] Enter the date range for the Patient Activity Report (PAR):
  - Recommended range: prior 12 months (minimum prior 3 months for continuing treatment)
  - For patients with complex histories: extend to 24 months
- [ ] Submit the search and wait for results

---

### Step 5: Review the Patient Activity Report (PAR)

- [ ] Review all prescriptions listed in the PAR for the patient
- [ ] Specifically look for the following patterns:

| Pattern | Significance | Action |
|---------|-------------|--------|
| Multiple prescribers for the same substance class | Possible "doctor shopping" (obtaining prescriptions from multiple providers) | Verify medical necessity; document rationale; consider contacting prior prescriber |
| Multiple pharmacies filling controlled substance prescriptions | May indicate diversion (giving or selling medication to others) | Verify; document; consider requesting pharmacy records |
| High-dose opioids | Risk of overdose and dependency | Review clinical necessity; document rationale |
| Benzodiazepine + opioid combination | High-risk combination; significant overdose risk | Do not prescribe without documented peer consultation |
| Controlled substances already prescribed by another current provider | Therapeutic duplication | Coordinate with that provider before prescribing |
| No prior controlled substance history | Patient is not on any PDMP record | Note in documentation; lower concern, but not zero |

- [ ] Determine clinical decision (see Decision Points section below)

---

### Step 6: Document CURES Check in Tebra Clinical Note

Immediately after reviewing the PAR, document the CURES check in the patient's Tebra clinical note for today's appointment. Use the documentation template in Appendix A.

- [ ] Open today's clinical note in Tebra for this patient
- [ ] Complete the CURES Documentation Template (copy from Appendix A and fill in all fields)
- [ ] Save the clinical note — this documentation is a legal record

---

### Step 7: Make Prescribing Decision

Based on PAR findings and clinical judgment:

- [ ] **No concerning patterns found:** Proceed with prescription as clinically indicated
- [ ] **Concerning patterns found:** Apply Decision Points below before prescribing

See the Decision Points section for specific scenarios.

---

### Step 8: Write Prescription (if proceeding)

- [ ] Write the prescription through Tebra (or via DEA-compliant e-prescribing for controlled substances — EPCS — if configured)
- [ ] For Schedule II substances: electronic prescribing for controlled substances (EPCS) is required in California effective January 1, 2025 (CA H&S Code 11162.1). Exceptions exist for technical failures.
- [ ] Ensure the prescription includes DEA registration number **FP3833933**

---

## Decision Points

### DP-01: No Concerning Patterns in PAR

```
PAR reviewed — no red flags identified
  └── Proceed with prescription as clinically indicated
  └── Document in Tebra: "CURES checked [date]. No concerning patterns identified."
  └── Write prescription
```

### DP-02: Multiple Prescribers for Same Substance Class

```
PAR shows patient receiving same controlled substance class from multiple prescribers
  └── Do NOT prescribe without first:
      1. Documenting clinical rationale for prescribing despite multiple prescribers
      2. Attempting to contact prior prescriber to coordinate care
         (If prescriber cannot be reached: document attempt and outcome)
      3. Discussing findings with patient and documenting conversation
  └── If clinical rationale is established: may proceed with prescription
  └── If situation appears unsafe or patient is evasive: decline to prescribe; document decision
```

### DP-03: Benzodiazepine + Opioid Combination

```
PAR shows patient is currently prescribed both benzodiazepines and opioids
  └── Do NOT prescribe an additional controlled substance without:
      1. Peer consultation with a colleague or specialist (document who, date, recommendation)
      2. Full clinical rationale documented in Tebra note
      3. Patient discussion about combined risk of respiratory depression and overdose
  └── This combination carries significant overdose risk — err on the side of caution
```

### DP-04: PAR Shows Patterns Suggesting Diversion

```
PAR suggests possible diversion (multiple pharmacies, out-of-pattern prescriptions, discrepancies)
  └── Do NOT prescribe
  └── Request pharmacy records if appropriate
  └── Discuss findings with patient directly and document the conversation
  └── If diversion is suspected: consult with legal/risk counsel before prescribing
  └── Document all findings and clinical decisions thoroughly
```

### DP-05: CURES System Is Down (Technical Difficulties)

```
Unable to access CURES 2.0 due to system outage or technical error
  └── If the prescription is clinically urgent:
      → You may prescribe a non-refillable supply of up to 5 days
      → Document the following in Tebra:
          - Date and time CURES was attempted
          - Nature of the technical difficulty (error message, outage notice, etc.)
          - Clinical urgency justifying the limited supply
      → Check CURES as soon as the system is restored
      → Document the restored CURES check in the chart retroactively, noting it was delayed due to outage
  └── If the prescription is not urgent:
      → Do not prescribe until CURES is accessible
      → Reschedule or provide bridge with non-controlled medication
```

---

## Exemptions

The following situations are exempt from the CURES mandatory check requirement under CA H&S Code 11165.4. Document which exemption applies in the clinical note.

| Exemption | Condition | Limits |
|-----------|-----------|--------|
| Inpatient hospitalization | Patient is admitted to an inpatient hospital or licensed clinic | Applies during inpatient stay only |
| Emergency department | Patient is being treated in an emergency department | Non-refillable, 7-day supply maximum |
| Post-surgical acute pain | Patient had a surgical procedure and is in acute post-operative pain | Non-refillable, 5-day supply maximum |
| Hospice care | Patient is enrolled in a licensed hospice program | Applies for duration of hospice care |
| Technical difficulties | CURES 2.0 is inaccessible due to system outage or technical failure | Non-refillable, 5-day supply maximum; must check CURES as soon as system restores |

**No other exemptions exist.** If the situation does not match one of the above, the CURES check is mandatory.

---

## Non-Compliance Consequences

Failure to perform a mandatory CURES check before prescribing a Schedule II-V controlled substance in California constitutes a violation of CA H&S Code 11165.4 and may result in:

- Referral to the Medical Board of California for administrative review
- Administrative sanctions up to and including license suspension or revocation
- Civil liability in the event of patient harm attributable to the missed PDMP check

The Medical Board of CA treats CURES non-compliance seriously. There is no de minimis exception — even a single missed check on a Schedule II prescription is a reportable violation.

---

## Documentation Requirements

| Item | Where to Document | Deadline |
|------|------------------|----------|
| CURES check date and time | Tebra clinical note for today's appointment | Same day as CURES check (before prescription is written) |
| PAR date range searched | Tebra clinical note | Same day |
| PAR findings summary | Tebra clinical note | Same day |
| Clinical decision (proceed/decline/modify) | Tebra clinical note | Same day |
| Prescriber name and DEA number | Tebra clinical note | Same day |
| Any red flags found and rationale for decision | Tebra clinical note | Same day |
| Outage documentation (if technical difficulty exemption used) | Tebra clinical note | Same day; retroactive CURES check when system restored |
| 6-month continuing treatment check | Tebra clinical note at that appointment | At least every 6 months for ongoing controlled substance patients |

---

## Appendix A: CURES Documentation Template

Copy this template into every Tebra clinical note where a CURES check was performed:

---

**CURES PDMP Check Documentation**

- **Date of CURES query:** [MM/DD/YYYY]
- **Time of CURES query:** [HH:MM AM/PM]
- **PAR date range searched:** [from MM/DD/YYYY] to [MM/DD/YYYY]
- **Controlled substance(s) reviewed in PAR:** [list substance classes found, or "none on record"]
- **Findings summary:** [e.g., "No concerning patterns identified" OR "Multiple prescribers for benzodiazepine class — see note below" OR "No prior controlled substance history on record"]
- **Clinical decision:** [e.g., "Proceeding with Rx for [medication] as clinically indicated" OR "Declined to prescribe due to [reason]" OR "5-day bridge supply due to CURES system outage"]
- **Prescriber name:** Valentina Park, MD
- **DEA registration number:** FP3833933
- **Additional notes:** [any red flags, consultations, or patient discussions to document]

---

## References

| Reference | Authority |
|-----------|-----------|
| CA Health and Safety Code Section 11165.4 | Mandatory CURES use law — statutory basis for this SOP |
| Medical Board of California — CURES Mandatory Use Guidelines | Enforcement authority and interpretive guidance |
| CA H&S Code Section 11162.1 | Electronic prescribing requirement for Schedule II (effective 2025-01-01) |
| CURES 2.0 Portal | https://cures.doj.ca.gov/ |
| DEA Registration FP3833933 | Valentina Park, MD — required for CURES account and all controlled substance prescriptions |

---

*SOP-02 — Version 1.0 — Valentina Park MD, PC — Effective 2026-03-01*
