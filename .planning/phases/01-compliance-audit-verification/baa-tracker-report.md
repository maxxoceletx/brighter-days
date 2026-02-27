# BAA Vendor Audit Report
## Valentina Park MD, Professional Corporation

**Prepared by:** Maximilian Park, Privacy Officer
**Date:** 2026-02-27
**Practice:** Valentina Park MD, PC | NPI 1023579513 | EIN 99-1529764
**Citation:** 45 CFR 164.308(b), 164.502(e) — Business Associate Agreements

---

## Summary

| Total vendors audited | 10 |
|---|---|
| BAAs confirmed (signed or incorporated) | 3 |
| Pending verification | 3 |
| BAA NOT signed (critical gap) | 1 |
| BAA not required | 3 |

**CRITICAL gaps requiring immediate action: 2**
(Consumer Gmail + Google Voice — patient PHI exposure risk if either handles patient communications)

---

## Vendor Status Table

| Vendor | PHI Exposure | BAA Status | Severity | Action Needed |
|---|---|---|---|---|
| Google Gmail (valentinaparkmd@gmail.com) | YES | NOT SIGNED | CRITICAL | Stop using for PHI; migrate to Workspace immediately |
| Google Workspace (admin@valentinaparkmd.com) | YES | PENDING | CRITICAL | Enable BAA in Admin Console |
| Google Voice (424) 248-8090 | YES | PENDING | CRITICAL | Verify Workspace vs. consumer; enable BAA if Workspace |
| Tebra (EHR) | HIGH | INCORPORATED IN TOS | VERIFIED | Locate acceptance record for OCR audit documentation |
| Telehealth Video Platform | HIGH | SIGNED (location TBD) | WARNING | Identify platform; locate signed BAA |
| Cloud Backup Provider | MEDIUM | SIGNED (location TBD) | WARNING | Identify provider; locate signed BAA |
| Tebra Clearinghouse | MEDIUM | INCORPORATED IN TOS | VERIFIED | Verify if clearinghouse is accessed directly outside Tebra |
| Supabase (Brighter Days) | NONE (currently) | NOT REQUIRED | INFO | BAA required before Phase 3 patient data entry |
| 1Password | NONE | NOT REQUIRED | INFO | No action needed |
| GoDaddy | NONE | NOT REQUIRED | INFO | No action needed |

---

## CRITICAL: Email Provider — Action Required Immediately

### The Problem

The practice has two email addresses:
- **valentinaparkmd@gmail.com** — This is a consumer Gmail account. Consumer Gmail accounts are NOT eligible for a HIPAA Business Associate Agreement with Google. Using this address to communicate patient information (appointment confirmations, medication information, anything referencing a specific patient) is a **HIPAA violation**.
- **admin@valentinaparkmd.com** — This uses the practice's custom domain (valentinaparkmd.com). If hosted on Google Workspace Business, a BAA IS available and must be enabled.

### Decision Tree: Which Situation Are You In?

**Step 1:** Log into admin@valentinaparkmd.com and check if it redirects to Gmail.com (consumer) or opens a Google Workspace admin interface.

**Scenario A — admin@valentinaparkmd.com IS on Google Workspace:**
- Log into Google Admin Console: https://admin.google.com
- Navigate to: Account > Legal and Compliance > HIPAA
- Accept the Google HIPAA Business Associate Amendment
- This BAA covers: Gmail, Drive, Docs, Calendar, Meet, Voice (if using Workspace Voice)
- Update admin@valentinaparkmd.com status in baa-tracker to SIGNED
- Do NOT use valentinaparkmd@gmail.com for any patient communication — route everything through the Workspace account

**Scenario B — admin@valentinaparkmd.com is also a consumer account (forwarding, alias, or not on Workspace):**
- This is a CRITICAL compliance gap
- Required action: Sign up for Google Workspace Business Starter at $6/user/month
- Set up valentinaparkmd.com domain on Workspace (GoDaddy DNS update required)
- Enable Google HIPAA BAA in Admin Console
- Migrate all patient-facing communications to the new Workspace address
- Timeline: Complete within 2 weeks (by 2026-03-15)

### Interim Rule Until Resolved

**No patient names, dates of service, diagnoses, medications, or appointment details may be communicated via either Gmail address until BAA is confirmed.** Direct patients to use Tebra's secure patient portal for all written communication.

---

## CRITICAL: Google Voice — Action Required Immediately

### The Problem

The practice phone number (424) 248-8090 is a Google Voice number. Patient calls and voicemails may contain PHI (patient names, appointment requests, medication refill requests). If this is a consumer Google Voice account, there is no HIPAA BAA available — making every patient voicemail a potential HIPAA exposure.

### Decision Tree: Which Situation Are You In?

**Step 1:** Log into voice.google.com. Look for Google Workspace indicators (work profile icon, admin settings).

**Scenario A — Google Voice for Google Workspace:**
- The Google Workspace HIPAA BAA (accepted in Admin Console) covers Voice
- No separate action needed once the Workspace BAA is accepted
- Update Google Voice status in baa-tracker to SIGNED

**Scenario B — Consumer Google Voice (free or paid personal plan):**
- Consumer Google Voice does NOT support a HIPAA BAA
- This is a CRITICAL gap if patient voicemails contain identifying information
- Options to remediate:
  1. **Upgrade to Google Voice for Workspace** — port the (424) 248-8090 number to Google Voice for Workspace if admin@valentinaparkmd.com is on Workspace ($10/user/month add-on)
  2. **Switch to HIPAA-compliant phone** — Options: Spruce Health ($24-48/month), RingCentral HIPAA ($30+/month), Dialpad HIPAA ($15+/month). All offer BAAs and HIPAA-compliant voicemail.
  3. **Minimum viable fix** — Change voicemail greeting to: "You have reached the office of Dr. Valentina Park. Please do not leave messages containing personal health information in this voicemail. For appointment requests or non-urgent matters, please use the patient portal at [Tebra portal URL]. For urgent matters, please call back and follow the emergency prompts." This reduces — but does not eliminate — PHI exposure risk.
- Timeline: Resolve by 2026-03-15

---

## WARNING: Telehealth Video Platform — Locate BAA

### Status: SIGNED (confirmed by HIPAA spreadsheet) — BAA Location Unknown

The HIPAA Compliance Record 2025.xlsx confirms a signed BAA is on file for the telehealth video platform. However, the specific platform name and the location of the signed agreement are not documented.

### Action Required

1. Identify the telehealth video platform:
   - Option A: Tebra built-in telehealth (video sessions launched from within Tebra) — if this is the case, the Tebra BAA covers it; no separate BAA needed
   - Option B: Zoom for Healthcare — BAA signed with Zoom
   - Option C: Doxy.me — Doxy.me has a free HIPAA-compliant tier with BAA included
   - Option D: Other platform

2. Locate the signed BAA:
   - Check email inbox for messages from the video platform vendor around practice setup dates (2024-2025)
   - Check vendor account settings/legal section
   - Check shared files or practice setup documentation folder in Google Drive

3. Record in the baa-tracker table:
   - Update vendor_name to actual platform name
   - Set baa_date to actual signed date
   - Set baa_location to where the document can be found

**Target:** 2026-03-31

---

## WARNING: Cloud Backup Provider — Locate BAA

### Status: SIGNED (confirmed by HIPAA spreadsheet) — Provider and BAA Location Unknown

The HIPAA Compliance Record 2025.xlsx confirms a signed BAA is on file for a cloud backup provider. The specific provider and BAA location are not documented.

### Action Required

1. Identify the cloud backup provider:
   - Option A: Tebra provides backup as part of its cloud-hosted EHR service — covered by Tebra BAA; no separate provider or BAA needed
   - Option B: External backup service (Backblaze, Carbonite, iDrive, Acronis, etc.)
   - Option C: Google Drive / Google One backup — covered by Workspace BAA if on Workspace; NOT covered by consumer Gmail

2. Locate the signed BAA:
   - Search email for messages from backup provider around practice setup
   - Check vendor account > legal/agreements section
   - If backup is through Tebra: confirm with Tebra support that their BAA covers backup services; no separate vendor needed

3. Record in the baa-tracker table with actual provider name, date, and location

**Target:** 2026-03-31

---

## VERIFIED: Tebra (EHR)

### Status: BAA INCORPORATED IN TOS (effective 2025-03-07)

Tebra (formerly Kareo) incorporates its HIPAA Business Associate Agreement into the Tebra Customer Agreement, which Valentina Park MD, PC accepted during account setup. Contract effective date: 2025-03-07.

**BAA Text Location:** https://www.tebra.com/business-associate-agreement

**Action Required for OCR Audit Readiness:**
Log into Tebra account settings > Legal / Terms of Service section. Locate the date the Terms of Service (which incorporates the BAA) were accepted. Take a screenshot or export the acceptance record. Store in Google Drive > HIPAA Documentation folder. This gives Valentina a paper trail showing exactly when the BAA took effect.

Contact for questions: Susan Delao (susan.delao@tebra.com), Customer Loyalty Manager

---

## NOT REQUIRED: Supabase (Brighter Days project)

### Status: NOT REQUIRED — Phase 1 only

The Brighter Days Supabase project currently stores compliance audit metadata (item names, statuses, action items, drafted documents). This is practice management data — it does not contain patient names, diagnoses, treatment records, or any other Protected Health Information. No BAA is required for this current use.

### When This Changes

Before Phase 3 (patient-facing systems), when any patient PHI enters Supabase, the BAA becomes CRITICAL:

1. Upgrade Brighter Days Supabase project to Team plan (~$599/month)
2. Contact Supabase via https://supabase.com/contact/enterprise to request HIPAA add-on
3. Sign Supabase BAA (Supabase provides the BAA text)
4. Update this tracker to SIGNED status
5. Estimated total cost: ~$599/month base + ~$350/month HIPAA add-on

This is a planned Phase 3 action item. Do not delay past patient system launch.

---

## NOT REQUIRED: 1Password and GoDaddy

**1Password:** Stores login credentials (usernames, passwords, API keys). Credentials are not Protected Health Information. 1Password does not create, receive, maintain, or transmit patient health information. No Business Associate relationship. No BAA required.

**GoDaddy:** Domain registrar for valentinaparkmd.com (renews 2027-06-13). Domain registration does not involve patient data. No Business Associate relationship. No BAA required.

**Ensure auto-renewal is enabled for valentinaparkmd.com to prevent service interruption.**

---

## Payer Relationships (Not Business Associates)

Disclosures of PHI to insurance payers (Medicare, Medi-Cal, Blue Shield, Aetna, etc.) for billing purposes are permitted under HIPAA 45 CFR 164.506 — Treatment, Payment, Operations (TPO). Insurance payers are not Business Associates; they are covered entities receiving permitted disclosures. No BAA is required with any payer.

---

## Action Item Summary

| Priority | Item | Assigned To | Target Date |
|---|---|---|---|
| CRITICAL | Verify admin@valentinaparkmd.com is on Google Workspace and enable HIPAA BAA in Admin Console | Maxi | 2026-03-15 |
| CRITICAL | Stop using valentinaparkmd@gmail.com for patient communications immediately | Valentina | Immediately |
| CRITICAL | Verify Google Voice account type (Workspace vs. consumer); enable BAA or migrate | Maxi | 2026-03-15 |
| WARNING | Identify telehealth video platform; locate and document signed BAA | Maxi | 2026-03-31 |
| WARNING | Identify cloud backup provider; locate and document signed BAA | Maxi | 2026-03-31 |
| WARNING | Log into Tebra, screenshot Terms of Service acceptance date for OCR paper trail | Maxi | 2026-03-31 |
| INFO | Enable Supabase BAA before Phase 3 patient data entry (upgrade to Team plan) | Maxi | Before Phase 3 |

---

## Reference: HIPAA Business Associate Definition

Under 45 CFR 160.103, a Business Associate is any person or entity (other than a covered entity workforce member) that:
- Creates, receives, maintains, or transmits PHI on behalf of a covered entity
- Performs functions involving PHI (claims processing, billing, data analysis, storage)

A BAA is NOT required when:
- Disclosing PHI to a payer for payment (TPO exception)
- Sharing records with another treating provider for treatment purposes
- Providing records to patients directly

---

*Document maintained by: Maximilian Park, Privacy Officer*
*Citation: 45 CFR 164.308(b)(1) — Business Associate Contracts and Other Arrangements*
*Next review: Concurrent with annual HIPAA SRA — 2026-08-27*
