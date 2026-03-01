# Third-Party Biller Onboarding and Oversight
### SOP-05 — Valentina Park MD, Professional Corporation
### Standard Operating Procedure — Billing Operations

**Document ID:** SOP-05
**Version:** 2026-03 | **Next Review:** 2027-03
**Owner:** Maxi (CTO) — biller onboarding and oversight is an administrative function
**Reviewer/Approver:** Valentina Park, MD
**Current Biller:** Nexus Billing (already selected; BAA already signed)
**Legal Authority:** HIPAA Privacy Rule 45 CFR 164.502(b) (minimum necessary standard); HIPAA Security Rule 45 CFR 164.312 (access controls)

---

## 1. Purpose

This SOP provides a complete, step-by-step process for onboarding a third-party billing company to the practice. Any future CTO or administrator can follow this document to onboard a replacement biller without prior context.

**Scope:** Use this SOP when (a) onboarding a new third-party biller for the first time, or (b) replacing an existing biller with a new one. Also use as a periodic reference when reviewing the existing biller relationship.

**Current biller:** Nexus Billing. All decision fields that say "already completed" or "reference only" apply to Nexus Billing's initial onboarding.

---

## 2. Roles and Responsibilities

| Role | Responsibility |
|------|---------------|
| **Maxi (CTO)** | Creates Tebra user account, delivers onboarding data packet, monitors biller performance, serves as primary escalation point for operational issues |
| **Valentina Park, MD (Provider)** | Approves all diagnosis and CPT code decisions, reviews denied claims if clinical documentation is required, final authority on clinical coding |
| **Nexus Billing (Third-Party Biller)** | Submits claims via Tebra, manages accounts receivable follow-up, reports denials same-day to Maxi, provides monthly performance summary |

---

## 3. Onboarding Procedure

### Step 1: Confirm BAA is Executed

- [ ] Verify that a signed Business Associate Agreement (BAA) exists with the billing company before granting any system access.
- [ ] **For Nexus Billing:** BAA is already signed. Reference only — do not create a new BAA checklist.
- [ ] Document BAA execution date and storage location in 1Password (see Step 3).

**If onboarding a new biller:** A BAA is required before any PHI can be shared. Do not proceed past this step without a signed BAA.

---

### Step 2: Create Tebra User Account for Biller

- [ ] Log into Tebra as System Admin (Maxi's account).
- [ ] Navigate to: **Settings > Users > Add User**.
- [ ] Enter the biller's contact name and work email address.
- [ ] **Role: Select "Biller" — NOT Billing Manager, NOT System Admin.**

  > See Section 4 (HIPAA Minimum Necessary) for why this specific role is required. Do not deviate from the Biller role without a documented need reviewed by Maxi and Valentina.

- [ ] Practice access: Enable access for **Valentina Park MD, Professional Corporation** only.
- [ ] Send the Tebra invitation (user sets their own password).
- [ ] Verify: Biller contacts Maxi to confirm they can access:
  - [ ] Charge entries
  - [ ] Claims status
  - [ ] Patient demographic information (limited)
  - [ ] Insurance information
- [ ] Record the Tebra invitation date in 1Password (see Step 3).

---

### Step 3: Document Biller Access in 1Password

Store all biller-related records in the **1Password shared vault**, category: **Billing & Revenue > Nexus Billing** (per Phase 2 vault spec — 1password-vault-spec.md).

- [ ] Create or update the Nexus Billing entry in 1Password with:
  - [ ] Biller company name
  - [ ] Primary contact name and title
  - [ ] Primary contact phone number
  - [ ] Primary contact email
  - [ ] Tebra username / login email
  - [ ] Tebra user creation date
  - [ ] BAA execution date
  - [ ] BAA storage location (e.g., "Signed BAA in Google Drive > Legal > Nexus Billing BAA 2025-XX-XX.pdf")
  - [ ] Payment model: percentage of collections
  - [ ] Contract start date

**Security requirement:** Never share PHI, EIN, DEA numbers, or NPI over unencrypted email. Use 1Password's secure sharing link or an encrypted file transfer. The onboarding data packet (Step 4) must be delivered via secure channel.

---

### Step 4: Deliver Onboarding Data Packet

The biller needs the following data to begin submitting claims. Deliver this packet via secure channel (1Password shared link or equivalent encrypted transfer — not plain email).

| Data Element | Value | Source |
|-------------|-------|--------|
| Individual NPI | 1023579513 | Phase 2 credential-inventory.md |
| Group NPI | 1699504282 | Phase 2 credential-inventory.md |
| DEA Number | FP3833933 | Phase 2 credential-inventory.md |
| Federal Tax ID / EIN | 99-1529764 | Phase 2 credential-inventory.md |
| Practice Address | 2748 Pacific Coast Hwy #1084, Torrance, CA 90505 | Practice records |
| Practice Phone | (424) 248-8090 | Practice records |
| CA Medical License | A-177690 | Phase 2 credential-inventory.md |
| CAQH ProView ID | 16149210 | Phase 2 credential-inventory.md |
| Taxonomy Code | 2084P0800X (Psychiatry) | Phase 2 credential-inventory.md |
| **All 17 payer IDs and contracts** | See payer list below | Phase 2 payer-tracker-seed.sql |
| Standard CPT codes | 90791, 99213, 99214, 99215, 90833, 90836, 90838 | See note below |
| Fee schedule | Medicare rates as baseline | [Valentina to confirm or provide custom schedule] |

**CPT Code Reference (standard psychiatry outpatient):**

| CPT Code | Description |
|----------|-------------|
| 90791 | Psychiatric diagnostic evaluation (initial intake, 60 min) |
| 99213 | Office visit, established patient, low complexity (20–29 min) |
| 99214 | Office visit, established patient, moderate complexity (30–39 min) |
| 99215 | Office visit, established patient, high complexity (40–54 min) |
| 90833 | Psychotherapy add-on, 16–37 min (billed with 99213/99214) |
| 90836 | Psychotherapy add-on, 38–52 min (billed with 99214/99215) |
| 90838 | Psychotherapy add-on, 53+ min (billed with 99215) |

**All 17 payer IDs (from Phase 2 payer tracker):**

| Payer | Tebra Payer ID |
|-------|----------------|
| Aetna | 60054 |
| Blue Cross of California (Anthem) | 47198 |
| Blue Shield of California | 94036 |
| California Health & Wellness | 68069 |
| Cigna | 62308 |
| Cigna Behavioral Health | MCCBV |
| Coastal Communities Physician Network | CCPN1 |
| Facey Medical Foundation | 95432 |
| Health Net of California | 95567 |
| Hoag | HPPZZ |
| Kaiser Foundation Health Plan of Southern CA | 94134 |
| Magellan Behavioral Health | 01260 |
| Medicaid of California (Medi-Cal) | 00148 |
| Medicare of California Southern | 01182 |
| Providence Health Plan | PHP01 |
| Torrance Hospital IPA | THIPA |
| Torrance Memorial Medical Center | TMMC1 |

**Note on contract status:** As of 2026-02, only 3 panels are currently billable (Aetna, Medi-Cal, Medicare). 3 are pending contract execution, 2 are not yet executed, and 9 are unknown status. Confirm current billable panels with Maxi before biller begins submitting claims to avoid denied authorizations.

- [ ] Compile all data elements above into a secure packet.
- [ ] Deliver packet to biller contact via secure channel (not email).
- [ ] Biller confirms receipt in writing (email or text is acceptable for confirmation; the data itself must be delivered securely).

---

### Step 5: Verify Biller is Operational

- [ ] Biller confirms they can view charge entries in Tebra.
- [ ] Biller confirms they can view claims status in Tebra.
- [ ] Within 5 business days of access setup, confirm first real claim has been submitted (or a test claim if practice is pre-launch).
- [ ] Biller provides their primary contact name, direct phone number, and email — document in 1Password (Step 3).
- [ ] Confirm denial notification protocol with biller: same-day contact when a denial is received (see Section 5).

**Onboarding complete.** Move biller to ongoing oversight mode (Section 5).

---

## 4. HIPAA Minimum Necessary Standard — Biller Role

**Why the "Biller" role, and not Billing Manager or System Admin?**

The **Biller** role in Tebra exposes only financial and administrative PHI — the minimum data set a billing company needs to do their job. It explicitly excludes clinical PHI.

### What the Biller Role Can Access

| Access | Included |
|--------|----------|
| Charge entries | Yes |
| Claims status and history | Yes |
| Patient collections and balances | Yes |
| Payout and revenue reports | Yes |
| Patient demographic information (limited) | Yes |
| Appointment scheduling (limited) | Yes |
| Insurance information | Yes |
| Messages (billing-related) | Yes |

### What the Biller Role Cannot Access

| Access | Blocked |
|--------|---------|
| Clinical notes and progress notes | Yes — blocked |
| Prescriptions and medication history | Yes — blocked |
| Clinical documentation and assessments | Yes — blocked |
| User management | Yes — blocked |
| Practice settings and configuration | Yes — blocked |
| Admin-level reports | Yes — blocked |

**HIPAA compliance note:** HIPAA's minimum necessary standard (45 CFR 164.502(b)) requires that only the minimum amount of PHI necessary to accomplish the intended purpose be shared. For billing, that means financial and administrative data — not clinical records. The Biller role enforces this boundary at the system level.

**Policy:** If Nexus Billing (or any future biller) requests elevated Tebra access (Billing Manager or System Admin), Maxi evaluates the specific need at the task level. Accommodate specific needs without upgrading the role. If a task genuinely requires elevated access (rare), document the exception in 1Password and restrict the elevated access to the minimum timeframe needed. Never permanently upgrade the biller role.

---

## 5. Reporting Expectations and Ongoing Oversight

### 5.1 Per-Claim Visibility

All claims submitted through Tebra flow data back to the practice in real time. Maxi (and Valentina, when needed) can view every claim's status directly in Tebra at any time. This is by design — per-claim visibility is a locked practice decision.

Monthly summary reports from Nexus Billing supplement (but do not replace) real-time Tebra visibility.

### 5.2 Denial Notification

**Requirement:** When Nexus Billing receives a denial on any claim, they must contact Maxi **the same business day** via phone or text. Denials are not batched or held for the monthly report.

**Why same-day:** Denied claims have appeal windows (typically 60–180 days depending on payer). Delayed notification reduces the window available for appeal. For psychiatry, the denial rate benchmark is 5–10%; if denials are not caught quickly, the practice's AR aging worsens rapidly.

### 5.3 Monthly Summary Report

Nexus Billing provides a written monthly summary report including:

| Metric | Description |
|--------|-------------|
| Claims submitted (count) | Total claims sent to payers during the month |
| Claims paid (count + amount) | Claims adjudicated and paid |
| Outstanding AR by aging bucket | 0–30, 31–60, 61–90, 90+ days |
| Denial rate (%) | Denials as a percentage of submitted claims |
| Denial reasons (top 3) | Most common denial codes/reasons |
| Patient responsibility collected | Copays, coinsurance, deductibles collected |

Report due: **By the 10th business day of the following month.**

### 5.4 Biller Performance Benchmarks

| Metric | Green | Yellow (Watch) | Red (Action Required) |
|--------|-------|----------------|----------------------|
| Denial rate | < 10% | 10–15% | > 15% |
| AR days outstanding | < 45 days | 45–60 days | > 60 days |
| Clean claim rate | > 90% | 85–90% | < 85% |
| Monthly report delivery | By Day 10 | Day 11–15 | After Day 15 or not delivered |

**Action at Red:** Schedule a performance review meeting with Nexus Billing within 5 business days. If metrics do not improve within 60 days of the review, begin evaluating biller replacement.

---

## 6. Escalation Path

1. **First contact:** Nexus Billing primary contact: [Name — insert at onboarding] | Phone: [insert] | Email: [insert]
2. **Denial routing:** Nexus contacts Maxi same day → Maxi evaluates whether clinical documentation review is needed:
   - If **administrative denial** (wrong code, missing modifier, eligibility issue): Maxi resolves with biller
   - If **clinical denial** (medical necessity, diagnosis, authorization): Maxi routes to Valentina → Valentina reviews and provides documentation → Maxi instructs biller to appeal
3. **Unresolved after 5 business days:** Valentina reviews the claim directly in Tebra and contacts the payer directly if needed.
4. **Pattern of denials (> 15% rate):** Quarterly biller performance review meeting (Maxi + Valentina + Nexus Billing primary contact). Documented meeting notes required.
5. **Biller replacement:** If performance does not improve after one quarter of review → begin replacement biller selection process. Maintain Nexus Billing relationship through full transition to avoid AR gaps.

---

## 7. Decision Rules

| Situation | Decision | Action |
|-----------|----------|--------|
| Denial received | Nexus notifies Maxi same day | Maxi evaluates; routes clinical denials to Valentina |
| Biller requests elevated Tebra access | Evaluate specific need | Accommodate task-level; never upgrade role; document exception in 1Password |
| Monthly report not received by Day 10 | Yellow status | Contact Nexus Billing; if Day 15 passes with no report, escalate to management contact |
| Denial rate 10–15% | Monitor | Review denial reasons; identify patterns; monthly check-in with biller |
| Denial rate > 15% | Red — action required | Schedule review meeting within 5 business days |
| AR days > 60 | Red — action required | Review aging report with biller; identify stuck claims |
| New payer panel activated | Update biller | Send updated payer ID and contract details via secure channel |
| Biller staff change (new contact) | Update 1Password | Get new contact name/phone/email; verify Tebra access was transferred properly |

---

## 8. Documentation Requirements

| What to Document | Where | When |
|-----------------|-------|------|
| Tebra user creation (date, username) | 1Password — Billing & Revenue > Nexus Billing | At onboarding |
| BAA execution date and location | 1Password — Billing & Revenue > Nexus Billing | At onboarding |
| Biller primary contact info | 1Password — Billing & Revenue > Nexus Billing | At onboarding; update if contact changes |
| Onboarding packet delivery confirmation | 1Password note or email archive | At onboarding |
| Monthly summary report receipt | Practice electronic files (by month) | Monthly |
| Denial escalation (per incident) | Tebra — notes on the specific claim | Per denial event |
| Tebra role exception (if any) | 1Password — Billing & Revenue > Nexus Billing | If exception granted |
| Performance review meeting notes | Practice electronic files (by date) | Per meeting |

---

## 9. References

- **Phase 2 credential-inventory.md** — source of all provider credentials (NPI, DEA, CAQH ID, license numbers)
- **Phase 2 payer-tracker-seed.sql** — all 17 payer IDs, contract status, and billing parameters
- **Phase 2 1password-vault-spec.md** — 1Password vault structure; Billing & Revenue category
- **HIPAA Privacy Rule 45 CFR 164.502(b)** — minimum necessary standard
- **HIPAA Security Rule 45 CFR 164.312** — access control requirements for ePHI

---

## 10. Annual Review

This SOP is reviewed annually and updated when:

- A new biller is onboarded or an existing biller is replaced
- Tebra updates its role-based access structure
- HIPAA requirements change
- Payer panel status changes significantly (major additions or terminations)
- Biller performance expectations are renegotiated

**Next review:** March 2027

---

*Document ID: SOP-05*
*Valentina Park MD, Professional Corporation | NPI: 1023579513 | Current Biller: Nexus Billing*
*Document version: 2026-03 | Owner: Maxi (CTO) | Approved by: Valentina Park, MD*
