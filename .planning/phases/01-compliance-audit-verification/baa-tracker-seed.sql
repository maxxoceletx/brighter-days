-- ============================================================
-- BAA Tracker Seed Data
-- Practice: Valentina Park MD, Professional Corporation
-- EIN: 99-1529764 | NPI: 1023579513
-- Generated: 2026-02-27
-- References: compliance-schema.sql (baa_tracker table)
-- ============================================================
-- BAA Status Values: SIGNED | INCORPORATED_IN_TOS | NOT_SIGNED | NOT_REQUIRED | PENDING

-- NOTE: This file inserts directly into the baa_tracker table.
-- The companion compliance_items BAA record (COMP-02) references this tracker.
-- Run compliance-schema.sql first to create the table before running this seed.

-- Clear existing data for idempotent re-run
DELETE FROM baa_tracker;

INSERT INTO baa_tracker (
  vendor_name,
  vendor_type,
  handles_phi,
  baa_status,
  baa_date,
  baa_location,
  notes
) VALUES

-- 1. Tebra (EHR) — BAA incorporated into Terms of Service
(
  'Tebra (formerly Kareo)',
  'ehr',
  true,
  'INCORPORATED_IN_TOS',
  '2025-03-07',
  'Tebra Customer Agreement — accepted during account setup. Full agreement at tebra.com/business-associate-agreement. Effective date matches contract start date from Tebra subscription agreement.',
  'BAA incorporated into Tebra Customer Agreement per tebra.com/business-associate-agreement. Contract effective 3/7/2025, renews 5/7/2026. Monthly fee ~$339 (Patient Pop + Practice Growth). Action required: Log into Tebra account, navigate to Settings > Legal/Agreements, screenshot or export the Terms of Service acceptance record to document the BAA acceptance date for OCR audit purposes. Contact: Susan Delao (susan.delao@tebra.com).'
),

-- 2. Telehealth video platform — BAA on file per HIPAA spreadsheet
(
  'Telehealth Video Platform (identity TBD)',
  'video',
  true,
  'SIGNED',
  NULL,
  'BAA on file — location not yet confirmed. Locate in email records from practice setup (2024-2025) or Tebra account if using Tebra built-in telehealth module.',
  'HIPAA Compliance Record 2025.xlsx confirms BAA on file for telehealth platform. ACTION REQUIRED: (1) Identify which platform is being used — Tebra built-in telehealth module, Zoom for Healthcare, Doxy.me, or other. (2) If Tebra built-in: BAA covered by Tebra Terms of Service (see Tebra entry above). (3) If separate platform: locate signed BAA in email inbox or vendor account. (4) Record exact platform name, BAA date, and document location in this tracker. TARGET: 2026-03-31.'
),

-- 3. Cloud backup provider — BAA on file per HIPAA spreadsheet
(
  'Cloud Backup Provider (identity TBD)',
  'cloud_storage',
  true,
  'SIGNED',
  NULL,
  'BAA on file — location and provider not yet confirmed. Locate in email records or subscription records from practice setup.',
  'HIPAA Compliance Record 2025.xlsx confirms BAA on file for cloud backup provider. ACTION REQUIRED: (1) Identify the specific cloud backup provider (e.g., Backblaze, Carbonite, iDrive, or a Tebra-included backup service). (2) Locate signed BAA agreement. (3) Record provider name, BAA date, and document location in this tracker. (4) Note: If backup is handled solely by Tebra as part of their service, it may be covered by the Tebra BAA — confirm with Tebra support. TARGET: 2026-03-31.'
),

-- 4a. Email — valentinaparkmd@gmail.com (consumer Gmail — CRITICAL GAP)
(
  'Google Gmail (consumer) — valentinaparkmd@gmail.com',
  'email',
  true,
  'NOT_SIGNED',
  NULL,
  'CRITICAL GAP: Consumer Gmail accounts are NOT eligible for a BAA with Google. Google only provides a BAA for Google Workspace Business/Enterprise accounts. Consumer Gmail cannot be HIPAA-compliant for PHI.',
  'CRITICAL HIPAA VIOLATION RISK: valentinaparkmd@gmail.com is a consumer Gmail account. If this account is used to communicate with patients or exchange PHI with other providers, it is a HIPAA violation. Google''s HIPAA BAA is only available for Google Workspace Business Starter ($6/user/month) or higher — not free consumer Gmail accounts. IMMEDIATE ACTION REQUIRED: (1) Stop using valentinaparkmd@gmail.com for any patient communication or PHI-containing messages NOW. (2) Migrate to Google Workspace for valentinaparkmd.com domain — verify whether admin@valentinaparkmd.com is already on Workspace. (3) If admin@valentinaparkmd.com is on Google Workspace, enable the BAA in Google Admin Console (admin.google.com > Account > Legal and Compliance > HIPAA). (4) All patient communications must route through the HIPAA-compliant email address. TARGET: 2026-03-15.'
),

-- 4b. Email — admin@valentinaparkmd.com (likely Google Workspace — BAA available)
(
  'Google Workspace — admin@valentinaparkmd.com',
  'email',
  true,
  'PENDING',
  NULL,
  'admin@valentinaparkmd.com appears to be a Google Workspace account (custom domain). Google Workspace Business Starter and above support BAA via Admin Console. BAA must be explicitly enabled — it is NOT automatic.',
  'PENDING VERIFICATION: admin@valentinaparkmd.com uses the custom domain valentinaparkmd.com which is registered with GoDaddy and likely routed through Google Workspace. ACTION REQUIRED: (1) Log into Google Admin Console (admin.google.com) using admin credentials. (2) Navigate to Account > Legal and Compliance (or Account > Legal). (3) Locate the HIPAA Business Associate Amendment. (4) If not yet accepted: click to review and accept the Google HIPAA BAA. (5) Record the acceptance date in this tracker and update baa_status to SIGNED. (6) Google Workspace plan must be Business Starter ($6/user/month) or higher — confirm current plan. NOTE: If admin@valentinaparkmd.com is actually forwarding to Gmail consumer, treat it the same as the Gmail consumer entry above. TARGET: 2026-03-15.'
),

-- 5. Google Voice — practice phone (424) 248-8090
(
  'Google Voice — (424) 248-8090',
  'phone',
  true,
  'PENDING',
  NULL,
  'Practice phone (424) 248-8090 uses Google Voice. BAA availability depends on account type: Google Workspace Voice (BAA available) vs. consumer Google Voice (BAA NOT available). Must verify which version is in use.',
  'PENDING VERIFICATION: Phone number (424) 248-8090 is Google Voice. Patient calls and voicemails may contain PHI. ACTION REQUIRED: (1) Log into the Google Voice account and check the account type. (2) If Google Voice for Google Workspace: The HIPAA BAA from step 4b above covers Voice as part of Workspace. Enable BAA in Admin Console (covers Gmail, Drive, Docs, Voice, Calendar, and other core Workspace services under one agreement). (3) If consumer Google Voice: CRITICAL — consumer Google Voice does NOT support BAA. Must migrate to Google Voice for Google Workspace or switch to a HIPAA-compliant phone solution (e.g., RingCentral HIPAA, Dialpad HIPAA, or Spruce Health). (4) If voicemail messages contain PHI (patient names, appointment details, medication references), this is an active HIPAA violation until resolved. TARGET: 2026-03-15.'
),

-- 6. Supabase — Brighter Days project (no PHI in Phase 1)
(
  'Supabase (Brighter Days project)',
  'database',
  false,
  'NOT_REQUIRED',
  NULL,
  'BAA not currently required. Phase 1 compliance data (item names, statuses, drafted documents) is NOT patient PHI. BAA will be required before any patient data enters the system (Phase 3+).',
  'Phase 1 status: NOT REQUIRED. Supabase currently stores practice compliance audit data — not patient records. This is practice management data, not PHI. FUTURE ACTION: Before Phase 3 (patient-facing systems with PHI): (1) Upgrade Brighter Days Supabase project to Team plan (~$599/month). (2) Request and sign HIPAA add-on agreement with Supabase. (3) Update this tracker to SIGNED status. (4) Estimated cost: ~$599/month base + ~$350/month HIPAA add-on = ~$950/month total. Note: Supabase BAA is triggered at first patient data entry — do not delay past Phase 3 launch.'
),

-- 7. 1Password
(
  '1Password',
  'password_manager',
  false,
  'NOT_REQUIRED',
  NULL,
  'Stores credentials and access keys, not patient records. Credentials are not PHI under HIPAA. No BAA required.',
  '1Password is used to store login credentials for practice systems (Tebra, payer portals, Google Workspace, etc.). Credentials (usernames/passwords) are not Protected Health Information. 1Password does not create, receive, maintain, or transmit ePHI on behalf of the practice. Not a Business Associate. BAA not required. However: 1Password security should be maintained at highest settings — enable 2FA, use a strong unique Master Password, keep team membership current.'
),

-- 8. GoDaddy (domain registration)
(
  'GoDaddy',
  'domain_registrar',
  false,
  'NOT_REQUIRED',
  NULL,
  'Domain registration only — valentinaparkmd.com (renews 2027-06-13). No PHI exposure. Not a Business Associate.',
  'GoDaddy is the registrar for valentinaparkmd.com (renews 2027-06-13). Domain registration does not involve PHI. GoDaddy does not access, store, or transmit patient information. Not a Business Associate. BAA not required. ACTION: Ensure auto-renewal is enabled to prevent domain expiration. Ensure domain contact email is current.'
),

-- 9. Medi-Cal (DHCS) — as payer, not BA
(
  'California DHCS (Medi-Cal)',
  'payer',
  false,
  'NOT_REQUIRED',
  NULL,
  'Payer relationship, not Business Associate relationship. PHI submitted to Medi-Cal for billing is a Treatment, Payment, Operations (TPO) disclosure — no BAA required with payers. Medi-Cal PAVE ID: 100517999.',
  'Medi-Cal/DHCS is a payer (health plan). Disclosures of PHI to health plans for payment purposes are permitted under HIPAA 45 CFR 164.506 (Treatment, Payment, Operations) without a BAA. This is not a Business Associate relationship — it is a covered entity-to-covered entity disclosure for payment. Same applies to Medicare, Blue Shield, Aetna, and all other insurance payers.'
),

-- 10. Clearinghouse (for claims submission via Tebra)
(
  'Tebra Clearinghouse / Availity (if separate)',
  'clearinghouse',
  true,
  'INCORPORATED_IN_TOS',
  '2025-03-07',
  'Claims clearinghouse services provided through Tebra. BAA incorporated into Tebra Customer Agreement. If Availity or another clearinghouse is used directly (not through Tebra), a separate BAA is required.',
  'Electronic claims are submitted through Tebra''s integrated clearinghouse function. As a Tebra Business Associate covered by the Tebra Customer Agreement, the clearinghouse function is covered under the Tebra BAA. ACTION REQUIRED: Verify whether Tebra routes claims through Availity or another clearinghouse. If any clearinghouse is accessed directly by the practice outside of Tebra, a separate BAA must be obtained. If all clearinghouse activity goes through Tebra, no separate BAA is needed.'
);

-- ============================================================
-- Summary Query (run after seeding to verify)
-- ============================================================
-- SELECT vendor_name, vendor_type, handles_phi, baa_status
-- FROM baa_tracker
-- ORDER BY
--   CASE baa_status
--     WHEN 'NOT_SIGNED' THEN 1
--     WHEN 'PENDING' THEN 2
--     WHEN 'SIGNED' THEN 3
--     WHEN 'INCORPORATED_IN_TOS' THEN 4
--     WHEN 'NOT_REQUIRED' THEN 5
--   END,
--   vendor_name;
