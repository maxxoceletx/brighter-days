# Phase 1: Document Audit — Real Data Extracted
**Source:** 60+ files from Downloads/PRIVATE PRACTICE, Psychiatry Licensing, Malpractice CAPP, Credentialing
**Extracted:** 2026-02-27

## Master Identifiers (Confirmed)

| Field | Value |
|---|---|
| Legal Entity | Valentina Park MD, Professional Corporation |
| Entity Type | S-Corporation (CA) |
| EIN | 99-1529764 |
| CA State ID | 6093174 |
| Individual NPI | 1023579513 |
| Group NPI | 1699504282 |
| CAQH ID | 16149210 |
| Taxonomy | 2084P0800X (Psychiatry) |
| Practice Address | 2748 Pacific Coast Hwy #1084, Torrance, CA 90505 |
| Phone | (424) 248-8090 (Google Voice) |
| Fax | (949) 703-8810 (Tebra) |
| Email (professional) | valentinaparkmd@gmail.com; admin@valentinaparkmd.com |
| Website | valentinaparkmd.com (GoDaddy, renews 2027-06-13) |
| Owner | Valentina Park, MD (100%) |
| Admin/CTO | Maximilian Park (Maxi) |
| Privacy Officer | Maximilian Park |

## Credential Status (Verified Against Documents)

| Credential | Number | Status | Expires |
|---|---|---|---|
| CA Medical License | A-177690 | ACTIVE | 6/30/2028 |
| DEA Registration | FP3833933 | ACTIVE (address issue) | 3/31/2027 |
| ABPN Psychiatry | Cert #83742 | ACTIVE (CC compliant) | No expiry |
| ABPN Child & Adolescent | Cert #13399 | ACTIVE (CC compliant) | No expiry |
| Malpractice (CAP/MPT) | #48289 | ACTIVE (full-time from 1/1/2026) | 12/31/2026 |
| S-Corp Entity Coverage | Entity #10709 | ACTIVE | 12/31/2026 |
| Business License (Torrance) | BL-LIC-051057 | EXPIRED | 12/31/2025 |
| Medicare PTAN (Group) | CB496693 | DEACTIVATED 1/31/2026 | — |
| Medicare PTAN (Individual) | CB496694 | Unknown (linked to group) | — |
| Medi-Cal PAVE ID | 100517999 | Active | — |

## HIPAA Status (From HIPAA Compliance Record 2025.xlsx)

- **SRA:** Completed, all 11 threat categories assessed
- **Policies:** Privacy, Breach Notification, Device Security, Telehealth Use, Risk Assessment — all documented and staff trained
- **Technical Safeguards:** Access control, 2FA, TLS/SSL, audit controls — all complete
- **BAAs on file:** Tebra (EMR), telehealth platform, cloud backup provider
- **Breach Log:** No incidents
- **Gaps:** Contingency plan testing "in progress"; device disposal vendor not finalized
- **Next review:** ~August 2026

## Consent Forms Status

- **NPP:** Exists, effective 5/15/2025, properly branded to Valentina Park MD PC
- **Telehealth Informed Consent (B&P 2290.5):** DOES NOT EXIST for this practice. Only reference templates from prior employers (CPS one-paragraph, Renew TeleHealth/Struble template)
- **Minor/Parent Consent:** DOES NOT EXIST — critical given child/adolescent focus
- **Financial Policy:** No standalone document
- **After-Hours/Emergency Protocol:** Not documented

## Payer Credentialing Status (Verified Against Contracts)

| Payer | Status | Can Bill? | Key Issue |
|---|---|---|---|
| Medicare | DEACTIVATED 1/31/2026 | NO | Re-enroll via PECOS |
| Medi-Cal (DHCS) | Active, EFT approved | Yes | PAVE ID 100517999 |
| LA County DMH | Credentialed, contract unclear | Unclear | Contract MH660140 execution unconfirmed |
| Blue Shield of CA | Credentialed 8/7/2025 | Unclear | Contract effective date TBD |
| Blue Shield Promise | Credentialed 10/30/2024 | Unclear | Contract effective date TBD |
| Anthem Blue Cross | Provider-signed 5/20/2025 | NO | Anthem has NOT countersigned |
| Kaiser (SCPMG) | Contract sent via DocuSign | Unclear | Execution unconfirmed |
| Aetna | Active since 8/13/2024 | Yes (individual) | Group requires 2+ providers |
| Cigna/Evernorth | Documents requested 12/9/2024 | NO | Contract not executed |
| Carelon | Application submitted 7/23/2024 | NO | No approval on file after 18+ months |
| Tricare/HNFS | Application only | NO | TIN discrepancy (941706811 vs 991529764) |
| LACDMH | Pending | NO | Mary working on it |

## Critical Gaps (MUST address in Phase 1)

### CRITICAL (blocks first patient)
1. **Medicare DEACTIVATED** — No claims in 6+ months. Rebuttal deadline passed 2/13/2026. Must re-enroll via PECOS immediately.
2. **No telehealth consent (B&P 2290.5)** — Cannot see patients without a compliant informed consent form for telehealth.
3. **No minor/parent consent** — Cannot treat children without parent authorization, HIPAA minor confidentiality disclosures, assent forms.
4. **Business license expired** — BL-LIC-051057, City of Torrance, expired 12/31/2025.
5. **CAQH re-attestation date unknown** — If lapsed, could suspend all payer contracts.

### WARNING (address within 30 days)
6. **DEA address mismatch** — Registration shows Walnut Creek (CPS address), practice is Torrance. Must update per 21 CFR 1301.51.
7. **Anthem contracts unsigned by Anthem** — Both commercial and Medicaid agreements lack Anthem countersignature.
8. **Multiple payer contracts unconfirmed** — Blue Shield, Kaiser, Cigna, Carelon, Tricare status unclear.
9. **Sensitive data in plaintext** — SSN, passwords, portal credentials stored in unencrypted Word docs (Master Key.docx, liscensing notes.docx). Move to 1Password.
10. **Address inconsistencies** — Three addresses across documents: Torrance PCH (current), Walnut Creek (DEA), Palomino Lane (home/old). Medicare deactivation was sent to home address.
11. **No general liability insurance** — Required by most payer contracts.
12. **No workers' comp** — Required if Maxi is classified as employee.
13. **Tricare TIN discrepancy** — Application shows wrong TIN.
14. **DOB discrepancy** — 1991 vs 1992 across documents.

### INFO (nice to have)
15. **Contingency plan testing incomplete** (HIPAA)
16. **Device disposal vendor not finalized** (HIPAA)
17. **Contacts list nearly empty** — Only Tebra contact documented
18. **CME mandatory topic documentation missing** — 86.5 credits but CA-specific topics (pain mgmt, implicit bias, suicide prevention) not verified
19. **No tail coverage documentation** for pre-July 2024 clinical work
20. **PECOS web submission history empty** — Never used online portal

## Tebra Contract
- Effective: 3/7/2025, renews 5/7/2026
- Monthly: ~$339/month (Patient Pop + Practice Growth)
- E-Prescribe: Active
- Contact: Susan Delao (susan.delao@tebra.com)

## Key Contacts
- Mary — credentialing agent (contractor), handling payer applications
- Andy Miller (andy.miller@medheave.com) — credentialing specialist
- Susan Delao — Tebra Customer Loyalty
- Nanette Bordenave — Kaiser credentialing (Nanette.J.Bordenave@kp.org)

## Fee Schedules (Contracted Rates)
| Payer | 99214 | 90833 | 90785 | Total |
|---|---|---|---|---|
| Medicare | $137.58 | $77.86 | $15.21 | $230.65 |
| Blue Shield | $113.27 | $84.00 | $4.88 | $202.15 |
| Aetna | $94.50 | $85.00 | $16.55 | $196.05 |
| Cigna | $90.33 | $40.00 | $4.60 | $134.93 |
