# Roadmap: Brighter Days

## Overview

Brighter Days launches through five phases that move from legal verification to operational readiness to system design. Phases 1-3 are research and documentation work executed directly by GSD -- they produce the compliance audit, credential vault, and operational SOPs that Valentina needs before seeing her first patient. Phases 4-5 are specification work for the TouchDesigner command center and AI automation layer -- they produce detailed specs for handoff to software development, not working software. Every phase builds on the prior: compliance findings feed credential organization, both feed SOPs, and all three inform what the dashboard must display and automate.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Compliance Audit & Verification** - Verify every legal, regulatory, and insurance obligation for operating a CA telehealth psychiatry practice
- [ ] **Phase 2: Credential Vault & Monitoring** - Organize all practice credentials into a single system with expiry tracking and alerts
- [ ] **Phase 3: Clinical & Business Operations** - Document every SOP, workflow, and procedure needed to run the practice
- [ ] **Phase 4: Dashboard Command Center Specification** - Produce a complete spec for the TouchDesigner-based practice command center (spec for handoff, not built by GSD)
- [ ] **Phase 5: AI Automation Specification** - Produce a complete spec for AI-powered form filling and compliance monitoring (spec for handoff, not built by GSD)

## Phase Details

### Phase 1: Compliance Audit & Verification
**Goal**: Valentina has verified, documented proof that every legal and regulatory requirement for operating a CA telehealth psychiatry practice is met -- or has a clear action plan for anything that is not
**Depends on**: Nothing (first phase)
**Requirements**: COMP-01, COMP-02, COMP-03, COMP-04, COMP-05, COMP-06, COMP-07, COMP-08, COMP-09, COMP-10
**Success Criteria** (what must be TRUE):
  1. A completed HIPAA Security Risk Analysis document exists that Valentina can produce if audited by OCR
  2. A BAA tracker lists every vendor handling PHI with signed/unsigned status, and all critical BAAs (Tebra, email provider) are confirmed signed
  3. A CA-compliant telehealth informed consent form exists that meets B&P Code 2290.5 requirements, ready to load into Tebra
  4. A master compliance checklist covers every legal obligation (state licensing, DEA, CAQH, malpractice, corporate compliance, tax, OSHA, employment law) with verified status for each item
  5. DEA registration is confirmed active with correct address, schedule coverage, and Ryan Haight Act compliance documented
**Plans**: 3 plans

Plans:
- [x] 01-01-PLAN.md -- Compliance data foundation: Supabase schema, seed all compliance items from document audit, generate prioritized action items report
- [x] 01-02-PLAN.md -- HIPAA SRA formal document (HHS SRA Tool format) and BAA vendor audit with tracker
- [x] 01-03-PLAN.md -- Patient-facing documents: telehealth consent (B&P 2290.5), minor consent, GFE template, location protocol, forms audit

### Phase 2: Credential Vault & Monitoring
**Goal**: Every practice credential, login, license, and certificate is organized in one place with automated alerts before anything expires
**Depends on**: Phase 1 (compliance audit identifies what credentials exist and their status)
**Requirements**: CRED-01, CRED-02, CRED-03, CRED-04
**Success Criteria** (what must be TRUE):
  1. A 1Password vault contains every practice login (Tebra, CAQH, DEA, payer portals, state boards, email) organized by category
  2. A single credential inventory document lists every license, certification, NPI, DEA number, and payer ID with expiry dates
  3. CAQH 120-day re-attestation alerts are configured and will fire at 90/60/30/7 days before deadline
  4. A payer credentialing tracker for all 17 insurance panels shows contract dates, re-credentialing deadlines, and contact info
**Plans**: 2 plans

Plans:
- [x] 02-01-PLAN.md -- Credential data foundation: Supabase schema extension (credentials + payer_tracker tables), credential seed data, 1Password vault structure spec
- [ ] 02-02-PLAN.md -- Payer tracker dossiers (all 17 panels), printable credential inventory, alert architecture spec for Phase 4/5

### Phase 3: Clinical & Business Operations
**Goal**: Every operational workflow -- from patient intake to crisis response to biller oversight -- is documented in SOPs that Valentina and Maxi can follow on day one
**Depends on**: Phase 1 (compliance requirements inform SOP content), Phase 2 (credential references needed for workflow documentation)
**Requirements**: OPS-01, OPS-02, OPS-03, OPS-04, OPS-05
**Success Criteria** (what must be TRUE):
  1. A patient intake workflow document covers the full sequence from screening through first session, including eligibility check, consent, and intake forms
  2. A CURES database check SOP exists with step-by-step instructions for the mandatory CA PDMP check before every controlled substance prescription
  3. A crisis protocol document specifies exactly what happens during a telehealth session when a patient is in crisis, including emergency contacts, 988 referral, and documentation requirements
  4. A business structure document describes the current Valentina Park MD, PC S-Corp setup, roles (Valentina as owner, Maxi as CTO), and the deferred Brighter Days entity plan
  5. A third-party biller onboarding document specifies what data billers need, how they access Tebra, and what reporting Valentina expects from them
**Plans**: TBD

Plans:
- [ ] 03-01: TBD
- [ ] 03-02: TBD

### Phase 4: Dashboard Command Center Specification
**Goal**: A complete, implementable specification exists for the TouchDesigner-based practice command center that a developer can build from without further discovery
**Depends on**: Phase 1 (compliance items define what dashboard tracks), Phase 2 (credential data model informs dashboard data sources), Phase 3 (SOPs define what workflows dashboard supports)
**Requirements**: DASH-01, DASH-02, DASH-03, DASH-04, DASH-05, DASH-06, DASH-07, DASH-08
**Success Criteria** (what must be TRUE):
  1. The spec defines the TouchDesigner command center layout with ASCII art visual aesthetic — all panels, data sources, and interaction patterns documented with the retro terminal/text-based UI design language
  2. The spec includes a compliance status panel design showing green/yellow/red indicators for every tracked license, cert, BAA, and CAQH status
  3. The spec covers the obligations checklist, compliance calendar, and billing oversight views with data flow from Tebra API
  4. The spec documents Tebra API integration requirements (endpoints, polling frequency, data mapping) including research findings on API capabilities and costs
  5. The spec defines functional action buttons and automation tracking -- what each button does, what triggers automations, and how status is displayed

**NOTE**: This phase produces a specification document for handoff to software development. GSD agents do not build the TouchDesigner dashboard -- they research, design, and document it.

**Plans**: TBD

Plans:
- [ ] 04-01: TBD
- [ ] 04-02: TBD
- [ ] 04-03: TBD

### Phase 5: AI Automation Specification
**Goal**: A complete specification exists for AI-powered form filling and compliance monitoring that defines exactly what the AI does, what data it needs, and how humans stay in the loop
**Depends on**: Phase 2 (credential vault is the data source for form pre-fill), Phase 3 (SOPs define what compliance monitoring must track), Phase 4 (dashboard spec defines where AI features surface)
**Requirements**: AI-01, AI-02, AI-03, AI-04
**Success Criteria** (what must be TRUE):
  1. The spec defines the AI form pre-fill system including which forms it targets (insurance applications, compliance documents, credentialing forms), what credential vault data it uses, and the human review/approval flow
  2. The spec defines the automated regulatory monitoring system — what sources it watches (CA Medical Board, CURES, DEA, HIPAA/HHS), how it detects changes, and how it alerts Valentina and Maxi
  3. The spec defines the automated insurance monitoring system — tracking payer policy changes, credentialing requirement updates, and billing rule changes across all 17 panels
  4. The spec defines software/platform monitoring — Tebra updates, API changes, security patches, vendor compliance shifts

**NOTE**: This phase produces a specification document for handoff to software development. GSD agents do not build the AI systems -- they research, design, and document them.

**Plans**: TBD

Plans:
- [ ] 05-01: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 -> 2 -> 3 -> 4 -> 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Compliance Audit & Verification | 3/3 | Complete | 2026-02-27 |
| 2. Credential Vault & Monitoring | 1/2 | In progress | - |
| 3. Clinical & Business Operations | 0/2 | Not started | - |
| 4. Dashboard Command Center Specification | 0/3 | Not started | - |
| 5. AI Automation Specification | 0/1 | Not started | - |
