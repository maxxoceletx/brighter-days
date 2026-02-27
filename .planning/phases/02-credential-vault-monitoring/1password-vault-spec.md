# 1Password Vault Organization — Brighter Days Practice

**Document type:** Operational setup guide
**Audience:** Valentina Park, MD and Maxi
**Purpose:** Organize every practice login and credential into a shared 1Password vault with a clear, functional structure. Follow these instructions to create the vault, migrate all existing logins, and delete plaintext credential documents.

---

## Practice Identifiers

Keep these on hand while setting up vault entries — many portals require them during account creation or login.

| Identifier | Value |
|---|---|
| Individual NPI | 1023579513 |
| Group NPI | 1699504282 |
| EIN | 99-1529764 |
| CAQH ID | 16149210 |
| DEA Number | FP3833933 |
| CA Medical License | A-177690 |
| CA Entity Number | 6093174 |
| Taxonomy Code | 2084P0800X (Psychiatry) |
| Practice Address | 2748 Pacific Coast Hwy #1084, Torrance, CA 90505 |
| Practice Phone | (424) 248-8090 |
| Practice Fax | (949) 703-8810 |

---

## Section 1: Vault Category Structure

**Vault name:** Brighter Days Practice
**Vault type:** Shared vault (both Maxi and Valentina have full access)
**Location:** Inside Valentina's existing 1Password account

Categories are organized by how the credentials are actually used — not alphabetically — so the right login is found quickly under time pressure.

---

### Category 1: EHR & Billing

The core practice management platform and clearinghouse.

| Item Name | Username Hint | URL | Notes |
|---|---|---|---|
| Tebra (EHR/PM) | Email or practice NPI | https://app.tebra.com | Primary EHR and billing platform. Used daily for scheduling, notes, claims. |
| Tebra Clearinghouse / Availity | Tebra-linked login or separate Availity login | https://apps.availity.com | ERA/EOB receipt and claim status. May use same credentials as Tebra or separate Availity account. |

---

### Category 2: Insurance & Credentialing

All credentialing portals, payer networks, and government enrollment systems.

#### Credentialing Platforms

| Item Name | Username Hint | URL | Notes |
|---|---|---|---|
| CAQH ProView | NPI or email — varies | https://proview.caqh.org | CAQH ID: 16149210. Re-attest every 120 days. HIGHEST RISK: missing one cycle suspends all 17 payer contracts simultaneously. |
| Medicare PECOS | CMS user ID | https://pecos.cms.hhs.gov/ | Individual PTAN CB496694, Group PTAN CB496693. Both ACTIVE. Re-validate every 5 years. |
| Medi-Cal PAVE / DHCS Provider Portal | NPI or email | https://www.dhcs.ca.gov/ | Provider ID 100517999. ACTIVE. Annual re-enrollment required. |

#### Payer Portals — All 17 Panels

Create one 1Password entry per payer portal. Tebra payer IDs are noted for reference — include them in the Notes field of each 1Password entry.

| Item Name | Username Hint | URL | Tebra Payer ID | Notes |
|---|---|---|---|---|
| Aetna Provider Portal | NPI or username | https://www.aetnaprovidermatcher.com | 60054 | Credentialing date: 2024-08-13. Individual only — group requires 2+ providers. Re-cred est. 2027-08-13. |
| Anthem / Blue Cross of California Provider Portal | NPI or username | https://www.anthem.com/provider | 47198 | Contract PENDING — provider-signed 5/20/2025; awaiting Anthem countersignature. Confirm before billing. |
| Blue Shield of California Provider Portal | NPI or username | https://provider.blueshieldca.com | 94036 | Contract PENDING — credentialing date 2025-08-07; contract effective date unconfirmed. |
| California Health & Wellness Provider Portal | NPI or username | https://www.californiahealthwellness.com/providers | 68069 | Contract status UNKNOWN — verify with Mary (credentialing agent) or call provider relations. |
| Cigna Provider Portal (Commercial) | NPI or username | https://cignaforhcp.cigna.com | 62308 | Contract NOT EXECUTED — documents requested 12/9/2024; contract not yet signed. Do NOT bill until executed. |
| Cigna Behavioral Health Provider Portal | NPI or username | https://cignaforhcp.cigna.com | MCCBV | Linked to Cigna commercial contract — same execution status. Do NOT bill until Cigna contract executed. |
| Coastal Communities Physician Network Portal | NPI or username | Contact payer for portal URL | CCPN1 | Contract status UNKNOWN — verify with Mary or call provider relations. |
| Facey Medical Foundation Provider Portal | NPI or username | Contact payer for portal URL | 95432 | Contract status UNKNOWN — verify with Mary or call provider relations. |
| Health Net of California Provider Portal | NPI or username | https://www.healthnet.com/portal/provider | 95567 | Contract status UNKNOWN — verify with Mary or call provider relations. |
| Hoag Provider Portal | NPI or username | Contact payer for portal URL | HPPZZ | Contract status UNKNOWN — verify with Mary or call provider relations. |
| Kaiser Foundation Health Plan Southern CA | NPI or email | https://kprovider.kaiserpermanente.org | 94134 | Contract PENDING — sent via DocuSign; execution unconfirmed. Contact: Nanette Bordenave (Nanette.J.Bordenave@kp.org). |
| Magellan Behavioral Health Provider Portal | NPI or username | https://www.magellanprovider.com | 01260 | Contract status UNKNOWN — verify with Mary or call provider relations. |
| Medi-Cal Provider Portal (Medicaid CA) | NPI or username | https://www.dhcs.ca.gov/ | 00148 | ACTIVE. See also DHCS/PAVE entry above. EFT approved. |
| Medicare Provider Portal (CMS Southern CA) | CMS user ID | https://pecos.cms.hhs.gov/ | 01182 | ACTIVE per Phase 2 correction. See also PECOS entry above. |
| Providence Health Plan Provider Portal | NPI or username | https://www.providencehealthplan.com/providers | PHP01 | Contract status UNKNOWN — verify with Mary or call provider relations. |
| Torrance Hospital IPA Provider Portal | NPI or username | Contact payer for portal URL | THIPA | Contract status UNKNOWN — verify with Mary or call provider relations. |
| Torrance Memorial Medical Center Provider Portal | NPI or username | Contact payer for portal URL | TMMC1 | Contract status UNKNOWN — verify with Mary or call provider relations. |

---

### Category 3: State Licensing & DEA

Licenses, prescribing authorization, and the PDMP (Prescription Drug Monitoring Program).

| Item Name | Username Hint | URL | Notes |
|---|---|---|---|
| CA BreEZe (Medical Board) | Username set during account creation | https://www.breeze.ca.gov/ | License A-177690. ACTIVE. Expires 2028-06-30. Renew via BreEZe. Also used for CEU reporting. |
| DEA Diversion Control Portal | DEA number FP3833933 | https://www.deaecom.gov/ | DEA FP3833933. ACTIVE. Expires 2027-03-31. URGENT: Update address from Walnut Creek to Torrance (2748 Pacific Coast Hwy #1084) per 21 CFR 1301.51. |
| CURES (CA PDMP) | Email or username | https://pmp.doj.ca.gov/ | CA Prescription Drug Monitoring Program. Must check before prescribing Schedule II-IV controlled substances. |

---

### Category 4: Business & Corporate

Corporate filings, tax portals, and the city business license.

| Item Name | Username Hint | URL | Notes |
|---|---|---|---|
| CA Secretary of State BizFile | Email | https://bizfileplus.sos.ca.gov/ | Used for annual Statement of Information. CA Entity #6093174. $25 fee. |
| IRS EFTPS (Federal Tax Payments) | EIN 99-1529764 | https://www.eftps.gov/ | Federal payroll and estimated tax payments for the S-Corp. |
| CA FTB MyFTB (State Tax) | EIN or SSN | https://www.ftb.ca.gov/myftb/ | CA Franchise Tax Board. State tax payments and entity filings. |
| City of Torrance Business License Portal | License # BL-LIC-051057 | https://www.torranceca.gov/ | EXPIRED as of 2025-12-31. Renew immediately. Annual renewal. |

---

### Category 5: Communication & Workspace

Practice email, phone, and domain management.

| Item Name | Username Hint | URL | Notes |
|---|---|---|---|
| Google Workspace Admin | admin@valentinaparkmd.com | https://admin.google.com | Admin console for the practice domain. Enable HIPAA BAA in Admin Console before using for patient communications. |
| Google Voice | (424) 248-8090 | https://voice.google.com | Practice phone line. BAA availability depends on Workspace vs. consumer account — verify in Google Workspace Admin. |
| GoDaddy | Email or username | https://www.godaddy.com | Domain registration for valentinaparkmd.com. |

---

### Category 6: Infrastructure & Tech

Technical systems used to run the practice's digital infrastructure.

| Item Name | Username Hint | URL | Notes |
|---|---|---|---|
| Supabase (Brighter Days project) | Email | https://app.supabase.com | Credential and compliance database. Project: "Brighter Days." Do not confuse with FindItNOW or Momo Supabase projects. |
| 1Password Vault Admin | Email | https://my.1password.com | 1Password account management. Used to add/remove vault members and manage vault settings. |

*(Add new infrastructure credentials here as they are acquired — e.g., n8n, webhook services, analytics tools.)*

---

### Category 7: Malpractice & Insurance

Professional liability policies and future general liability.

| Item Name | Username Hint | URL | Notes |
|---|---|---|---|
| CAP/MPT Portal (Malpractice) | Email or policy number | https://www.cap-mpt.com/ | Individual policy #48289 (Valentina, expires 2026-12-31). Entity policy #10709 (S-Corp, expires 2026-12-31). Both active and annual renewal. |

*(Add general liability and workers' comp portals here when obtained.)*

---

## Section 2: Items That Stay in the Personal Vault

The following items must NOT be added to the "Brighter Days Practice" shared vault. They belong in Valentina's personal 1Password vault only.

**Excluded items:**
- Personal banking accounts (checking, savings, investment)
- Social Security Number (SSN)
- Personal email accounts (non-practice email)
- Personal social media accounts
- Personal credit cards
- Any credentials unrelated to the practice

**Why this matters:** Mixing personal and practice credentials in the shared vault creates liability exposure, complicates any future practice sale or addition of new providers, and creates unnecessary access to personal financial data for anyone granted vault access. Keep the practice vault strictly limited to practice operations.

---

## Section 3: Migration From Plaintext Documents

Phase 1 audit found that SSNs, passwords, and portal credentials are currently stored in plaintext Word documents — specifically:

- **Master Key.docx** — contains passwords, SSNs, and portal login credentials
- **liscensing notes.docx** — contains licensing credentials and notes

Plaintext credential storage is a security risk. If either document were lost, emailed, or accessed by an unauthorized person, all practice systems would be compromised simultaneously. Complete the migration below and then delete both files.

### Step 1: Create the Shared Vault

1. Open 1Password on your Mac or iPhone.
2. Tap or click the vault selector (top-left corner, shows your current vault name).
3. Select "New Vault."
4. Name the vault exactly: **Brighter Days Practice**
5. Set permissions so both Valentina and Maxi have full access.
   - If on 1Password Individual plan: upgrade first (see Section 3, Step 2 below).
   - If on 1Password Families or Teams: add Maxi as a vault member.

### Step 2: Verify Your Account Plan Supports Shared Vaults

Shared vaults require a multi-user plan:
- **1Password Families:** $4.99/month — supports up to 5 people sharing vaults. Best option if only Maxi and Valentina need access.
- **1Password Teams:** $19.95/month for first 10 users — better if you add staff in the future.
- **1Password Individual:** Does not support shared vaults. Upgrade required before sharing with Maxi.

To check your plan: go to https://my.1password.com → Account → Subscription.

### Step 3: Add Items From the Migration Checklist

Open Master Key.docx and liscensing notes.docx. For each item below, create a new 1Password entry in the correct category in the "Brighter Days Practice" vault, then check it off.

**EHR & Billing**
- [ ] Tebra login (username + password + any MFA codes)
- [ ] Availity / clearinghouse login (username + password)

**Insurance & Credentialing**
- [ ] CAQH ProView login (username + password)
- [ ] Medicare PECOS login (CMS user ID + password)
- [ ] Medi-Cal PAVE / DHCS Provider Portal login
- [ ] Aetna Provider Portal login
- [ ] Anthem / Blue Cross of California Provider Portal login
- [ ] Blue Shield of California Provider Portal login
- [ ] California Health & Wellness Provider Portal login
- [ ] Cigna Provider Portal login (Commercial)
- [ ] Cigna Behavioral Health Provider Portal login
- [ ] Kaiser Foundation Health Plan Southern CA login
- [ ] Any other payer portal logins found in documents

**State Licensing & DEA**
- [ ] CA BreEZe login (username + password)
- [ ] DEA Diversion Control Portal login (username + password)
- [ ] CURES (CA PDMP) login (username + password)

**Business & Corporate**
- [ ] CA Secretary of State BizFile login
- [ ] IRS EFTPS login (EIN + PIN + password)
- [ ] CA FTB MyFTB login
- [ ] City of Torrance Business License Portal login

**Communication & Workspace**
- [ ] Google Workspace Admin login (admin@valentinaparkmd.com)
- [ ] GoDaddy domain account login

**Malpractice & Insurance**
- [ ] CAP/MPT Portal login (username + password for policies #48289 and #10709)

**Also store these identifiers as Secure Notes in the vault:**
- [ ] EIN: 99-1529764
- [ ] Individual NPI: 1023579513
- [ ] Group NPI: 1699504282
- [ ] CAQH ID: 16149210
- [ ] CA Entity Number: 6093174
- [ ] DEA Number: FP3833933
- [ ] CA Medical License: A-177690

### Step 4: Delete the Plaintext Documents

After confirming that every item in the checklist above has been added to 1Password and that you can log into each system using the 1Password credentials:

1. Delete **Master Key.docx** from your computer.
2. Delete **liscensing notes.docx** from your computer.
3. Empty the Trash.
4. If either document is stored in cloud storage (Google Drive, Dropbox, iCloud), delete it from there as well.
5. If either document was ever emailed, note that email copies may exist in sent/received mail folders — delete those as well.

**Do not skip this step.** The security benefit of 1Password is eliminated if the plaintext documents remain accessible.

---

## Section 4: Vault Entry Cross-Reference Table

This table maps each `vault_entry_ref` value from `credential-seed.sql` to the corresponding 1Password entry. Use this to verify every Supabase credential row has a matching vault entry after migration.

| vault_entry_ref (Supabase) | 1Password Category | 1Password Item Name |
|---|---|---|
| CA BreEZe (Medical Board) | State Licensing & DEA | CA BreEZe (Medical Board) |
| DEA Diversion Control Portal | State Licensing & DEA | DEA Diversion Control Portal |
| ABPN Portal (Psychiatry) | (Optional — create if desired) | ABPN Portal (Psychiatry) |
| ABPN Portal (Child & Adolescent) | (Optional — create if desired) | ABPN Portal (Child & Adolescent) |
| CAQH ProView | Insurance & Credentialing | CAQH ProView |
| CAP/MPT Portal (Malpractice) | Malpractice & Insurance | CAP/MPT Portal (Malpractice) |
| CAP/MPT Portal (Entity Coverage) | Malpractice & Insurance | CAP/MPT Portal (Malpractice) |
| City of Torrance Business License Portal | Business & Corporate | City of Torrance Business License Portal |
| CA Secretary of State BizFile | Business & Corporate | CA Secretary of State BizFile |
| Medicare PECOS | Insurance & Credentialing | Medicare PECOS |
| Medi-Cal PAVE / DHCS Provider Portal | Insurance & Credentialing | Medi-Cal PAVE / DHCS Provider Portal |

**Note on ABPN portals:** ABPN certifications do not have portal logins in the same way as licensing boards. Create entries only if you have an active ABPN online account. The certifications themselves have no renewal deadline (Continuous Certification) — no urgent login management needed.

**Note on duplicate vault_entry_ref:** Medicare PECOS covers both Group PTAN (CB496693) and Individual PTAN (CB496694) — one 1Password entry with both PTANs in the notes field is sufficient. Similarly, the CAP/MPT entry covers both individual policy #48289 and entity policy #10709.

---

## Section 5: Ongoing Maintenance

### When a new payer portal is added
1. Create a new 1Password entry in the "Insurance & Credentialing" category.
2. Add the portal URL, login credentials, and Tebra payer ID in the entry notes.
3. Update the `payer_tracker` table in Supabase with the `portal_login_ref` field set to the exact 1Password item name.

### When credentials are renewed
1. Log in via the 1Password entry for that portal.
2. Complete the renewal.
3. Update the 1Password entry if the password changes.
4. Update the `credentials` table in Supabase:
   - Set new `expiry_date`
   - Update `status` to 'ACTIVE' (this stops the alert system from continuing to fire)
   - Update `updated_at`

### When staff are added in the future
1. Invite the new user to the "Brighter Days Practice" vault in 1Password.
2. Review which categories they should have access to — do not grant full vault access by default.
3. Consider 1Password Teams if headcount grows beyond 2 users (Maxi + Valentina).

### Annual vault audit (each January)
1. Review every entry in the vault — confirm no entries have been orphaned (portal no longer in use, contract terminated).
2. Confirm no plaintext credential storage exists anywhere — check email drafts, Google Drive, Dropbox.
3. Verify all 1Password entries have current passwords (none more than 2 years old without a refresh).
4. Cross-reference with the Supabase `credentials` table — every `vault_entry_ref` should have a matching 1Password entry.

---

*Document generated: 2026-02-27*
*Practice: Valentina Park MD, Professional Corporation*
*Phase: 02-credential-vault-monitoring — Plan 01*
*This is an operational document. Verify all portal URLs and contact information directly before use, as payer portals change periodically.*
