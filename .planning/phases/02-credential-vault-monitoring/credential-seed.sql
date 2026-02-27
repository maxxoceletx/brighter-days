-- =============================================================================
-- Brighter Days Credential System — Seed Data
-- Practice: Valentina Park MD, Professional Corporation
-- Created: 2026-02-27
-- Purpose: Pre-populate credentials table with all known credentials from
--          Phase 1 document audit. Real numbers only — no placeholders.
--
-- FK pattern: compliance_item_id uses subselect on req_id for Phase 1 links.
--             Credentials with no Phase 1 compliance_items row use NULL.
--
-- CRITICAL: Medicare status = ACTIVE per Phase 2 CONTEXT.md correction.
--           Phase 1 showed DEACTIVATED 1/31/2026 — this is incorrect.
--           Valentina confirmed ACTIVE enrollment as of 2026-02-27.
--
-- holder values: 'valentina' = personal/professional credentials
--                'entity' = Valentina Park MD, Professional Corporation credentials
-- =============================================================================


-- =============================================================================
-- 1. CA Medical License A-177690
--    Links to compliance_items COMP-08 (Phase 1 licensing row)
--    2-year renewal cycle via CA BreEZe portal
--    Phase 1 finding: license is ACTIVE and current
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  (SELECT id FROM compliance_items WHERE req_id = 'COMP-08' LIMIT 1),
  'license',
  'CA Medical License A-177690',
  'CA Medical Board',
  'A-177690',
  'valentina',
  'ACTIVE',
  '2028-06-30',
  730,
  NULL,
  'https://www.breeze.ca.gov/',
  'Log in to CA BreEZe to renew. Renewal opens 90 days before expiry. CME requirements must be met before renewal submission.',
  true, true, true, true,
  'CA BreEZe (Medical Board)',
  'Phase 1 document audit — license verified ACTIVE',
  'Expires 2028-06-30. 2-year renewal cycle. CME required for renewal.'
);


-- =============================================================================
-- 2. DEA Registration FP3833933
--    Links to compliance_items COMP-10 (Phase 1 DEA/prescribing row)
--    3-year renewal cycle via DEA Diversion Control Portal (online only)
--    CRITICAL NOTE: DEA shows Walnut Creek address (prior employer CPS);
--    practice address is Torrance. Must update per 21 CFR 1301.51.
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  (SELECT id FROM compliance_items WHERE req_id = 'COMP-10' LIMIT 1),
  'dea',
  'DEA Registration FP3833933',
  'DEA Diversion Control Division',
  'FP3833933',
  'valentina',
  'ACTIVE',
  '2027-03-31',
  1095,
  731.00,
  'https://www.deaecom.gov/',
  'URGENT ADDRESS ISSUE: DEA registration currently shows Walnut Creek address (prior employer CPS). Practice address is Torrance (2748 Pacific Coast Hwy #1084, Torrance, CA 90505). Must update address via DEA Diversion Control Portal per 21 CFR 1301.51 before re-credentialing cycles flag mismatch. Renewal online only — paper eliminated in 2024.',
  true, true, true, true,
  'DEA Diversion Control Portal',
  'Phase 1 document audit — DEA certificate verified ACTIVE',
  'Expires 2027-03-31. 3-year cycle. $731 renewal fee. Address mismatch: Walnut Creek vs Torrance — correct in DEA portal.'
);


-- =============================================================================
-- 3. ABPN Psychiatry Certification #83742
--    No compliance_item_id — no Phase 1 compliance_items row for ABPN certs
--    Continuous Certification (CC) — no fixed expiry; MOC requirements ongoing
--    Alert booleans all FALSE — no expiry date to alert on
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'certification',
  'ABPN Psychiatry Certification #83742',
  'American Board of Psychiatry and Neurology',
  '83742',
  'valentina',
  'ACTIVE',
  NULL,
  NULL,
  NULL,
  'https://www.abpn.com/',
  'Continuous Certification (CC) program — no fixed renewal date. MOC (Maintenance of Certification) requirements must be met on ongoing basis. Verify MOC status annually via ABPN portal.',
  false, false, false, false,
  'ABPN Portal (Psychiatry)',
  'Phase 1 document audit — ABPN certification verified',
  'Continuous Certification. No fixed expiry. MOC program requires ongoing participation. Cert #83742.'
);


-- =============================================================================
-- 4. ABPN Child & Adolescent Psychiatry Certification #13399
--    Same pattern as ABPN Psychiatry — Continuous Certification, no expiry
--    Alert booleans all FALSE
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'certification',
  'ABPN Child & Adolescent Psychiatry Certification #13399',
  'American Board of Psychiatry and Neurology',
  '13399',
  'valentina',
  'ACTIVE',
  NULL,
  NULL,
  NULL,
  'https://www.abpn.com/',
  'Continuous Certification (CC) program — no fixed renewal date. Same MOC requirements as general psychiatry certification.',
  false, false, false, false,
  'ABPN Portal (Child & Adolescent)',
  'Phase 1 document audit — ABPN Child & Adolescent certification verified',
  'Continuous Certification. No fixed expiry. MOC program ongoing. Cert #13399.'
);


-- =============================================================================
-- 5. CAQH ProView Attestation — CAQH ID 16149210
--    HIGHEST-RISK credential: one missed cycle can silently suspend ALL 17 payer
--    contracts simultaneously. 120-day re-attestation cycle.
--    expiry_date = NULL because last attestation date is UNKNOWN from Phase 1.
--    Valentina must log in to proview.caqh.org and verify current attestation date.
--    expiry_date = last_attestation_date + 120 days. Update this row after verifying.
--    All alert booleans TRUE — do not lower these.
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'caqh',
  'CAQH ProView Attestation — CAQH ID 16149210',
  'CAQH',
  '16149210',
  'valentina',
  'ACTIVE',
  NULL,
  120,
  0.00,
  'https://proview.caqh.org',
  'CAQH ProView requires re-attestation every 120 days. Missing ONE cycle can silently suspend in-network status with ALL 17 payer contracts simultaneously. The 90-day alert fires when 30 days have passed since last attestation — this is intentional to provide time to re-attest before the halfway point. Process: Log in → Attestation tab → Review current information → Submit. Takes 5-20 minutes.',
  true, true, true, true,
  'CAQH ProView',
  NULL,
  'UPDATE REQUIRED: Valentina must log into proview.caqh.org and verify last attestation date. Set expiry_date = last_attestation_date + 120 days in this row after verifying. CAQH ID: 16149210. FREE re-attestation — no fee.'
);


-- =============================================================================
-- 6. Malpractice Insurance CAP/MPT Policy #48289
--    Links to compliance_items COMP-09 (Phase 1 insurance row)
--    Annual renewal cycle; professional malpractice for Valentina individually
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  (SELECT id FROM compliance_items WHERE req_id = 'COMP-09' LIMIT 1),
  'malpractice',
  'Malpractice Insurance CAP/MPT Policy #48289',
  'CAP/MPT (The Doctors Company)',
  '48289',
  'valentina',
  'ACTIVE',
  '2026-12-31',
  365,
  NULL,
  'https://www.cap-mpt.com/',
  'Annual renewal. Log in to CAP/MPT portal. Premiums vary by specialty and claims history. Psychiatry/telehealth coverage should be confirmed at renewal.',
  true, true, true, true,
  'CAP/MPT Portal (Malpractice)',
  'Phase 1 document audit — malpractice policy verified ACTIVE',
  'Individual professional malpractice. Policy #48289. Expires 2026-12-31. Annual renewal. Confirm telehealth coverage scope at renewal.'
);


-- =============================================================================
-- 7. S-Corp Entity Coverage Policy #10709
--    Entity-level malpractice/liability for Valentina Park MD, Professional Corp
--    No compliance_item_id — no separate Phase 1 row for entity coverage
--    Annual renewal; expires same date as individual policy
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'insurance',
  'S-Corp Entity Coverage CAP/MPT Policy #10709',
  'CAP/MPT (The Doctors Company)',
  '10709',
  'entity',
  'ACTIVE',
  '2026-12-31',
  365,
  NULL,
  'https://www.cap-mpt.com/',
  'Entity-level malpractice/liability coverage for Valentina Park MD, Professional Corporation. Annual renewal. Typically renewed concurrently with individual policy #48289.',
  true, true, true, true,
  'CAP/MPT Portal (Entity Coverage)',
  'Phase 1 document audit — entity coverage verified ACTIVE',
  'S-Corp entity coverage. Policy #10709. Expires 2026-12-31. Annual renewal. Renew together with individual policy #48289.'
);


-- =============================================================================
-- 8. Business License Torrance BL-LIC-051057
--    EXPIRED as of 2025-12-31 — renewal required immediately
--    City of Torrance annual business license
--    No compliance_item_id needed — not in Phase 1 compliance_items as separate row
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'business_license',
  'Business License Torrance BL-LIC-051057',
  'City of Torrance',
  'BL-LIC-051057',
  'entity',
  'EXPIRED',
  '2025-12-31',
  365,
  NULL,
  'https://www.torranceca.gov/',
  'EXPIRED — renewal required immediately. Visit torranceca.gov or contact City of Torrance Finance Department. Annual license tied to the practice address at 2748 Pacific Coast Hwy #1084, Torrance, CA 90505. Late fees may apply.',
  true, true, true, true,
  'City of Torrance Business License Portal',
  'Phase 1 document audit — business license flagged EXPIRED',
  'EXPIRED as of 2025-12-31. Renewal is an active action item from Phase 1. Renew at torranceca.gov. License #BL-LIC-051057.'
);


-- =============================================================================
-- 9. CA Statement of Information (Annual)
--    Filed with CA Secretary of State; required for all S-Corps annually
--    PENDING — status requires Valentina to verify last filing date
--    No credential_number — varies by filing year/confirmation number
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'corporate_filing',
  'CA Statement of Information (Annual) — Valentina Park MD, PC',
  'CA Secretary of State',
  NULL,
  'entity',
  'PENDING',
  NULL,
  365,
  25.00,
  'https://bizfileplus.sos.ca.gov/',
  'Annual filing required for all CA S-Corps. $25 filing fee. Due date is based on original incorporation date. CA Entity Number: 6093174. File via bizfileplus.sos.ca.gov using the entity number.',
  true, true, true, true,
  'CA Secretary of State BizFile',
  NULL,
  'STATUS PENDING: Valentina must log into bizfileplus.sos.ca.gov and verify last filing date. Set expiry_date = last_filing_date + 365 days. CA Entity #6093174. $25 annual filing fee.'
);


-- =============================================================================
-- 10. Medicare PTAN Group CB496693
--     STATUS: ACTIVE — per Phase 2 CONTEXT.md correction.
--     Phase 1 incorrectly flagged as DEACTIVATED 1/31/2026.
--     Valentina confirmed ACTIVE enrollment as of 2026-02-27.
--     5-year re-enrollment cycle via PECOS.
--     No expiry_date — Medicare PTANs don't have a fixed expiry date;
--     the 5-year re-enrollment trigger is a revalidation, not a renewal.
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'payer_id',
  'Medicare PTAN Group CB496693',
  'CMS (Centers for Medicare & Medicaid Services)',
  'CB496693',
  'entity',
  'ACTIVE',
  NULL,
  1825,
  NULL,
  'https://pecos.cms.hhs.gov/',
  'Medicare group PTAN for Valentina Park MD, Professional Corporation. Re-validation (not renewal) required every 5 years via PECOS. Submission is online only. Group NPI on file: 1699504282. EIN: 99-1529764.',
  true, true, true, true,
  'Medicare PECOS',
  NULL,
  'Status corrected per Phase 2 discussion — Valentina confirmed ACTIVE enrollment 2026-02-27. Phase 1 showed DEACTIVATED 1/31/2026 — incorrect. Group PTAN CB496693. 5-year re-validation cycle. Verify in PECOS portal if in doubt.'
);


-- =============================================================================
-- 11. Medicare PTAN Individual CB496694
--     Same correction as Group PTAN — ACTIVE per CONTEXT.md.
--     Individual NPI on file: 1023579513.
--     5-year re-enrollment/re-validation cycle via PECOS.
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'payer_id',
  'Medicare PTAN Individual CB496694',
  'CMS (Centers for Medicare & Medicaid Services)',
  'CB496694',
  'valentina',
  'ACTIVE',
  NULL,
  1825,
  NULL,
  'https://pecos.cms.hhs.gov/',
  'Medicare individual PTAN for Valentina Park, MD. Re-validation every 5 years via PECOS. Individual NPI on file: 1023579513. EIN: 99-1529764.',
  true, true, true, true,
  'Medicare PECOS',
  NULL,
  'Status corrected per Phase 2 discussion — Valentina confirmed ACTIVE enrollment 2026-02-27. Phase 1 showed DEACTIVATED 1/31/2026 — incorrect. Individual PTAN CB496694. 5-year re-validation cycle. Verify in PECOS portal if in doubt.'
);


-- =============================================================================
-- 12. Medi-Cal PAVE Provider ID 100517999
--     Annual re-enrollment required via DHCS provider portal.
--     EFT (Electronic Funds Transfer) already approved.
--     No fixed expiry date — annual re-enrollment is a calendar-year process.
-- =============================================================================
INSERT INTO credentials (
  compliance_item_id,
  credential_type,
  credential_name,
  issuing_body,
  credential_number,
  holder,
  status,
  expiry_date,
  renewal_cycle_days,
  renewal_cost_usd,
  renewal_portal_url,
  renewal_notes,
  alert_90, alert_60, alert_30, alert_7,
  vault_entry_ref,
  document_ref,
  notes
) VALUES (
  NULL,
  'payer_id',
  'Medi-Cal PAVE Provider ID 100517999',
  'DHCS (CA Department of Health Care Services)',
  '100517999',
  'valentina',
  'ACTIVE',
  NULL,
  365,
  NULL,
  'https://www.dhcs.ca.gov/',
  'Medi-Cal PAVE annual re-enrollment via DHCS provider portal. EFT approved. Individual NPI 1023579513 on file. Annual re-enrollment required to maintain active enrollment.',
  true, true, true, true,
  'Medi-Cal PAVE / DHCS Provider Portal',
  'Phase 1 document audit — Medi-Cal PAVE verified ACTIVE, EFT approved',
  'PAVE ID 100517999. ACTIVE. Annual re-enrollment. EFT approved. Individual NPI: 1023579513.'
);
