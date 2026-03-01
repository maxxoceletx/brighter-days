# Phase 4: Dashboard Command Center Specification - Research

**Researched:** 2026-03-01
**Domain:** TouchDesigner dashboard, Tebra API integration, n8n automation, ASCII art animation, Supabase connectivity
**Confidence:** MEDIUM (TouchDesigner patterns HIGH; Tebra API MEDIUM — full method list inaccessible in PDF; Keragon fallback HIGH)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Panel Layout & Density:**
- Home screen is today's overview (morning briefing format): appointments, overdue obligations, compliance status summary, recent billing activity
- Dense layout: 6-8 panels visible simultaneously — stock trading terminal / NASA mission control aesthetic
- Display target: single external monitor 24-32 inches, designed for 2560x1440 or 3840x2160
- ASCII art is animated, dynamic, art installation feel — not static retro terminal. Animation IS the aesthetic: spinning indicators, scrolling banners, animated borders, flowing characters. Spec must describe animation behaviors for each panel (idle/loading/alert/interaction states)

**Action Buttons (all four enabled):**
- Send patient communications (intake packets, reminders, consent forms)
- Run CAQH re-attestation check (one-click workflow)
- Generate compliance reports (current-state snapshot for audits)
- Trigger payer status checks (credentialing status across portals)
- Confirmation behavior: tiered — no confirm for read/generate/refresh; confirm required for send/submit/external writes
- Status feedback: inline badges AND dedicated automation history panel (DASH-08)

**Tebra Write Access:** Defer to research (design baseline as read-only; stretch goal read+limited-write)

**Data Integration:**
- Appointments and billing are equally important — show side by side
- Data freshness: every 15-30 minutes
- Three-tier fallback: Tier 1 (Tebra API direct), Tier 2 (Tebra CSV export + auto-import), Tier 3 (manual data entry panels)
- PHI on dashboard: first name + appointment time only (e.g., "Alex at 2:00 PM"). No full names, no diagnoses, no clinical notes. Aggregates only for billing — no patient-level billing detail

**Calendar Model:**
- Primary: countdown list sorted by urgency ("X days until [obligation]") — green/yellow/red/pulsing red
- Secondary: monthly calendar grid (toggle), click date to see what's due
- Scope: compliance + operations obligations (not patient-level tasks)
- Overdue escalation: persistent red banner (undismissable until resolved), pulsing ASCII art, optional audio alert (configurable, chime type selectable)
- Interactivity: users can mark complete, snooze, add notes; automations can auto-mark complete

### Claude's Discretion

None specified — all major decisions were locked during discuss-phase.

### Deferred Ideas (OUT OF SCOPE)

None captured during discussion — all suggestions stayed within Phase 4 scope.
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| DASH-01 | TouchDesigner-based practice command center — central node for all practice operations, real-time visual interface | Architecture patterns section covers TD node structure, Container COMP layout, Window COMP for external monitor |
| DASH-02 | Compliance status panel with visual indicators (green/yellow/red) for all licenses, certs, BAAs, and CAQH status | Alert architecture spec from Phase 2 defines exact color mapping from `credential_alert_queue` view |
| DASH-03 | Running obligations checklist — interactive list of everything to do, with status and priority | Supabase `compliance_items` + `payer_tracker` tables defined in Phase 1/2; countdown timer pattern researched |
| DASH-04 | Compliance and operations calendar — deadlines, renewals, CAQH attestation windows, filing dates | Calendar model locked (countdown primary + grid secondary); data source is same Supabase views |
| DASH-05 | Tebra API integration pulling appointment and billing data into dashboard | Three-tier fallback researched: SOAP API (read+write), CSV export (Tier 2), manual panels (Tier 3); Keragon as HIPAA-native middleware |
| DASH-06 | Billing oversight view showing claims submitted, denials, AR aging from Tebra data | Billing data accessible via Tebra SOAP API (GetTransactions, charges/payments); PHI scope defined (aggregates only) |
| DASH-07 | Functional action buttons — send emails, trigger automations, submit forms from dashboard | Button COMP → Web Client DAT POST → n8n webhook pattern researched; confirmation tier defined |
| DASH-08 | Automation process tracker — visual status of running/completed automations | Automation log written to Supabase `automation_log` table; TD polls and renders ASCII history panel |
</phase_requirements>

---

## Summary

Phase 4 produces a specification document — not working code. The spec must be complete enough for a TouchDesigner developer to build the dashboard without further discovery. The research reveals five technically distinct domains: (1) TouchDesigner dashboard architecture, (2) Tebra API data access, (3) ASCII art animation techniques, (4) audio notification implementation, and (5) the button-to-automation pipeline via n8n.

The biggest technical unknown — Tebra API capabilities — is now substantially resolved. Tebra's SOAP API (accessed via customer key + username/password) supports read AND write for appointments, patients, charges, and transactions. This means Tier 1 (direct API integration) is feasible for appointment display and billing oversight. The n8n architecture research document already in the repository correctly identifies the integration pattern: TouchDesigner polls Supabase via Timer CHOP + Web Client DAT; n8n handles all external API calls and writes data to Supabase as a shared data layer.

For the animated ASCII art aesthetic, TouchDesigner has a robust native toolkit: Text TOP renders monospace fonts at any resolution, Pattern CHOP drives character animation, and existing community examples (including a "Severance-inspired" ASCII effect) confirm this aesthetic is well-trodden in the TD community. The planner does not need to invent patterns — they need to specify the desired states per panel and reference documented TD techniques.

**Primary recommendation:** Spec the dashboard as a Supabase-mediated architecture. TouchDesigner reads exclusively from Supabase (never calling Tebra, CAQH, or external services directly). n8n handles all external API calls, data normalization, and writes to Supabase. This clean separation makes the TD spec provider-agnostic — if Tebra changes their API, only the n8n workflows change.

---

## Standard Stack

### Core
| Component | Version/Detail | Purpose | Why Standard |
|-----------|---------------|---------|--------------|
| TouchDesigner | 2023.11340+ (latest stable) | Dashboard rendering, UI, animation | Platform decision locked in prior phases; desktop app, macOS/Windows |
| Supabase | Existing Brighter Days project | Shared data layer between TD and n8n | Already established in Phase 1/2; REST API accessible from TD Python |
| n8n (self-hosted) | Community Edition, free | Automation backbone: Tebra polling, alert emails, webhook handling | Architecture researched in Phase 2; DigitalOcean droplet at 178.128.12.34 |
| Tebra SOAP API | v1 (legacy, stable) | Source of appointment and billing data | Only production API surface with full read+write access |

### Supporting
| Component | Version/Detail | Purpose | When to Use |
|-----------|--------------|---------|-------------|
| Keragon | Cloud, HIPAA-native | HIPAA-compliant Tebra middleware | If direct SOAP API proves too complex; Keragon signs BAA, has 18 Tebra actions including appointments, charges, transactions |
| Web Client DAT | Built-in TD operator | TD → Supabase REST or TD → n8n webhook HTTP calls | All outbound HTTP from TouchDesigner |
| Timer CHOP | Built-in TD operator | Drives periodic polling (15-30 min refresh cycle) | Any timed event in TouchDesigner |
| Audio Play CHOP | Built-in TD operator | Configurable audio alerts for overdue items | Audio notifications |
| Text TOP | Built-in TD operator | ASCII and monospace text rendering | All text display in ASCII aesthetic |
| Button COMP | Built-in TD operator | Interactive action buttons on dashboard | User-triggered actions |
| Container COMP | Built-in TD operator | Panel layout and grouping | Multi-panel dashboard organization |
| Window COMP | Built-in TD operator | External monitor output at target resolution | Dedicated display on second monitor |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Tebra SOAP API | Tebra FHIR API (via SmileCDR) | FHIR is cleaner/modern but requires separate SmileCDR registration with additional T&Cs; SOAP is simpler for a solo practice |
| Self-hosted n8n | Keragon | Keragon has native BAA and 18 Tebra actions but costs more; n8n is free but no BAA (use DigitalOcean BAA + PHI-free workflow design) |
| Supabase polling from TD | WebSocket realtime from Supabase | WebSocket is more complex in TD Python; polling every 15-30 min is sufficient for this use case |

**Installation:**
TouchDesigner is a desktop application — download from derivative.ca. n8n is already researched for DigitalOcean deployment.

---

## Architecture Patterns

### Recommended Data Flow Architecture

```
External Services (Tebra, CAQH portals)
         |
         | (HTTP/SOAP — n8n handles all external calls)
         v
    n8n (DigitalOcean)
    - Polls Tebra SOAP API every 15-30 min for appointments + billing
    - Writes normalized data to Supabase
    - Handles action webhooks from TouchDesigner (button presses)
    - Sends email alerts on credential expiry
         |
         | (REST API — service role key)
         v
    Supabase (Brighter Days project)
    Tables: compliance_items, credentials, payer_tracker,
            tebra_appointments, tebra_billing_summary, automation_log
    Views: credential_alert_queue, payer_credentialing_alerts
         |
         | (REST polling via Web Client DAT, every 15-30 min)
         v
    TouchDesigner (desktop, external monitor)
    - Reads ONLY from Supabase — never calls Tebra or external APIs directly
    - Renders 6-8 panels with animated ASCII aesthetic
    - Button COMP click → Web Client DAT POST → n8n webhook URL
    - n8n writes result back to automation_log → TD re-renders
```

### Recommended Panel Layout (2560x1440 target)

```
┌─────────────────────────────────────────────────────────────────────┐
│  [OVERDUE BANNER — pulsing red ASCII border, full width]            │
│  "!!! CRITICAL: Business License BL-LIC-051057 EXPIRED 61 DAYS !!!" │
├──────────────────────┬──────────────────────┬───────────────────────┤
│  PANEL 1: TODAY      │  PANEL 2: COMPLIANCE │  PANEL 3: CREDENTIALS │
│  Morning Briefing    │  Status Panel        │  Expiry Tracker       │
│  - Appts today       │  - License: GREEN    │  Countdown list       │
│  - Overdue items     │  - DEA: GREEN        │  sorted by urgency    │
│  - Billing summary   │  - CAQH: YELLOW      │  X days until [item]  │
│  - Animated spinner  │  - BAAs: GREEN       │  Pulsing on overdue   │
│  ASCII art header    │  - Biz Lic: RED !!!  │                       │
├──────────────────────┼──────────────────────┼───────────────────────┤
│  PANEL 4: CALENDAR   │  PANEL 5: APPOINTS   │  PANEL 6: BILLING     │
│  Obligation View     │  Today's Schedule    │  Oversight View       │
│  [countdown/grid]    │  (PHI: first name    │  Claims submitted     │
│  Toggle: list/grid   │  + time only)        │  Denials count        │
│  Click date = detail │  15-30 min refresh   │  AR aging buckets     │
├──────────────────────┴──────────────────────┴───────────────────────┤
│  PANEL 7: ACTIONS (buttons row)    │  PANEL 8: AUTOMATION TRACKER   │
│  [CAQH CHECK] [COMPLIANCE REPORT]  │  Running/Done/Failed log       │
│  [PAYER STATUS] [SEND COMMS]       │  Timestamps + expandable log   │
│  Inline status badges per button   │  Scrolling ASCII history       │
└────────────────────────────────────┴────────────────────────────────┘
```

### Pattern 1: Supabase REST Polling from TouchDesigner

**What:** Timer CHOP fires every N seconds, triggering a Web Client DAT to GET Supabase REST endpoint. Python parses JSON and feeds data into display operators.

**When to use:** All dashboard data refresh — compliance status, appointments, billing, automation log.

```python
# Source: TouchDesigner forum (forum.derivative.ca/t/data-update-part-in-webclient-operator/346336)
# In Timer CHOP callback DAT — onCycle() fires every N seconds:
def onCycle(timerOp, segment, interrupt):
    # Trigger new request on Web Client DAT
    op('webClient_supabase').par.request.pulse()
    return

# In Web Client DAT callback — onReceiveResponse():
def onReceiveResponse(webClientDAT, statusCode, headerDict, data, id):
    import json
    if statusCode == 200:
        rows = json.loads(data)
        # Write to Table DAT for downstream operators
        tbl = op('table_compliance')
        tbl.clear()
        for row in rows:
            tbl.appendRow([row['credential_name'], row['alert_level'], row['days_until_expiry']])
    return
```

**Timer CHOP configuration:**
- Mode: Loop
- Cycle: enabled
- Cycle Limit: disabled
- Length (seconds): 900 (15 min) or 1800 (30 min) — user configurable

### Pattern 2: Button → Webhook → n8n → Result

**What:** Button COMP press triggers a Web Client DAT POST to n8n webhook URL. n8n performs the action (CAQH check, send email, etc.), writes result to Supabase `automation_log`. TD polls `automation_log` and renders the result.

**When to use:** All action buttons (DASH-07, DASH-08).

```python
# Source: TouchDesigner documentation (docs.derivative.ca/Web_Client_DAT)
# In Button COMP Panel Execute DAT — onValueChange():
def onValueChange(panelValue):
    if panelValue.val == 1:  # Button pressed
        # Confirm dialog for destructive actions
        # For non-destructive: trigger directly
        webClient = op('webClient_n8n_action')
        webClient.par.method = 'POST'
        webClient.par.url = 'https://n8n.example.com/webhook/caqh-check'
        import json
        body = json.dumps({'action': 'caqh_recheck', 'triggered_by': 'dashboard'})
        # Feed body via DAT input
        op('text_action_body').text = body
        webClient.par.request.pulse()
    return
```

**Inline button state tracking:**
```
Button state machine: IDLE → RUNNING → (DONE | FAILED)
- IDLE: green ascii bracket [ CAQH CHECK ]
- RUNNING: spinning ascii indicator [ CAQH CHECK ... ]
- DONE: green checkmark indicator [ CAQH CHECK OK ]
- FAILED: red X indicator [ CAQH CHECK ERR ]
State driven by latest row in automation_log matching action type
```

### Pattern 3: ASCII Art Animation in TouchDesigner

**What:** Text TOP renders monospace (terminal-style) fonts. Pattern CHOP / Noise CHOP drive animated parameters. Lookup TOP maps grayscale values to ASCII character sets.

**When to use:** All visual elements in the ASCII aesthetic.

**Confirmed TD operators for ASCII aesthetic:**
- `Text TOP` — renders monospace text with CHOP-driven position, color, and content parameters
- `Pattern CHOP` — generates waveforms driving animation (spinning indicators, scrolling text speed)
- `Noise CHOP` — organic variation in animation (flowing character effects)
- `Lookup TOP` — maps pixel values to ASCII character texture atlas
- `Replicator COMP` — instances text elements for character grids

**Animation states per panel (spec requirement from CONTEXT.md):**
- **Idle state:** Gentle scrolling ticker or slow breathing ASCII border animation
- **Loading state:** Spinning ASCII indicator (e.g., rotating `|/-\` character sequence)
- **Alert state:** Pulsing border at alert color (AMBER/RED), increased animation speed
- **Interaction state:** Highlighted border + status badge animation on button action

**Recommended fonts for terminal aesthetic:**
- IBM Plex Mono (free, Google Fonts)
- Courier New (system default, guaranteed available)
- Terminus (bitmap-style, clean retro look)
- Any .ttf/.otf loadable via Text TOP "Font File" parameter

### Pattern 4: Audio Alert Implementation

**What:** Audio Play CHOP plays configurable chime files triggered by Python logic when overdue conditions are detected.

```python
# Source: TouchDesigner documentation (docs.derivative.ca/Audio_Play_CHOP)
# In a DAT Execute DAT watching compliance status table:
def onTableChange(dat):
    overdue_count = 0
    for row in range(dat.numRows):
        if dat[row, 'alert_level'].val == 'EXPIRED':
            overdue_count += 1

    if overdue_count > 0 and op('toggle_audio_alerts').panel.val == 1:
        audio = op('audioPlay_alert')
        audio.par.file = op('table_settings')[0, 'chime_file'].val  # user-configurable
        audio.par.play.pulse()
    return
```

**Configuration UI:** A settings panel (toggle in PANEL 1 or overlay) exposes:
- Audio alerts: ON/OFF toggle
- Chime type: dropdown (select from 3-5 pre-loaded .wav files)
- Trigger conditions: overdue only / 7-day warning / 30-day warning

### Anti-Patterns to Avoid

- **TouchDesigner calling Tebra directly:** TD making SOAP calls adds authentication state management inside TD; use n8n as proxy, keep TD as pure display layer
- **PHI in raw form on any Supabase table that TD reads:** n8n must normalize patient data to first-name-only before writing to the `tebra_appointments` display table
- **Polling too frequently:** Under 5 minutes creates unnecessary API load; 15-30 min is specified and appropriate
- **Blocking Python in TD callbacks:** Long-running Python in TD callbacks freeze the render thread; use async Web Client DAT pattern, never block
- **Single monolithic TD network:** Organize into Container COMPs per panel for maintainability and per-panel reload capability

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| HTTP requests from TD | Custom socket code | Web Client DAT | Built-in TD operator, handles auth, methods, callbacks |
| Timed polling | Python threading | Timer CHOP + callback | TD's native timing system; Python threads conflict with TD's cook engine |
| JSON parsing | Custom string splitting | Python `import json` | Standard library, available in TD's Python environment |
| SOAP envelope construction | Custom XML builder | n8n HTTP Request node with Tebra preset | n8n handles SOAP envelope, auth header, response parsing |
| Email delivery | SMTP code | n8n SendGrid/email node | n8n handles retries, formatting, auth |
| Audio file management | Custom audio system | Audio Play CHOP | Built-in TD operator, supports .wav/.mp3/.aif |
| External monitor output | Custom window management | Window COMP | TD native multi-monitor support with resolution parameter |
| Supabase realtime WebSocket | Custom WebSocket client in Python | REST polling via Web Client DAT | Simpler, sufficient for 15-30 min refresh; WebSocket in TD Python is significantly more complex |

**Key insight:** TouchDesigner is a visual programming environment, not a Python application. The vast majority of functionality — timing, HTTP, audio, rendering, layout — has native operators. Custom Python should only appear in callbacks, data transformation, and business logic; never in system-level concerns.

---

## Common Pitfalls

### Pitfall 1: PHI Leakage via Tebra Data
**What goes wrong:** n8n pulls appointment data from Tebra including full patient name, DOB, diagnosis code and writes it all to Supabase. TouchDesigner renders it. This is a HIPAA violation if the external monitor is visible to unauthorized persons.
**Why it happens:** Forgetting to apply the PHI scope filter at the n8n normalization step.
**How to avoid:** n8n data transformation step MUST strip all PHI before writing to `tebra_appointments` display table. Only write: `appointment_id`, `first_name_only`, `appointment_time`, `appointment_type` (generic). Never write last name, DOB, insurance info, or any clinical data.
**Warning signs:** Supabase `tebra_appointments` table contains a field called `patient_last_name` or `dob`.

### Pitfall 2: CAQH `expiry_date` Is NULL (Pre-Launch Blocker)
**What goes wrong:** Dashboard shows CAQH as "green" (no data = no alert). In reality, CAQH status is unknown because the last attestation date was never entered.
**Why it happens:** Phase 2 left `expiry_date = NULL` in credentials table pending Valentina's verification.
**How to avoid:** Spec must flag this as a pre-launch data requirement. CAQH row in dashboard should show "UNKNOWN — verify attestation date" state when expiry_date is NULL (not green).
**Warning signs:** CAQH row displays green with no expiry date shown.

### Pitfall 3: n8n Processing PHI Without BAA Coverage
**What goes wrong:** An n8n workflow pulls Tebra appointment data (containing patient names) and processes it. n8n cloud has no BAA; self-hosted n8n has DigitalOcean BAA coverage at the infra layer but n8n itself has no BAA. This is a HIPAA gray area.
**Why it happens:** Tebra data retrieval is the obvious place to use n8n, but PHI in workflow data is the risk.
**How to avoid:** Two options: (A) Design n8n to be a passthrough — pull from Tebra, strip PHI immediately, write only de-identified data to Supabase. Never store raw PHI in n8n execution logs (disable via `EXECUTIONS_DATA_SAVE_ON_SUCCESS=false`). (B) Use Keragon instead of n8n for any workflow that touches patient names — Keragon has a full BAA.
**Warning signs:** n8n execution history shows patient full names in workflow data.

### Pitfall 4: TouchDesigner Cook Engine Blocking
**What goes wrong:** A Python callback runs a long synchronous operation (like waiting for an HTTP response). The entire TD network stops cooking (rendering freezes) until the operation completes.
**Why it happens:** TouchDesigner's cook engine runs on the main thread. Synchronous Python blocks it.
**How to avoid:** Use Web Client DAT's async request model — trigger the request, return immediately from the callback, handle the response in `onReceiveResponse` callback (called when response arrives). Never `time.sleep()` or synchronous wait in TD Python.
**Warning signs:** Dashboard visually "freezes" for 1-5 seconds periodically.

### Pitfall 5: Tebra SOAP Auth Customer Key Exposure
**What goes wrong:** Customer key (a Tebra-specific auth token) is hardcoded in the n8n workflow configuration or stored in plaintext in a TD Python DAT.
**Why it happens:** Quick setup, "I'll secure it later."
**How to avoid:** Store customer key in n8n's encrypted credential vault. TD should never hold the customer key — TD calls n8n webhook, n8n handles Tebra auth internally.
**Warning signs:** Customer key visible in a TD Text DAT or in a Supabase environment variable.

### Pitfall 6: 9 of 17 Payer Re-Credentialing Dates Are Estimated
**What goes wrong:** Dashboard shows re-credentialing countdown timers for all 17 payers as if they're confirmed. Valentina over-trusts the dates.
**Why it happens:** Phase 2 set `recred_is_estimated = true` for 9 payers with industry-norm estimates (contract_date + 3 years).
**How to avoid:** Compliance panel MUST visually distinguish estimated vs confirmed dates. Show `~` or "(est)" suffix on estimated countdowns. Spec this in the DASH-02/DASH-04 panel design explicitly.
**Warning signs:** All 17 payer re-cred dates display with identical visual treatment.

---

## Code Examples

Verified patterns from official sources:

### Supabase REST GET from TouchDesigner

```python
# Source: TouchDesigner docs (docs.derivative.ca/Web_Client_DAT) + Supabase REST docs
# Web Client DAT configuration:
# URL: https://{project-ref}.supabase.co/rest/v1/credential_alert_queue
# Method: GET
# Headers (via Table DAT input):
#   apikey: {service_role_key}
#   Authorization: Bearer {service_role_key}
#   Accept: application/json

# Response handler in Web Client callback DAT:
def onReceiveResponse(webClientDAT, statusCode, headerDict, data, id):
    import json
    if statusCode == 200:
        records = json.loads(data)
        tbl = op('table_credential_status')
        tbl.clear()
        tbl.appendRow(['credential_name', 'alert_level', 'days_until_expiry', 'display_color'])
        for r in records:
            tbl.appendRow([
                r.get('credential_name', ''),
                r.get('alert_level', 'UNKNOWN'),
                str(r.get('days_until_expiry', '')),
                r.get('display_color', 'GREEN')
            ])
```

### Timer CHOP-Driven Polling (15-30 min cycle)

```python
# Source: TouchDesigner forum (forum.derivative.ca/t/data-update-part-in-webclient-operator)
# Timer CHOP: Mode=Loop, Cycle=On, CycleLimit=Off, Length=1800 (30 min)
# Timer CHOP Callback DAT:
def onCycle(timerOp, segment, interrupt):
    # Trigger all data refresh operations
    op('webClient_credentials').par.request.pulse()
    op('webClient_appointments').par.request.pulse()
    op('webClient_billing').par.request.pulse()
    op('webClient_automation_log').par.request.pulse()
    return

def onStart(timerOp, segment, interrupt):
    # Also refresh on startup
    op('webClient_credentials').par.request.pulse()
    return
```

### Button Action → n8n Webhook

```python
# Source: TouchDesigner docs (docs.derivative.ca/Button_COMP, docs.derivative.ca/Web_Client_DAT)
# Panel Execute DAT on Button COMP:
def onValueChange(panelValue):
    if panelValue.val == 1:  # on press
        import json, time

        # Update inline button state: RUNNING
        op('text_caqh_status').par.text = '[ CAQH CHECK ... ]'
        op('null_caqh_color').par.rgb = (1.0, 0.8, 0.0)  # amber during run

        # Log to automation_log (via n8n or direct Supabase write)
        payload = json.dumps({
            'action': 'caqh_recheck',
            'triggered_at': time.strftime('%Y-%m-%dT%H:%M:%SZ'),
            'triggered_by': 'dashboard_button'
        })
        op('text_action_payload').text = payload
        op('webClient_n8n_caqh').par.request.pulse()
    return
```

### Audio Alert with Toggle Control

```python
# Source: TouchDesigner docs (docs.derivative.ca/Audio_Play_CHOP)
# In DAT Execute DAT watching compliance table changes:
def onTableChange(dat):
    audio_enabled = op('toggle_audio').panel.val  # 1=on, 0=off
    if not audio_enabled:
        return

    # Check for any EXPIRED credentials
    for row_i in range(1, dat.numRows):  # skip header
        if dat[row_i, 'alert_level'].val == 'EXPIRED':
            chime_file = op('table_settings')['chime_path', 1].val
            audio_op = op('audioPlay_alert')
            audio_op.par.file = chime_file
            audio_op.par.play.pulse()
            break  # play once per table change, not once per expired item
    return
```

### ASCII Overdue Banner Animation (Pulsing Border)

```python
# Source: TouchDesigner docs (docs.derivative.ca/Text_TOP) + community patterns
# Use Pattern CHOP (Square wave) driving text color alpha for pulsing:
# Pattern CHOP: Type=Square, Frequency=1Hz → drives op('text_banner').par.textcolora
# In a CHOP Execute DAT watching the Pattern CHOP:
def onValueChange(channel, sampleIndex, val, prev):
    if channel.name == 'chan1':  # square wave 0→1
        op('text_overdue_banner').par.textcolorr = 1.0
        op('text_overdue_banner').par.bgcolorr = val  # flashes bg red
```

---

## Tebra API Research Findings

This section is specifically for DASH-05 spec decisions.

### API Surface Summary

| API Surface | Protocol | Auth | Read | Write | Status |
|------------|----------|------|------|-------|--------|
| SOAP Web Service | SOAP/XML | Username + Password + Customer Key | Yes | Yes | Production-stable |
| FHIR API | REST/FHIR | SmileCDR registration required | Yes | Limited | Separate registration, additional T&Cs |
| Clinical Open API | REST/Swagger | TBD | Yes | Unknown | swagger at api.kareo.com/clinical/v1 |

**Confidence:** MEDIUM — SOAP API structure confirmed via help center documentation and community research; exact method signatures in PDF (inaccessible). Clinical Open API Swagger UI loaded but rendered empty in fetch.

### SOAP API Confirmed Methods (via Tebra help documentation)

**Read methods (confirmed):**
- GetAppointments — retrieve appointment data (single or bulk)
- GetPatients — patient demographics (poll every 5-10 min recommended by Tebra for sync)
- GetTransactions — charge and payment data (June 2024: GetTransaction response now includes Claim ID)
- GetEncounters — clinical encounter records
- GetCharges — service charges
- GetPayments — payment records

**Write methods (confirmed):**
- CreatePatient, UpdatePatient
- CreateAppointment, DeleteAppointment
- CreateEncounter, CreatePayment

**Authentication:** 3-field RequestHeader — `UserName`, `Password`, `CustomerKey`
- CustomerKey: generated in Tebra portal under Help → Get Customer Key (same for all users on account)
- Customer Key is a system-level API token, not per-user

**Integration polling pattern (Tebra-recommended):** Poll GetPatients every 5-10 minutes for sync. Dashboard appointment display can poll every 15-30 minutes (not all appointment data changes between minutes).

### Three-Tier Fallback (Spec Requirement)

**Tier 1 — Tebra SOAP API (Preferred):**
```
n8n HTTP Request node → Tebra SOAP endpoint
  - Method: POST
  - Auth: Username + Password + CustomerKey in SOAP RequestHeader
  - Poll: every 15-30 min via n8n Schedule trigger
  - Data: appointments (next 24 hrs), transactions (last 30 days)
  - n8n normalizes → strips PHI → writes to Supabase tebra_appointments + tebra_billing_summary
  - TD reads from Supabase only
```

**Tier 2 — Tebra Report Export (Fallback):**
```
Tebra built-in reports → CSV export
  - Appointment report: export daily as CSV
  - Billing report: export weekly as CSV (or custom report via Excel Add-in)
  - n8n watches a shared folder (Dropbox/Google Drive) for new CSV files
  - n8n parses CSV → strips PHI → writes to Supabase
  - TD reads from Supabase (same as Tier 1 — identical downstream)
  - Cost: No additional API cost; manual export required unless scheduled
```

**Tier 3 — Manual Data Entry (Last Resort):**
```
Dashboard panels 5 and 6 switch to editable mode
  - Panel 5: manual appointment entry form (provider fills daily)
  - Panel 6: manual billing numbers form (Maxi enters weekly totals)
  - Data written directly to Supabase via n8n webhook or direct Supabase write
  - Inline TD form using Button COMPs + Text COMPs as input fields
```

### HIPAA Note for Tebra Integration

n8n (self-hosted on DigitalOcean) does not sign a BAA. The DigitalOcean BAA covers the infrastructure layer. The risk: Tebra SOAP responses contain PHI (full patient names, DOBs). For HIPAA defensibility:

- Option A (recommended): n8n processes PHI as stateless passthrough — disable execution history saving (`EXECUTIONS_DATA_SAVE_ON_SUCCESS=false`), strip PHI before writing to Supabase, never store raw PHI in n8n's internal state
- Option B (higher assurance): Use Keragon instead of n8n for Tebra data pulls — Keragon signs BAA, has 9 Tebra triggers including "Appointment created/updated" and "Charge created", and has 18 Tebra actions. Cost not publicly listed (contact sales)

Spec must document both options and defer the choice to the developer based on practice's risk tolerance.

---

## New Supabase Tables Required for Phase 4

These tables do not yet exist and must be created in Wave 0 of Phase 4 execution:

| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `tebra_appointments` | Normalized appointment display (PHI-stripped) | `appointment_id`, `first_name_only`, `appointment_time`, `appointment_type`, `synced_at` |
| `tebra_billing_summary` | Aggregated billing data (no patient-level detail) | `period`, `claims_submitted`, `claims_denied`, `ar_current`, `ar_30`, `ar_60`, `ar_90plus`, `synced_at` |
| `automation_log` | History of all dashboard-triggered automations | `id`, `action_type`, `triggered_at`, `triggered_by`, `status`, `details`, `completed_at` |
| `dashboard_settings` | Configurable dashboard preferences | `key`, `value` (audio_enabled, chime_type, refresh_interval_seconds) |
| `obligations` | Compliance + operations obligations for DASH-03/04 | `id`, `title`, `obligation_type`, `due_date`, `status`, `notes`, `snoozed_until`, `completed_at`, `auto_completable` |

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Kareo (legacy brand) | Tebra (rebranded) | 2022 Kareo + PatientPop merger | API docs use "Kareo" internally; same endpoints |
| Web DAT (older TD) | Web Client DAT | TouchDesigner 2022+ | Web Client DAT is the current HTTP operator; Web DAT is older |
| Static text rendering | Slug Font Rendering Library in Text COMP | TouchDesigner 2023 | Resolution-independent GPU text; use Text TOP for ASCII aesthetic (simpler) |
| n8n Cloud (no BAA) | Self-hosted n8n on DO with DO BAA | Ongoing | Only path to any BAA coverage with n8n |

**Deprecated/outdated:**
- Web DAT: Older version of HTTP request operator; use Web Client DAT
- Kareo API references: Same as Tebra; API endpoint domain may still be kareo.com (api.kareo.com/clinical/v1/)

---

## Open Questions

1. **Tebra SOAP API exact endpoint URL and WSDL location**
   - What we know: Authentication uses Username + Password + CustomerKey; methods include GetAppointments, GetTransactions
   - What's unclear: The exact WSDL URL, whether api.kareo.com or a Tebra-specific domain is used for the SOAP endpoint
   - Recommendation: Developer must retrieve Customer Key from Tebra portal and locate WSDL via the API Integration Technical Guide PDF; spec should note this as a setup step

2. **Tebra SOAP rate limits**
   - What we know: No published rate limit found in documentation or community sources
   - What's unclear: Whether high-frequency polling (every 5-10 min as Tebra recommends) triggers throttling
   - Recommendation: Spec Tier 1 with 15-30 min polling (lower than Tebra's max recommendation); this is safe for a solo practice with low appointment volume

3. **Keragon pricing**
   - What we know: Keragon signs BAA, has 18 Tebra actions, has "contact sales" pricing model
   - What's unclear: Actual monthly cost
   - Recommendation: Spec Tier 1 as n8n (free) with Keragon as documented alternative; note developer should request Keragon pricing if PHI-in-workflow is a concern

4. **TouchDesigner on macOS vs Windows**
   - What we know: Valentina is likely running macOS (Maxi's environment is macOS M4). Audio Device Out CHOP uses CoreAudio on macOS (vs DirectSound on Windows per Audio Play CHOP docs)
   - What's unclear: Whether the dashboard will run on Valentina's Mac or a dedicated display Mac Mini
   - Recommendation: Spec must note macOS audio path (CoreAudio) and any macOS-specific TD considerations; Audio Play CHOP supports both platforms

5. **Dashboard persistence / always-on behavior**
   - What we know: CONTEXT.md assumes dedicated display, likely always-on
   - What's unclear: What happens when Valentina's computer sleeps or reboots — does TD auto-restart?
   - Recommendation: Spec should include a note on TD startup behavior and recommend a system startup script or macOS Login Items entry for auto-launch

---

## Sources

### Primary (HIGH confidence)
- `docs.derivative.ca/Web_Client_DAT` — Confirmed Web Client DAT supports GET/POST/PUT/DELETE, OAuth, streaming, callback pattern
- `docs.derivative.ca/Text_TOP` — Confirmed Text TOP supports monospace fonts, CHOP-driven animation parameters, custom .ttf fonts
- `docs.derivative.ca/Audio_Play_CHOP` — Confirmed Audio Play CHOP supports .wav/.mp3/.aif, Python trigger via `play()`, Mode parameter for on/off
- `docs.derivative.ca/Button_COMP` — Confirmed Button COMP with Panel Execute DAT callback for click events
- `derivative.ca` Timer CHOP + Web Client DAT polling pattern — confirmed by forum discussion (forum.derivative.ca/t/data-update-part-in-webclient-operator/346336)
- Phase 2 artifact: `.planning/phases/02-credential-vault-monitoring/alert-architecture.md` — Definitive data model, Supabase views, color mapping, HIPAA edge cases
- Phase 2 artifact: `.planning/phases/04-dashboard-spec/n8n-architecture-research.md` — n8n + TD + Supabase integration architecture confirmed

### Secondary (MEDIUM confidence)
- `helpme.tebra.com/Tebra_PM/12_API_and_Integration` — Tebra SOAP API overview; confirmed authentication (3-field: Username + Password + CustomerKey), confirmed read+write capability for appointments/patients/transactions
- `keragon.com/integrations/kareo` — Confirmed Keragon has 9 Tebra triggers + 18 actions, BAA on all plans, SOC2 Type II; pricing not published
- TouchDesigner ASCII art community resources: `alltd.org/ascii-art-in-touchdesigner/`, `github.com/FollowTheDarkside/td-ascii-effect`, Severance ASCII tutorial at `derivative.ca/community-post/tutorial/severance-inspired-ascii-text-effect/71502`

### Tertiary (LOW confidence)
- Tebra SOAP specific method signatures (GetAppointments response fields, rate limits): API technical guide PDF was binary and unreadable; inferred from help center overview and community sources
- Tebra FHIR API specifics: SmileCDR partnership mentioned; separate registration required; details inaccessible without registration

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — TouchDesigner operators confirmed via official docs; n8n + Supabase architecture confirmed via Phase 2 research
- Architecture: HIGH — Supabase-mediated pattern is well-documented and aligns with Phase 2 alert architecture spec
- Tebra API: MEDIUM — SOAP API confirmed (auth, read+write, key methods); exact WSDL/endpoint URLs and rate limits not independently verified
- ASCII animation patterns: HIGH — multiple community implementations confirmed; Severance-style ASCII effect is a documented TD tutorial
- Audio: HIGH — Audio Play CHOP fully documented in official TD docs
- Pitfalls: HIGH — PHI leakage, CAQH NULL date, and cook engine blocking are all documented in Phase 2 artifacts and official TD sources

**Research date:** 2026-03-01
**Valid until:** 2026-06-01 (Tebra API stable; TD major versions release ~2x/year; 90-day validity)
