-- =============================================================================
-- Brighter Days Practice — Payer Tracker Seed Data
-- Phase 2 Plan 02 | 2026-02-27
-- =============================================================================
-- Populates all 17 insurance panel dossiers in payer_tracker table.
--
-- Data sources:
--   - Phase 1 01-DOCUMENT-AUDIT.md (credential numbers, dates, Tebra IDs)
--   - Phase 2 02-RESEARCH.md (fee schedules, contacts, contract statuses)
--   - 02-CONTEXT.md (locked decisions, Medicare ACTIVE correction)
--
-- NOTE: 9 of 17 payers have UNKNOWN contract status — California Health &
-- Wellness, Coastal Communities, Facey Medical, Health Net CA, Hoag, Magellan,
-- Providence Health Plan, Torrance Hospital IPA, and Torrance Memorial MC all
-- lack Phase 1 contract records. Their rows are populated with industry-norm
-- estimates (recred_cycle_years=3, timely_filing_days=90) and flagged with
-- recred_is_estimated=true / timely_filing_is_estimated=true. Valentina or
-- credentialing agent Mary must verify actual statuses.
--
-- Re-credentialing dates for PENDING/ACTIVE payers are estimated as
-- credentialing_date + 3 years (industry standard for commercial payers).
-- All estimates are flagged with recred_is_estimated=true.
--
-- Standard identifiers on all rows:
--   npi_on_file        = '1023579513'  (Individual NPI)
--   group_npi_on_file  = '1699504282'  (Group NPI)
--   ein_on_file        = '99-1529764'  (EIN)
-- =============================================================================

-- 1. Aetna
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status, credentialing_status, credentialing_date,
  recred_due_date, recred_cycle_years, recred_is_estimated,
  can_bill, claim_submission_method,
  timely_filing_days, timely_filing_is_estimated,
  fee_schedule_notes,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Aetna', 'Aetna', '60054', 'PPO',
  'ACTIVE', 'CREDENTIALED', '2024-08-13',
  '2027-08-13', 3, true,
  true, 'electronic_only',
  90, true,
  '99214: $94.50, 90833: $85.00, 90785: $16.55, combined E&M+add-on: $196.05',
  'https://www.aetna.com/health-care-professionals/resources-and-tools/provider-portal.html', 'Aetna Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '60054',
  'Individual credentialing only; group contract requires minimum 2 providers. Do not bill under group NPI until group contract executed.'
);

-- 2. Blue Cross of California (Anthem)
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status, credentialing_status, credentialing_date,
  recred_due_date, recred_cycle_years, recred_is_estimated,
  can_bill, claim_submission_method,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues, contact_notes
) VALUES (
  'Blue Cross of California (Anthem)', 'BCCA', '47198', 'PPO',
  'PENDING', 'CREDENTIALED', '2025-08-07',
  '2028-08-07', 3, true,
  false, 'electronic_only',
  90, true,
  'https://www.anthem.com/provider/', 'Anthem Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '47198',
  'Provider-signed contract 5/20/2025; awaiting Anthem countersignature — cannot bill until fully countersigned. Follow up with Andy Miller for countersignature status.',
  'Andy Miller (andy.miller@medheave.com) handling credentialing for this payer.'
);

-- 3. Blue Shield of California
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status, credentialing_status, credentialing_date,
  recred_due_date, recred_cycle_years, recred_is_estimated,
  can_bill, claim_submission_method,
  timely_filing_days, timely_filing_is_estimated,
  fee_schedule_notes,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Blue Shield of California', 'BSCA', '94036', 'PPO',
  'PENDING', 'CREDENTIALED', '2025-08-07',
  '2028-08-07', 3, true,
  false, 'electronic_only',
  90, true,
  '99214: $113.27, 90833: $84.00, 90785: $4.88, combined E&M+add-on: $202.15',
  'https://www.blueshieldca.com/bsca/bsc/wcm/connect/provider/provider_content_en/portal', 'Blue Shield CA Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '94036',
  'Contract effective date TBD — credentialing complete but contract not yet fully executed. Verify contract execution status before billing.'
);

-- 4. California Health & Wellness
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'California Health & Wellness', 'CAHW', '68069', 'HMO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.californiahealthwellness.com/provider', 'California Health & Wellness Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '68069',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. If credentialed, obtain copy of contract and update this record. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- 5. Cigna
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill, claim_submission_method,
  timely_filing_days, timely_filing_is_estimated,
  fee_schedule_notes,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Cigna', 'Cigna', '62308', 'PPO',
  'NOT_EXECUTED',
  false, 'electronic_only',
  90, true,
  '99214: $90.33, 90833: $40.00, 90785: $4.60, combined E&M+add-on: $134.93',
  'https://cignaforhcp.cigna.com/', 'Cigna Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '62308',
  'Documents requested 12/9/2024; contract not executed as of Phase 2 (2026-02-27). Do not bill. Contact Cigna provider relations to determine application status and next steps.'
);

-- 6. Cigna Behavioral Health
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Cigna Behavioral Health', 'CignaBH', 'MCCBV', 'PPO',
  'NOT_EXECUTED',
  false,
  90, true,
  'https://cignaforhcp.cigna.com/', 'Cigna Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  'MCCBV',
  'Linked to Cigna main contract — same NOT_EXECUTED status. Will activate when Cigna main contract executes. Do not bill separately. Verify whether Cigna Behavioral Health requires separate credentialing application.'
);

-- 7. Coastal Communities Physician Network
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Coastal Communities Physician Network', 'CCPN', 'CCPN1', 'HMO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.ccpn.net/', 'Coastal Communities Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  'CCPN1',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- 8. Facey Medical Foundation
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Facey Medical Foundation', 'Facey', '95432', 'HMO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.faceymedical.com/providers/', 'Facey Medical Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '95432',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- 9. Health Net of California
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Health Net of California', 'HealthNet', '95567', 'PPO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.healthnet.com/portal/provider/content/home.action', 'Health Net Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '95567',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- 10. Hoag
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Hoag', 'Hoag', 'HPPZZ', 'PPO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.hoag.org/providers/', 'Hoag Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  'HPPZZ',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- 11. Kaiser Foundation Health Plan of Southern California
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status, credentialing_status,
  recred_cycle_years, recred_is_estimated,
  can_bill, claim_submission_method,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  credentialing_rep_name, credentialing_rep_email,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Kaiser Foundation Health Plan of Southern California', 'Kaiser', '94134', 'HMO',
  'PENDING', 'PENDING',
  3, true,
  false, 'clearinghouse',
  90, true,
  'https://providers.kaiserpermanente.org/', 'Kaiser Southern CA Provider Portal',
  'Nanette Bordenave', 'Nanette.J.Bordenave@kp.org',
  '1023579513', '1699504282', '99-1529764',
  '94134',
  'Contract sent via DocuSign; execution unconfirmed as of Phase 2 (2026-02-27). Contact Nanette Bordenave to confirm countersignature status. Do not bill until contract is fully executed and credentialing confirmed.'
);

-- 12. Magellan Behavioral Health
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Magellan Behavioral Health', 'Magellan', '01260', 'PPO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.magellanprovider.com/', 'Magellan Behavioral Health Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '01260',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- 13. Medicaid of California (Medi-Cal)
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status, credentialing_status,
  can_bill, billing_notes,
  claim_submission_method,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Medicaid of California (Medi-Cal)', 'MediCal', '00148', 'BOTH',
  'ACTIVE', 'CREDENTIALED',
  true, 'PAVE ID 100517999; EFT approved and active. Medi-Cal provider ID confirmed.',
  'electronic_only',
  365, false,
  'https://www.dhcs.ca.gov/provgovpart/Pages/ProviderPortal.aspx', 'Medi-Cal PAVE Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '00148',
  'Active Medi-Cal enrollment via PAVE. Timely filing is 12 months from date of service (365 days) — not estimated, statutory. Annual re-enrollment required through PAVE portal.'
);

-- 14. Medicare of California Southern
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status, credentialing_status,
  can_bill, billing_notes,
  claim_submission_method,
  timely_filing_days, timely_filing_is_estimated,
  fee_schedule_notes,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Medicare of California Southern', 'Medicare', '01182', 'BOTH',
  'ACTIVE', 'CREDENTIALED',
  true, 'PTAN Group: CB496693, PTAN Individual: CB496694. Both PTANs confirmed ACTIVE.',
  'electronic_only',
  365, false,
  '99214: $137.58, 90833: $77.86, 90785: $15.21, combined E&M+add-on: $230.65 (highest reimbursement of all panels)',
  'https://pecos.cms.hhs.gov/', 'Medicare PECOS Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  '01182',
  'Status corrected per Phase 2 discussion — Valentina confirmed ACTIVE enrollment 2026-02-27. Phase 1 document audit incorrectly showed DEACTIVATED 1/31/2026. Medicare timely filing is 12 months from DOS (365 days) — statutory, not estimated. Re-enrollment every 5 years via PECOS.'
);

-- 15. Providence Health Plan
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Providence Health Plan', 'Providence', 'PHP01', 'PPO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.providence.org/providers/', 'Providence Health Plan Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  'PHP01',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- 16. Torrance Hospital IPA
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Torrance Hospital IPA', 'TorranceIPA', 'THIPA', 'HMO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.torrancememorial.org/providers/', 'Torrance Hospital IPA Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  'THIPA',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- 17. Torrance Memorial Medical Center
INSERT INTO payer_tracker (
  payer_name, payer_short, tebra_payer_id, network_type,
  contract_status,
  can_bill,
  recred_cycle_years, recred_is_estimated,
  timely_filing_days, timely_filing_is_estimated,
  portal_url, portal_login_ref,
  npi_on_file, group_npi_on_file, ein_on_file,
  payer_id_for_claims,
  key_issues
) VALUES (
  'Torrance Memorial Medical Center', 'TorranceMC', 'TMMC1', 'PPO',
  'UNKNOWN',
  NULL,
  3, true,
  90, true,
  'https://www.torrancememorial.org/providers/', 'Torrance Memorial MC Provider Portal',
  '1023579513', '1699504282', '99-1529764',
  'TMMC1',
  'No contract data found in Phase 1 document audit. Verify current status with credentialing agent Mary. Re-credentialing date estimated at 3 years from contract date once known.'
);

-- =============================================================================
-- Verification query — run after seeding to confirm all 17 rows:
--   SELECT payer_name, tebra_payer_id, contract_status, can_bill
--   FROM payer_tracker ORDER BY payer_name;
-- =============================================================================
