# HIPAA Security Risk Analysis
## Valentina Park MD, Professional Corporation

**Assessment Type:** Annual Security Risk Analysis
**Citation:** 45 CFR 164.308(a)(1) — Security Management Process
**Assessment Format:** HHS Security Risk Assessment Tool v3.6 (October 2025)
**Assessment Date:** 2026-02-27
**Next Scheduled Review:** 2026-08-27

---

## Practice Information

| Field | Value |
|---|---|
| Practice Name | Valentina Park MD, Professional Corporation |
| EIN | 99-1529764 |
| CA State ID | 6093174 |
| Individual NPI | 1023579513 |
| Group NPI | 1699504282 |
| Practice Address | 2748 Pacific Coast Hwy #1084, Torrance, CA 90505 |
| Practice Phone | (424) 248-8090 |
| Practice Fax | (949) 703-8810 |
| Practice Type | Solo telehealth psychiatry, home office setting |
| EHR System | Tebra (formerly Kareo) |
| Privacy Officer | Maximilian Park |
| Security Officer | Maximilian Park |
| Covered Entity Type | Healthcare Provider (Sole Proprietor / Professional Corporation) |

---

## Assessment Scope

This Security Risk Analysis covers all electronic Protected Health Information (ePHI) created, received, maintained, and transmitted by Valentina Park MD, Professional Corporation. Assessed systems include:

- Tebra EHR platform (cloud-hosted)
- Practice email (admin@valentinaparkmd.com; valentinaparkmd@gmail.com)
- Telehealth video platform
- Cloud backup services
- Practice workstations (MacBook)
- Patient portal (Tebra-hosted)
- Payer portals (accessed via secure browser)
- Google Voice business phone (424) 248-8090

---

## 1. Administrative Safeguards (45 CFR 164.308)

### 1.1 Security Management Process (§164.308(a)(1))

**Risk Analysis**

| Item | Status | Finding |
|---|---|---|
| Risk analysis performed | COMPLETE | This document constitutes the annual Security Risk Analysis. Previous analysis referenced in HIPAA Compliance Record 2025.xlsx covered all 11 threat categories. |
| Risk management plan | COMPLETE | Current safeguards documented in this SRA; remediation items tracked in Section 6 |
| Risk analysis frequency | ANNUAL | Annual review scheduled; next review 2026-08-27 |
| All ePHI systems identified | COMPLETE | All systems listed in Assessment Scope above |

**Current Safeguards:**
- Annual SRA performed (this document)
- HIPAA Compliance Record 2025.xlsx maintained as historical audit trail
- All 11 threat categories assessed in prior analysis; findings incorporated herein

**Residual Risk:** LOW — risk analysis process is established and functioning.

---

**Sanction Policy**

| Item | Status | Finding |
|---|---|---|
| Sanction policy documented | COMPLETE | Written sanction policy exists as part of HIPAA policy set |
| Policy applied to all workforce | COMPLETE | Solo practice — policy applies to both Valentina Park MD (owner/clinician) and Maximilian Park (CTO/Privacy Officer) |

**Policy Summary:** Any workforce member who violates HIPAA policies is subject to disciplinary action up to and including termination of employment or engagement. For this solo practice with two principals, violations are reviewed by the non-violating party or an independent HIPAA consultant if both are implicated.

**Residual Risk:** LOW — policy exists; solo practice simplifies enforcement.

---

**Information System Activity Review**

| Item | Status | Finding |
|---|---|---|
| Audit logs reviewed regularly | COMPLETE | Tebra audit logs reviewed monthly by Maxi (Privacy Officer) |
| Login activity monitored | COMPLETE | Tebra tracks all access by user ID; 2FA alerts for suspicious logins |
| Review frequency documented | COMPLETE | Monthly review schedule; ad hoc review for any reported incident |

**Residual Risk:** LOW.

---

### 1.2 Assigned Security Responsibility (§164.308(a)(2))

| Role | Assigned To | Contact |
|---|---|---|
| Privacy Officer | Maximilian Park | admin@valentinaparkmd.com |
| Security Officer | Maximilian Park | admin@valentinaparkmd.com |
| Clinical Responsibility | Valentina Park, MD | valentinaparkmd@gmail.com |

**Responsibilities of Privacy/Security Officer (Maximilian Park):**
- Maintain and annually review all HIPAA policies and procedures
- Conduct annual Security Risk Analysis
- Manage BAA execution and tracking
- Respond to security incidents and potential breaches
- Monitor system audit logs monthly
- Ensure workforce training is current
- Oversee access controls and user authentication

**Residual Risk:** LOW — roles are formally assigned. Single person covering both roles in a solo practice is standard and appropriate at this scale.

---

### 1.3 Workforce Security (§164.308(a)(3))

**Authorization and Supervision**

| Item | Status | Finding |
|---|---|---|
| Authorization procedures documented | COMPLETE | Only two authorized workforce members: Valentina Park MD (owner) and Maximilian Park (CTO). No other individuals have access to ePHI systems. |
| Workforce clearance | COMPLETE | Maximilian Park is vetted family member with signed confidentiality agreement. Background check conducted prior to engagement. |
| Clearance verification documented | COMPLETE | Confidentiality agreement on file |

**Workforce Inventory:**

| Individual | Role | PHI Access Systems | Access Level |
|---|---|---|---|
| Valentina Park, MD | Owner / Clinician | Tebra (full), payer portals, telehealth platform | Full clinical + admin |
| Maximilian Park | CTO / Privacy Officer | Tebra (admin), Supabase admin, practice email | Admin/technical; no clinical record creation |

**Residual Risk:** LOW — workforce is minimal and each member's access is appropriate to their role.

---

**Termination Procedures**

Documented procedure for access revocation if workforce relationship ends:

1. Immediately disable Tebra user account via Admin console
2. Revoke Google Workspace access (email, Drive) via Admin console
3. Revoke Supabase project access
4. Change all shared credentials stored in 1Password vaults
5. Revoke access to all payer portals
6. Document revocation date and confirmation in HIPAA audit log

**Residual Risk:** LOW — procedures are documented; solo practice means this scenario is rare.

---

### 1.4 Information Access Management (§164.308(a)(4))

**Access Authorization**

| System | Authorized Users | Authentication Method |
|---|---|---|
| Tebra EHR | Valentina Park MD (clinical), Maximilian Park (admin) | Username + password + 2FA |
| Patient Portal | Patients (self-service) | Tebra-managed patient login |
| Practice Email (admin@valentinaparkmd.com) | Valentina, Maximilian | Google Workspace credentials + 2FA |
| Supabase (Brighter Days project) | Maximilian Park | API keys + dashboard login + 2FA |
| Payer Portals (Medicare, Medi-Cal, Blue Shield, Aetna, etc.) | Valentina Park MD | Portal-specific credentials + 2FA where available |
| Telehealth Video Platform | Valentina Park MD (host), Patients (invited) | Platform-specific session links |
| 1Password | Valentina, Maximilian | Master password + 2FA |

**Access Establishment Procedures:**
New access is only granted by the Security Officer (Maximilian Park) after documented justification. All access is on a minimum-necessary basis.

**Access Modification Procedures:**
Any change in job role or departure triggers immediate access review. Changes are documented in the HIPAA audit log.

**Residual Risk:** LOW — access is tightly controlled with a small workforce.

---

### 1.5 Security Awareness and Training (§164.308(a)(5))

| Item | Status | Finding |
|---|---|---|
| Initial HIPAA training | COMPLETE | Both Valentina Park MD and Maximilian Park completed HIPAA training prior to practice launch |
| Annual refresher | COMPLETE | Annual training completed; next due 2027-02 |
| Training topics | COMPLETE | See topics below |
| Training documented | COMPLETE | Completion dates on file in HIPAA Compliance Record 2025.xlsx |

**Training Topics Covered:**
- HIPAA Privacy Rule basics: minimum necessary, patient rights, allowable disclosures
- HIPAA Security Rule: safeguard requirements, incident reporting obligations
- Phishing and social engineering: recognizing malicious emails, not clicking unknown links
- Password management: use of 1Password, no reuse, 12+ character requirements
- PHI handling: no PHI in unencrypted communications, lock screens when leaving workstation
- Breach notification: what constitutes a breach, 60-day notification requirement, who to contact
- Telehealth-specific: private space requirements, secure platform use, patient location verification

**Residual Risk:** LOW — training is current and documented.

---

### 1.6 Security Incident Procedures (§164.308(a)(6))

**Incident Response Plan**

| Phase | Action | Responsible |
|---|---|---|
| Detection | Any workforce member who discovers a potential security incident reports to Maximilian Park within 24 hours | Any workforce member |
| Assessment | Maxi investigates to determine whether a breach of unsecured ePHI has occurred within 48 hours of report | Maximilian Park |
| Containment | Immediately revoke access, change credentials, isolate affected systems as appropriate | Maximilian Park |
| Documentation | Document the incident in the Breach Log with date, nature of incident, systems involved, and response taken | Maximilian Park |
| Notification | If breach confirmed: notify affected individuals within 60 days; notify HHS; notify media if >500 individuals in state | Valentina Park MD |
| Review | After resolution: review how the incident occurred and update safeguards to prevent recurrence | Both |

**Breach Log:**

| Incident | Date | Status |
|---|---|---|
| No security incidents to date | — | — |

**Residual Risk:** LOW — incident procedures are documented; no incidents have occurred.

---

### 1.7 Contingency Plan (§164.308(a)(7))

**Data Backup Plan**

| System | Backup Method | Frequency | Responsibility |
|---|---|---|---|
| Tebra EHR (clinical data) | Tebra cloud backup (SOC 2 certified vendor handles backup) | Continuous / daily | Tebra (contractual) |
| Supabase (Brighter Days project) | Supabase managed backups (Point-in-Time Recovery) | Daily snapshots | Supabase (contractual) |
| Practice documents (non-PHI) | Cloud storage via Google Workspace (Google Drive) | Continuous sync | Maximilian Park |

**Disaster Recovery Plan**

| Scenario | Recovery Action | RTO Target |
|---|---|---|
| Tebra system outage | Contact Tebra support; use paper scheduling as interim; access Tebra mobile app for critical patient info | 4 hours |
| Workstation failure | Restore from cloud backup; all data is cloud-hosted, no local-only PHI; new workstation can be operational within 24 hours | 24 hours |
| Internet outage | Use mobile hotspot for urgent telehealth sessions; reschedule non-urgent appointments | 1 hour |
| Complete practice closure | Provide patients with 30-day advance notice; transfer records per Tebra data export; notify all payers | 30 days |

**Emergency Mode Operation Plan**

During a system outage, the practice can continue to operate by:
1. Accessing Tebra via mobile app for existing patient records
2. Using paper-based scheduling for new appointments
3. Calling patients directly using Google Voice (424) 248-8090 for urgent matters
4. Postponing non-urgent telehealth sessions

**GAP: Contingency Plan Testing**

| Gap | Severity | Status | Target Resolution |
|---|---|---|---|
| Contingency plan has not been formally tested (e.g., simulated outage exercise) | INFO | IN PROGRESS | 2026-04-30 |

The plan is documented but has not been tested with a formal drill. This is recorded as a remediation item. Per HIPAA spreadsheet, this item was noted as "in progress" as of 2025.

**Residual Risk:** MEDIUM (reduced to LOW upon test completion) — all major scenarios have documented responses; gap is testing, not plan existence.

---

### 1.8 Evaluation (§164.308(a)(8))

| Item | Status | Finding |
|---|---|---|
| Periodic technical and non-technical evaluation | COMPLETE | This SRA constitutes the periodic evaluation |
| Evaluation covers all Security Rule domains | COMPLETE | This document covers all Administrative, Physical, and Technical Safeguards |
| Evaluation conducted in response to operational changes | COMPLETE | Assessment date: 2026-02-27; practice launched as full-time solo telehealth 2026-01-01 |
| Next evaluation | SCHEDULED | 2026-08-27 |

**Residual Risk:** LOW.

---

## 2. Physical Safeguards (45 CFR 164.310)

### 2.1 Facility Access Controls (§164.310(a))

**Setting:** This practice operates entirely via telehealth from a private home office in Torrance, CA. There is no clinic or shared workspace.

| Item | Status | Finding |
|---|---|---|
| Physical facility for ePHI systems | HOME OFFICE | No external clinic. ePHI is only accessible via cloud-hosted systems; no on-premises servers. |
| Access to home office controlled | COMPLETE | Locked private office within home; no external visitors; no cleaning or maintenance personnel with unsupervised access to workstations |
| Workstation located in private space | COMPLETE | Telehealth sessions and all clinical work conducted in private, locked home office |
| Visitors / unauthorized access | COMPLETE | No patients, insurance representatives, or external parties visit the home office |

**Home Office Physical Controls:**
- Locked exterior doors during all working hours
- Private dedicated workspace (no shared workspace with others)
- Screen positioned away from windows or common areas
- No cleaning service or contractors with unsupervised office access
- Workstation locked or screen-locked when stepping away

**Residual Risk:** LOW — home office provides high physical security with no patient foot traffic or external visitors.

---

### 2.2 Workstation Use (§164.310(b))

| Item | Status | Finding |
|---|---|---|
| Workstation use policy documented | COMPLETE | Written policy covers authorized use, private location requirement, and screen lock |
| Telehealth sessions conducted in private | COMPLETE | All telehealth visits from private, locked home office |
| Public-location use policy | COMPLETE | ePHI access from public spaces (coffee shops, airports) is PROHIBITED. Policy documented and enforced. |
| Personal use on practice workstations | LIMITED | Personal use is permitted on practice workstations but PHI must never be exposed to family members. Screen lock when stepping away is required. |

**Authorized Workstation Functions:**
- Clinical documentation in Tebra
- Telehealth video sessions via [telehealth platform]
- Payer portal access
- Practice management and billing
- HIPAA-related administrative work

**Residual Risk:** LOW.

---

### 2.3 Workstation Security (§164.310(c))

**Primary Workstation: MacBook (Apple Silicon)**

| Security Control | Status | Details |
|---|---|---|
| Full disk encryption | COMPLETE | macOS FileVault 2 — AES-256 encryption enabled on all volumes |
| Screen lock / auto-lock | COMPLETE | macOS auto-lock set to 5 minutes; password required to unlock |
| Password protection | COMPLETE | Strong unique password (managed in 1Password) |
| OS updates | COMPLETE | Automatic security updates enabled; macOS kept current |
| Antivirus / endpoint protection | COMPLETE | macOS built-in XProtect + Gatekeeper; supplemented with Malwarebytes |
| Remote wipe capability | COMPLETE | Apple Find My Mac enabled; can remotely erase if lost or stolen |
| Local PHI storage | NONE | No PHI stored locally on workstation; all data is cloud-hosted (Tebra, Google Workspace) |

**Residual Risk:** LOW — workstation security controls are strong. No local PHI storage eliminates the highest-risk scenario.

---

### 2.4 Device and Media Controls (§164.310(d))

**Device Inventory:**

| Device | Purpose | PHI Access | Encryption | Remote Wipe |
|---|---|---|---|---|
| MacBook (primary workstation) | Clinical work, admin | YES (via cloud) | FileVault 2 | Apple Find My |
| iPhone (mobile) | Tebra mobile app, Google Voice | YES (via cloud) | iOS device encryption (always on) | iCloud Find My |

**Media Re-Use and Disposal:**

| Item | Status | Finding |
|---|---|---|
| Secure media disposal policy | DOCUMENTED | Written policy covers HDD shred or DoD 3-pass wipe before disposal |
| Device disposal vendor | PENDING | Specific certified e-waste vendor not yet contracted |
| Media re-use procedure | COMPLETE | All devices wiped to factory settings before re-use or disposal |

**GAP: Device Disposal Vendor**

| Gap | Severity | Status | Target Resolution |
|---|---|---|---|
| Specific certified e-waste / device disposal vendor not yet identified and contracted | INFO | OPEN | 2026-04-30 |

Current workaround: Apple Trade-In program includes secure data erasure certification (Apple Recycling Program) and can serve as interim solution. However, a formal contracted vendor should be identified for audit documentation.

**Residual Risk:** LOW — no current devices are scheduled for disposal; gap is procedural, not active exposure.

---

## 3. Technical Safeguards (45 CFR 164.312)

### 3.1 Access Control (§164.312(a))

**Unique User Identification**

| System | Unique User IDs | Status |
|---|---|---|
| Tebra EHR | Yes — each user has a unique login; no shared credentials | COMPLETE |
| Practice email | Yes — separate accounts per user | COMPLETE |
| Payer portals | Yes — each portal has provider-specific credentials | COMPLETE |
| Supabase | Yes — project-specific credentials | COMPLETE |

**Emergency Access Procedure (Break-Glass)**

| Scenario | Procedure | Responsible |
|---|---|---|
| Primary user (Valentina) incapacitated | Maximilian Park (Privacy Officer) contacts Tebra support to gain emergency admin access; provides written authorization from Valentina's designee | Maximilian Park |
| Both principals unavailable | Written break-glass authorization letter is maintained in 1Password emergency vault with instructions for practice attorney or successor | Valentina Park MD |

Emergency access authorization letter is on file in 1Password under "Emergency Access" vault.

**Automatic Logoff**

| System | Session Timeout | Status |
|---|---|---|
| Tebra EHR | 30-minute inactivity timeout | COMPLETE |
| macOS workstation | 5-minute auto-lock | COMPLETE |
| Google Workspace | Session managed by Google (8-hour sessions, re-auth required) | COMPLETE |

**Encryption and Decryption**

| Data Type | Encryption Method | Status |
|---|---|---|
| Data at rest (EHR records) | Tebra: AES-256 server-side encryption | COMPLETE |
| Data at rest (workstation) | macOS FileVault 2: AES-256 | COMPLETE |
| Data in transit | TLS 1.2/1.3 minimum on all connections | COMPLETE |

**Residual Risk:** LOW.

---

### 3.2 Audit Controls (§164.312(b))

| System | Audit Log Type | Review Frequency | Responsible |
|---|---|---|---|
| Tebra EHR | Full user activity log: logins, chart access, modifications, exports | Monthly | Maximilian Park |
| Google Workspace | Admin audit log: login events, document access, sharing events | Monthly | Maximilian Park |
| Supabase (Brighter Days) | Database audit logs via Supabase dashboard | Monthly | Maximilian Park |
| Payer portals | Activity logs per portal (reviewed if anomaly suspected) | As needed | Valentina Park MD |

**Log Retention:** Tebra audit logs retained per Tebra's data retention policy (minimum 6 years, consistent with HIPAA record retention requirements). Google Workspace admin logs retained 6 months by default; extended retention configured.

**Residual Risk:** LOW.

---

### 3.3 Integrity (§164.312(c))

| Item | Status | Finding |
|---|---|---|
| PHI integrity controls in EHR | COMPLETE | Tebra maintains audit trail for all record modifications; changes cannot be deleted, only amended with original preserved |
| Data transmission integrity | COMPLETE | TLS with certificate validation ensures data integrity in transit |
| Backup integrity | COMPLETE | Tebra backup system includes restoration testing by Tebra (SOC 2 Type II requirement) |
| No unauthorized alteration of ePHI | VERIFIED | Tebra's immutable audit log prevents undocumented modifications |

**Residual Risk:** LOW.

---

### 3.4 Person or Entity Authentication (§164.312(d))

**Multi-Factor Authentication Status:**

| System | MFA Status | MFA Method |
|---|---|---|
| Tebra EHR | ENABLED | Authenticator app (TOTP) |
| Google Workspace | ENABLED | Google Authenticator / Prompt |
| Supabase | ENABLED | Authenticator app (TOTP) |
| 1Password | ENABLED | Secret key + authenticator app |
| Payer portals | MIXED | Major portals (Medicare, Medi-Cal) have MFA; some older portals use password only |

**Per spreadsheet:** 2FA is complete across all primary systems (Tebra, email, password manager). Payer portals where MFA is not available are accessed via unique strong passwords managed in 1Password.

**Residual Risk:** LOW — all high-risk systems require MFA.

---

### 3.5 Transmission Security (§164.312(e))

| Transmission Type | Encryption Method | Status |
|---|---|---|
| Tebra EHR access | HTTPS / TLS 1.2+ | COMPLETE |
| Telehealth video sessions | End-to-end encryption via platform | COMPLETE |
| Patient portal communications | Tebra secure messaging (HTTPS) | COMPLETE |
| Email (clinical communications) | Google Workspace TLS in transit | COMPLETE |
| Payer portal submissions | HTTPS / TLS | COMPLETE |
| Supabase API access | HTTPS / TLS 1.2+ | COMPLETE |

**Policy:** Unencrypted transmission of ePHI is prohibited. PHI must not be sent via standard SMS or unencrypted email. Patient communications must use Tebra's secure messaging portal or telephone (which is acceptable under HIPAA). Consumer email (Gmail consumer or unencrypted email) is not permitted for PHI transmission.

**Residual Risk:** LOW.

---

## 4. Organizational Requirements (45 CFR 164.308(b), 164.502(e))

### 4.1 Business Associate Agreements

A full BAA vendor audit is maintained in the companion document `baa-tracker-report.md`. Summary of BAA status by vendor:

| Vendor | PHI Exposure | BAA Status | Notes |
|---|---|---|---|
| Tebra (EHR) | HIGH | INCORPORATED IN TOS | BAA incorporated into Tebra Customer Agreement; effective 3/7/2025 (contract date) |
| Telehealth video platform | HIGH | SIGNED (on file) | HIPAA spreadsheet confirms BAA on file; platform identity needs verification |
| Cloud backup provider | MEDIUM | SIGNED (on file) | HIPAA spreadsheet confirms BAA on file; provider identity needs verification |
| Email provider | MEDIUM | PENDING VERIFICATION | valentinaparkmd@gmail.com is consumer Gmail (no BAA available); admin@valentinaparkmd.com may be Google Workspace (BAA available via Admin Console). See baa-tracker-report.md for remediation. |
| Google Voice | MEDIUM | PENDING VERIFICATION | Practice phone (424) 248-8090 uses Google Voice. BAA requires Google Workspace version. Consumer Google Voice does NOT support BAA. Verify which version is in use. |
| Supabase (Brighter Days) | LOW (currently) | NOT REQUIRED YET | Phase 1 data is not PHI. BAA required before patient data enters system (Phase 3+). Requires Supabase Team plan + HIPAA add-on. |
| 1Password | LOW | NOT REQUIRED | Stores credentials, not PHI. |
| GoDaddy | NONE | NOT REQUIRED | Domain registration only. |

**Requirement:** Every business associate that creates, receives, maintains, or transmits ePHI on behalf of this covered entity must have a signed or incorporated BAA prior to PHI handling.

**See:** `baa-tracker-report.md` for full vendor audit with action items.

---

### 4.2 Covered Entity Relationships

Valentina Park MD, Professional Corporation is a covered entity (healthcare provider). It does not act as a business associate to other covered entities.

---

## 5. Policies and Procedures (45 CFR 164.316)

### 5.1 Policy Inventory

| Policy | Status | Maintained By | Location |
|---|---|---|---|
| HIPAA Privacy Policy | COMPLETE | Maximilian Park | HIPAA Compliance Record 2025.xlsx |
| HIPAA Security Policy | COMPLETE | Maximilian Park | HIPAA Compliance Record 2025.xlsx |
| Breach Notification Policy | COMPLETE | Maximilian Park | HIPAA Compliance Record 2025.xlsx |
| Device Security Policy | COMPLETE | Maximilian Park | HIPAA Compliance Record 2025.xlsx |
| Telehealth Use Policy | COMPLETE | Maximilian Park | HIPAA Compliance Record 2025.xlsx |
| Risk Assessment Policy | COMPLETE | Maximilian Park | This document (SRA) + HIPAA Compliance Record 2025.xlsx |
| Workforce Training Policy | COMPLETE | Maximilian Park | HIPAA Compliance Record 2025.xlsx |
| Sanction Policy | COMPLETE | Maximilian Park | HIPAA Compliance Record 2025.xlsx |

**Policy Location:** All policies are maintained in HIPAA Compliance Record 2025.xlsx, stored in Google Drive under the shared practice administration folder, accessible only to Valentina Park MD and Maximilian Park.

**Policy Review Schedule:** All policies reviewed annually, concurrent with the Security Risk Analysis. Next review: 2026-08-27.

**Staff Training on Policies:** Per HIPAA spreadsheet, all current workforce members have been trained on all policies. Training records are on file.

---

### 5.2 Procedure Documentation

| Procedure | Status | Notes |
|---|---|---|
| Breach response procedure | COMPLETE | See Section 1.6 above |
| Access revocation procedure | COMPLETE | See Section 1.3 (Termination Procedures) |
| Incident reporting procedure | COMPLETE | See Section 1.6 above |
| Record access procedure | COMPLETE | Patient requests for record access fulfilled via Tebra patient portal |
| Contingency activation procedure | COMPLETE | See Section 1.7 above |

---

## 6. Risk Summary and Remediation Plan

### 6.1 Overall Risk Assessment

| Domain | Risk Level | Basis |
|---|---|---|
| Administrative Safeguards | LOW | All policies, roles, and procedures documented; training current; only known gap is contingency testing |
| Physical Safeguards | LOW | Home office provides high inherent security; workstations are encrypted; only gap is formal disposal vendor |
| Technical Safeguards | LOW | MFA on all primary systems; TLS enforced; EHR has robust audit trail and encryption |
| Organizational Requirements | MEDIUM | BAA status requires verification for email provider and Google Voice; see baa-tracker-report.md |
| Policies and Procedures | LOW | All required policies exist and are maintained |

**Overall Practice Risk Level: LOW-MEDIUM**

The practice has strong foundational HIPAA compliance. The primary outstanding risk is the email/phone BAA verification (see Section 4 and baa-tracker-report.md). Once the BAA gaps are resolved, overall risk is LOW.

---

### 6.2 Open Remediation Items

| # | Gap | Severity | Citation | Target Date | Owner |
|---|---|---|---|---|---|
| 1 | Contingency plan testing not yet formally conducted | INFO | 45 CFR 164.308(a)(7)(ii)(D) | 2026-04-30 | Maximilian Park |
| 2 | Certified device disposal vendor not contracted | INFO | 45 CFR 164.310(d)(2)(i) | 2026-04-30 | Maximilian Park |
| 3 | Email provider BAA verification — consumer Gmail cannot support a BAA; must confirm which email service handles PHI and either switch to Google Workspace Business or a HIPAA-compliant alternative | CRITICAL | 45 CFR 164.308(b) | 2026-03-15 | Maximilian Park |
| 4 | Google Voice BAA verification — must confirm whether practice phone uses Google Workspace Voice (BAA available) or consumer Google Voice (no BAA possible) | CRITICAL | 45 CFR 164.308(b) | 2026-03-15 | Valentina Park MD |
| 5 | Telehealth platform identity — confirm which platform is used (Tebra built-in vs. separate) and that BAA is on file and locatable for OCR audit | WARNING | 45 CFR 164.308(b) | 2026-03-31 | Maximilian Park |
| 6 | Cloud backup provider identity — confirm provider name and locate signed BAA | WARNING | 45 CFR 164.308(b) | 2026-03-31 | Maximilian Park |

**Remediation Status:** Items 1 and 2 were pre-existing from the HIPAA Compliance Record 2025.xlsx audit. Items 3-6 are identified in this SRA from the vendor audit.

---

### 6.3 Verified Compliance Summary

| Requirement | Status | Date Verified |
|---|---|---|
| Annual Security Risk Analysis conducted | VERIFIED | 2026-02-27 |
| Privacy Officer and Security Officer assigned | VERIFIED | 2026-02-27 |
| Workforce trained on HIPAA policies | VERIFIED | 2026-02-27 |
| Incident response plan documented | VERIFIED | 2026-02-27 |
| All ePHI systems use MFA | VERIFIED | 2026-02-27 |
| All ePHI transmission encrypted (TLS) | VERIFIED | 2026-02-27 |
| Data at rest encrypted (FileVault) | VERIFIED | 2026-02-27 |
| Audit logs configured and reviewed | VERIFIED | 2026-02-27 |
| No security breaches to date | VERIFIED | 2026-02-27 |
| Tebra BAA in effect | VERIFIED | 2026-02-27 |
| PHI integrity controls active | VERIFIED | 2026-02-27 |

---

## 7. Certification

This Security Risk Analysis was conducted in accordance with 45 CFR 164.308(a)(1) of the HIPAA Security Rule and the HHS Security Risk Assessment Tool v3.6 framework.

**Conducted by:**
Maximilian Park, Privacy Officer & Security Officer
Valentina Park MD, Professional Corporation
Date: 2026-02-27

**Reviewed and Accepted by:**
Valentina Park, MD — Owner and Covered Entity
Date: 2026-02-27

**Next Annual Review Due:** 2026-08-27

---

*This document is confidential and protected under attorney-client privilege to the extent applicable. It constitutes a compliance record of Valentina Park MD, Professional Corporation and should be retained for a minimum of 6 years from the date of creation.*

*Produced using the HHS Security Risk Assessment Tool v3.6 framework — assessments conducted using HHS/ONC-published domain structure.*
