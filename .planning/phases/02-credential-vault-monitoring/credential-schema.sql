-- =============================================================================
-- Brighter Days Credential System — Supabase Schema Extension
-- Practice: Valentina Park MD, Professional Corporation
-- Project: Dedicated Brighter Days Supabase project (NOT shared with FindItNOW/Momo)
-- Created: 2026-02-27
-- Purpose: Phase 2 extension of Phase 1 compliance schema — adds credential
--          renewal tracking and payer credentialing dossiers for all 17 panels.
--          These tables extend compliance_items (Phase 1) via foreign key;
--          no Phase 1 tables are modified.
-- =============================================================================


-- =============================================================================
-- TABLE: credentials
-- Purpose-built credential inventory with renewal metadata and alert thresholds.
-- Extends Phase 1 compliance_items via compliance_item_id FK where a Phase 1 row
-- exists for the same item (CA license, DEA, malpractice). Credentials with no
-- Phase 1 counterpart (ABPN certs, Medicare PTANs) set compliance_item_id = NULL.
-- =============================================================================

CREATE TABLE credentials (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  compliance_item_id  UUID REFERENCES compliance_items(id),   -- links to Phase 1 record if exists; NULL if no Phase 1 row
  credential_type     TEXT NOT NULL,    -- 'license', 'dea', 'npi', 'caqh', 'certification', 'malpractice', 'payer_id', 'business_license', 'corporate_filing', 'insurance'
  credential_name     TEXT NOT NULL,    -- human-readable name for TD display
  issuing_body        TEXT,             -- 'CA Medical Board', 'DEA', 'NPPES', 'CAQH', 'ABPN', 'CAP/MPT', 'City of Torrance', 'CMS', 'DHCS', etc.
  credential_number   TEXT,             -- the actual number/ID value
  holder              TEXT NOT NULL,    -- 'valentina' for personal credentials; 'entity' for corporate credentials
  status              TEXT NOT NULL,    -- 'ACTIVE', 'EXPIRED', 'PENDING', 'SUSPENDED', 'ESTIMATED'
  issue_date          DATE,
  expiry_date         DATE,             -- NULL for credentials with no fixed expiry (NPIs, no-expiry certs)
  renewal_cycle_days  INT,             -- how often it renews: 730=2yr, 1095=3yr, 365=annual, 120=CAQH, 1825=5yr
  renewal_cost_usd    NUMERIC(10,2),   -- estimated renewal cost in USD (NULL if unknown or N/A)
  renewal_portal_url  TEXT,            -- direct URL for online renewal
  renewal_notes       TEXT,            -- caveats, multi-step processes, address requirements, etc.
  alert_90            BOOLEAN DEFAULT true,   -- fire alert at 90 days before expiry
  alert_60            BOOLEAN DEFAULT true,   -- fire alert at 60 days before expiry
  alert_30            BOOLEAN DEFAULT true,   -- fire alert at 30 days before expiry
  alert_7             BOOLEAN DEFAULT true,   -- fire alert at 7 days before expiry
  vault_entry_ref     TEXT,            -- 1Password item name in "Brighter Days Practice" shared vault
  document_ref        TEXT,            -- path or name of underlying cert/registration document
  notes               TEXT,
  updated_at          TIMESTAMPTZ DEFAULT now()
);

-- Indexes for TD query performance and alert polling
CREATE INDEX idx_credentials_expiry_date       ON credentials(expiry_date);
CREATE INDEX idx_credentials_credential_type   ON credentials(credential_type);
CREATE INDEX idx_credentials_status            ON credentials(status);
CREATE INDEX idx_credentials_holder            ON credentials(holder);


-- =============================================================================
-- TABLE: payer_tracker
-- Full dossier per payer for all 17 insurance panels.
-- Unknown fields populated with industry-norm estimates; flagged with
-- recred_is_estimated=true and timely_filing_is_estimated=true where applicable.
-- Source: Phase 1 document audit + CONTEXT.md decisions + industry norms.
-- =============================================================================

CREATE TABLE payer_tracker (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  payer_name                  TEXT NOT NULL,        -- full legal name
  payer_short                 TEXT,                 -- short display name: 'Aetna', 'BCCA', 'BSCA', etc.
  tebra_payer_id              TEXT,                 -- Tebra-assigned payer ID code (from CONTEXT.md specifics)
  network_type                TEXT,                 -- 'PPO', 'HMO', 'EPO', 'BOTH', 'UNKNOWN'
  contract_status             TEXT NOT NULL,        -- 'ACTIVE', 'PENDING', 'NOT_EXECUTED', 'SUSPENDED', 'UNKNOWN'
  credentialing_status        TEXT,                 -- 'CREDENTIALED', 'PENDING', 'APPLICATION_SUBMITTED', 'NOT_STARTED', 'UNKNOWN'
  credentialing_date          DATE,                 -- date credentialing was completed/became effective
  contract_effective_date     DATE,
  recred_due_date             DATE,                 -- next re-credentialing due date
  recred_cycle_years          INT,                  -- typically 3 (commercial industry norm); some payers use 2
  recred_is_estimated         BOOLEAN DEFAULT false, -- true = date is industry-norm estimate, not confirmed
  can_bill                    BOOLEAN,              -- can the practice currently submit claims to this payer?
  billing_notes               TEXT,
  claim_submission_method     TEXT,                 -- 'electronic_only', 'paper_available', 'clearinghouse'
  timely_filing_days          INT,                  -- days from date of service to submit claim
  timely_filing_is_estimated  BOOLEAN DEFAULT false, -- true = using industry-norm estimate (90 days conservative)
  denial_patterns             TEXT,                 -- known denial reason codes or patterns for this payer
  portal_url                  TEXT,                 -- provider portal URL for this payer
  portal_login_ref            TEXT,                 -- 1Password entry name for portal login credentials
  provider_relations_phone    TEXT,
  provider_relations_email    TEXT,
  credentialing_rep_name      TEXT,
  credentialing_rep_email     TEXT,
  fee_schedule_notes          TEXT,                 -- known rates, e.g. '99214: $94.50, 90833: $85.00'
  payer_id_for_claims         TEXT,                 -- EDI payer ID for electronic claim submission
  npi_on_file                 TEXT,                 -- individual NPI payer has on file (should match 1023579513)
  group_npi_on_file           TEXT,                 -- group NPI payer has on file (should match 1699504282)
  ein_on_file                 TEXT,                 -- EIN payer has on file (should match 99-1529764)
  key_issues                  TEXT,                 -- flagged issues from Phase 1 audit or Phase 2 review
  contact_notes               TEXT,                 -- general notes on the payer relationship
  updated_at                  TIMESTAMPTZ DEFAULT now()
);

-- Indexes for TD payer credentialing panel and alert queries
CREATE INDEX idx_payer_tracker_contract_status ON payer_tracker(contract_status);
CREATE INDEX idx_payer_tracker_recred_due_date ON payer_tracker(recred_due_date);
CREATE INDEX idx_payer_tracker_can_bill         ON payer_tracker(can_bill);


-- =============================================================================
-- VIEW: credential_alert_queue
-- TD-ready view for the credential alert/monitoring panel.
-- Returns all credentials with expiry dates, excluding already-EXPIRED items.
-- Computed fields: days_until_expiry, alert_level, display_color.
-- Consumed by n8n polling job (Phase 4/5) and TD dashboard (Phase 4/5).
--
-- Alert levels: EXPIRED, ALERT_7, ALERT_30, ALERT_60, ALERT_90, CURRENT
-- Display colors: RED (expired or ≤30 days), AMBER (≤60 days), YELLOW (≤90 days), GREEN (>90 days)
-- =============================================================================

CREATE VIEW credential_alert_queue AS
SELECT
  c.id,
  c.credential_name,
  c.credential_type,
  c.credential_number,
  c.expiry_date,
  c.status,
  c.renewal_portal_url,
  c.vault_entry_ref,
  (c.expiry_date - CURRENT_DATE) AS days_until_expiry,
  CASE
    WHEN c.expiry_date < CURRENT_DATE                              THEN 'EXPIRED'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '7 days'         THEN 'ALERT_7'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '30 days'        THEN 'ALERT_30'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '60 days'        THEN 'ALERT_60'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '90 days'        THEN 'ALERT_90'
    ELSE 'CURRENT'
  END AS alert_level,
  CASE
    WHEN c.expiry_date < CURRENT_DATE                              THEN 'RED'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '30 days'        THEN 'RED'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '60 days'        THEN 'AMBER'
    WHEN c.expiry_date < CURRENT_DATE + INTERVAL '90 days'        THEN 'YELLOW'
    ELSE 'GREEN'
  END AS display_color
FROM credentials c
WHERE c.expiry_date IS NOT NULL
  AND c.status != 'EXPIRED'
ORDER BY c.expiry_date ASC;


-- =============================================================================
-- VIEW: payer_credentialing_alerts
-- TD-ready view for payer re-credentialing deadline tracking.
-- Returns payers with known re-credentialing due dates, ordered by urgency.
-- Computed fields: days_until_recred, recred_urgency.
--
-- Urgency levels: OVERDUE, DUE_SOON (≤90 days), DUE_QUARTER (≤180 days), CURRENT
-- Phase 4/5 n8n trigger: WHERE recred_urgency IN ('DUE_SOON', 'OVERDUE')
-- =============================================================================

CREATE VIEW payer_credentialing_alerts AS
SELECT
  p.id,
  p.payer_name,
  p.payer_short,
  p.contract_status,
  p.recred_due_date,
  p.recred_is_estimated,
  p.can_bill,
  p.provider_relations_phone,
  p.credentialing_rep_name,
  p.credentialing_rep_email,
  (p.recred_due_date - CURRENT_DATE) AS days_until_recred,
  CASE
    WHEN p.recred_due_date < CURRENT_DATE                              THEN 'OVERDUE'
    WHEN p.recred_due_date < CURRENT_DATE + INTERVAL '90 days'        THEN 'DUE_SOON'
    WHEN p.recred_due_date < CURRENT_DATE + INTERVAL '180 days'       THEN 'DUE_QUARTER'
    ELSE 'CURRENT'
  END AS recred_urgency
FROM payer_tracker p
WHERE p.recred_due_date IS NOT NULL
ORDER BY p.recred_due_date ASC NULLS LAST;
