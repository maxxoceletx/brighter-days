# Pitfalls Research

**Domain:** Telehealth Psychiatry Practice Operations — Solo CA Practice
**Researched:** 2026-02-25
**Confidence:** MEDIUM-HIGH (regulatory sources verified; Tebra-specific issues LOW from user reviews only)

---

## Critical Pitfalls

### Pitfall 1: Practicing Without Valid CA License / Treating Out-of-State Patients Without Their State License

**What goes wrong:**
Telehealth services are considered to occur at the *patient's location*. If a patient moves to Nevada, travels to Texas, or is located outside California during an appointment, Valentina is practicing medicine in that state without a license — a felony-level violation in most jurisdictions.

**Why it happens:**
Psychiatrists assume their CA license covers telehealth anywhere because the *provider* is in California. This is wrong. The controlling jurisdiction is where the patient is physically located at the time of service.

**How to avoid:**
- Obtain patient's physical location at the start of every session (not home address — actual current location)
- Document location in the session note for every encounter
- Add a session-opening SOP step: "Confirm: where are you located right now?"
- Do not see patients who are out of state unless licensed in that state or state has a reciprocity compact
- California does NOT currently participate in the Interstate Medical Licensure Compact (IMLC) as of 2026 — verify before treating any cross-state patient

**Warning signs:**
- Patient mentions being "visiting family in Arizona" or "on a work trip"
- Intake forms list home address in another state
- Patient was previously a CA resident but has relocated

**Phase to address:** Phase 1 (Compliance Audit) — add to intake SOP and note template
**Severity: PRACTICE-ENDING** — Criminal licensure violation, immediate medical board complaint risk

---

### Pitfall 2: DEA Controlled Substance Prescribing Without Understanding the Ryan Haight Expiration Timeline

**What goes wrong:**
Prescribing Schedule II-V controlled substances (stimulants for ADHD, benzodiazepines, buprenorphine) via telehealth without an in-person examination has been legal under COVID-era flexibilities. Those flexibilities are temporary extensions, not permanent law. The DEA extended them through December 31, 2026 via a fourth temporary extension. When the extension ends, providers who have never seen patients in person will lose the ability to prescribe controlled substances via telehealth unless they obtain a DEA Special Registration (proposed rule published January 17, 2025 — not yet finalized as of Feb 2026).

**Why it happens:**
Providers have operated on extensions since 2020 and treat them as permanent. A new rule cycle that doesn't get extended or finalized leaves the practice unable to prescribe stimulants, benzodiazepines, or other scheduled drugs — potentially abandoning the majority of a psychiatry panel.

**How to avoid:**
- Track DEA extension deadlines on a compliance calendar (current: Dec 31, 2026)
- Monitor the proposed DEA Special Registration rule (Federal Register 2025-01099) for finalization status
- Plan to offer in-person evaluation capability for new controlled substance starts if the extension expires — even if via a partner clinic or urgent care arrangement
- Do NOT build the practice exclusively around telehealth-only controlled substance prescribing without a continuity plan
- For new patients: check California CURES within 24 hours before first controlled substance prescription, then every 6 months thereafter (mandatory under CA law)

**Warning signs:**
- DEA extension expiration date passes without a new rule finalized
- Multiple patients are on Schedule II medications with no documented in-person visit ever

**Phase to address:** Phase 1 (Compliance Audit), Phase 2 (Operational SOPs)
**Severity: PRACTICE-ENDING** — Loss of ability to prescribe controlled substances means losing most psychiatric patients

---

### Pitfall 3: HIPAA Violation via Non-Compliant Telehealth Platform or Missing BAAs

**What goes wrong:**
Using any video, messaging, or scheduling tool that doesn't have a signed Business Associate Agreement (BAA) is a HIPAA violation. Common offenders: standard Zoom (not Zoom for Healthcare), standard Google Meet, SMS texting for clinical communication, Google Workspace without a healthcare BAA, or AI tools processing PHI without a BAA.

**Why it happens:**
Convenience. Regular Zoom "works" and feels private. Providers don't realize the BAA must be signed before any PHI touches the platform — even if the tool promises encryption.

**How to avoid:**
- Audit every tool that touches PHI: video platform, scheduling software, patient portal, email, fax, storage, AI assistant
- Obtain signed BAAs from every vendor (Tebra, video platform, cloud storage, AI tools used for chart review)
- Do NOT use standard consumer tools for any patient communication
- California adds CMIA (Confidentiality of Medical Information Act) on top of HIPAA — stricter breach notification timelines
- Conduct a formal HIPAA Security Risk Analysis before seeing first patient (OCR's #1 enforcement target in 2025 was failure to perform risk analysis)
- Document the risk analysis — having it done is not enough without the paper trail

**Warning signs:**
- Any tool used for patient communication that doesn't have a healthcare-specific plan or BAA option
- Staff or admin using personal email for scheduling
- AI tools used to summarize notes without a BAA in place

**Phase to address:** Phase 1 (Compliance Audit)
**Severity: PRACTICE-ENDING** — OCR penalties range from $25K to $3M per violation; small practices are actively targeted

---

### Pitfall 4: Medicare Billing with Wrong Modifier or Place of Service Code

**What goes wrong:**
Medicare telehealth billing requires the correct combination of CPT code + modifier + Place of Service (POS) code. Common errors:

- Using POS 11 (Office) instead of POS 02 (Telehealth, not home) or POS 10 (Telehealth, patient home)
- Missing modifier 95 (video) or 93 (audio-only) on E/M codes
- Billing audio-only visits with modifier 95 instead of 93
- Billing new telehealth CPT codes 98000-98015 for Medicare (Medicare does NOT use these — use 99202-99215 with modifiers)
- Billing psychotherapy add-on codes (90833, 90836, 90838) without using E/M medical decision-making (not time) to determine E/M level

**Why it happens:**
The 2025 CPT update introduced new telehealth codes (98000-98015) that most commercial payers may adopt, but Medicare explicitly does NOT. Running the same billing setup for Medicare and commercial payers creates systematic errors. Tebra's default templates may not be pre-configured for psychiatry-specific modifier rules.

**How to avoid:**
- Configure Tebra with payer-specific rule sets: Medicare gets 99202-99215 + modifier 95 or 93 + POS 02 or 10; commercial payers may differ
- Build a billing cheat sheet per payer for the 10-15 most common encounters
- Audit first 20-30 claims per payer for modifier/POS accuracy before relying on automation
- For E/M + psychotherapy same-day: use modifier 25 on the E/M to flag it as a separately identifiable service; document them separately in the note
- POS must match modifier: POS 02 for non-home telehealth, POS 10 for patient-at-home — Medi-Cal will auto-deny mismatches

**Warning signs:**
- High denial rate on Medicare claims (>10%)
- Denials citing "place of service error" or "modifier required"
- Remittance codes CO-4, CO-16, or CO-97

**Phase to address:** Phase 2 (Billing Workflow Setup)
**Severity: COSTLY** — Systematic errors result in months of denied claims; potential overpayment recoupment with interest if not caught early

---

### Pitfall 5: CAQH Profile Lapsing — Silent Insurance Panel Removal

**What goes wrong:**
CAQH ProView requires re-attestation every 120 days (approximately every 4 months). If Valentina misses a re-attestation cycle, insurance payers automatically lose access to her credentialing data. This can trigger:
- Claim rejections (provider not recognized as credentialed)
- Automatic removal from insurance panels
- Revenue interruption with no clear error message on claim rejections

**Why it happens:**
CAQH sends email reminders that get lost or ignored. Solo practitioners have no credentialing coordinator watching for these. Attestation feels like a formality, so it gets deferred.

**How to avoid:**
- Set quarterly calendar reminders (every 90 days, not 120 — give a 30-day buffer)
- Assign CAQH maintenance ownership explicitly (Maxi as admin)
- After each attestation, verify all 17 payer connections are active and authorized in CAQH
- Keep all supporting documents current in CAQH: malpractice insurance certificate, DEA certificate, CA medical license, NPI confirmation
- Set up expiry tracking for every document in CAQH with 90-day advance alerts

**Warning signs:**
- Any payer claim denied with "provider not found" or "invalid provider"
- CAQH account shows "authorization expired" for any payer
- Missing re-attestation email (set up a dedicated admin email alias for CAQH)

**Phase to address:** Phase 1 (Compliance Audit) to establish baseline, Phase 2 to build the monitoring calendar
**Severity: COSTLY** — Revenue loss while out-of-network; re-credentialing can take 90-180 days

---

### Pitfall 6: Inadequate Telehealth Informed Consent (CA-Specific)

**What goes wrong:**
California Business and Professions Code Section 2290.5 requires specific informed consent for telehealth that goes beyond a generic "I agree to treatment" form. Missing elements create both regulatory and malpractice exposure. Required elements include:
- Risks and limitations specific to telehealth (technology failure, confidentiality risks, limited physical exam)
- Patient's right to discontinue telehealth and request in-person care
- Emergency procedures when technology fails or patient is in crisis
- The fact that records may be stored electronically
- For Medi-Cal patients: additional disclosures about service limitations via telehealth

**Why it happens:**
Providers use a generic HIPAA notice or a therapy intake form and assume it covers telehealth consent. It doesn't. Oral consent is permitted in California but must be documented in the chart.

**How to avoid:**
- Create a California-specific telehealth informed consent form covering all B&P 2290.5 elements
- Include emergency action plan: what happens if patient expresses suicidal ideation during a video session (nearest ER, 988, local emergency contact)
- Document consent in every patient's chart before first session — Tebra should have this as a required intake document
- Re-obtain if patient changes modality (video to audio-only)
- For Medi-Cal patients: use DHCS-compliant language

**Warning signs:**
- Intake forms don't mention telehealth specifically
- No emergency contact or crisis plan in the intake packet
- No documentation in chart confirming consent obtained

**Phase to address:** Phase 1 (Compliance Audit), forms audit
**Severity: COSTLY** — Regulatory violation and malpractice exposure; medical board complaint risk

---

## Moderate Pitfalls

### Pitfall 7: Medicare In-Person Visit Requirement (Behavioral Health)

**What goes wrong:**
Medicare has a requirement that new behavioral health telehealth patients have an in-person visit within 6 months of first telehealth contact, and annually thereafter. This requirement has been extended/suspended multiple times. The most recent suspension covers patients who began services on or before January 30, 2026 (considered "established" and subject only to annual requirement). The extension runs through December 31, 2027. If Valentina takes new Medicare patients after a future deadline without an in-person option, claims may be denied.

**How to avoid:**
- Track CMS telehealth policy page for behavioral health in-person requirement status
- Document in each chart why in-person visit was not feasible (access barriers, geographic hardship) to protect against retroactive audits
- If the annual in-person requirement becomes active, plan an in-person evaluation option or telemedicine hub arrangement
- Do NOT assume the requirement is permanently waived — it requires ongoing Congressional/CMS action

**Phase to address:** Phase 2 (Billing Workflow) — document tracking and chart template
**Severity: COSTLY** — Denials and potential recoupment if the requirement becomes active and charts don't document exemptions

---

### Pitfall 8: Upcoding or Miscoding E/M + Psychotherapy Add-On Combination

**What goes wrong:**
Psychiatrists commonly bill both an E/M code (99202-99215) and a psychotherapy add-on code (90833 for 16-37 min, 90836 for 38-52 min, 90838 for 53+ min) in the same encounter. This is legitimate and appropriate — but requires:
- E/M level determined by **medical decision-making** (NOT total time) when psychotherapy add-on is used
- Modifier 25 on the E/M to indicate a separately identifiable service
- Two distinct sections in the clinical note: one for the medical/E/M portion, one for the psychotherapy portion
- Time documented for psychotherapy portion only (not total encounter time)

**How to avoid:**
- Create a standard note template in Tebra with separate sections: Medical Decision-Making Assessment and Psychotherapy Summary
- Train on the 1-minute thresholds for psychotherapy add-on codes (90833: 16 min minimum; 90836: 38 min minimum; 90838: 53 min minimum)
- Run a periodic billing audit: sample 10 claims per month to verify E/M level aligns with MDM in the note
- Do not use total session time to justify the E/M level when psychotherapy add-on is billed

**Warning signs:**
- Note describes mostly psychotherapy but E/M is billed at 99214 or 99215 (high complexity)
- Note doesn't have distinct sections for E/M and therapy portions
- Psychotherapy time consistently lands exactly at code minimums (looks rounded)

**Phase to address:** Phase 2 (Billing Workflow Setup)
**Severity: COSTLY** — OIG audits specifically target psychiatry billing patterns; overpayment demand + exclusion risk

---

### Pitfall 9: No Surprises Act Good Faith Estimate Non-Compliance

**What goes wrong:**
Since January 1, 2022, all uninsured and self-pay patients must receive a Good Faith Estimate (GFE) before services begin. The GFE must include: session rate, CPT codes, provider NPI, tax ID, practice location, and projected number/frequency of sessions. Providing just a rate sheet is not compliant. Patients who are billed $400+ more than the GFE can initiate a dispute resolution process.

**How to avoid:**
- Create a GFE template with all required fields; issue it to every self-pay or uninsured patient before first session
- Include a reasonable projected treatment course (e.g., "initial evaluation + 12 monthly medication management visits" as an estimate)
- Store signed or acknowledged GFEs in Tebra with the patient's intake documents
- Review GFE annually or when rates change

**Phase to address:** Phase 2 (Billing Workflow Setup)
**Severity: MODERATE** — CMS civil monetary penalties; patient-initiated disputes

---

### Pitfall 10: Tebra Billing Configuration Left at Defaults

**What goes wrong:**
Tebra's default billing configuration is generic. Psychiatry has a distinct CPT code set, modifier requirements, and payer-specific rules that must be configured manually. Leaving defaults in place results in:
- Claims going out with wrong POS code
- Missing modifiers on telehealth claims
- Behavioral health denial rates of 15-25% nationally
- No automation of psychotherapy add-on time-based rules

**How to avoid:**
- Do a full Tebra billing configuration audit before submitting the first claim
- Set up payer-specific rules for each of the 17 credentialed payers
- Configure standard encounter templates for the top 5-6 visit types (new patient eval, med management, E/M + psychotherapy, crisis, etc.)
- Set up denial tracking in Tebra — review every denied claim within 48 hours
- Establish a clean claim target: >95% first-pass acceptance rate

**Warning signs:**
- First batch of claims returns more than 5-10% denials
- Remittance shows systematic errors (same code on multiple claims)
- Tebra support articles referenced are outdated (known issue per user reviews)

**Phase to address:** Phase 2 (Billing Workflow Setup)
**Severity: COSTLY** — Revenue leakage from day one if not configured correctly

---

## Minor Pitfalls

### Pitfall 11: Missing or Expired Malpractice Insurance Certificate in Credentialing Files

**What goes wrong:**
Payers require current malpractice insurance as a credentialing condition. If the certificate lapses or the coverage dates change and CAQH is not updated, payers may flag the provider and suspend billing privileges.

**How to avoid:**
- Track malpractice policy renewal date with 90-day advance alert
- Upload updated certificate to CAQH immediately upon renewal
- Maintain a copy in the credential vault alongside the policy number, coverage limits, and carrier contact

**Phase to address:** Phase 1 (Compliance Audit)
**Severity: MODERATE**

---

### Pitfall 12: Not Verifying Patient Insurance Eligibility Before Each Visit

**What goes wrong:**
A patient's insurance can change — coverage terminates, plan switches, deductible resets — without notice. Seeing patients without real-time eligibility verification results in seeing sessions that won't be reimbursed, co-pay errors, and write-offs.

**How to avoid:**
- Use Tebra's real-time eligibility verification tool before every scheduled visit
- Build eligibility check into the scheduling workflow (run 48 hours before appointment and again morning-of)
- Document eligibility check results in Tebra for audit trail

**Phase to address:** Phase 3 (Patient Intake Workflow)
**Severity: INCONVENIENT** — Revenue leakage but recoverable with patient billing

---

### Pitfall 13: Emergency Protocol Gap for Telehealth Crisis Situations

**What goes wrong:**
During a telehealth session, if a patient expresses suicidal ideation or is in acute psychiatric distress, the provider cannot physically intervene. Without a pre-established crisis protocol documented in the chart, the provider may not know the patient's physical location, local emergency services number, or emergency contact — all needed to dispatch help.

**How to avoid:**
- Every patient chart must contain: current physical address (updated each session if patient is mobile), emergency contact name + phone, local crisis line for their location, and nearest ER
- Crisis protocol SOP: steps to take if patient expresses SI (confirm location, call 911 or ask patient to call, document in real time)
- Include crisis plan acknowledgment in telehealth informed consent

**Phase to address:** Phase 3 (Patient Intake Workflow)
**Severity: PRACTICE-ENDING** — Patient harm + board complaint + malpractice if protocol is missing and an adverse event occurs

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Generic intake forms not updated for telehealth | Fast launch | Compliance gap, consent invalidity | Never — fix before first patient |
| Skip HIPAA risk analysis | Save time | OCR audit = $100K+ settlement | Never |
| Use Tebra defaults without payer-specific setup | Start billing faster | High denial rate, revenue loss from day one | Never |
| Manually track license/cert expiries in a spreadsheet | No setup cost | Misses renewals, causes panel lapses | Acceptable for <6 months; then automate |
| Same note template for all visit types | Less setup | MDM not documented correctly for E/M level, audit risk | Never for billing compliance |

---

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Tebra + Medicare | Using 98000-98015 CPT codes (new telehealth codes) | Medicare uses 99202-99215 + modifier 95/93; never 98000-98015 |
| Tebra + Medi-Cal | Wrong POS code with telehealth modifier | POS 02 or POS 10 required when telehealth modifier present; Medi-Cal auto-denies mismatches |
| CAQH + all 17 payers | Not checking payer authorization status after re-attestation | Verify all 17 payers have active authorization in CAQH dashboard after every attestation |
| Video platform + HIPAA | Using standard Zoom or Google Meet | Must use a platform with signed BAA (Zoom for Healthcare, Doxy.me, or equivalent) |
| CURES (CA PDMP) + prescribing | Forgetting to check before controlled substance prescribing | Required within 24 hours before first Rx; every 6 months ongoing |
| DEA registration + telehealth | Assuming registration auto-renews | DEA registration must be renewed every 3 years; lapse = cannot prescribe controlled substances |

---

## Security Mistakes

| Mistake | Risk | Prevention |
|---------|------|------------|
| No HIPAA Security Risk Analysis documented | OCR's #1 enforcement target (2025); $25K-$3M fines | Conduct and document a formal SRA before launch using HHS SRA Tool |
| BAA not signed with AI tools processing PHI | HIPAA violation; business associate breach | Get BAA from any AI tool used for note summarization, coding suggestions, or chart review |
| Patient PHI in non-encrypted storage | Data breach liability; CA CMIA notification requirements | Use HIPAA-compliant storage with encryption at rest and in transit |
| SMS for clinical communication | Unencrypted PHI transmission | Use HIPAA-compliant secure messaging (Tebra's patient portal or equivalent) |
| Shared login credentials for Tebra | Audit trail impossible; cannot investigate breach | Unique login per user; 2FA enabled; audit logs reviewed quarterly |

---

## "Looks Done But Isn't" Checklist

- [ ] **Telehealth Informed Consent:** Often missing CA-specific elements (B&P 2290.5) and emergency plan — verify form covers all required disclosures
- [ ] **CAQH Profile:** Often considered done after initial setup — verify re-attestation schedule is active and all 17 payer connections show "authorized"
- [ ] **Billing Configuration:** Often left at Tebra defaults — verify payer-specific modifier and POS rules are configured before first claim
- [ ] **CURES Registration:** Often assumed complete — verify active enrollment with CA DOJ and confirm mandatory consultation workflow is documented
- [ ] **DEA Registration:** Often assumed current — verify certificate is active and renewal date is on the compliance calendar
- [ ] **HIPAA BAAs:** Often missing for newer tools — audit every vendor that touches PHI (video, AI, scheduling, email, storage)
- [ ] **No Surprises Act GFE:** Often overlooked for self-pay/uninsured patients — verify GFE template exists and is issued in scheduling workflow
- [ ] **Crisis Protocol:** Often absent from telehealth intake — verify patient location, emergency contact, and crisis steps are in every chart
- [ ] **Malpractice Policy:** Often current but not updated in CAQH — verify certificate upload date matches current policy period

---

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| CAQH lapse / payer removal | HIGH | Re-submit credentialing application; 90-180 day wait; no billing during gap |
| Wrong POS/modifier on claims | MEDIUM | Identify affected claims, submit corrected claims within timely filing limit (Medicare: 12 months from DOS) |
| HIPAA BAA missing (discovered) | MEDIUM | Sign BAA immediately; conduct risk analysis; document corrective action; no self-reporting required unless breach occurred |
| HIPAA breach (discovered) | HIGH | Follow Breach Notification Rule: notify affected patients within 60 days; notify OCR; CA CMIA may require faster notification |
| Controlled substance prescribing error | VERY HIGH | Consult healthcare attorney immediately; voluntary disclosure to DEA may mitigate penalty |
| Medicare overpayment discovered | HIGH | Voluntary repayment within 60 days of discovery is required by law (60-day rule); consult attorney before refunding |

---

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Out-of-state patient prescribing | Phase 1: Compliance Audit | Patient intake form asks physical location; note template includes location field |
| DEA extension expiration | Phase 1: Compliance Audit + Phase 2: Ops SOP | DEA renewal date on compliance calendar; CURES workflow documented |
| HIPAA BAA gaps | Phase 1: Compliance Audit | Vendor inventory complete; BAAs signed and filed |
| HIPAA Risk Analysis missing | Phase 1: Compliance Audit | SRA document exists, dated, signed |
| Medicare modifier/POS errors | Phase 2: Billing Workflow Setup | Payer-specific rules in Tebra; first 30 claims audited manually |
| CAQH re-attestation lapse | Phase 1 (baseline) + Phase 2 (monitoring) | Quarterly calendar alerts active; Maxi assigned as CAQH owner |
| CA telehealth informed consent | Phase 1: Compliance Audit | CA-specific consent form drafted and loaded into Tebra intake |
| E/M + psychotherapy miscoding | Phase 2: Billing Workflow Setup | Note template has separate E/M and therapy sections; billing audit SOP defined |
| No Surprises Act GFE | Phase 2: Billing Workflow Setup | GFE template exists; scheduling workflow includes issuance step |
| Tebra billing defaults | Phase 2: Billing Workflow Setup | Configuration audit complete; payer rules set; first-pass acceptance rate >95% |
| Emergency/crisis protocol gap | Phase 3: Patient Intake Workflow | Crisis protocol SOP written; intake form captures location + emergency contact |
| Medicare in-person requirement | Phase 2: Billing Workflow Setup | Documentation protocol for exceptions; CMS policy monitoring on calendar |

---

## Sources

- [CMS Telehealth FAQ CY 2026 (February 2026)](https://www.cms.gov/files/document/telehealth-faq-updated-02-04-2026.pdf) — HIGH confidence
- [DEA Fourth Temporary Extension of COVID-19 Telemedicine Flexibilities (Federal Register, Dec 31 2025)](https://www.federalregister.gov/documents/2025/12/31/2025-24123/fourth-temporary-extension-of-covid-19-telemedicine-flexibilities-for-prescription-of-controlled) — HIGH confidence
- [DEA Special Registration Proposed Rule, Federal Register 2025-01099 (Jan 17, 2025)](https://www.federalregister.gov/documents/2025/01/17/2025-01099/special-registrations-for-telemedicine-and-limited-state-telemedicine-registrations) — HIGH confidence
- [California Medical Board — Telehealth Requirements](https://www.mbc.ca.gov/Resources/Medical-Resources/telehealth.aspx) — HIGH confidence
- [CURES Mandatory Use — Medical Board of California](https://www.mbc.ca.gov/Resources/Medical-Resources/CURES/Mandatory-Use.aspx) — HIGH confidence
- [HHS HIPAA for Telehealth Technology](https://telehealth.hhs.gov/providers/telehealth-policy/hipaa-for-telehealth-technology) — HIGH confidence
- [OCR HIPAA Enforcement 2025 — Ogletree Deakins Analysis](https://ogletree.com/insights-resources/blog-posts/2025-enforcement-trends-risk-analysis-failures-at-the-center-of-hhss-multimillion-dollar-hipaa-penalties/) — MEDIUM confidence
- [California Business Associate Agreements — Cooper & Huber Counsel](https://chcounsel.com/business-associate-agreements-in-california-the-overlooked-compliance-risk-for-healthcare-providers/) — MEDIUM confidence
- [APA — No Surprises Act Good Faith Estimate FAQ](https://www.psychiatry.org/File%20Library/Psychiatrists/Practice/Practice-Management/No-Surprises-Act-Questions-12-29--FAQs-for-website.pdf) — HIGH confidence
- [MGMA — 2025 Telehealth CPT Codes for Video and Audio-Only Visits](https://www.mgma.com/articles/2025-telehealth-cpt-codes-for-video-and-audio-only-visits) — MEDIUM confidence
- [AAPC Forum — Psychotherapy Codes with New Telemedicine Codes for 2025](https://www.aapc.com/discuss/threads/psychotherapy-codes-w-new-telemedicine-synchronous-audio-video-e-m-codes-for-2025.201621/) — MEDIUM confidence
- [7 Common Insurance Credentialing Pitfalls — Assured](https://www.withassured.com/blog/insurance-credentialing-pitfalls) — MEDIUM confidence
- [CAQH Re-Attestation Guide — SybridMD](https://sybridmd.com/blogs/credentialing-corner/caqh-credentialing-re-attestation/) — MEDIUM confidence
- [California Telehealth Regulations — Wheel](https://www.wheel.com/state-telehealth-regulations/california) — MEDIUM confidence
- [Federal Fraud Defense for Psychiatrists — Oberheiden P.C.](https://federal-lawyer.com/healthcare-defense/psychologists-psychiatrists/) — MEDIUM confidence
- [Medicare Telehealth Updates for Psychiatrists 2026 — APA](https://www.psychiatry.org/Psychiatrists/Practice/Telepsychiatry/Blog/Medicare-Telehealth-Updates-What-Psychiatrists-Nee) — HIGH confidence
- [Tebra Billing Pain Points 2025 — The Intake](https://www.tebra.com/theintake/getting-paid/medical-billing-pain-points-insights-solutions) — LOW confidence (vendor source)
- [California Telemedicine Regulations and Violations — California Licensing Defense](https://www.californialicensingdefense.com/california-telemedicine-regulations-violations/) — MEDIUM confidence

---
*Pitfalls research for: Telehealth psychiatry practice operations — solo CA psychiatrist, Medicare/Medi-Cal, Tebra EHR*
*Researched: 2026-02-25*
