-- =============================================================================
-- Brighter Days Compliance System — Seed Data
-- Practice: Valentina Park MD, Professional Corporation
-- EIN: 99-1529764 | Individual NPI: 1023579513 | Group NPI: 1699504282
-- Source: 01-DOCUMENT-AUDIT.md (real data extracted 2026-02-27)
-- =============================================================================
-- IMPORTANT: This file contains credential numbers and professional identifiers.
-- It does NOT contain SSNs, passwords, or portal credentials.
-- =============================================================================


-- =============================================================================
-- SECTION 1: compliance_items
-- All rows ordered: CRITICAL first, then WARNING, then INFO
-- =============================================================================

INSERT INTO compliance_items (req_id, category, title, severity, status, description, legal_citation, verified_date, expiry_date, document_ref, notes) VALUES

-- ---------------------------------------------------------------------------
-- CRITICAL: HIPAA Security Risk Analysis
-- ---------------------------------------------------------------------------
(
  'COMP-01',
  'hipaa',
  'HIPAA Security Risk Analysis (SRA)',
  'CRITICAL',
  'VERIFIED',
  'Formal HIPAA Security Risk Analysis completed per HHS SRA Tool structure. Covers all 11 threat categories. Staff trained. Policies in place: Privacy, Breach Notification, Device Security, Telehealth Use, Risk Assessment.',
  '45 CFR 164.308(a)(1) — Administrative Safeguards: Security Management Process',
  '2026-02-27',
  '2026-08-27',
  'HIPAA Compliance Record 2025.xlsx',
  'Next review targeted August 2026. Gaps: (1) Contingency plan testing in-progress, not yet completed. (2) Device disposal vendor not finalized. No breach incidents on log. Technical safeguards complete: access control, 2FA, TLS/SSL, audit controls active.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: Business Associate Agreements (BAA) — Tebra
-- ---------------------------------------------------------------------------
(
  'COMP-02a',
  'hipaa',
  'BAA — Tebra (EHR / Practice Management)',
  'CRITICAL',
  'VERIFIED',
  'Tebra Business Associate Agreement incorporated into Terms of Service accepted at account creation. Tebra is the primary EHR handling all patient records, billing, and e-prescribing.',
  '45 CFR 164.308(b), 164.502(e) — Business Associate Agreements',
  '2026-02-27',
  '2026-05-07',
  'Tebra Customer Agreement (signed 3/7/2025, renews 5/7/2026)',
  'BAA is incorporated into Tebra Terms of Service — not a separate signed document. Contract effective 3/7/2025, renewal 5/7/2026. Monthly ~$339 (Patient Pop + Practice Growth). Contact: Susan Delao (susan.delao@tebra.com). Fax: (949) 703-8810.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: Business Associate Agreements (BAA) — Email
-- ---------------------------------------------------------------------------
(
  'COMP-02b',
  'hipaa',
  'BAA — Email Provider (Patient Communications)',
  'CRITICAL',
  'PENDING',
  'Email provider for patient communications must have a signed BAA. Personal Gmail accounts cannot sign BAAs and are a HIPAA violation for PHI communications.',
  '45 CFR 164.308(b), 164.502(e) — Business Associate Agreements',
  '2026-02-27',
  NULL,
  NULL,
  'ISSUE: valentinaparkmd@gmail.com is a personal Gmail account — no BAA available. admin@valentinaparkmd.com domain exists (GoDaddy, renews 2027-06-13) — if hosted on Google Workspace for Business, BAA is available. Must verify email hosting and sign BAA if using Workspace. If personal Gmail for PHI, must switch to HIPAA-compliant provider (Google Workspace, Paubox, etc.). This is a GAP if Gmail consumer is used for patient PHI.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: Business Associate Agreements (BAA) — Supabase
-- ---------------------------------------------------------------------------
(
  'COMP-02c',
  'hipaa',
  'BAA — Supabase (Compliance Data Store)',
  'CRITICAL',
  'PENDING',
  'Supabase requires Team or Enterprise plan plus HIPAA add-on to sign a BAA. Phase 1 compliance data is not PHI, but BAA must be in place before any patient data enters the system.',
  '45 CFR 164.308(b), 164.502(e) — Business Associate Agreements',
  '2026-02-27',
  NULL,
  NULL,
  'PLAN: Phase 1 data (compliance item names, statuses, drafted consent forms) is practice management data, not patient PHI. BAA not immediately required for this phase. ACTION REQUIRED before Phase 3 (Operations) when patient-adjacent data may enter the system. Upgrade path: Supabase Team plan + HIPAA add-on + signed BAA.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: Telehealth Informed Consent (B&P 2290.5)
-- ---------------------------------------------------------------------------
(
  'COMP-03',
  'forms',
  'CA Telehealth Informed Consent (B&P 2290.5)',
  'CRITICAL',
  'GAP',
  'California law requires a specific telehealth informed consent form covering: right to in-person care, technology risks, location confirmation (CA-only), confidentiality, provider identity, and consent withdrawal rights. This form DOES NOT EXIST for this practice.',
  'CA Business & Professions Code 2290.5; DHCS model language',
  '2026-02-27',
  NULL,
  'Plan 01-03 will produce this document',
  'CRITICAL: Cannot see first patient without compliant consent. Two template references found from prior employers (CPS one-paragraph, Renew TeleHealth/Struble template) but neither is compliant or branded for Valentina Park MD, PC. Will be produced in Plan 01-03 and formatted for Tebra digital patient intake.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: CA Medical License
-- ---------------------------------------------------------------------------
(
  'COMP-04a',
  'licensing',
  'CA Medical License — Valentina Park MD (A-177690)',
  'CRITICAL',
  'VERIFIED',
  'Active California medical license for psychiatry. Renewed via BreEZe portal. Required for all patient care in California.',
  'CA Business & Professions Code 2050 et seq.; Medical Board of California',
  '2026-02-27',
  '2028-06-30',
  'CA Medical License A-177690',
  'Active, no issues. License number A-177690. Renews 6/30/2028. 2-year renewal cycle via BreEZe portal. Add to compliance calendar for reminder at 6/30/2027 (1-year pre-warning) and 4/30/2028 (60-day warning).'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: DEA Registration
-- ---------------------------------------------------------------------------
(
  'COMP-04b',
  'prescribing',
  'DEA Registration — FP3833933 (Schedules II-V)',
  'CRITICAL',
  'GAP',
  'DEA registration is active and covers Schedule II-V controlled substances. However, registration address shows Walnut Creek (former employer CPS) not current Torrance practice address. Address update required per 21 CFR 1301.51.',
  '21 U.S.C. 823; 21 CFR 1301.11; 21 CFR 1301.51 (address change requirement)',
  '2026-02-27',
  '2027-03-31',
  'DEA Registration Certificate FP3833933',
  'ISSUE: Address mismatch — DEA shows Walnut Creek (CPS prior employer address), current practice is 2748 Pacific Coast Hwy #1084, Torrance, CA 90505. Must update within 30 days of address change per 21 CFR 1301.51. DEA registration active, does not expire until 3/31/2027. Schedules II-V covered. Operating under Fourth Temporary Extension of COVID-19 Telemedicine Flexibilities (expires 2026-12-31) — can prescribe Schedule II-V via audio-video telehealth without prior in-person visit.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: Ryan Haight Act / DEA Telehealth Flexibility
-- ---------------------------------------------------------------------------
(
  'COMP-04c',
  'prescribing',
  'DEA Ryan Haight Act Telehealth Flexibility (Fourth Extension)',
  'CRITICAL',
  'VERIFIED',
  'Operating under the DEA Fourth Temporary Extension of COVID-19 Telemedicine Flexibilities. Allows prescribing Schedule II-V controlled substances via audio-video telehealth without prior in-person visit through December 31, 2026.',
  '21 U.S.C. 831; DEA Fourth Temporary Extension (Federal Register 2025-12-31)',
  '2026-02-27',
  '2026-12-31',
  'DEA Fourth Temporary Extension (expires 2026-12-31)',
  'EXPIRY WARNING: Fourth Extension expires December 31, 2026. Permanent rules not yet finalized. Must monitor DEA rulemaking in Q3-Q4 2026. If permanent rules require in-person visit or special registration, practice workflow changes significantly. Flag for compliance calendar review 2026-09-01.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: Malpractice Insurance
-- ---------------------------------------------------------------------------
(
  'COMP-09',
  'insurance',
  'Malpractice Insurance — CAP/MPT #48289',
  'CRITICAL',
  'VERIFIED',
  'Active malpractice insurance through CAP (Cooperative of American Physicians) / MPT. Full-time coverage effective 1/1/2026. Entity coverage also active. Covers telehealth psychiatry and controlled substance prescribing.',
  'Standard of care requirement; required by all payer contracts',
  '2026-02-27',
  '2026-12-31',
  'CAP/MPT Malpractice Certificate #48289',
  'Individual policy #48289 active, full-time from 1/1/2026. Entity policy #10709 also active (covers Valentina Park MD, PC as entity). Both policies expire 12/31/2026 — add renewal reminder at 10/1/2026. Coverage confirmed: telehealth psychiatry + controlled substance prescribing. No tail coverage documentation found for pre-July 2024 clinical work at prior employers.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: ABPN Board Certification
-- ---------------------------------------------------------------------------
(
  'COMP-08a',
  'licensing',
  'ABPN Board Certification — Psychiatry (Cert #83742)',
  'CRITICAL',
  'VERIFIED',
  'Active ABPN board certification in Psychiatry. Continuous Certification (CC) compliant — no fixed expiry date under CC program.',
  'American Board of Psychiatry and Neurology; CA Medical Board standard of care',
  '2026-02-27',
  NULL,
  'ABPN Psychiatry Certificate #83742',
  'CC compliant — no expiry date under Continuous Certification program. CC requirements include ongoing CME and periodic assessment. Status: Active.'
),

-- ---------------------------------------------------------------------------
-- CRITICAL: ABPN Child & Adolescent Psychiatry Certification
-- ---------------------------------------------------------------------------
(
  'COMP-08b',
  'licensing',
  'ABPN Board Certification — Child & Adolescent Psychiatry (Cert #13399)',
  'CRITICAL',
  'VERIFIED',
  'Active ABPN board certification in Child & Adolescent Psychiatry. Continuous Certification (CC) compliant. Required for treating minors.',
  'American Board of Psychiatry and Neurology; CA Medical Board standard of care',
  '2026-02-27',
  NULL,
  'ABPN Child & Adolescent Psychiatry Certificate #13399',
  'CC compliant — no expiry under Continuous Certification program. Required for child/adolescent patient population. Status: Active.'
),

-- ---------------------------------------------------------------------------
-- WARNING: CAQH ProView Re-Attestation
-- ---------------------------------------------------------------------------
(
  'COMP-05',
  'credentialing',
  'CAQH ProView Re-Attestation (ID 16149210)',
  'WARNING',
  'PENDING',
  'CAQH ProView requires re-attestation every 120 days. If profile expires, all 17 payer credentialing contracts may be silently suspended. Current attestation date unknown — must verify immediately.',
  'CAQH ProView Participation Agreement; required by all 17 payer contracts',
  '2026-02-27',
  NULL,
  'CAQH ProView profile (ID 16149210)',
  'URGENT VERIFICATION NEEDED: Last attestation date unknown. If >120 days ago, re-attest immediately. Login at proview.caqh.org. If profile is in Expired state, all 17 payer contracts are at risk of silent suspension. Taxonomy: 2084P0800X. NPI: 1023579513.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Medicare PTAN Deactivated
-- ---------------------------------------------------------------------------
(
  'COMP-06',
  'credentialing',
  'Medicare Enrollment — PTAN CB496693 (DEACTIVATED)',
  'WARNING',
  'GAP',
  'Medicare group PTAN CB496693 was DEACTIVATED effective 1/31/2026 due to no claims submitted in 6+ months. Rebuttal deadline passed 2/13/2026. Cannot bill Medicare patients until re-enrollment through PECOS is completed.',
  'CMS Enrollment Requirements; 42 CFR Part 424',
  '2026-02-27',
  NULL,
  'Medicare PTAN deactivation notice (sent to home address)',
  'CRITICAL REVENUE IMPACT: Medicare rate for 99214+90833+90785 = $230.65/session. Cannot bill any Medicare patients currently. Must file new enrollment via PECOS (pecos.cms.hhs.gov). Use: Individual NPI 1023579513, Group NPI 1699504282, former PTAN CB496693 as reference. Note: deactivation notice was mailed to old home address (Palomino Lane) — address inconsistency contributed to delayed discovery. Medicare Individual PTAN CB496694 status also unknown (linked to group).'
),

-- ---------------------------------------------------------------------------
-- WARNING: Business License Expired
-- ---------------------------------------------------------------------------
(
  'COMP-07',
  'corporate',
  'City of Torrance Business License — BL-LIC-051057 (EXPIRED)',
  'WARNING',
  'GAP',
  'Torrance business license BL-LIC-051057 expired December 31, 2025. Required for operating a business within city limits. Must renew immediately to avoid late fees and potential legal issues.',
  'Torrance Municipal Code; CA Business License requirements',
  '2026-02-27',
  '2025-12-31',
  'Business License BL-LIC-051057',
  'Expired 12/31/2025. Contact: City of Torrance Business License Division, 3031 Torrance Blvd, Torrance CA 90503. Phone: (310) 618-5540. Online renewal likely available at TorranceCA.gov. Business address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Anthem Contracts — No Anthem Countersignature
-- ---------------------------------------------------------------------------
(
  'COMP-10a',
  'credentialing',
  'Anthem Blue Cross — Contract Unsigned by Anthem (Commercial)',
  'WARNING',
  'GAP',
  'Anthem Blue Cross commercial provider agreement was signed by Valentina Park MD, PC on 5/20/2025 but has NOT been countersigned by Anthem. Cannot bill Anthem commercial patients in-network until contract is executed.',
  'Anthem Blue Cross provider agreement',
  '2026-02-27',
  NULL,
  'Anthem commercial contract (provider-signed 5/20/2025, awaiting Anthem countersignature)',
  'Provider-signed 5/20/2025. Credentialing agent Mary is handling. Must follow up with Mary to escalate Anthem countersignature on commercial contract.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Anthem Medicaid Contract — No Anthem Countersignature
-- ---------------------------------------------------------------------------
(
  'COMP-10b',
  'credentialing',
  'Anthem Blue Cross — Contract Unsigned by Anthem (Medicaid)',
  'WARNING',
  'GAP',
  'Anthem Blue Cross Medicaid provider agreement was signed by Valentina Park MD, PC but has NOT been countersigned by Anthem. Cannot bill Anthem Medicaid patients in-network until contract is executed.',
  'Anthem Blue Cross Medicaid provider agreement',
  '2026-02-27',
  NULL,
  'Anthem Medicaid contract (provider-signed, awaiting Anthem countersignature)',
  'Same situation as commercial contract — provider-signed, Anthem has not countersigned. Mary is handling. Follow up needed.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Kaiser SCPMG Contract — Execution Unconfirmed
-- ---------------------------------------------------------------------------
(
  'COMP-10c',
  'credentialing',
  'Kaiser (SCPMG) — DocuSign Contract Execution Unconfirmed',
  'WARNING',
  'PENDING',
  'Kaiser Southern California Permanente Medical Group sent a provider contract via DocuSign. Execution status is unconfirmed — not clear if both parties have signed.',
  'Kaiser SCPMG provider agreement',
  '2026-02-27',
  NULL,
  'Kaiser DocuSign contract (status unconfirmed)',
  'Contact: Nanette Bordenave, Kaiser credentialing (Nanette.J.Bordenave@kp.org). Must confirm DocuSign completion and obtain executed copy for records.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Cigna/Evernorth Contract — Not Executed
-- ---------------------------------------------------------------------------
(
  'COMP-10d',
  'credentialing',
  'Cigna/Evernorth — Contract Not Executed',
  'WARNING',
  'GAP',
  'Cigna/Evernorth requested documents on 12/9/2024 but no contract has been executed. Cannot bill Cigna patients in-network.',
  'Cigna/Evernorth provider agreement',
  '2026-02-27',
  NULL,
  'Cigna document request 12/9/2024',
  'Documents submitted 12/9/2024. No approval or contract execution confirmed. Over 14 months with no resolution. Must follow up aggressively. Contracted rate: 99214+90833+90785 = $134.93/session.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Carelon Application — 18+ Months Pending
-- ---------------------------------------------------------------------------
(
  'COMP-10e',
  'credentialing',
  'Carelon (Anthem Behavioral Health) — Application Pending 18+ Months',
  'WARNING',
  'PENDING',
  'Carelon (formerly Beacon, now Anthem behavioral health) application submitted 7/23/2024 — no approval after 18+ months. Follow-up urgently needed.',
  'Carelon provider participation agreement',
  '2026-02-27',
  NULL,
  'Carelon application submitted 7/23/2024',
  'Application submitted July 23, 2024. No approval on file. 18+ months is highly abnormal processing time. Mary may be handling. Escalation needed.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Tricare TIN Discrepancy
-- ---------------------------------------------------------------------------
(
  'COMP-10f',
  'credentialing',
  'Tricare/HNFS — TIN Discrepancy (Application Only, Not Contracted)',
  'WARNING',
  'GAP',
  'Tricare application submitted with wrong TIN (941706811 instead of correct EIN 99-1529764). Application status: not contracted. TIN error must be corrected before any Tricare billing.',
  'HNFS/Tricare provider application',
  '2026-02-27',
  NULL,
  'Tricare/HNFS provider application',
  'Correct EIN: 99-1529764 (formatted as 99-1529764). Incorrect TIN in application: 941706811 (appears to be transposed/wrong number). Must submit correction to HNFS. Contact HNFS Provider Relations to correct and reprocess application.'
),

-- ---------------------------------------------------------------------------
-- WARNING: No General Liability Insurance
-- ---------------------------------------------------------------------------
(
  'COMP-11a',
  'insurance',
  'General Liability Insurance — NOT ACTIVE',
  'WARNING',
  'GAP',
  'No general liability insurance policy found in document audit. Many payer contracts require general liability insurance as a condition of participation.',
  'Standard payer contract requirement; CA business practice',
  '2026-02-27',
  NULL,
  NULL,
  'Required by most commercial payer contracts. Also protects against slip-and-fall, property damage, and non-medical liability claims. Typical cost for solo medical practice: $500-$2,000/year. Get quotes from: Proliability, MedPro Group, HPSO.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Workers Compensation — Status Unknown
-- ---------------------------------------------------------------------------
(
  'COMP-11b',
  'employment',
  'Workers Compensation Insurance — Status Unknown',
  'WARNING',
  'PENDING',
  'Workers compensation insurance required if Maximilian Park is classified as an employee of Valentina Park MD, PC. Employment classification must be determined.',
  'CA Labor Code 3700; CA workers compensation requirements',
  '2026-02-27',
  NULL,
  NULL,
  'Maxi serves as CTO/Admin. If classified as employee of the PC, workers comp is legally required in California (no exemption for single-employee businesses). If classified as independent contractor, requirement may not apply. Must determine employment classification and obtain coverage if required.'
),

-- ---------------------------------------------------------------------------
-- WARNING: DEA Address Change Required
-- (Separate action item tracking from the credential status above)
-- ---------------------------------------------------------------------------
(
  'COMP-10g',
  'prescribing',
  'DEA Address Update — Walnut Creek to Torrance Required',
  'WARNING',
  'GAP',
  'DEA registration FP3833933 still shows former employer CPS address in Walnut Creek. Current practice address is 2748 Pacific Coast Hwy #1084, Torrance, CA 90505. Address change required per 21 CFR 1301.51 within 30 days of relocation.',
  '21 CFR 1301.51 — Change of name, address, or business activity',
  '2026-02-27',
  NULL,
  'DEA Registration FP3833933 (update required)',
  'Must file address change via DEA Diversion Control at apps.deadiversion.usdoj.gov. Process: log in, navigate to Registration Updates, submit address change. Usually processed within 30 days. Old address: Walnut Creek (CPS). New address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Sensitive Data in Plaintext Files
-- ---------------------------------------------------------------------------
(
  'COMP-12',
  'hipaa',
  'Sensitive Credentials in Unencrypted Files',
  'WARNING',
  'GAP',
  'SSN, passwords, and portal credentials found in unencrypted Word documents: Master Key.docx and liscensing notes.docx. These must be moved to 1Password immediately.',
  '45 CFR 164.312 — Technical Safeguards; HIPAA Minimum Necessary',
  '2026-02-27',
  NULL,
  'Master Key.docx, liscensing notes.docx',
  'SECURITY RISK: Unencrypted credentials = HIPAA technical safeguards gap. Move all sensitive data (SSN, portal passwords, credential numbers) to 1Password. Files to remediate: Master Key.docx, liscensing notes.docx. After migration, securely delete original Word docs. Assigned to Maxi.'
),

-- ---------------------------------------------------------------------------
-- WARNING: Blue Shield Credentialing — Effective Date Unclear
-- ---------------------------------------------------------------------------
(
  'COMP-10h',
  'credentialing',
  'Blue Shield of CA — Credentialed, Effective Date TBD',
  'WARNING',
  'PENDING',
  'Valentina Park MD credentialed with Blue Shield of CA as of 8/7/2025. Contract effective date not confirmed.',
  'Blue Shield of CA provider agreement',
  '2026-02-27',
  NULL,
  'Blue Shield credentialing record (8/7/2025)',
  'Credentialed 8/7/2025. Contract effective date TBD — unclear if currently billable in-network. Also credentialed with Blue Shield Promise (Medicaid) as of 10/30/2024. Verify both effective dates via Blue Shield provider portal or credentialing contact.'
),

-- ---------------------------------------------------------------------------
-- INFO: CA Professional Corporation Statement of Information
-- ---------------------------------------------------------------------------
(
  'COMP-13',
  'corporate',
  'CA S-Corp Statement of Information — Annual Filing',
  'INFO',
  'PENDING',
  'Valentina Park MD, PC (CA S-Corp) must file a Statement of Information (Form SI-200) annually with the CA Secretary of State to avoid $250 late fees and potential suspension.',
  'CA Corporations Code 13406; CA Secretary of State annual filing requirement',
  '2026-02-27',
  NULL,
  'CA Secretary of State BizFile — Entity #6093174',
  'Verify current filing status at bizfilingca.com or sos.ca.gov/business-programs/business-entities. Entity number: 6093174. CA State ID: 6093174. Filing fee: $25. Must file within anniversary month of incorporation.'
),

-- ---------------------------------------------------------------------------
-- INFO: HIPAA Contingency Plan Testing
-- ---------------------------------------------------------------------------
(
  'COMP-01b',
  'hipaa',
  'HIPAA Contingency Plan Testing — In Progress',
  'INFO',
  'PENDING',
  'HIPAA contingency plan exists but testing is documented as "in progress" in the HIPAA Compliance Record. Must complete tabletop exercise or actual test.',
  '45 CFR 164.308(a)(7) — Contingency Plan',
  '2026-02-27',
  NULL,
  'HIPAA Compliance Record 2025.xlsx',
  'Required per HIPAA Security Rule contingency plan standard. Testing can be a tabletop exercise (reviewing the plan with key staff) for a solo practice. Document the test date and outcome in HIPAA Compliance Record.'
),

-- ---------------------------------------------------------------------------
-- INFO: Device Disposal Vendor Not Finalized
-- ---------------------------------------------------------------------------
(
  'COMP-01c',
  'hipaa',
  'HIPAA Device Disposal Vendor — Not Finalized',
  'INFO',
  'PENDING',
  'Device disposal vendor not finalized per HIPAA Compliance Record. All hardware that has touched ePHI must be disposed of via NIST 800-88-compliant media sanitization.',
  '45 CFR 164.310(d) — Device and Media Controls',
  '2026-02-27',
  NULL,
  'HIPAA Compliance Record 2025.xlsx',
  'For a solo practice, options: (1) Certified ITAD vendor (Iron Mountain, Shred-it), (2) Local certified e-waste facility. Ensure certificate of destruction issued for each device. Low urgency for current phase — no devices being retired currently.'
),

-- ---------------------------------------------------------------------------
-- INFO: CME Mandatory Topics Not Verified
-- ---------------------------------------------------------------------------
(
  'COMP-14',
  'licensing',
  'CME Mandatory Topics — CA-Specific Requirements Not Verified',
  'INFO',
  'PENDING',
  'Valentina has 86.5 CME credits documented. CA mandatory topics (pain management, end-of-life, implicit bias, suicide prevention) not yet verified against the credit list.',
  'CA Business & Professions Code 2190 et seq.; CA Medical License CME requirements',
  '2026-02-27',
  '2028-06-30',
  'CME records (86.5 credits documented)',
  'CA requires 50 CME hours per 2-year renewal cycle with mandatory topics: pain management/end-of-life care (8 hrs), implicit bias (4 hrs, ongoing), suicide prevention (6 hrs total). Verify specific topic compliance against CME records before next license renewal.'
),

-- ---------------------------------------------------------------------------
-- INFO: No Tail Coverage for Pre-July 2024 Work
-- ---------------------------------------------------------------------------
(
  'COMP-15',
  'insurance',
  'Tail Coverage — Prior Employment (Pre-July 2024)',
  'INFO',
  'PENDING',
  'No tail coverage documentation found for clinical work at prior employers before July 2024. Tail coverage protects against claims filed after leaving a practice.',
  'Standard malpractice insurance practice',
  '2026-02-27',
  NULL,
  NULL,
  'Low priority — depends on claims-made vs. occurrence policy at prior employers. If prior employers had claims-made policy, tail coverage should have been purchased at departure. If occurrence policy, no tail needed. Verify with prior employers (CPS, Renew TeleHealth) what policy type was in force.'
),

-- ---------------------------------------------------------------------------
-- INFO: CURES Database Access Verification
-- ---------------------------------------------------------------------------
(
  'COMP-16',
  'prescribing',
  'CURES Database Registration and Access Verified',
  'INFO',
  'PENDING',
  'California requires consultation of CURES (Controlled Substance Utilization Review and Evaluation System) before prescribing controlled substances. Registration and active login access must be verified.',
  'CA Health & Safety Code 11165.4 — Mandatory CURES consultation',
  '2026-02-27',
  NULL,
  NULL,
  'Verify: (1) CURES registration active, (2) Can successfully log in at cures.doj.ca.gov, (3) Test run a lookup to confirm access works. Required before prescribing any Schedule II-V medications. Must check before EVERY controlled substance prescription.'
),

-- ---------------------------------------------------------------------------
-- INFO: DOB Discrepancy in Records
-- ---------------------------------------------------------------------------
(
  'COMP-17',
  'administrative',
  'DOB Discrepancy — 1991 vs 1992 Across Documents',
  'INFO',
  'PENDING',
  'Date of birth discrepancy found across credentialing documents: shows 1991 in some records, 1992 in others. Incorrect DOB can cause credentialing mismatches.',
  'CAQH ProView accuracy requirements; payer credentialing standards',
  '2026-02-27',
  NULL,
  'Multiple credentialing documents',
  'Must determine correct DOB and standardize across all credentialing records. Discrepancies can delay or block payer credentialing verification. Update CAQH ProView with correct DOB. Check: DEA registration, Medicare enrollment, all payer applications for consistency.'
),

-- ---------------------------------------------------------------------------
-- INFO: Address Inconsistencies Across Documents
-- ---------------------------------------------------------------------------
(
  'COMP-18',
  'administrative',
  'Address Inconsistencies — Three Addresses in Use',
  'INFO',
  'PENDING',
  'Three addresses appear across practice documents: (1) 2748 Pacific Coast Hwy #1084, Torrance, CA 90505 (current/canonical), (2) Walnut Creek — CPS prior employer, still on DEA, (3) Palomino Lane — home address, where Medicare deactivation was mailed.',
  'Payer credentialing accuracy requirements; DEA 21 CFR 1301.51',
  '2026-02-27',
  NULL,
  'Multiple credentialing and insurance documents',
  'Canonical address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505. This should be the address on: DEA, CAQH, all payer contracts, NPI Registry, CA Medical License, business license. Action: audit each document and update to Torrance address. DEA address change is already a WARNING action item.'
);


-- =============================================================================
-- SECTION 2: action_items
-- Linked to compliance_items via req_id matching
-- draft_content: ready-to-send emails/scripts, no blanks
-- =============================================================================

-- Action: CAQH Re-Attestation Check
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'CAQH ProView Re-Attestation — Verify and Re-Attest Immediately',
  'Log into CAQH ProView and check last attestation date. Re-attest immediately if profile is expired or within 30 days of expiry. All 17 payer contracts depend on this.',
  'URGENT',
  'OPEN',
  'valentina',
  '2026-03-06',
  '**Step-by-step instructions:**

1. Go to https://proview.caqh.org
2. Log in with your credentials (stored in 1Password under CAQH)
3. Navigate to the "Attestation" tab in the left menu
4. Find the "Last Attested" date and the "Attestation Expiry" date
5. If last attestation was more than 90 days ago, or if status shows "Expired" — proceed immediately:
   - Click "Re-Attest" button
   - Review each section (approximately 5-20 minutes)
   - Confirm all information is current, especially: practice address (Torrance), NPI 1023579513, taxonomy 2084P0800X
   - Submit attestation
6. Screenshot confirmation page with new attestation date
7. Forward screenshot to Maxi for compliance record

**Why this is urgent:** CAQH re-attestation is required every 120 days. If your profile shows "Expired," Blue Shield, Kaiser, Cigna, Anthem, Aetna, and all other payers cannot verify your credentials. This can silently suspend in-network status across all 17 contracts.'
FROM compliance_items WHERE req_id = 'COMP-05';

-- Action: Medicare PECOS Re-Enrollment
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'Medicare PECOS Re-Enrollment — File New Application',
  'PTAN CB496693 deactivated 1/31/2026. Rebuttal window closed 2/13/2026. Must file new Medicare enrollment application via PECOS. No Medicare billing until complete.',
  'URGENT',
  'OPEN',
  'valentina',
  '2026-03-13',
  '**Step-by-step PECOS re-enrollment:**

1. Go to https://pecos.cms.hhs.gov
2. Log in with your PECOS credentials (stored in 1Password under Medicare/PECOS)
3. Select "Start New Application" (not Revalidation — your enrollment was deactivated, not just expired)
4. Application type: "Group Practice" for Valentina Park MD, PC
5. Enter information:
   - Legal Business Name: Valentina Park MD, Professional Corporation
   - Group NPI: 1699504282
   - EIN: 99-1529764
   - Practice Address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505
   - Phone: (424) 248-8090
   - Taxonomy: 2084P0800X (Psychiatry)
6. Also re-enroll individual: NPI 1023579513, PTAN reference CB496694
7. Submit with all required supporting documents (copy of medical license A-177690, DEA FP3833933, malpractice certificate #48289)
8. Note application tracking number — Medicare re-enrollment can take 60-90 days

**What happens if not done:** Cannot bill Medicare for any patient. Medicare rate is $230.65 per session (99214+90833+90785). Every Medicare patient seen without enrollment = uncompensated care or compliance risk.

**Contact:** Medicare Provider Enrollment hotline: 1-855-CMS-1515 if PECOS application has issues.'
FROM compliance_items WHERE req_id = 'COMP-06';

-- Action: Business License Renewal
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'City of Torrance Business License Renewal — BL-LIC-051057',
  'Business license expired 12/31/2025. Must renew with City of Torrance immediately.',
  'URGENT',
  'OPEN',
  'maxi',
  '2026-03-06',
  '**Online renewal (preferred):**
1. Go to https://www.torranceca.gov/business-license
2. Select "Renew Existing License"
3. Enter license number: BL-LIC-051057
4. Business: Valentina Park MD, Professional Corporation
5. Address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505
6. Pay renewal fee (typically $100-$200 for medical professional)
7. Print confirmation and save to compliance folder

**If online renewal is unavailable:**
Call City of Torrance Business License Division: (310) 618-5540
Hours: Monday-Friday 7:30am-5:30pm
Address: 3031 Torrance Blvd, Torrance, CA 90503

**Email template if needed:**

Subject: Business License Renewal — BL-LIC-051057

Dear City of Torrance Business License Division,

I am writing to renew the business license for Valentina Park MD, Professional Corporation (License Number BL-LIC-051057). The license expired December 31, 2025 and I would like to renew immediately.

Business Name: Valentina Park MD, Professional Corporation
License Number: BL-LIC-051057
Business Address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505
Phone: (424) 248-8090
Email: admin@valentinaparkmd.com

Please let me know if additional documentation is required or if I may complete the renewal online.

Thank you,
Maximilian Park
Administrator, Valentina Park MD, PC'
FROM compliance_items WHERE req_id = 'COMP-07';

-- Action: DEA Address Change
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'DEA Registration Address Change — Walnut Creek to Torrance',
  'DEA registration FP3833933 shows Walnut Creek (former CPS employer). Must update to 2748 Pacific Coast Hwy #1084, Torrance, CA 90505 per 21 CFR 1301.51.',
  'SOON',
  'OPEN',
  'valentina',
  '2026-03-27',
  '**Step-by-step DEA address change:**

1. Go to https://apps.deadiversion.usdoj.gov/webforms/
2. Log in with DEA Diversion Control credentials (stored in 1Password)
3. Navigate to "Manage Registrations"
4. Find registration FP3833933
5. Select "Change of Address"
6. New address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505
7. County: Los Angeles
8. State: CA
9. Submit the update

DEA will mail a new registration certificate to the updated address within 4-6 weeks. The current certificate remains valid during processing.

**Why required:** 21 CFR 1301.51 requires DEA registration to reflect the actual registered location. Using a controlled substance at an address different from your DEA registration address is a regulatory violation. The current registration shows Walnut Creek (CPS address), but all prescribing occurs in Torrance.'
FROM compliance_items WHERE req_id = 'COMP-10g';

-- Action: Anthem Contract Follow-Up (via Mary)
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'Anthem Commercial Contract Follow-Up — Request Countersignature from Mary',
  'Provider signed Anthem commercial agreement 5/20/2025. Anthem has not countersigned. Must follow up with Mary (credentialing agent) to escalate.',
  'SOON',
  'OPEN',
  'maxi',
  '2026-03-27',
  'Subject: Anthem Blue Cross Contract — Awaiting Countersignature — Valentina Park MD PC

Hi Mary,

I''m following up on the Anthem Blue Cross commercial provider agreement for Valentina Park MD, Professional Corporation (NPI 1023579513, EIN 99-1529764).

We signed the agreement on May 20, 2025, but we have not received Anthem''s countersignature or confirmation that the contract is fully executed. As a result, we cannot bill Anthem commercial patients in-network.

Could you please:
1. Check the current status of the Anthem commercial contract in your credentialing system
2. Escalate to Anthem''s contract team for countersignature if still pending
3. Also check the Anthem Medicaid agreement — same situation (provider-signed, no Anthem countersignature)
4. Let us know the expected timeline

We are actively preparing to see patients and need these contracts executed as soon as possible.

Thank you for your help,
Maximilian Park
Administrator, Valentina Park MD, PC
admin@valentinaparkmd.com
(424) 248-8090'
FROM compliance_items WHERE req_id = 'COMP-10a';

-- Action: Kaiser DocuSign Follow-Up
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'Kaiser SCPMG Contract — Confirm DocuSign Execution with Nanette Bordenave',
  'Kaiser sent DocuSign contract. Execution status unconfirmed. Must verify with Nanette Bordenave at Kaiser credentialing.',
  'SOON',
  'OPEN',
  'maxi',
  '2026-03-27',
  'Subject: Provider Contract Execution Status — Valentina Park MD PC — NPI 1023579513

Hi Nanette,

I am following up on the provider contract for Dr. Valentina Park (NPI: 1023579513, Individual; Group NPI: 1699504282) with Southern California Permanente Medical Group.

A provider agreement was sent via DocuSign, but we have not received confirmation that the contract is fully executed by both parties. Could you please confirm:

1. Whether the DocuSign agreement has been completed by SCPMG
2. The contract effective date (when we can begin billing Kaiser patients in-network)
3. Whether there are any outstanding items needed from our side

Practice information:
- Provider: Valentina Park, MD
- Entity: Valentina Park MD, Professional Corporation
- Individual NPI: 1023579513
- Group NPI: 1699504282
- EIN: 99-1529764
- Taxonomy: 2084P0800X (Psychiatry)
- Address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505

Please feel free to contact me directly at the information below.

Thank you,
Maximilian Park
Administrator, Valentina Park MD, PC
admin@valentinaparkmd.com
(424) 248-8090'
FROM compliance_items WHERE req_id = 'COMP-10c';

-- Action: Cigna Contract Follow-Up
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'Cigna/Evernorth Contract Follow-Up — 14 Months Since Document Submission',
  'Cigna requested documents 12/9/2024 — no contract executed in 14+ months. Must follow up and escalate.',
  'SOON',
  'OPEN',
  'maxi',
  '2026-03-27',
  'Subject: Provider Contract Follow-Up — Valentina Park MD PC — Submitted 12/9/2024

Dear Cigna/Evernorth Provider Relations,

I am writing to follow up on the credentialing and contracting application for Dr. Valentina Park (NPI: 1023579513) with Cigna/Evernorth.

Documents were requested and submitted on December 9, 2024. It has now been over 14 months with no contract execution or status update. We need to confirm the current status and obtain an executed provider agreement.

Provider information:
- Provider: Valentina Park, MD
- Individual NPI: 1023579513
- Group NPI: 1699504282
- EIN: 99-1529764
- Taxonomy: 2084P0800X (Psychiatry)
- CAQH ID: 16149210
- Practice Address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505

Please advise on:
1. Current application status
2. Any outstanding documentation required
3. Expected timeline to contract execution

We look forward to resolving this and joining the Cigna network.

Maximilian Park
Administrator, Valentina Park MD, PC
admin@valentinaparkmd.com
(424) 248-8090'
FROM compliance_items WHERE req_id = 'COMP-10d';

-- Action: Carelon Application Follow-Up
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'Carelon (Anthem Behavioral Health) Application Follow-Up — 18+ Months Pending',
  'Carelon application submitted 7/23/2024. No approval or status update in 18+ months. Must escalate immediately.',
  'SOON',
  'OPEN',
  'maxi',
  '2026-03-27',
  'Subject: Credentialing Application Status — Valentina Park MD PC — Submitted July 2024

Dear Carelon Provider Relations,

I am writing to inquire about the status of the credentialing application for Dr. Valentina Park (NPI: 1023579513) submitted to Carelon (formerly Beacon Health Options) on July 23, 2024.

It has been over 18 months since the application was submitted and we have not received any status updates, requests for additional information, or a determination. This delay is significantly impacting the practice''s ability to serve patients with Carelon-covered insurance.

Provider information:
- Provider: Valentina Park, MD
- Individual NPI: 1023579513
- Group NPI: 1699504282
- EIN: 99-1529764
- Taxonomy: 2084P0800X (Psychiatry — also board certified Child & Adolescent Psychiatry)
- CAQH ID: 16149210
- Practice Address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505

Please advise immediately on:
1. Current application status
2. Any outstanding items needed from our end
3. Expected timeframe for credentialing determination

We are also working with Anthem Blue Cross on provider agreements. Please coordinate with your Anthem colleagues if needed.

Maximilian Park
Administrator, Valentina Park MD, PC
admin@valentinaparkmd.com
(424) 248-8090'
FROM compliance_items WHERE req_id = 'COMP-10e';

-- Action: Tricare TIN Correction
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'Tricare/HNFS TIN Correction — Fix Wrong EIN on Application',
  'Tricare application has wrong TIN (941706811 instead of correct EIN 99-1529764). Must submit correction to HNFS.',
  'SOON',
  'OPEN',
  'maxi',
  '2026-03-27',
  'Subject: EIN/TIN Correction Request — Provider Application — Valentina Park MD PC

Dear HNFS Provider Relations,

I am writing to submit a correction to the credentialing application for Dr. Valentina Park (NPI: 1023579513) with TRICARE/HNFS.

We identified an error in the Tax Identification Number (TIN) submitted on our provider application. The correct EIN is 99-1529764, not the number currently on file.

Correction needed:
- Incorrect TIN on file: 94-1706811 (or similar transposition)
- Correct EIN: 99-1529764
- Legal Entity Name: Valentina Park MD, Professional Corporation
- Individual NPI: 1023579513
- Group NPI: 1699504282

Please update our application with the correct EIN and advise on next steps for completing the credentialing process.

Supporting documentation available upon request: IRS EIN assignment letter for Valentina Park MD, Professional Corporation (EIN 99-1529764).

Maximilian Park
Administrator, Valentina Park MD, PC
admin@valentinaparkmd.com
(424) 248-8090'
FROM compliance_items WHERE req_id = 'COMP-10f';

-- Action: Move sensitive data to 1Password
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'Migrate Sensitive Credentials from Word Docs to 1Password',
  'SSN, portal passwords, and credential numbers stored in Master Key.docx and liscensing notes.docx. Must move to 1Password and securely delete originals.',
  'SOON',
  'OPEN',
  'maxi',
  '2026-03-13',
  '**Step-by-step migration:**

1. Open Master Key.docx and liscensing notes.docx
2. For each credential/password found:
   a. Create a new entry in 1Password (Brighter Days vault)
   b. Categorize correctly: Login (portals), Identity (SSN/credentials), Secure Note (other)
   c. Copy each value precisely into 1Password
3. After all items are migrated, test each login/credential from 1Password
4. Once verified, securely delete both Word documents:
   - On Mac: Move to Trash, then Secure Empty Trash (or use srm command in Terminal)
   - Or use a secure deletion app
5. Check iCloud/Dropbox/OneDrive sync — ensure deleted files are removed from cloud sync too
6. Document completion date in HIPAA Compliance Record

**Priority items to migrate:**
- DEA portal credentials
- PECOS/Medicare portal credentials
- CAQH ProView credentials
- All payer credentialing portal logins
- SSN (store as Identity in 1Password)
- Any banking or tax credentials'
FROM compliance_items WHERE req_id = 'COMP-12';

-- Action: General Liability Insurance Quote
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'General Liability Insurance — Get Quotes and Purchase Policy',
  'No general liability insurance found. Required by most payer contracts. Must research options and purchase coverage.',
  'SOON',
  'OPEN',
  'maxi',
  '2026-03-27',
  '**Research general liability insurance for solo medical practice:**

Recommended carriers to contact for quotes:
1. **Proliability** (HPSO) — https://www.proliability.com — popular with solo practitioners
2. **CM&F Group** — https://www.cmfgroup.com — medical professional liability packages
3. **MedPro Group** — https://www.medpro.com
4. **State Farm Business Insurance** — can bundle with other policies

**What to ask for:**
- General Liability: $1 million per occurrence / $2 million aggregate (standard payer contract requirement)
- Business Owner''s Policy (BOP): combines general liability + property
- Telehealth-specific endorsement if needed

**Expected cost:** $500-$2,000/year for solo medical practice

**Information to provide to carriers:**
- Business: Valentina Park MD, Professional Corporation
- EIN: 99-1529764
- Address: 2748 Pacific Coast Hwy #1084, Torrance, CA 90505
- Business type: Telehealth psychiatry practice
- Employees: 1-2 (solo physician + administrator)
- Annual revenue: [Valentina to provide estimated annual revenue]'
FROM compliance_items WHERE req_id = 'COMP-11a';

-- Action: Workers Compensation Determination
INSERT INTO action_items (compliance_item_id, title, description, priority, status, assigned_to, due_date, draft_content)
SELECT id,
  'Determine Workers Compensation Need Based on Maxi Employment Classification',
  'Workers comp required if Maxi is classified as employee of Valentina Park MD, PC. Employment classification must be determined first.',
  'SOON',
  'OPEN',
  'maxi',
  '2026-03-27',
  '**Step 1: Determine employment classification**

Factors pointing to EMPLOYEE classification (workers comp required):
- Maxi works regular hours for the practice
- Maxi uses practice-provided equipment/systems
- Practice controls how work is done (not just what is done)
- Maxi''s work is integral to the core business

Factors pointing to INDEPENDENT CONTRACTOR (workers comp may not be required):
- Maxi operates under a separate business entity
- Maxi sets own schedule and methods
- Maxi provides services to multiple clients
- Written independent contractor agreement exists

**Step 2: If employee classification — purchase workers comp**
- In California, all employers (even with 1 employee) must carry workers compensation
- Contact: State Compensation Insurance Fund (SCIF) — scif.com — 1-888-782-7243
- Or get quotes from private carriers: Zenefits, Gusto (payroll platforms offer workers comp)
- For a 2-person admin office: expected cost $500-$1,500/year

**Recommend:** Consult with a CA employment attorney or CPA to confirm classification. Misclassification carries significant penalties in California.'
FROM compliance_items WHERE req_id = 'COMP-11b';


-- =============================================================================
-- SECTION 3: baa_tracker
-- All vendors that handle or may handle PHI
-- =============================================================================

INSERT INTO baa_tracker (vendor_name, vendor_type, handles_phi, baa_status, baa_date, baa_location, notes) VALUES

(
  'Tebra',
  'ehr',
  true,
  'INCORPORATED_IN_TOS',
  '2025-03-07',
  'Tebra Customer Agreement signed 3/7/2025 (renews 5/7/2026). BAA incorporated into Terms of Service.',
  'Primary EHR, billing, e-prescribing. BAA is not a separate document — incorporated into customer agreement. Tebra BAA URL: https://www.tebra.com/business-associate-agreement. Contact: Susan Delao (susan.delao@tebra.com). Next renewal: 5/7/2026.'
),

(
  'Supabase (Brighter Days project)',
  'database',
  false,
  'PENDING',
  NULL,
  'Must upgrade to Team plan and enable HIPAA add-on before signing BAA',
  'Phase 1 data is practice management data, NOT patient PHI. BAA not required for Phase 1. Must establish BAA before Phase 3 when patient-adjacent data may enter. Action: Upgrade to Supabase Team plan + HIPAA add-on ($350/mo additional). HIPAA add-on URL: https://supabase.com/docs/guides/security/hipaa-compliance'
),

(
  'Gmail (valentinaparkmd@gmail.com)',
  'email',
  true,
  'NOT_SIGNED',
  NULL,
  'Personal Gmail — BAA not available for consumer accounts',
  'CRITICAL GAP if used for patient PHI. Personal Gmail accounts cannot sign a HIPAA BAA. Must confirm: (1) Is this account used for patient communications? (2) Is there a Google Workspace account for admin@valentinaparkmd.com? If yes to #2, Google Workspace BAA is available. If using personal Gmail for PHI, must switch to HIPAA-compliant email (Google Workspace Business, Paubox, etc.).'
),

(
  'Google Workspace / admin@valentinaparkmd.com',
  'email',
  true,
  'PENDING',
  NULL,
  'Domain valentinaparkmd.com exists (GoDaddy, renews 2027-06-13). Need to verify if Google Workspace is active for this domain.',
  'If Google Workspace Business is active for valentinaparkmd.com domain, Google offers a BAA (covered under Google Workspace for Business). Must confirm: login to admin.google.com, check organization settings, sign BAA at workspace.google.com/terms/baa/. If Workspace not active — set it up and sign BAA before any patient email communications.'
),

(
  'Video Telehealth Platform',
  'video',
  true,
  'PENDING',
  NULL,
  'Platform not identified in document audit. Tebra may have built-in telehealth module.',
  'Must identify which video platform is being used for telehealth sessions. Options: (1) Tebra built-in telehealth — covered by existing Tebra BAA, (2) Zoom for Healthcare — requires HIPAA BAA from Zoom, (3) Doxy.me — HIPAA-compliant, no BAA needed for free tier. Verify with Tebra what telehealth video feature is in use.'
),

(
  '1Password',
  'storage',
  false,
  'NOT_REQUIRED',
  NULL,
  '1Password stores credentials and encryption keys, not patient PHI. Not a Business Associate.',
  'Stores portal credentials (DEA, PECOS, CAQH, etc.) — these are practice credentials, not patient health information. 1Password is not a Business Associate under HIPAA. No BAA needed.'
),

(
  'GoDaddy (domain/hosting)',
  'storage',
  false,
  'NOT_REQUIRED',
  NULL,
  'Domain registration only (valentinaparkmd.com, renews 2027-06-13). Does not handle PHI.',
  'GoDaddy hosts the domain registration for valentinaparkmd.com. If no patient data passes through GoDaddy hosting (website is informational only), no BAA required. If website collects any patient intake data, reconsider.'
),

(
  'CloudFlare (DNS/CDN)',
  'infrastructure',
  false,
  'NOT_REQUIRED',
  NULL,
  'DNS and CDN routing only — does not store patient data.',
  'DNS provider. If CloudFlare is only handling DNS routing (not storing data), no BAA required. If CloudFlare Argo or other data-processing features are enabled, reassess.'
);
