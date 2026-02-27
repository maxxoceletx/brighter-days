# Credential Inventory
## Valentina Park MD, Professional Corporation

**Document date:** 2026-02-27
**Version:** 2.0 (Phase 2 — Credential Vault & Monitoring)
**Prepared by:** Brighter Days Practice Management System

---

## Practice Identifiers

| Identifier | Value |
|------------|-------|
| Legal Entity | Valentina Park MD, Professional Corporation |
| Entity Type | S-Corporation (California) |
| Federal EIN | 99-1529764 |
| CA Secretary of State Entity | 6093174 |
| Individual NPI | 1023579513 |
| Group NPI | 1699504282 |
| CAQH ProView ID | 16149210 |
| Taxonomy Code | 2084P0800X (Psychiatry) |
| Practice Address | 2748 Pacific Coast Hwy #1084, Torrance, CA 90505 |
| Phone | (424) 248-8090 |
| Fax | (949) 703-8810 |

---

## Section 1: State Medical Licenses

| Credential | Number | Issuing Body | Status | Expiry Date | Renewal Portal |
|------------|--------|-------------|--------|-------------|----------------|
| California Medical License | A-177690 | CA Medical Board (BreEZe) | ACTIVE | 2028-06-30 | breeze.ca.gov |

**Notes:**
- Renewal cycle: Every 2 years. Continuing medical education (CME) requirements apply.
- Renewal portal: https://www.breeze.ca.gov/
- Annual renewal reminder recommended 90 days before expiry.

---

## Section 2: DEA Registration

| Credential | Number | Issuing Body | Status | Expiry Date | Schedules | Renewal Portal |
|------------|--------|-------------|--------|-------------|-----------|----------------|
| DEA Registration | FP3833933 | Drug Enforcement Administration | ACTIVE | 2027-03-31 | II–V | deaecom.gov |

**Notes:**
- Renewal cycle: Every 3 years. Online renewal only (paper eliminated 2024).
- Renewal portal: https://www.deaecom.gov/
- **Action required:** DEA registration currently lists a Walnut Creek address (prior employer CPS). Must be updated to Torrance practice address per 21 CFR 1301.51 before next re-credentialing cycle. Contact DEA Diversion Control (1-800-882-9539) to initiate address change.

---

## Section 3: Board Certifications

| Credential | Certificate | Issuing Body | Status | Expiry | Maintenance |
|------------|-------------|-------------|--------|--------|-------------|
| ABPN Psychiatry Certification | #83742 | American Board of Psychiatry and Neurology | ACTIVE | No expiry | Continuous Certification (CC) |
| ABPN Child & Adolescent Psychiatry | #13399 | American Board of Psychiatry and Neurology | ACTIVE | No expiry | Continuous Certification (CC) |

**Notes:**
- Both certifications are under ABPN's Continuous Certification program — no fixed expiry date.
- Annual participation in CC activities is required (ABPN online modules, practice improvement activities).
- Monitor ABPN communications for any requirement changes.
- Renewal portal: https://www.abpn.com/

---

## Section 4: CAQH ProView Attestation

| Credential | ID | Issuing Body | Status | Attestation Cycle | Renewal Portal |
|------------|-----|-------------|--------|-------------------|----------------|
| CAQH ProView Profile | 16149210 | Council for Affordable Quality Healthcare | ACTIVE | Every 120 days | proview.caqh.org |

**Notes:**
- **Critical:** CAQH re-attestation every 120 days is required to maintain in-network status with all 17 commercial payer panels simultaneously. One missed cycle can silently suspend all contracts.
- Alert cadence: 90 / 60 / 30 / 7 days before attestation expiry.
- Current attestation expiry date: **Verify in CAQH portal** — log into https://proview.caqh.org, find last attestation date, calculate expiry as last_attestation_date + 120 days, and update the Supabase credentials table.
- Estimated time per re-attestation: 5–20 minutes.
- Steps: Log in → Attestation tab → Review information → Submit.

---

## Section 5: Malpractice Insurance

| Credential | Policy | Issuing Body | Status | Coverage Period | Entity Coverage | Telehealth |
|------------|--------|-------------|--------|-----------------|-----------------|------------|
| CAP/MPT Malpractice Policy | #48289 | The Cooperative of American Physicians / MPT | ACTIVE | Through 2026-12-31 | Entity #10709 | Confirmed |

**Notes:**
- Renewal cycle: Annual.
- Renewal portal: https://www.cap-mpt.com/
- Telehealth coverage confirmed — policy covers synchronous video and telephone encounters.
- S-Corp entity coverage included under Entity #10709 — both individual provider and practice entity covered.
- Renew by November 30 to avoid gap in coverage at year-end.

---

## Section 6: Government Program Enrollments

| Program | Identifier | Status | Notes |
|---------|------------|--------|-------|
| Medicare PTAN (Group) | CB496693 | ACTIVE | Southern California — Noridian |
| Medicare PTAN (Individual) | CB496694 | ACTIVE | Southern California — Noridian |
| Medi-Cal PAVE | 100517999 | ACTIVE | EFT approved; annual re-enrollment required |

**Notes:**
- Medicare PTANs verified ACTIVE as of 2026-02-27 (Phase 2 correction — Phase 1 document audit showed DEACTIVATED 1/31/2026; Valentina confirmed enrollment is active).
- Medicare re-enrollment: Every 5 years via PECOS (https://pecos.cms.hhs.gov/). No current expiry.
- Medi-Cal timely filing: 12 months from date of service (statutory, not estimated).
- Medicare timely filing: 12 months from date of service (statutory, not estimated).

---

## Section 7: Business and Corporate Registrations

| Credential | Number | Issuing Body | Status | Expiry / Due | Renewal Portal |
|------------|--------|-------------|--------|--------------|----------------|
| Torrance Business License | BL-LIC-051057 | City of Torrance | **EXPIRED** | Was 2025-12-31 | torranceca.gov |
| CA Statement of Information | 6093174 | CA Secretary of State | PENDING VERIFY | Annual | bizfileplus.sos.ca.gov |
| CA S-Corp Registration | 6093174 | CA Secretary of State | ACTIVE | — | bizfileplus.sos.ca.gov |

**Notes:**
- **Immediate action required:** Torrance Business License BL-LIC-051057 expired December 31, 2025. Renew immediately at https://www.torranceca.gov/. Practicing without a current business license may trigger violations during payer audits.
- Statement of Information: Due annually from original filing date. Verify current filing status at https://bizfileplus.sos.ca.gov/.
- Renewal portals: https://www.torranceca.gov/ (business license), https://bizfileplus.sos.ca.gov/ (SOS filings).

---

## Section 8: Insurance Panel Status

| Payer | Tebra ID | Contract Status | Can Bill |
|-------|----------|-----------------|----------|
| Aetna | 60054 | ACTIVE | Yes |
| Blue Cross of California (Anthem) | 47198 | PENDING | No — awaiting countersignature |
| Blue Shield of California | 94036 | PENDING | No — contract execution pending |
| California Health & Wellness | 68069 | UNKNOWN | Unknown — verify with Mary |
| Cigna | 62308 | NOT EXECUTED | No |
| Cigna Behavioral Health | MCCBV | NOT EXECUTED | No |
| Coastal Communities Physician Network | CCPN1 | UNKNOWN | Unknown — verify with Mary |
| Facey Medical Foundation | 95432 | UNKNOWN | Unknown — verify with Mary |
| Health Net of California | 95567 | UNKNOWN | Unknown — verify with Mary |
| Hoag | HPPZZ | UNKNOWN | Unknown — verify with Mary |
| Kaiser Foundation Health Plan of Southern CA | 94134 | PENDING | No — DocuSign pending |
| Magellan Behavioral Health | 01260 | UNKNOWN | Unknown — verify with Mary |
| Medicaid of California (Medi-Cal) | 00148 | ACTIVE | Yes |
| Medicare of California Southern | 01182 | ACTIVE | Yes |
| Providence Health Plan | PHP01 | UNKNOWN | Unknown — verify with Mary |
| Torrance Hospital IPA | THIPA | UNKNOWN | Unknown — verify with Mary |
| Torrance Memorial Medical Center | TMMC1 | UNKNOWN | Unknown — verify with Mary |

**Summary:** 3 of 17 panels currently billable (Aetna, Medi-Cal, Medicare). 3 PENDING (Blue Cross CA, Blue Shield CA, Kaiser). 2 NOT EXECUTED (Cigna, Cigna Behavioral Health). 9 UNKNOWN — require verification with credentialing agent Mary.

---

## Footnotes

**[est.]** — Dates marked as estimated are calculated from known credentialing dates using industry-standard renewal cycles (3 years for commercial payers; 120 days for CAQH). Estimated dates are operationally useful for alert scheduling but must be verified against source documents and payer communications before submission to auditors or payers.

---

*Document generated 2026-02-27. Estimated dates marked [est.]. Verify all dates against source documents and portals before submission to auditors or payers. This document reflects data as of the generation date; payer contract statuses and credential expiry dates change. Maintain regular updates in the Supabase credential system.*
