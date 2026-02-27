# Phase 3: Clinical & Business Operations - Context

**Gathered:** 2026-02-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Document every operational workflow — from patient intake to crisis response to biller oversight — in SOPs that Valentina and Maxi can follow on day one. Deliverables: five SOP documents covering patient intake (OPS-01), CURES database checks (OPS-02), crisis protocol (OPS-03), business structure (OPS-04), and biller onboarding (OPS-05). This phase produces documentation, not software.

**Population:** Youth psychiatry (minors). This affects intake (parental consent), crisis protocol (CANRA, parent notification), and screening tools (youth-validated instruments).

**Upstream dependencies:**
- Phase 1 deliverables: compliance checklist, HIPAA SRA, BAA tracker, telehealth consent form, minor consent form, patient location protocol
- Phase 2 deliverables: credential inventory, 1Password vault spec, payer tracker (17 panels), alert architecture

</domain>

<decisions>
## Implementation Decisions

### Patient Intake Flow (OPS-01)
- Primary intake channel: Tebra patient portal (patients find via insurance directories or Psychology Today)
- No free pre-screening call — anyone who books gets seen, clinical assessment happens during first session
- Duties are fluid between Maxi and Valentina — SOP should propose a clean admin/clinical split as a recommendation, not document an existing arrangement
- Eligibility verification workflow: unknown — **needs research** on whether Tebra handles this automatically or if manual verification is needed
- Intake forms: not yet configured — **needs research** on standard forms for telehealth youth psychiatry (demographics, psychiatric history, medication list, age-appropriate screeners, parental consent)
- Prescribing posture: conservative start (SSRIs, SNRIs, non-stimulant ADHD meds). Controlled substances (stimulants, benzos) deferred until practice established. CURES SOP must cover requirements regardless.

### Crisis Protocol (OPS-03)
- Solo practitioner with no formal clinical backup — **SOP should include a peer consultation / backup protocol recommendation**
- Parent presence during youth telehealth sessions: undecided — **needs research** on best practices by age group
- CA-specific youth crisis resources: not identified — **needs research** (988 Suicide & Crisis Lifeline, county mobile crisis teams, emergency contacts by patient location statewide)
- CANRA (Child Abuse and Neglect Reporting Act): Valentina is familiar — SOP includes quick-reference only (phone numbers, timelines, SS 8572 form), not a full training document
- Suicide risk assessment: no tool selected — **SOP should research and recommend a validated youth suicide risk assessment instrument** (C-SSRS, ASQ, or similar)
- Safety plan: include BOTH a provider-side crisis protocol AND a patient-facing safety plan template (warning signs, coping strategies, emergency contacts)
- Post-crisis protocol: full documentation — charting requirements, parent/guardian notification policy, mandatory follow-up timeline (24-48 hrs), provider self-care

### Biller Onboarding (OPS-05)
- Billing company: **Nexus Billing** (already selected)
- Payment model: percentage of collections
- BAA: already signed — reference in SOP, don't create new checklist
- Tebra access level: **needs research** on what role-based access Tebra offers; recommend most HIPAA-restrictive option that still lets biller function
- Reporting: per-claim visibility — Valentina wants to see every claim status, not just monthly summaries
- SOP should document: what data Nexus Billing needs to get started, how they access Tebra, what reports Valentina expects, and escalation path for denied claims

### SOP Audience & Format
- Audience: written for future staff (admin, nurse, therapist) — cannot assume shared context, must be self-explanatory
- Format: step-by-step checklists with numbered steps and checkboxes
- Destination: structured for Phase 4 dashboard integration (machine-readable structure) while remaining standalone documents now
- Polish level: production-ready — usable on day one without further editing
- Tone: professional, clear, no jargon without definition

### Claude's Discretion
- Exact checklist formatting and section structure within each SOP
- How to structure the business entity document (OPS-04) — straightforward factual documentation
- CURES SOP (OPS-02) step-by-step formatting — clinical workflow is well-defined by CA law
- How to organize crisis resources by region for statewide telehealth coverage
- Which youth-specific screening instruments to recommend for intake forms

</decisions>

<specifics>
## Specific Ideas

- SOPs must be dual-purpose: human-readable checklists NOW, parseable by Phase 4 TouchDesigner dashboard LATER — use consistent heading structure and step numbering
- Crisis protocol needs to account for telehealth-specific constraints: can't physically intervene, may not know patient's exact location, need parent/guardian contact info pre-populated
- Youth population means every SOP touches parental consent / guardian involvement — this should be a cross-cutting theme, not an afterthought
- Conservative prescribing posture means CURES SOP still covers full Schedule II-V requirements, but intake workflow doesn't need stimulant-specific consent forms at launch

</specifics>

<deferred>
## Deferred Ideas

- None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-clinical-business-operations*
*Context gathered: 2026-02-27*
