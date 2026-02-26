# Feature Research

**Domain:** Telehealth psychiatry practice operations system — solo physician, California
**Researched:** 2026-02-25
**Confidence:** MEDIUM-HIGH (regulatory requirements HIGH; AI automation features MEDIUM)

---

## Feature Landscape

### Table Stakes (Must Have — Practice Cannot Legally Operate or Get Paid Without These)

These are compliance and billing requirements. Missing any of these means the practice either violates law, can't bill, or will face claim denials.

#### Compliance / Legal Requirements

| Feature | Why Required | Complexity | CA-Specific Notes |
|---------|--------------|------------|-------------------|
| Telehealth informed consent capture | CA law requires written/verbal consent before initial telehealth delivery; must be documented in patient record | LOW | Must include: provider identity, telehealth limitations, risks, patient's right to withhold. Verbal OK but must be documented. |
| HIPAA-compliant platform enforcement | BAA required for all vendors handling PHI since May 2023 (no more enforcement discretion) | MEDIUM | All telehealth platforms must sign BAA. Document: Zoom for Healthcare, Doxy.me, etc. |
| CURES check workflow | Mandatory for every new controlled substance prescription; every 4 months or each refill thereafter | MEDIUM | CA-specific: Check CURES before first Rx, then every 4 months during treatment or each refill. Failure = license board referral. |
| DEA registration tracking | DEA registration required to prescribe Schedule II-V controlled substances (stimulants, benzodiazepines, opioids — all common in psychiatry) | LOW | Renews every 3 years. Requires 8-hour substance use disorder training at registration/renewal. DEA sends email reminders at 60/45/30/15/5 days. |
| CA medical license tracking | CA physician license expires biennial (birth month). 50 CME hours per 2-year cycle required | LOW | One-time 12-hr CME in pain management/end-of-life care required. BoardVitals CA psychiatry-specific CME tracker available. |
| California professional corporation annual filings | Statement of Information (SI-550) filed with CA Secretary of State annually during incorporation birth month; $25 fee | LOW | Solo physician must formally appoint herself as sole director and officers annually. "Action by Unanimous Written Consent" satisfies meeting requirement. |
| Franchise Tax Board compliance | CA minimum $800 franchise tax per year; 1120S federal return + 100S CA return for S-Corp | LOW | Due April 15 for calendar-year S-Corps. Non-negotiable — failure risks entity dissolution. |
| Malpractice insurance telehealth coverage verification | Not all malpractice carriers cover telehealth automatically; must verify coverage extends to telehealth | LOW | Confirm in writing annually. If practicing across state lines, verify multi-state coverage. |

#### Billing / Revenue Requirements

| Feature | Why Required | Complexity | Notes |
|---------|--------------|------------|-------|
| CPT code selection (psychiatry-specific) | Wrong codes = claim denial. Core psych codes: 90791/90792 (diagnostic eval), 90832/90834/90837 (psychotherapy), 99202-99215 (E/M) | MEDIUM | Psychiatry has distinct code sets from therapy/counseling. Medicare uses POS 10 (patient home) for telehealth. |
| Telehealth modifier application | Modifier 95 (synchronous audio-video) or 93 (audio-only patient-preference) required for telehealth claims | LOW | POS 02 (facility) vs POS 10 (patient home) is a common denial trigger. Audio-only: document that patient preferred or couldn't use video. |
| Insurance credentialing status tracking | 17 payers already credentialed, but credentialing must be re-verified periodically; payer contracts expire or require updates | MEDIUM | Each payer has different re-credentialing cycle (typically every 2-3 years). CAQH profile must stay current. |
| ERA/EOB reconciliation | Matching insurance payments to claims. Required for accurate books, catch underpayments, and identify denials | MEDIUM | Tebra handles this natively but must be actively monitored. |
| Denial management workflow | Behavioral health has highest denial rates in healthcare (2025 avg AR: 65-75 days). Need a process to catch, appeal, and resubmit | HIGH | Most common denial triggers for telehealth psych: wrong POS code, missing modifier 95, prior auth not obtained, ICD-10 not specific enough. |
| NPI linkage verification | Individual NPI (1023579513) must be correctly linked to group/entity NPI and each payer enrollment | LOW | Group NPI required for billing under the PC entity. Must verify each payer has both NPIs correctly on file. |
| PTAN verification | Provider Transaction Access Number required for Medicare billing | LOW | Medicare PTAN links NPI to Medicare enrollment. Must be current for Medicare billing. |
| Prior authorization tracking | Many payers require PA for initial psych evaluations and ongoing medication management. Missing PA = denial | HIGH | PA requirements differ per payer. Some payers (Magellan Behavioral Health, Cigna Behavioral) are especially PA-heavy. |

#### Patient Care Requirements

| Feature | Why Required | Complexity | Notes |
|---------|--------------|------------|-------|
| HIPAA Notice of Privacy Practices delivery | Must provide NPP at first service; patient must acknowledge receipt | LOW | Can be electronic. Must be updated when privacy practices change. |
| Patient rights documentation | Required under HIPAA and CA patient rights statutes | LOW | Include in intake packet. |
| Good faith prior examination documentation | CA law requires "good faith prior examination" before prescribing dangerous drugs via telehealth | MEDIUM | Telehealth exam qualifies. Must document adequately in EHR (Tebra). |
| Audio-video capability requirement | CA telehealth standard requires synchronous audio-video for psychiatric eval. Audio-only only when patient preference or inability documented | MEDIUM | Document patient's statement if audio-only used. |

---

### Differentiators (AI Automation + Efficiency Gains)

These are not legally required but create real operational leverage for a solo physician. This is where the AI-powered command center vision lives.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Compliance expiry dashboard | Visual countdown of every license, certification, DEA registration, malpractice renewal, corporate filing deadline — all in one place | LOW | Training data: this doesn't exist as a product for solo physicians. Very buildable. Pulls from structured data store, not APIs. |
| AI-assisted CPT code suggestion | After session note is drafted, AI suggests appropriate CPT code + modifier combination based on documented time, session type, and insurance | HIGH | Verify with Tebra's existing coding support first. If Tebra already does this, skip. Only add if gap exists. |
| Denial pattern analysis | Track denial reasons by payer over time, surface "you always get denied by Magellan for X" insights | MEDIUM | Tebra has basic reporting. This would augment with pattern recognition across denial codes. |
| Insurance billing cheat sheet generator | Per-payer quick reference cards (Modifier rules, PA requirements, filing deadlines) for each of the 17 payers | LOW | Static data, manually curated. Huge time saver. Could be AI-generated from payer contracts. |
| Automated appointment reminders + intake form dispatch | Send intake forms, consent documents, and telehealth link automatically when new appointment is booked | MEDIUM | Tebra has patient portal. Question is whether Tebra's automation is sufficient or needs augmentation. |
| AI-assisted intake screening | Pre-session PHQ-9, GAD-7, Columbia Suicide Severity Rating Scale auto-scored and surfaced to provider before session | HIGH | Requires patient-facing form + scoring logic + integration with Tebra notes. Significant clinical value. |
| Credential/password vault | Organized, HIPAA-compliant single location for all logins, certificates, licenses, payer contracts, and important docs | LOW | Use Bitwarden (self-hostable, BAA-optional) or 1Password Teams with medical vault structure. NOT a custom build — use existing tool. |
| CAQH profile freshness monitor | Alert when CAQH profile data will expire (typically requires attestation every 120 days) | LOW | CAQH sends email but a dashboard alert ensures nothing lapses, which triggers re-credentialing gaps. |
| Payer credentialing timeline tracker | Track re-credentialing due dates for all 17 payers | MEDIUM | Most practices lose track of these. A spreadsheet works; the dashboard makes it visual. |
| AI form-fill assistant | For insurance applications, prior auth forms, appeals — AI pre-fills from known practice data (NPI, DEA, CAQH ID, etc.) | HIGH | High value for PA-heavy payers like Magellan and Cigna Behavioral. Reduces admin time significantly. |
| Session documentation AI scribe | Real-time or post-session note drafting from audio/transcript. Reduces documentation burden. | HIGH | Strong market: Nuance DAX, Nabla, AWS HealthScribe. Evaluate against Tebra's native capabilities first. |
| Denial appeal letter generator | AI drafts appeal letters based on denial reason code + clinical context | MEDIUM | Template-based first, AI-enhanced later. High ROI: behavioral health denials are often won on appeal with proper documentation. |
| Revenue cycle visual dashboard | Week-over-week: claims submitted, paid, denied, AR aging by payer. One-screen view of financial health | MEDIUM | Tebra has basic analytics. The value here is in the command center integration, not the data itself. |
| CA regulatory change monitor | Watch Medical Board of California, CA DOJ (CURES), DEA, and CMS feeds for rule changes affecting the practice | MEDIUM | RSS/webhook monitoring + digest email. Prevents compliance surprises. |
| Corporate filing calendar | Automated reminders for CA SI-550, franchise tax, S-Corp elections, and annual officer resolutions | LOW | Easy to build as a recurring event system. Prevents entity compliance lapses. |

---

### Anti-Features (Explicitly Do Not Build)

| Anti-Feature | Why Requested | Why Problematic | What to Do Instead |
|--------------|---------------|-----------------|-------------------|
| Custom EHR | Frustration with Tebra limitations | HIPAA compliance, data migration, payer integrations, e-prescribing for controlled substances — all require years of engineering. Tebra already handles this. | Extend Tebra via API. Accept its limitations in exchange for being feature-complete on day one. |
| Custom billing engine | Desire for more control over claims | EDI 837/835 claim formats, clearinghouse relationships, and payer-specific rules are extremely complex. Tebra + clearinghouse already handles this. | Use Tebra billing natively. Build dashboards ON TOP of Tebra data, not around it. |
| Custom patient portal | Want branded experience | Doubles PHI exposure surface; requires HIPAA security assessment; violates "don't duplicate Tebra" principle | Use Tebra's patient portal. Brand it within Tebra's customization options. |
| Video conferencing platform | Want integrated telehealth | Tebra has HIPAA-certified integrated telehealth. Building or deeply integrating a third platform adds BAA complexity and duplicate functionality. | Use Tebra's built-in telehealth or Doxy.me (with BAA) as fallback. |
| Scheduling system | Dissatisfaction with Tebra scheduler | Scheduling is deeply linked to billing workflow. A separate system creates double-entry risk. | Use Tebra scheduling. Automate around it (reminders, intake dispatch) via API or Zapier. |
| CURES direct integration | Want automated CURES checks | CURES does not offer a public API for prescriber lookups. Any "integration" requires screen scraping, which violates ToS and is unreliable. | Build a CURES check reminder workflow (prompt at prescribing time) rather than automated lookup. |
| Multi-state credentialing | Ambition to expand | Out of scope. CA telehealth with CA-licensed patients is the starting point. IMLC expansion is a later milestone. | Document as future milestone. Do not architect for it now. |

---

## Feature Dependencies

```
[Credential/Password Vault]
    └──enables──> [Compliance Dashboard] (needs authoritative data source)
    └──enables──> [AI Form-Fill Assistant] (needs practice data in structured form)

[CAQH Profile Freshness Monitor]
    └──blocks-if-missing──> [Insurance Credentialing Status Tracking] (stale CAQH = credentialing gaps)

[Tebra API Integration]
    └──enables──> [Revenue Cycle Dashboard]
    └──enables──> [Denial Pattern Analysis]
    └──enables──> [Automated Intake Dispatch]

[CPT Code Selection Workflow]
    └──requires──> [Telehealth Modifier Application] (modifier is part of same claim)
    └──requires──> [Prior Authorization Tracking] (some codes require PA)

[Telehealth Informed Consent Capture]
    └──must precede──> [First Patient Visit] (CA law: consent before initial service)

[CURES Check Workflow]
    └──must precede──> [Any Controlled Substance Prescribing]

[DEA Registration Active]
    └──required by──> [CURES Check Workflow] (DEA number needed for CURES access)

[AI Intake Screening]
    └──enhances──> [Session Documentation AI Scribe] (pre-session data informs note structure)

[Denial Management Workflow]
    └──feeds──> [Denial Pattern Analysis] (need denial data before patterns emerge)
    └──feeds──> [Denial Appeal Letter Generator]
```

### Dependency Notes

- **Credential vault must be built first**: It is the authoritative data store for all subsequent automation. NPI, DEA number, CAQH ID, payer contract IDs, license numbers — all flow from this.
- **Compliance dashboard before AI automation**: You need a complete view of current state before automating. Skipping this creates automation on faulty assumptions.
- **Tebra API integration is the unlock**: Most differentiator features (revenue dashboard, denial analysis, intake dispatch) require reading from Tebra. Validate API capabilities early — Tebra has SOAP and FHIR APIs but access and capabilities vary by plan.
- **Table stakes before differentiators**: The practice cannot see patients until compliance requirements are verified and documented. AI features add no value if a CURES violation or bad claim modifier is happening on every prescription or submission.

---

## MVP Definition

### Launch With (v1) — Before First Patient

These must be complete before Valentina sees her first patient.

- [ ] **Compliance audit checklist** — Verified status of: DEA registration, CA license, CAQH currency, malpractice telehealth coverage, corporate filings current, NPI/PTAN linked correctly to all 17 payers
- [ ] **Credential vault** — All logins, certificates, and license numbers organized in HIPAA-compliant vault (Bitwarden or 1Password Teams)
- [ ] **Telehealth informed consent form** — CA-compliant, documented in Tebra patient record before first session
- [ ] **HIPAA Notice of Privacy Practices** — Current version ready for patient delivery
- [ ] **CURES check workflow SOP** — Written procedure: when to check CURES, how to document, what to do if access fails
- [ ] **CPT code + modifier reference sheet** — Per the 17 payers: which CPT codes, which modifiers (95 vs 93), which POS codes (02 vs 10)
- [ ] **Compliance expiry dashboard** — Visual tracker of all license/cert/filing expiry dates with alert thresholds
- [ ] **Prior authorization tracking** — Per-payer PA requirements documented; process in place to check before scheduling

### Add After Validation (v1.x) — First Month of Operations

Once billing is running and first claims are submitted:

- [ ] **Revenue cycle dashboard** — Claims submitted/paid/denied by payer, AR aging, weekly view
- [ ] **Denial pattern analysis** — After first 30-60 days of claims data, identify recurring denial patterns
- [ ] **Payer credentialing re-verification calendar** — Track re-credentialing deadlines for all 17 payers
- [ ] **Automated appointment reminders + intake dispatch** — Trigger intake forms and telehealth link on booking
- [ ] **CA regulatory change monitor** — RSS/webhook on Medical Board, CURES, DEA, CMS for rule changes

### Future Consideration (v2+) — After 90 Days Operating

Defer until billing is stable and operational patterns are established:

- [ ] **AI-assisted CPT code suggestion** — Valuable, but validate Tebra's native capabilities first. Only build if gap confirmed.
- [ ] **AI intake screening (PHQ-9, GAD-7, Columbia)** — High clinical value; requires patient-facing form + scoring + EHR integration. Not a launch blocker.
- [ ] **AI session documentation scribe** — Market is mature (Nuance DAX, Nabla). Evaluate off-shelf first.
- [ ] **AI form-fill assistant for prior auths** — High ROI but complex. Defer to post-launch when PA volume is known.
- [ ] **Denial appeal letter generator** — Build after denial patterns are established (v1.x data needed).

---

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Compliance audit checklist | HIGH | LOW | P1 |
| Credential/password vault | HIGH | LOW | P1 |
| Telehealth informed consent form | HIGH | LOW | P1 |
| CURES check workflow SOP | HIGH | LOW | P1 |
| CPT code + modifier reference sheet | HIGH | LOW | P1 |
| Compliance expiry dashboard | HIGH | LOW | P1 |
| Prior authorization tracking | HIGH | MEDIUM | P1 |
| Revenue cycle dashboard | HIGH | MEDIUM | P2 |
| Denial management workflow | HIGH | MEDIUM | P2 |
| Automated intake dispatch | MEDIUM | MEDIUM | P2 |
| CA regulatory change monitor | MEDIUM | LOW | P2 |
| Payer credentialing calendar | MEDIUM | LOW | P2 |
| Denial pattern analysis | MEDIUM | MEDIUM | P2 |
| AI CPT code suggestion | MEDIUM | HIGH | P3 |
| AI intake screening | HIGH | HIGH | P3 |
| AI documentation scribe | HIGH | HIGH | P3 |
| AI form-fill for prior auth | HIGH | HIGH | P3 |
| Denial appeal letter generator | MEDIUM | MEDIUM | P3 |

**Priority key:**
- P1: Must have before first patient
- P2: Should have in first 30-60 days of operation
- P3: Future (post-launch validation)

---

## Competitor Feature Analysis

Note: No direct competitor exists for a solo physician AI command center at this scope. Reference points are practice management platforms and compliance tools.

| Feature | Tebra (existing EHR) | SimplePractice | Valant | Our Approach |
|---------|---------------------|----------------|--------|--------------|
| Telehealth | Built-in, HIPAA-certified | Built-in | Built-in | Use Tebra native |
| Billing / claims | Full revenue cycle | Superbills + insurance | Full | Use Tebra native |
| Patient portal | Yes | Yes | Yes | Use Tebra native |
| Compliance tracking | None | None | None | Build this |
| License expiry alerts | None | None | None | Build this |
| CURES reminders | None | None | None | Build this |
| Payer credentialing tracking | None | None | None | Build this |
| AI coding assist | Limited (Tebra) | No | No | Augment if Tebra insufficient |
| Command center view | No | No | No | Build this |
| Corporate filing calendar | No | No | No | Build this |

The gap is consistent: EHRs handle clinical and billing workflows but nothing handles compliance lifecycle, credential management, or the admin-operational layer for a solo physician. This is the unique value of the Brighter Days command center.

---

## CA-Specific Regulatory Requirements Summary

HIGH confidence (verified via official sources):

1. **CURES mandatory check**: Before every new controlled substance prescription; every 4 months or each refill during treatment. Failure = Medical Board referral. (Source: CA Medical Board, CA DOJ)
2. **Telehealth informed consent**: Written or verbal, documented in patient record, before initial telehealth service delivery. (Source: CA Health & Safety Code, CCHP)
3. **Payment parity (AB 744)**: Commercial insurers must reimburse telehealth on same basis as in-person. Medi-Cal managed care is excluded from parity requirement.
4. **DEA telehealth flexibility (2026)**: Controlled substances (Schedule II-V) can be prescribed via telehealth without in-person visit through end of 2026. Permanent rules expected before 2026 year-end.
5. **Good faith prior examination**: Required before prescribing dangerous drugs. Telehealth exam qualifies. Must be documented.
6. **CME requirements**: 50 hours per biennial cycle, ending on birth month. One-time 12-hr pain/end-of-life CME.
7. **Corporate annual filing**: SI-550 annually to CA Secretary of State, $25 fee, during incorporation month.
8. **HIPAA BAA**: Full enforcement since August 2023. All vendors handling PHI must have signed BAA.
9. **Audio-video standard**: Synchronous audio-video is the standard for psychiatric evaluation. Audio-only only when patient preference or inability is documented (modifier 93).

MEDIUM confidence (WebSearch, multiple sources):

10. **CAQH attestation**: Profile requires re-attestation approximately every 120 days or credentialing gaps emerge. (Widely reported but CAQH policies vary)
11. **Payer re-credentialing cycles**: Typically 2-3 years per payer. Exact timing varies by payer contract. (Medwave, APA credentialing guidance)

---

## Sources

- [CA Medical Board — CURES Mandatory Use](https://www.mbc.ca.gov/Resources/Medical-Resources/CURES/Mandatory-Use.aspx) — HIGH confidence
- [CA Medical Board — CURES 101](https://www.mbc.ca.gov/Resources/Medical-Resources/CURES/CURES-101.aspx) — HIGH confidence
- [CCHP — CA State Telehealth Laws](https://www.cchpca.org/california/) — HIGH confidence
- [CCHP — Consent Requirements](https://www.cchpca.org/?policy=consent-requirements-24) — HIGH confidence
- [CA Medical Board — Telehealth](https://www.mbc.ca.gov/Resources/Medical-Resources/telehealth.aspx) — HIGH confidence
- [APA — Medicare Telehealth Updates for Psychiatrists 2026](https://www.psychiatry.org/Psychiatrists/Practice/Telepsychiatry/Blog/Medicare-Telehealth-Updates-What-Psychiatrists-Nee) — MEDIUM confidence (403 returned, APA as source is HIGH authority)
- [CA Telehealth Resource Center — DEA 2026 Extension](https://caltrc.org/blog/dea-telehealth-rule-extension-understanding-the-2026-landscape/) — MEDIUM confidence
- [Wheel — California Telehealth Regulations](https://www.wheel.com/state-telehealth-regulations/california) — MEDIUM confidence
- [HHS Telehealth — Billing for Telebehavioral Health](https://telehealth.hhs.gov/providers/best-practice-guides/telehealth-for-behavioral-health/billing-for-telebehavioral-health) — HIGH confidence
- [CMS — Telehealth FAQ 2026](https://www.cms.gov/files/document/telehealth-faq-updated-02-04-2026.pdf) — HIGH confidence
- [Tebra — EHR APIs for Practices](https://www.tebra.com/theintake/ehr-emr/ehr-apis-and-why-they-matter-for-practices) — MEDIUM confidence
- [Tebra — Behavioral Health EHR Features 2026](https://www.tebra.com/theintake/ehr-emr/mental-health-practices/ehr-features-for-behavioral-health-practices) — MEDIUM confidence
- [HIPAA Journal — Password Requirements 2026](https://www.hipaajournal.com/hipaa-password-requirements/) — MEDIUM confidence
- [AMA BoardVitals — CA CME Requirements](https://www.boardvitals.com/cme-coach/california) — MEDIUM confidence
- [CA Professional Corporation Compliance Guide](https://djholtlaw.com/navigating-governance-and-compliance-in-california-healthcare-corporations/) — MEDIUM confidence
- [Blueprint.ai — Telehealth CPT Codes 2025](https://www.blueprint.ai/blog/telehealth-cpt-codes-2025-understanding-for-2025-and-beyond) — MEDIUM confidence
- [MedisysData — Telehealth Mental Health Billing 2025](https://www.medisysdata.com/blog/telehealth-mental-health-billing-2025-key-updates-and-insights/) — MEDIUM confidence

---
*Feature research for: Telehealth psychiatry practice operations system (Brighter Days)*
*Researched: 2026-02-25*
