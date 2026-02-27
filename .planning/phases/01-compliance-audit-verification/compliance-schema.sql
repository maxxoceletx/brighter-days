-- =============================================================================
-- Brighter Days Compliance System — Supabase Schema
-- Practice: Valentina Park MD, Professional Corporation
-- Project: Dedicated Brighter Days Supabase project (NOT shared with FindItNOW/Momo)
-- Created: 2026-02-27
-- Purpose: Data backbone for TouchDesigner compliance command center
-- =============================================================================

-- Enable UUID extension (available by default in Supabase)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";


-- =============================================================================
-- TABLE: compliance_items
-- Master registry of all compliance obligations
-- One row per regulatory/legal requirement
-- =============================================================================

CREATE TABLE compliance_items (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  req_id          TEXT NOT NULL UNIQUE,     -- 'COMP-01', 'COMP-02', etc.
  category        TEXT NOT NULL,            -- 'hipaa', 'licensing', 'credentialing', 'corporate', 'prescribing', 'forms', 'insurance', 'employment'
  title           TEXT NOT NULL,            -- human-readable name for TD display
  severity        TEXT NOT NULL,            -- 'CRITICAL', 'WARNING', 'INFO'
  status          TEXT NOT NULL,            -- 'VERIFIED', 'GAP', 'PENDING', 'NOT_APPLICABLE'
  description     TEXT,
  legal_citation  TEXT,                     -- e.g. 'CA B&P Code 2290.5', 'HHS 45 CFR 164.308(a)(1)'
  verified_date   DATE,                     -- date this item was last verified
  expiry_date     DATE,                     -- for items that expire (license, DEA, CAQH, insurance)
  document_ref    TEXT,                     -- path or name of the actual source document
  notes           TEXT,                     -- additional context, gaps, caveats
  updated_at      TIMESTAMPTZ DEFAULT now()
);

-- Indexes for TouchDesigner query performance
CREATE INDEX idx_compliance_items_severity ON compliance_items(severity);
CREATE INDEX idx_compliance_items_status ON compliance_items(status);
CREATE INDEX idx_compliance_items_expiry_date ON compliance_items(expiry_date);
CREATE INDEX idx_compliance_items_category ON compliance_items(category);


-- =============================================================================
-- TABLE: action_items
-- Human-required tasks surfaced in TD action queue
-- Every GAP compliance item generates at least one action_item
-- =============================================================================

CREATE TABLE action_items (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  compliance_item_id  UUID REFERENCES compliance_items(id) ON DELETE CASCADE,
  title               TEXT NOT NULL,
  description         TEXT,
  priority            TEXT NOT NULL,                   -- 'URGENT', 'SOON', 'WHENEVER'
  status              TEXT NOT NULL DEFAULT 'OPEN',    -- 'OPEN', 'IN_PROGRESS', 'DONE'
  assigned_to         TEXT,                            -- 'valentina', 'maxi'
  due_date            DATE,
  completed_date      DATE,
  draft_content       TEXT,                            -- pre-drafted email/letter/script, ready to send
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);

-- Indexes for TD action queue queries
CREATE INDEX idx_action_items_priority ON action_items(priority);
CREATE INDEX idx_action_items_status ON action_items(status);
CREATE INDEX idx_action_items_assigned_to ON action_items(assigned_to);
CREATE INDEX idx_action_items_compliance_item_id ON action_items(compliance_item_id);


-- =============================================================================
-- TABLE: documents
-- Compliance documents produced during audit
-- Stores full document text for TD document viewer
-- =============================================================================

CREATE TABLE documents (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  compliance_item_id  UUID REFERENCES compliance_items(id) ON DELETE CASCADE,
  document_type       TEXT NOT NULL,    -- 'hipaa_sra', 'baa', 'consent_form', 'gfe_template', 'policy', 'checklist'
  title               TEXT NOT NULL,
  content             TEXT,             -- full document text for Claude-drafted documents
  status              TEXT NOT NULL,    -- 'DRAFT', 'READY', 'ACTIVE', 'SUPERSEDED'
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_documents_compliance_item_id ON documents(compliance_item_id);
CREATE INDEX idx_documents_document_type ON documents(document_type);
CREATE INDEX idx_documents_status ON documents(status);


-- =============================================================================
-- TABLE: baa_tracker
-- Business Associate Agreement status per vendor
-- Dedicated table because BAAs are a HIPAA Category 1 enforcement target
-- =============================================================================

CREATE TABLE baa_tracker (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vendor_name   TEXT NOT NULL,
  vendor_type   TEXT,              -- 'ehr', 'database', 'email', 'video', 'billing', 'ai', 'storage'
  handles_phi   BOOLEAN DEFAULT true,
  baa_status    TEXT NOT NULL,     -- 'SIGNED', 'INCORPORATED_IN_TOS', 'NOT_SIGNED', 'NOT_REQUIRED', 'PENDING'
  baa_date      DATE,              -- effective date of the BAA
  baa_location  TEXT,              -- where to find the actual agreement (file path, URL, or description)
  notes         TEXT,
  updated_at    TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_baa_tracker_baa_status ON baa_tracker(baa_status);
CREATE INDEX idx_baa_tracker_vendor_type ON baa_tracker(vendor_type);


-- =============================================================================
-- VIEW: compliance_dashboard
-- TD-optimized view that adds display_color for the compliance panel
-- Color coding: VERIFIED=GREEN, CRITICAL GAP=RED, WARNING GAP=AMBER, PENDING=YELLOW, INFO=CYAN
-- =============================================================================

CREATE VIEW compliance_dashboard AS
SELECT
  ci.id,
  ci.req_id,
  ci.category,
  ci.title,
  ci.severity,
  ci.status,
  ci.description,
  ci.legal_citation,
  ci.verified_date,
  ci.expiry_date,
  ci.document_ref,
  ci.notes,
  ci.updated_at,
  CASE
    WHEN ci.status = 'VERIFIED'                                 THEN 'GREEN'
    WHEN ci.status = 'GAP'    AND ci.severity = 'CRITICAL'     THEN 'RED'
    WHEN ci.status = 'GAP'    AND ci.severity = 'WARNING'      THEN 'AMBER'
    WHEN ci.status = 'GAP'    AND ci.severity = 'INFO'         THEN 'CYAN'
    WHEN ci.status = 'PENDING'                                  THEN 'YELLOW'
    ELSE 'CYAN'
  END AS display_color,
  -- Days until expiry (NULL if no expiry)
  CASE
    WHEN ci.expiry_date IS NOT NULL
    THEN (ci.expiry_date - CURRENT_DATE)
    ELSE NULL
  END AS days_until_expiry,
  -- Expiry urgency flag for TD alerts
  CASE
    WHEN ci.expiry_date IS NULL                                THEN 'NONE'
    WHEN ci.expiry_date < CURRENT_DATE                         THEN 'EXPIRED'
    WHEN ci.expiry_date < CURRENT_DATE + INTERVAL '30 days'   THEN 'EXPIRING_SOON'
    WHEN ci.expiry_date < CURRENT_DATE + INTERVAL '90 days'   THEN 'EXPIRING_QUARTER'
    ELSE 'CURRENT'
  END AS expiry_urgency,
  -- Count of open action items for this compliance item
  (
    SELECT COUNT(*)
    FROM action_items ai
    WHERE ai.compliance_item_id = ci.id
      AND ai.status != 'DONE'
  ) AS open_action_count
FROM compliance_items ci
ORDER BY
  CASE ci.severity
    WHEN 'CRITICAL' THEN 1
    WHEN 'WARNING'  THEN 2
    WHEN 'INFO'     THEN 3
  END,
  CASE ci.status
    WHEN 'GAP'     THEN 1
    WHEN 'PENDING' THEN 2
    WHEN 'VERIFIED' THEN 3
    ELSE 4
  END,
  ci.expiry_date NULLS LAST;


-- =============================================================================
-- VIEW: action_queue
-- TD-optimized view for the action queue panel
-- =============================================================================

CREATE VIEW action_queue AS
SELECT
  ai.id,
  ai.compliance_item_id,
  ci.req_id,
  ci.severity AS compliance_severity,
  ai.title,
  ai.description,
  ai.priority,
  ai.status,
  ai.assigned_to,
  ai.due_date,
  ai.draft_content,
  ai.created_at,
  ai.updated_at,
  CASE ai.priority
    WHEN 'URGENT'   THEN 'RED'
    WHEN 'SOON'     THEN 'AMBER'
    WHEN 'WHENEVER' THEN 'CYAN'
    ELSE 'CYAN'
  END AS priority_color
FROM action_items ai
JOIN compliance_items ci ON ci.id = ai.compliance_item_id
WHERE ai.status != 'DONE'
ORDER BY
  CASE ai.priority
    WHEN 'URGENT'   THEN 1
    WHEN 'SOON'     THEN 2
    WHEN 'WHENEVER' THEN 3
  END,
  ai.due_date NULLS LAST;


-- =============================================================================
-- VIEW: baa_dashboard
-- TD-optimized view for BAA status panel
-- =============================================================================

CREATE VIEW baa_dashboard AS
SELECT
  id,
  vendor_name,
  vendor_type,
  handles_phi,
  baa_status,
  baa_date,
  baa_location,
  notes,
  updated_at,
  CASE baa_status
    WHEN 'SIGNED'              THEN 'GREEN'
    WHEN 'INCORPORATED_IN_TOS' THEN 'GREEN'
    WHEN 'NOT_REQUIRED'        THEN 'CYAN'
    WHEN 'PENDING'             THEN 'YELLOW'
    WHEN 'NOT_SIGNED'          THEN 'RED'
    ELSE 'AMBER'
  END AS display_color
FROM baa_tracker
WHERE handles_phi = true
ORDER BY
  CASE baa_status
    WHEN 'NOT_SIGNED' THEN 1
    WHEN 'PENDING'    THEN 2
    ELSE 3
  END,
  vendor_name;
