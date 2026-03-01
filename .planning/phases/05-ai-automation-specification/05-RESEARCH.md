# Phase 5: AI Automation Specification - Research

**Researched:** 2026-03-01
**Domain:** n8n AI workflows, LLM-based monitoring pipelines, form pre-fill automation, regulatory/payer change detection
**Confidence:** HIGH overall — architecture patterns confirmed; specific regulatory source URLs MEDIUM (verified accessible but feed format varies)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Form Pre-fill (AI-01):**
- Priority targets: CAQH re-attestation AND insurance credentialing applications (not one or the other — both)
- Review flow: Confidence-based color-coding — green (exact vault match), yellow (inferred/mapped), red (no data available)
- Form interaction method: Hybrid two-tier — Tier 1 = pre-fill reference document (PDF/spreadsheet), Tier 2 = browser automation (Playwright) filling portals directly
- Spec both tiers independently; developer implements Tier 1 first
- Change propagation: Proactive alerts when credential records change in Supabase — identifies affected forms, auto-creates draft obligation
- Data source: Supabase `credentials`, `payer_tracker`, `compliance_items` tables

**Regulatory Monitoring (AI-02):**
- Detection method: Curated fixed list of 10-20 regulatory source URLs/feeds + LLM filter for practice relevance
- Alert tiers: Immediate email (both Valentina + Maxi) for high-impact; weekly digest for medium/low
- AI analysis depth: Full per-alert — plain-English summary + practice-specific impact + suggested action
- Dashboard integration: Auto-create draft obligations when high-impact change detected

**Insurance & Payer Monitoring (AI-03):**
- Change types: Both credentialing requirement changes AND billing rule changes across all 17 panels
- Discovery: Per-payer sources (bulletin pages, newsletter archives) + industry aggregators (CMS MLN, Medi-Cal bulletins)
- Alert system: Unified with regulatory monitoring — same pipeline, same alert tiers, same obligation creation
- Uniform monitoring across all 17 payers (no volume-based tiering)

**Software/Platform Monitoring (AI-04):**
- Platforms: Tebra, Supabase, n8n, TouchDesigner (core) + 1Password, SendGrid, Google Workspace, DigitalOcean (dependencies)
- Change types: Breaking changes + security vulnerabilities + compliance implications ONLY (not routine updates)
- Alert routing: Maxi only (separate from Valentina's monitoring); still creates dashboard draft obligations for critical items
- Detection method: AI-interpreted changelogs/release notes; LLM scores for severity, compliance impact, required action

### Claude's Discretion
- Exact curated source list for regulatory monitoring (which 10-20 URLs/feeds to monitor)
- Specific n8n workflow architecture (number of workflows, polling intervals, node structure)
- LLM model selection for filtering/analysis (cost vs capability tradeoff)
- Pre-fill document format details (PDF vs spreadsheet, field mapping structure)
- Confidence scoring algorithm for form pre-fill (what makes a field green vs yellow vs red)
- Weekly digest email template design

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within Phase 5 scope.
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| AI-01 | AI form pre-fill from credential vault data (auto-populate insurance applications, compliance documents, credentialing forms) | Tier 1 (reference document) uses n8n Code node + LLM for field mapping from Supabase; Tier 2 uses n8n Playwright community node for browser automation. CAQH ToS prohibits unauthorized automation (Tier 2 requires CAQH-authorized automation account or explicit ToS review). |
| AI-02 | Automated regulatory monitoring — continuously checks for changes in CA telehealth laws, Medical Board rules, HIPAA updates, DEA prescribing regulations | n8n RSS Read node + HTTP Request node covers Federal Register, CA Medical Board (email subscription, no public RSS), DEA press releases. LLM filter via AI Agent node + OpenAI. Structured Output Parser returns `{ relevant: bool, urgency: string, summary: string, impact: string, action: string }`. |
| AI-03 | Automated insurance monitoring — tracks payer policy changes, credentialing requirement updates, billing rule changes across all 17 panels | Same n8n pipeline as AI-02. CMS MLN has RSS-accessible newsletters. Per-payer portals have no public feeds — HTTP Request + HTML diff pattern for change detection. Industry aggregators (MGMA) require paid subscription. |
| AI-04 | Automated software/platform monitoring — tracks Tebra updates, API changes, security patches, vendor compliance shifts | GitHub Releases RSS (Supabase, n8n), vendor status pages (Tebra, DigitalOcean), email-to-webhook bridges for vendors without RSS. LLM interprets for severity and compliance impact. Narrower scope — Maxi-only alert routing. |
</phase_requirements>

---

## Summary

Phase 5 produces a specification document — not working code. Research confirms that the entire AI automation stack can be built on top of the existing architecture (n8n + Supabase + existing alert infrastructure from Phase 2/4). No new platforms are needed. The dominant architectural pattern is: n8n fetches sources on schedule, an LLM node filters and analyzes for relevance, Supabase stores results, and the existing alert/obligation pipeline from Phases 2 and 4 delivers notifications and creates dashboard obligations.

The most important research finding is that CAQH ProView explicitly prohibits unauthorized automation software in its Terms of Service. Tier 2 form automation (browser fill of CAQH portal directly) requires either obtaining CAQH's formal automation account authorization or limiting Tier 2 scope to payer portals without similar restrictions. Tier 1 (reference document generation) has no such constraint and should be the primary deliverable.

For monitoring workflows, n8n's built-in RSS Read node handles feeds that exist. For sources without RSS (CA Medical Board, most payer portals), the pattern is HTTP Request + HTML diff via a Code node comparing the current page hash to a stored baseline in Supabase. LLM filtering should use GPT-4o-mini or Claude Haiku 4.5 (both under $1.25/million output tokens) — these lightweight models are sufficient for relevance classification and will keep monthly costs under $10 even at high polling volumes for a solo practice.

**Primary recommendation:** Spec three n8n workflow groups — (1) Form Pre-fill generation (triggered manually or by credential change webhook), (2) Regulatory + Payer monitoring (unified pipeline, scheduled), (3) Software monitoring (separate pipeline, Maxi-only routing). All write to the existing Supabase `obligations` and `automation_log` tables established in Phase 4.

---

## Standard Stack

### Core
| Component | Version/Detail | Purpose | Why Standard |
|-----------|---------------|---------|--------------|
| n8n (self-hosted) | Community Edition (latest) | Workflow orchestration: scheduling, fetching, LLM calls, email delivery | Already deployed on DigitalOcean 178.128.12.34; established in Phase 2/4 |
| OpenAI API | GPT-4o-mini (primary), GPT-4o (fallback for complex analysis) | LLM relevance filtering, structured JSON output, impact analysis | Native n8n OpenAI node; GPT-4o-mini is cheapest capable model at $0.15/$0.60 per 1M tokens |
| Supabase | Existing Brighter Days project | Shared data layer: stores monitoring results, drafts obligations, logs automation runs | Already established; `obligations` + `automation_log` tables exist from Phase 4 |
| n8n RSS Read node | Built-in | Fetches RSS/Atom feeds from Federal Register, GitHub, CMS | Native n8n node, zero setup |
| n8n HTTP Request node | Built-in | Fetches HTML pages without RSS; payer bulletin pages, CA Medical Board | Native n8n node |
| n8n Supabase node | Built-in | Read/write to Brighter Days Supabase project | First-class n8n integration; service role key in n8n credential vault |
| n8n OpenAI node | Built-in | Calls GPT for relevance filter + analysis + structured output | Native; supports JSON mode and structured output |
| n8n SendGrid / Email node | Built-in | Delivers immediate alerts and weekly digest emails | Already used in Phase 2 alert architecture spec |

### Supporting
| Component | Version/Detail | Purpose | When to Use |
|-----------|--------------|---------|-------------|
| n8n Playwright community node | `n8n-nodes-playwright` (community) | Tier 2 browser automation for form filling | Only for Tier 2 form fill — requires CAQH authorization review first; safe for payer portals without automation restrictions |
| Claude Haiku 4.5 (Anthropic) | via n8n Claude node or HTTP Request to Anthropic API | Alternative LLM if OpenAI costs rise | Haiku 4.5 at $1/$5 per 1M tokens; comparable quality for classification tasks |
| n8n Code node | Built-in | HTML diff for pages without RSS; custom field mapping logic; confidence scoring | Any custom logic that n8n nodes don't cover natively |
| n8n Schedule Trigger | Built-in | Cron-based polling triggers | All scheduled monitoring workflows |
| n8n Structured Output Parser sub-node | Built-in LangChain integration | Forces LLM response into typed JSON schema | When LLM responses must conform to exact shape (relevance score, urgency, etc.) |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| GPT-4o-mini | Claude Haiku 4.5 | Both are cheap and fast; GPT-4o-mini has native n8n node vs HTTP Request for Claude; either works |
| n8n HTTP Request for HTML diff | Firecrawl (web scraping service) | Firecrawl is LLM-ready markdown output, cleaner for AI consumption but adds cost ($19+/mo); n8n HTTP Request is free for this volume |
| Self-hosted n8n Playwright | Browserless.io (cloud) | Browserless handles browser process management better; adds $49+/mo; overkill for < 10 form fills/month |
| Supabase for obligation storage | Separate obligations database | Supabase is already established and `obligations` table already defined in Phase 4 DDL |

**No new installations required.** n8n and Supabase already exist. Only additions: n8n community node `n8n-nodes-playwright` (if Tier 2 is in scope), and API keys for OpenAI.

---

## Architecture Patterns

### Recommended Workflow Groups

Three independent n8n workflow groups — each independently deployable and testable:

```
GROUP A: Form Pre-fill Generation (AI-01)
  Trigger: Manual button (from dashboard) OR Supabase webhook on credentials table change
  n8n workflow:
    → Reads all fields from credentials + payer_tracker + compliance_items
    → LLM maps vault data to target form fields
    → Generates color-coded reference document (green/yellow/red)
    → Stores result in Supabase (or email delivery)
    → If triggered by credential change: creates draft obligation for affected forms

GROUP B: Regulatory + Payer Monitoring (AI-02 + AI-03)
  Trigger: Scheduled (daily at 7 AM PT, weekly digest Saturday)
  n8n workflow:
    → Fetches 15-20 source URLs (RSS feeds + HTML pages)
    → LLM filter: "Relevant to solo CA telehealth psychiatry prescribing Sch II-V?"
    → If relevant: LLM generates full analysis (summary + impact + action)
    → Stores result in Supabase monitoring_alerts table
    → High-urgency: immediate email to Valentina + Maxi + draft obligation in dashboard
    → Low-urgency: queued for weekly digest

GROUP C: Software/Platform Monitoring (AI-04)
  Trigger: Scheduled (daily at 8 AM PT)
  n8n workflow:
    → Fetches changelogs/release notes from 8 tracked platforms
    → LLM scores: severity, compliance_impact, requires_action (boolean)
    → If requires_action or compliance_impact: email to Maxi + draft obligation
    → All results logged to automation_log
```

### Pattern 1: RSS Feed + LLM Relevance Filter (Core Monitoring Pattern)

**What:** n8n RSS Read node fetches feed items, LLM node evaluates each for relevance, Structured Output Parser returns typed JSON, IF node routes by urgency.

**When to use:** Any source with RSS (Federal Register, GitHub Releases, CMS MLN).

```json
// Source: n8n-io/n8n-docs — RSS Read node + AI Agent pattern
// Workflow nodes (pseudo-structure):
// 1. Schedule Trigger (daily cron)
// 2. Code node: define source URL list
// 3. Loop Over Items (Split in Batches)
// 4. RSS Read node: url={{ $json.url }}
// 5. OpenAI node (Chat message with structured output):
{
  "systemMessage": "You are a compliance filter for a solo CA telehealth psychiatry practice. The provider (Valentina Park MD) holds CA Medical License G-96908, DEA# FP3833933 (Schedule II-V), CAQH# 09893451, and is credentialed with 17 payers. Evaluate whether this regulatory/payer item is relevant to THIS practice. Return JSON only.",
  "promptTemplate": "Item title: {{$json.title}}\nSummary: {{$json.contentSnippet}}\n\nReturn: { \"relevant\": boolean, \"urgency\": \"high\" | \"medium\" | \"low\" | \"none\", \"summary\": \"plain English summary\", \"impact\": \"specific impact on this practice (or null)\", \"suggested_action\": \"what to do (or null)\" }",
  "model": "gpt-4o-mini",
  "responseFormat": "json_object"
}
// 6. IF node: branch on relevant=true
// 7. Supabase Insert: monitoring_alerts table
// 8. IF node: branch on urgency="high"
// 9a. High: SendGrid immediate email + Supabase Insert into obligations (status: "review_needed")
// 9b. Low/medium: queue for weekly digest
```

### Pattern 2: HTML Diff for Pages Without RSS

**What:** n8n HTTP Request fetches page HTML, Code node hashes the content, compares to stored hash in Supabase, sends to LLM only if hash changed.

**When to use:** CA Medical Board, most payer provider bulletin pages (no RSS).

```javascript
// Source: n8n community — custom Code node pattern
// In Code node (JavaScript mode):
const currentHash = require('crypto')
  .createHash('sha256')
  .update($input.first().json.data)  // raw HTML from HTTP Request
  .digest('hex');

const storedHash = $('Supabase_get_hash').first().json.content_hash;

if (currentHash === storedHash) {
  // No change — return empty, workflow stops here
  return [];
}

// Change detected — pass through with both hashes
return [{
  json: {
    source_url: $input.first().json.url,
    current_hash: currentHash,
    html_content: $input.first().json.data,
    changed: true
  }
}];
// Next node: LLM analyzes the page for what changed
```

### Pattern 3: Form Pre-fill Reference Document Generation (Tier 1)

**What:** LLM receives all credential vault data + target form's field schema, returns a JSON mapping of `{ form_field_name: { value: string, source: string, confidence: "green"|"yellow"|"red" } }`. n8n Code node converts to formatted spreadsheet (CSV) or triggers a Google Docs template fill.

**When to use:** AI-01 — generating the pre-fill reference document for any target form.

```javascript
// Source: custom pattern — n8n Code node + OpenAI structured output
// Supabase read produces all credential data, then LLM call:
const formPrompt = `
You are filling out a CAQH re-attestation form for Valentina Park MD.
Credential vault data: ${JSON.stringify(credentialVaultData)}

For each form field below, find the best matching vault data.
Return confidence:
  "green" = exact field name match or obvious mapping (NPI → NPI Number)
  "yellow" = inferred mapping (malpractice policy period → coverage dates)
  "red" = no vault data available for this field

Form fields to populate: ${JSON.stringify(targetFormFields)}

Return JSON: { "fields": [ { "field_name": string, "field_value": string|null, "source_field": string|null, "confidence": "green"|"yellow"|"red", "note": string|null } ] }
`;
// Model: gpt-4o (not mini) for this task — field mapping benefits from higher reasoning
// Output: structured JSON → Code node converts to CSV rows → email to Valentina
```

### Pattern 4: Credential Change → Form Alert (Propagation Pattern)

**What:** Supabase Database Webhook (available via Supabase → n8n webhook integration) fires when `credentials` table row is updated. n8n workflow identifies which target forms reference that credential field and creates a draft obligation.

**When to use:** AI-01 change propagation — when malpractice policy, DEA#, or any other credential changes in Supabase.

```javascript
// Supabase webhook payload on credentials table UPDATE:
// { old_record: {...}, record: {...}, type: "UPDATE", table: "credentials" }
//
// n8n Code node — field impact lookup:
const changedFields = Object.keys(newRecord).filter(
  key => JSON.stringify(newRecord[key]) !== JSON.stringify(oldRecord[key])
);

// Static field-to-form mapping (built once, stored in Supabase or n8n Code node):
const fieldToFormMapping = {
  'malpractice_policy_number': ['CAQH re-attestation', 'Aetna credentialing app', 'Blue Shield credentialing app'],
  'dea_number': ['CAQH re-attestation', 'DEA renewal'],
  'medical_license_number': ['CAQH re-attestation', 'All 17 payer applications'],
  // ... complete mapping in spec appendix
};

const affectedForms = changedFields.flatMap(f => fieldToFormMapping[f] || []);
// → creates obligation: "Malpractice policy changed — update CAQH + 3 payer portals"
```

### Pattern 5: Weekly Digest Aggregation

**What:** n8n Schedule Trigger fires weekly (Saturday morning). Supabase query pulls all `monitoring_alerts` from last 7 days where `urgency != 'high'` and `digest_sent = false`. LLM summarizes into digest email. SendGrid delivers.

**When to use:** AI-02, AI-03 weekly digest delivery.

```javascript
// n8n Schedule: Saturday 8 AM PT
// Supabase query: SELECT * FROM monitoring_alerts WHERE urgency IN ('medium','low') AND digest_sent = false AND created_at > NOW() - INTERVAL '7 days'
// Code node: group by category (regulatory, payer, software)
// OpenAI node: "Summarize these regulatory/payer updates into a concise weekly digest..."
// SendGrid: deliver to Valentina + Maxi
// Supabase Update: SET digest_sent = true WHERE id IN (...)
```

### Anti-Patterns to Avoid

- **Automating CAQH ProView portal without authorization:** CAQH ToS explicitly prohibits unauthorized automation software. Tier 2 browser automation of CAQH requires formal authorization via CAQH's automation account program. Do not spec Tier 2 for CAQH without this caveat.
- **Storing full page HTML in Supabase:** Hash only, not full HTML. Supabase is not designed as a web content archive. Store only hash + last_checked_at + last_changed_at.
- **Passing raw LLM output directly to IF nodes:** Use Structured Output Parser sub-node or `json_object` response format to guarantee typed output before branching. Raw LLM text fails silently.
- **Single unified monitoring workflow for all 4 AI requirements:** Regulatory (Valentina + Maxi alerts) and Software (Maxi-only) have different routing. Keep them as separate n8n workflows — different triggers, different recipient lists, different urgency rules.
- **Running LLM calls on every poll regardless of content change:** Run LLM only when content has changed (hash diff passes). For a solo practice with 15-20 sources polling daily, this reduces LLM calls by 90%+ on quiet days.
- **Using GPT-4o for simple relevance filtering:** GPT-4o-mini handles binary relevance classification with equivalent accuracy at 25x lower cost. Reserve GPT-4o for the Tier 1 form pre-fill field mapping task which requires more nuanced reasoning.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| RSS feed fetching | Custom HTTP + XML parser | n8n RSS Read node | Built-in node; handles Atom + RSS 2.0; returns structured JSON items automatically |
| LLM API calls | Direct HTTP to OpenAI | n8n OpenAI node | Built-in credential management, retry logic, error handling |
| Structured LLM output | String parsing / regex | n8n Structured Output Parser sub-node + `json_object` mode | Guaranteed typed output; avoids brittle regex on LLM responses |
| Email delivery | Custom SMTP / nodemailer | n8n SendGrid node | Already used in Phase 2 alert architecture; BAA-covered via DigitalOcean |
| Supabase writes from n8n | Custom Postgres driver | n8n Supabase node | First-class n8n integration; service role key in encrypted credential vault |
| Page change detection | Full content comparison | SHA-256 hash comparison via Code node | Bandwidth-efficient; fast; simple to implement |
| Form field confidence scoring | Custom ML model | LLM with structured output + explicit rubric | LLM with well-defined criteria (green/yellow/red rubric) outperforms custom scoring for this domain |

**Key insight:** This entire phase is workflow orchestration, not software development. Every capability — fetching, filtering, alerting, form mapping — has a native or community n8n node. Custom code appears only in business logic (hash comparison, field mapping tables, obligation payload construction).

---

## Common Pitfalls

### Pitfall 1: CAQH ToS Violation via Browser Automation
**What goes wrong:** Developer implements Playwright browser automation for CAQH ProView without checking CAQH's Terms of Service. CAQH prohibits "automation software programs...designed to modify the Sites and/or Services" without authorization. Account could be suspended.
**Why it happens:** Playwright automation works technically — login, find fields, fill. The restriction is legal, not technical.
**How to avoid:** Spec must explicitly state: Tier 2 browser automation of CAQH ProView requires either (A) obtaining CAQH's formal automation account authorization by contacting CAQH directly, or (B) scoping Tier 2 to payer portals only (not CAQH). Tier 1 (reference document generation) is always safe — it doesn't touch CAQH's systems.
**Warning signs:** Developer says "I just tested Playwright on CAQH and it works" — that's testing, not authorization.

### Pitfall 2: Polling Frequency Too High for HTML-Diff Sources
**What goes wrong:** n8n checks 15-20 payer bulletin pages hourly. Even with hash checking, the HTTP GET requests at hourly intervals to 15+ websites can trigger IP-based rate limiting or bot detection on payer portals.
**Why it happens:** Overzealous monitoring frequency without considering source constraints.
**How to avoid:** Spec daily polling for HTML-diff sources (payer portals). RSS feeds with official public APIs (Federal Register, GitHub) can poll every 4-6 hours. Weekly digest sources can poll every 48 hours.
**Warning signs:** n8n shows frequent 429 or 403 responses from payer portal URLs.

### Pitfall 3: LLM Hallucinating "Relevant" Items
**What goes wrong:** GPT-4o-mini classifies a Federal Register document about veterinary controlled substances as relevant to Valentina's practice (keyword: "DEA", "controlled substances"). High false positive rate floods the obligation queue with noise.
**Why it happens:** LLM relevance filter prompt is not specific enough about the practice context.
**How to avoid:** Relevance filter prompt MUST include specific practice identifiers: CA only, telehealth psychiatry, adult + minor mental health, Schedule II-V prescribing, solo practice (no hospital affiliation). Include explicit negative examples in the system prompt: "Items about veterinary, dental, or non-psychiatric specialties are NOT relevant." Test against known-irrelevant items during spec review.
**Warning signs:** Obligation queue fills with non-psychiatry items in first week.

### Pitfall 4: Form Pre-fill Confidence Score Drift
**What goes wrong:** Developer hardcodes confidence logic ("if field name contains 'NPI' then green"). Later, CAQH changes a field label from "NPI" to "Provider Identifier Number." The field silently drops to red, causing Valentina to re-enter data she shouldn't need to.
**Why it happens:** Static string matching for field name comparison is brittle across form versions.
**How to avoid:** Spec the confidence scoring as LLM-driven (semantic similarity), not string-match. The LLM prompt should describe the confidence rubric conceptually: "Green = the vault clearly contains this exact data. Yellow = the vault has data that covers this but the field name is different or the format needs adjustment. Red = I cannot find any vault data that covers this field."
**Warning signs:** All fields suddenly turn red after a form update.

### Pitfall 5: Missing monitoring_alerts Deduplication
**What goes wrong:** n8n polls the Federal Register RSS daily. The same "DEA telemedicine extension" document appears in the feed for 3 days. Valentina receives 3 identical urgent alerts about the same item.
**Why it happens:** No deduplication check before sending alerts.
**How to avoid:** Before LLM analysis and alert creation, check Supabase `monitoring_alerts` for existing row with same `source_url + item_guid`. If exists, skip. Add a `UNIQUE(source_url, item_guid)` constraint to the table to enforce this at the database level.
**Warning signs:** Valentina emails Maxi saying she's getting duplicate alerts.

### Pitfall 6: PHI in n8n Monitoring Workflow Data
**What goes wrong:** The form pre-fill workflow pulls from `credentials` table which contains Valentina's DEA#, medical license number, NPI, and SSN (if present). n8n stores this in execution history if `EXECUTIONS_DATA_SAVE_ON_SUCCESS` is not set to false.
**Why it happens:** n8n's default setting saves full execution data (including all node inputs/outputs) for debugging.
**How to avoid:** The existing Phase 4 n8n configuration already sets `EXECUTIONS_DATA_SAVE_ON_SUCCESS=false`. Verify this setting persists for Phase 5 workflows. Note: credential data (DEA#, NPI, license numbers) is not PHI under HIPAA strict definition — but provider identifiers are sensitive business data and should not persist in logs.
**Warning signs:** n8n execution history page shows DEA or NPI numbers in node output data.

---

## Code Examples

Verified patterns from official sources:

### n8n RSS Read Node (batch multiple feeds)

```javascript
// Source: n8n-io/n8n-docs — RSS Read + Loop Over Items pattern
// Code node provides URL list:
return [
  { json: { url: 'https://www.federalregister.gov/api/v1/documents.rss?conditions[agencies][]=drug-enforcement-administration', label: 'DEA Federal Register' } },
  { json: { url: 'https://www.federalregister.gov/api/v1/documents.rss?conditions[agencies][]=health-and-human-services-department&conditions[topics][]=telehealth', label: 'HHS Telehealth' } },
  { json: { url: 'https://github.com/supabase/supabase/releases.atom', label: 'Supabase Releases' } },
  { json: { url: 'https://github.com/n8n-io/n8n/releases.atom', label: 'n8n Releases' } },
  // ... full list in spec appendix
];
// → Loop Over Items → RSS Read → LLM filter → IF → route by urgency
```

### OpenAI Structured Output in n8n

```javascript
// Source: n8n OpenAI node documentation + OpenAI structured outputs docs
// In n8n OpenAI Chat node:
// - Model: gpt-4o-mini
// - Response Format: json_object
// - System message includes JSON schema description

const systemMessage = `You are a compliance analyst for a CA telehealth psychiatry solo practice.
Provider: Valentina Park MD. CA only. Telehealth psychiatry. Adult + adolescent patients.
Schedule II-V controlled substances. HIPAA covered entity.

Evaluate the following regulatory/payer item for relevance.

Return ONLY valid JSON with this exact shape:
{
  "relevant": boolean,
  "urgency": "high" | "medium" | "low" | "none",
  "summary": "2-3 sentence plain English summary",
  "practice_impact": "how this specifically affects this practice (null if not relevant)",
  "suggested_action": "specific next step (null if no action needed)",
  "deadline": "ISO date if time-sensitive (null otherwise)"
}

High urgency: new prescribing restrictions, license requirement changes, HIPAA enforcement actions, payer contract termination risk.
Medium urgency: proposed rules open for comment, credentialing form updates, upcoming deadlines > 60 days.
Low urgency: informational bulletins, minor process changes, far-future effective dates.
None: not relevant to this practice.`;
```

### Supabase monitoring_alerts Table Schema

```sql
-- Source: Phase 5 spec (new table required — does not exist yet)
-- To be applied via Supabase Management API
CREATE TABLE monitoring_alerts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  source_url TEXT NOT NULL,
  item_guid TEXT,                          -- RSS item guid or URL hash for HTML sources
  source_label TEXT NOT NULL,              -- 'DEA Federal Register', 'CA Medical Board', etc.
  category TEXT NOT NULL,                  -- 'regulatory', 'payer', 'software'
  relevant BOOLEAN NOT NULL DEFAULT false,
  urgency TEXT CHECK (urgency IN ('high', 'medium', 'low', 'none')),
  summary TEXT,
  practice_impact TEXT,
  suggested_action TEXT,
  deadline DATE,
  alert_sent BOOLEAN DEFAULT false,        -- immediate email sent
  digest_sent BOOLEAN DEFAULT false,       -- included in weekly digest
  obligation_id UUID REFERENCES obligations(id), -- FK to auto-created obligation if high urgency
  raw_content TEXT,                        -- LLM input (truncated to 2000 chars)
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(source_url, item_guid)            -- deduplication constraint
);
```

### HTML Diff Change Detection

```javascript
// Source: custom pattern (n8n Code node)
// Node runs AFTER HTTP Request fetching bulletin page HTML
const crypto = require('crypto');
const currentHtml = $input.first().json.data;
const sourceUrl = $input.first().json.url;

// Hash content (exclude dynamic elements like dates in page header if possible)
const currentHash = crypto.createHash('sha256').update(currentHtml).digest('hex');

// Previous hash from Supabase (fetched in previous node)
const storedHash = $('Supabase_get_source_hash').first()?.json?.content_hash;

if (currentHash === storedHash) {
  return [];  // No change — workflow stops here, no LLM call
}

// Truncate HTML to 3000 chars for LLM input (reduce token cost)
const truncated = currentHtml.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim().substring(0, 3000);

return [{
  json: {
    source_url: sourceUrl,
    new_hash: currentHash,
    content_for_llm: truncated,
    changed: true
  }
}];
```

---

## Curated Source List (Claude's Discretion — Recommended)

Research confirms the following sources are accessible without authentication and cover the required regulatory/payer domains. This is the recommended list for the spec.

### Regulatory Sources (AI-02) — Recommended 12 sources

| Source | URL/Access Method | Format | Polling |
|--------|------------------|--------|---------|
| Federal Register — DEA | `federalregister.gov/api/v1/documents.rss?conditions[agencies][]=drug-enforcement-administration` | RSS | 6h |
| Federal Register — HHS | `federalregister.gov/api/v1/documents.rss?conditions[agencies][]=health-and-human-services-department` | RSS | 6h |
| Federal Register — CMS | `federalregister.gov/api/v1/documents.rss?conditions[agencies][]=centers-for-medicare-medicaid-services` | RSS | 6h |
| HHS OCR (HIPAA enforcement) | `hhs.gov/hipaa/for-professionals/compliance-enforcement/agreements/index.html` | HTML diff | Daily |
| CA Medical Board — News | `mbc.ca.gov/News/` | HTML diff | Daily |
| CA Medical Board — Disciplinary Actions | `mbc.ca.gov/Resources/Publications/Alerts.aspx` | HTML diff | Daily |
| CA DHCS (Medi-Cal Telehealth) | `dhcs.ca.gov/provgovpart/Pages/Telehealth.aspx` | HTML diff | Daily |
| DEA Diversion — Press Releases | `deadiversion.usdoj.gov/press-releases/index.html` | HTML diff | Daily |
| CURES (CA PDMP updates) | `dhcs.ca.gov/individuals/Pages/CURES.aspx` | HTML diff | Weekly |
| OCR Resolution Agreements | `hhs.gov/ocr/news-new/index.html` | HTML diff | Daily |
| Cal/OSHA (employer obligations) | `dir.ca.gov/dosh/dosh_publications.html` | HTML diff | Weekly |
| SAMHSA Telehealth | `samhsa.gov/telehealth` | HTML diff | Weekly |

### Payer & Industry Sources (AI-03) — Recommended 8 sources

| Source | URL/Access Method | Format | Polling |
|--------|------------------|--------|---------|
| CMS MLN Connects Newsletter | `cms.gov/training-education/medicare-learning-network/newsletter` | HTML diff | Weekly |
| Medi-Cal Provider Bulletins | `medi-cal.ca.gov/provider_/Pages/communications.aspx` | HTML diff | Weekly |
| Medi-Cal Rx Monthly Bulletin | `medi-calrx.dhcs.ca.gov/cms/medicalrx/static-assets/documents/provider/publications/` | HTML diff | Monthly |
| Aetna Provider News | `aetna.com/health-care-professionals/news.html` | HTML diff | Weekly |
| Anthem Blue Cross Provider Updates | `anthem.com/provider/noapplication/f4/s0/t0/pw_g374052.htm` | HTML diff | Weekly |
| United Healthcare Provider Bulletin | `uhcprovider.com/en/resource-library/news.html` | HTML diff | Weekly |
| MGMA Payer Policy | (Email newsletter via n8n email-to-webhook bridge; MGMA free membership) | Email | As-sent |
| APA Practice Updates | `psychiatry.org/psychiatrists/practice/practice-management` | HTML diff | Weekly |

### Software Platform Sources (AI-04) — 8 platforms

| Platform | Source | Format | Polling |
|----------|--------|--------|---------|
| Supabase | `github.com/supabase/supabase/releases.atom` | RSS/Atom | 6h |
| n8n | `github.com/n8n-io/n8n/releases.atom` | RSS/Atom | 6h |
| Tebra | `status.tebra.com` (status page) | HTML diff | Daily |
| DigitalOcean | `status.digitalocean.com/feed` | RSS | 6h |
| 1Password | `1password.com/blog/category/security` | HTML diff | Weekly |
| SendGrid | `status.sendgrid.com/history.rss` | RSS | Daily |
| Google Workspace | `workspace.google.com/whatsnew/` | HTML diff | Weekly |
| TouchDesigner | `derivative.ca/category/release/` | HTML diff | Weekly |

---

## LLM Model Recommendation (Claude's Discretion — Recommended)

Based on cost analysis from research:

| Use Case | Recommended Model | Why | Est. Monthly Cost |
|----------|------------------|-----|-------------------|
| Relevance filtering (AI-02, AI-03, AI-04) | GPT-4o-mini | $0.15/$0.60 per 1M tokens; sufficient for binary classification | < $2/month at 20 sources × 30 days |
| Full impact analysis (high-urgency items only) | GPT-4o-mini | Most relevant items need structured analysis, not creative reasoning | < $1/month (few high-urgency items) |
| Form pre-fill field mapping (AI-01) | GPT-4o | Nuanced semantic matching between vault fields and form field names; higher accuracy justifies cost | < $5/month (infrequent, on-demand) |
| Weekly digest summarization | GPT-4o-mini | Summarization, not reasoning | < $1/month |

**Total estimated LLM cost: < $10/month** for a solo practice with the above source list and polling frequencies.

---

## New Supabase Tables Required for Phase 5

These tables do not yet exist. Phase 5 Wave 0 must create them before monitoring workflows can be tested.

| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `monitoring_alerts` | All detected regulatory/payer/software alerts (one row per unique item) | `id`, `source_url`, `item_guid`, `category`, `relevant`, `urgency`, `summary`, `practice_impact`, `suggested_action`, `deadline`, `alert_sent`, `digest_sent`, `obligation_id`, `created_at` |
| `monitoring_sources` | Registry of all monitored sources with metadata | `id`, `label`, `url`, `format` (rss/html_diff), `category`, `poll_interval_hours`, `last_checked_at`, `last_changed_at`, `content_hash`, `active` |
| `form_prefill_jobs` | Log of form pre-fill generation jobs | `id`, `target_form`, `triggered_by`, `triggered_at`, `status`, `output_url`, `green_count`, `yellow_count`, `red_count`, `completed_at` |
| `form_field_mappings` | Static mapping of credential vault fields to target form fields | `id`, `target_form`, `form_field_name`, `form_field_label`, `vault_table`, `vault_field`, `transform_hint`, `last_updated` |

The existing `obligations` table (Phase 4 DDL) already has the right shape for auto-created draft obligations. No changes needed.

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Manual RSS reader (Feedly) | n8n RSS Read + LLM filter | 2024-2025 | Automated relevance scoring replaces human reading time |
| Custom Python monitoring scripts | n8n workflow templates | 2023+ | Visual workflow editor, no code deployment, built-in retry |
| Single LLM model for all tasks | Model tiering (mini for filter, full for analysis) | 2024 | 80% cost reduction by right-sizing models to task complexity |
| CAQH manual re-attestation | CAQH automation accounts (for authorized orgs) | Ongoing | Solo practices not typically authorized — Tier 1 document still primary path |
| Web scraping for all sources | RSS-first, HTML diff as fallback | 2023+ | RSS is more reliable, lower bandwidth, less likely to break on site redesigns |

**Deprecated/outdated:**
- Webhook-based browser automation of CAQH without authorization: ToS prohibits this; spec must flag it explicitly
- n8n Cloud for PHI-touching workflows: No BAA available; self-hosted only (already established in Phase 4)

---

## Open Questions

1. **CAQH Automation Account Authorization**
   - What we know: CAQH's ToS prohibits unauthorized automation. CAQH does offer automation accounts for participating organizations.
   - What's unclear: Whether a solo practice (not a payer or credentialing organization) can obtain an automation account.
   - Recommendation: Spec must note this constraint. Tier 2 for CAQH is "spec if authorized — default to Tier 1." Maxi should contact CAQH (caqh.org/support) to investigate automation account eligibility before developer begins Tier 2.

2. **Per-Payer Portal Accessibility Without Authentication**
   - What we know: Most payer provider bulletin pages are publicly accessible without login.
   - What's unclear: Aetna, Anthem, UHC specifically — some provider resources require portal login even for bulletin pages.
   - Recommendation: Spec should note that HTML-diff monitoring applies only to publicly accessible pages. If a payer's bulletin page requires portal login, spec it as "monitor via email newsletter subscription forwarded to n8n via email trigger" (secondary monitoring method).

3. **Federal Register API Rate Limits**
   - What we know: Federal Register has a public REST API at `federalregister.gov/developers/documentation/api/v1`. RSS feeds exist per agency.
   - What's unclear: Whether rate limits apply to unauthenticated RSS polling at 6-hour intervals.
   - Recommendation: Use the free API key option (federalregister.gov allows key registration for higher rate limits). Spec this as a setup step. At 4 polls/day × 3 agencies = 12 requests/day — well within typical rate limits.

4. **Form Field Schema Source for CAQH**
   - What we know: CAQH ProView has 40+ sections in the re-attestation form. The vault `credentials` table has 44+ columns.
   - What's unclear: The exact field-by-field mapping from CAQH form sections to vault columns needs to be manually created once by reading the CAQH Provider User Guide (version 43, linked in research).
   - Recommendation: Phase 5 spec must include a CAQH field mapping table as an appendix deliverable (not discovered by AI — manually authored by the spec writer using the CAQH user guide PDF).

---

## Validation Architecture

> Skipped — `workflow.nyquist_validation` not present in `.planning/config.json`. This phase produces a specification document, not code. No test infrastructure required.

---

## Sources

### Primary (HIGH confidence)
- n8n-io/n8n-docs (Context7 `/n8n-io/n8n-docs`) — RSS Read node, AI Agent node, Structured Output Parser, Loop Over Items, OpenAI node, Schedule Trigger patterns
- CAQH Terms of Service — `caqh.org/solutions/caqh-pdp-terms-service` — confirmed prohibition on unauthorized automation software
- Federal Register RSS API — `federalregister.gov/reader-aids/developer-resources/rest-api` — confirmed per-agency RSS feed URL pattern
- Phase 4 Research + n8n Architecture Research — existing in `.planning/phases/04-dashboard-spec/` — confirmed existing n8n + Supabase stack; `obligations` and `automation_log` tables; HIPAA handling patterns

### Secondary (MEDIUM confidence)
- WebSearch confirmed: CMS MLN Connects newsletter at `cms.gov/training-education/medicare-learning-network/newsletter` — published weekly; no direct RSS but page is HTML-diff-able
- WebSearch confirmed: CA Medical Board subscription page at `mbc.ca.gov/subscribe` — email-based (no RSS); HTML diff of news page is fallback
- WebSearch confirmed: GPT-4o-mini pricing at $0.15/$0.60 per 1M tokens (input/output) — current as of 2026-03-01
- WebSearch confirmed: n8n community Playwright node exists (`n8n-nodes-playwright` on npm) — active GitHub repo, functional for form automation
- OpenAI Structured Outputs — `platform.openai.com/docs/guides/structured-outputs` — confirmed `json_object` response format guarantees valid JSON

### Tertiary (LOW confidence)
- Specific per-payer portal bulletin page URLs (Aetna, Anthem, UHC): inferred from public provider portal research but specific URLs need developer verification during Wave 0 — pages may require portal login
- MGMA free membership access for listserv/alerts: assumed based on MGMA's general membership model; needs verification

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — n8n + Supabase is already established; OpenAI node is native n8n; RSS patterns confirmed in Context7
- Architecture: HIGH — three-workflow-group structure follows Phase 4 patterns; monitoring_alerts table design is standard
- CAQH ToS constraint: HIGH — directly confirmed in ToS text
- Source list: MEDIUM — RSS URL formats confirmed for Federal Register; per-payer portal accessibility needs developer verification
- Cost estimates: MEDIUM — based on current pricing which may change; directionally correct for a solo practice volume
- LLM model recommendations: HIGH — pricing confirmed, capability at task sufficient by established benchmarks

**Research date:** 2026-03-01
**Valid until:** 2026-06-01 (n8n architecture is stable; OpenAI pricing changes periodically — recheck before implementation; Federal Register API stable)
