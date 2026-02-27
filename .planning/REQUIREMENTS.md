# Requirements: Brighter Days

**Defined:** 2026-02-25
**Core Value:** Valentina can confidently see her first telehealth patient knowing every compliance, billing, and operational requirement is met — and has a single system to manage it all going forward.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Compliance

- [x] **COMP-01**: HIPAA Security Risk Analysis formally documented (OCR's #1 enforcement target, $25K-$3M penalties)
- [x] **COMP-02**: BAAs signed and tracked with all vendors handling PHI (Tebra, Supabase, email provider, etc.)
- [x] **COMP-03**: CA telehealth informed consent form audited or created per B&P Code 2290.5 (required before first session)
- [x] **COMP-04**: License and certification expiry tracking with automated alerts (medical license, DEA, malpractice insurance, board certifications)
- [x] **COMP-05**: Good Faith Estimate template compliant with No Surprises Act (requires CPT codes, NPI, tax ID, projected sessions for self-pay patients)
- [x] **COMP-06**: Patient location verification protocol documented (patient physical location governs licensure — CA only, no interstate)
- [x] **COMP-07**: Audit all existing patient-facing forms (consent, intake, financial agreements) against current CA law and federal requirements for completeness and liability protection
- [x] **COMP-08**: Full CA telehealth psychiatry compliance checklist — verify every legal obligation for operating this type of practice (state licensing, board requirements, corporate compliance, tax obligations, insurance requirements, OSHA, employment law for CTO hire, etc.)
- [x] **COMP-09**: Malpractice insurance verification — confirm coverage includes telehealth psychiatry and controlled substance prescribing
- [x] **COMP-10**: DEA registration audit — verify registration is active, correct address, covers Schedule II-V, and compliant with Ryan Haight Act telehealth flexibilities

### Credentials

- [x] **CRED-01**: 1Password vault organized with all practice logins (Tebra, CAQH, DEA, payer portals, state boards, email, etc.)
- [x] **CRED-02**: Single credential inventory document listing every license, cert, NPI (1023579513), DEA#, payer IDs, and expiry dates
- [ ] **CRED-03**: CAQH 120-day re-attestation alert system (missing one cycle can suspend all 17 payer contracts simultaneously)
- [ ] **CRED-04**: Payer credentialing status tracker for all 17 insurance panels with contract dates and contact info

### Operations

- [ ] **OPS-01**: Patient intake workflow documented (screening → eligibility check → scheduling → consent → intake forms → first session)
- [ ] **OPS-02**: CURES database check SOP for controlled substance prescribing (required before every Rx in CA)
- [ ] **OPS-03**: Crisis protocol for telehealth sessions (what happens when patient is in crisis, emergency contacts, 988 referral, documentation)
- [ ] **OPS-04**: Business structure documentation (current Valentina Park MD, PC S-Corp structure, roles, Maxi as CTO, future Brighter Days entity plan)
- [ ] **OPS-05**: Third-party biller onboarding and oversight process (what data they need, how they access Tebra, reporting expectations)

### Dashboard (TouchDesigner Command Center)

- [ ] **DASH-01**: TouchDesigner-based practice command center — central node for all practice operations, real-time visual interface
- [ ] **DASH-02**: Compliance status panel with visual indicators (green/yellow/red) for all licenses, certs, BAAs, and CAQH status
- [ ] **DASH-03**: Running obligations checklist — interactive list of everything you need to do, with status and priority
- [ ] **DASH-04**: Compliance and operations calendar — deadlines, renewals, CAQH attestation windows, filing dates, all in one view
- [ ] **DASH-05**: Tebra API integration pulling appointment and billing data into dashboard (research cost, capabilities, and MCP availability)
- [ ] **DASH-06**: Billing oversight view showing claims submitted, denials, AR aging from Tebra data (for monitoring third-party billers)
- [ ] **DASH-07**: Functional action buttons — send emails, trigger automations, submit forms directly from dashboard (not just display)
- [ ] **DASH-08**: Automation process tracker — visual status of running/completed automations (CAQH checks, email sends, form submissions)

### AI Automation

- [ ] **AI-01**: AI form pre-fill from credential vault data (auto-populate insurance applications, compliance documents, credentialing forms)
- [ ] **AI-02**: Automated regulatory monitoring — continuously checks for changes in CA telehealth laws, Medical Board rules, HIPAA updates, and DEA prescribing regulations
- [ ] **AI-03**: Automated insurance monitoring — tracks payer policy changes, credentialing requirement updates, billing rule changes across all 17 panels
- [ ] **AI-04**: Automated software/platform monitoring — tracks Tebra updates, API changes, security patches, and vendor compliance status changes

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### AI Billing

- **AIBL-01**: AI coding suggestions for CPT code selection based on session notes
- **AIBL-02**: AI denial analysis and appeal draft generation
- **AIBL-03**: Prior authorization automation with AI form-fill

### Growth

- **GROW-01**: Multi-provider credentialing management (add new providers to panels)
- **GROW-02**: New Brighter Days S-Corp entity formation and transition plan
- **GROW-03**: Provider scheduling and panel load balancing
- **GROW-04**: Employee onboarding workflow

### Advanced Dashboard

- **ADVD-01**: Revenue analytics and forecasting
- **ADVD-02**: Patient demographics and panel mix visualization
- **ADVD-03**: Payer performance comparison (reimbursement rates, denial rates by payer)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Building own EHR | Tebra is the anchor platform — complement, don't replace |
| In-person practice setup | Telehealth only model |
| Claims submission / billing | Third-party billers handle this; dashboard provides oversight only |
| Mobile app | Web-first dashboard approach |
| Interstate licensing | CA only for now; no Interstate Medical Licensure Compact participation |
| Hiring providers | 6+ months out — separate milestone |
| New Brighter Days S-Corp | Deferred until hiring timeline clear; needs attorney/CPA |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| COMP-01 | Phase 1 | Complete (01-01) |
| COMP-02 | Phase 1 | Complete (01-02) |
| COMP-03 | Phase 1 | Complete (01-03) |
| COMP-04 | Phase 1 | Complete (01-01) |
| COMP-05 | Phase 1 | Complete (01-03) |
| COMP-06 | Phase 1 | Complete (01-03) |
| COMP-07 | Phase 1 | Complete (01-03) |
| COMP-08 | Phase 1 | Complete (01-01) |
| COMP-09 | Phase 1 | Complete (01-01) |
| COMP-10 | Phase 1 | Complete (01-01) |
| CRED-01 | Phase 2 | Complete (02-01) |
| CRED-02 | Phase 2 | Complete (02-01) |
| CRED-03 | Phase 2 | Pending |
| CRED-04 | Phase 2 | Pending |
| OPS-01 | Phase 3 | Pending |
| OPS-02 | Phase 3 | Pending |
| OPS-03 | Phase 3 | Pending |
| OPS-04 | Phase 3 | Pending |
| OPS-05 | Phase 3 | Pending |
| DASH-01 | Phase 4 | Pending |
| DASH-02 | Phase 4 | Pending |
| DASH-03 | Phase 4 | Pending |
| DASH-04 | Phase 4 | Pending |
| DASH-05 | Phase 4 | Pending |
| DASH-06 | Phase 4 | Pending |
| DASH-07 | Phase 4 | Pending |
| DASH-08 | Phase 4 | Pending |
| AI-01 | Phase 5 | Pending |
| AI-02 | Phase 5 | Pending |
| AI-03 | Phase 5 | Pending |
| AI-04 | Phase 5 | Pending |

**Coverage:**
- v1 requirements: 31 total
- Mapped to phases: 29
- Unmapped: 0

---
*Requirements defined: 2026-02-25*
*Last updated: 2026-02-27 after 02-01 plan completion (CRED-01, CRED-02 marked complete — 1Password vault spec + credential schema/seed delivered)*
