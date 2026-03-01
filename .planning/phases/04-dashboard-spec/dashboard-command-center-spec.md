# Brighter Days Practice Command Center — TouchDesigner Dashboard Specification

**Version:** 1.0
**Date:** 2026-03-01
**Phase:** 4 (Dashboard Specification)
**For:** TouchDesigner developer building the Brighter Days practice command center
**Practice:** Valentina Park MD, Professional Corporation

---

## How to Read This Document

This specification is the single source of truth for building the Brighter Days dashboard. A developer reading this document from start to finish should be able to build the full TouchDesigner project without further discovery or questions.

- **Sections 1–3:** Full system architecture, TD network hierarchy, and ASCII aesthetic rules. Read these first. Every panel section (4–9) assumes you have read Sections 1–3.
- **Sections 4–5 (this document):** Panel 1 (Today/Morning Briefing) and Panel 2 (Compliance Status) — covered in Plan 01.
- **Sections 6–7 (Plan 02):** Panel 3 (Credentials/Obligations), Panel 4 (Calendar), Panel 5 (Appointments), Panel 6 (Billing).
- **Sections 8–9 (Plan 03):** Panel 7 (Actions), Panel 8 (Automation Tracker), Overdue Banner behavior, Supabase table DDL, startup/persistence notes.

---

## Section 1: Overview and Architecture

### 1.1 Purpose

The Brighter Days Dashboard Command Center is a TouchDesigner-based practice management display that gives Dr. Valentina Park a single-screen situational awareness view of all compliance, billing, credential, and operational obligations for her solo telehealth psychiatry practice.

This is NOT a web application. This is a TouchDesigner desktop application running on macOS, outputting to a dedicated external monitor (24–32 inches, 2560×1440 or 3840×2160 resolution). The aesthetic is animated ASCII art — dense, dynamic, terminal-style — inspired by stock trading terminals and NASA mission control. The animation IS the design language: panels breathe, alerts pulse, data flows.

**Primary user:** Dr. Valentina Park (Valentina). She opens the dashboard each morning and sees the full state of her practice in one view.

### 1.2 System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│   External Services                                                          │
│   ┌──────────────┐  ┌──────────────┐  ┌────────────────┐  ┌──────────────┐ │
│   │  Tebra EHR   │  │  CAQH Portal │  │  Payer Portals │  │  Google Wksp │ │
│   │  SOAP API    │  │  proview.caqh│  │  (17 payers)   │  │  Email/Cal   │ │
│   └──────┬───────┘  └──────┬───────┘  └───────┬────────┘  └──────┬───────┘ │
└──────────┼────────────────┼───────────────────┼──────────────────┼──────────┘
           │                │                   │                  │
           └────────────────┴───────────────────┴──────────────────┘
                                      │
                              HTTP/SOAP/REST
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│   n8n (self-hosted, DigitalOcean 178.128.12.34)                             │
│   - Polls Tebra SOAP API every 15–30 min (GetAppointments, GetTransactions) │
│   - Strips PHI: first name + time ONLY before writing to Supabase           │
│   - Writes normalized data to Supabase shared tables                        │
│   - Handles dashboard action webhooks (CAQH check, payer status, etc.)      │
│   - Sends email alerts daily at 7:00 AM PT for expiring credentials         │
│   - Creates/updates Google Calendar events for credential expiry dates      │
│   n8n Supabase node: REST API, service role key (stored in n8n creds vault) │
└────────────────────────────┬────────────────────────────────────────────────┘
                             │
                    REST API (service role key)
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│   Supabase (Brighter Days project — dedicated, NOT shared with FindItNOW)   │
│                                                                             │
│   Phase 1 tables:                                                           │
│     compliance_items          — audit findings, compliance status           │
│                                                                             │
│   Phase 2 tables:                                                           │
│     credentials               — credential inventory with expiry dates      │
│     payer_tracker             — 17 payer dossiers with re-cred dates        │
│                                                                             │
│   Phase 4 new tables (to be created — full DDL in Section 9):              │
│     tebra_appointments        — PHI-stripped appointment display data       │
│     tebra_billing_summary     — aggregated billing data (no patient detail) │
│     automation_log            — history of all dashboard-triggered actions  │
│     dashboard_settings        — configurable preferences (audio, refresh)   │
│     obligations               — compliance + ops obligations checklist      │
│                                                                             │
│   Phase 2 views (already exist):                                            │
│     credential_alert_queue    — computed alert levels for all credentials   │
│     payer_credentialing_alerts — urgency rankings for 17 payer re-creds     │
└────────────────────────────┬────────────────────────────────────────────────┘
                             │
              REST polling via Web Client DAT (15–30 min cycle)
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│   TouchDesigner (macOS desktop, external monitor)                           │
│   - Reads ONLY from Supabase — never calls Tebra, CAQH, or any external    │
│     service directly                                                        │
│   - Renders 8 panels with animated ASCII aesthetic                          │
│   - Button COMP click → Web Client DAT POST → n8n webhook URL              │
│   - n8n executes action, writes result to automation_log → TD re-renders   │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Critical architectural rule:** TouchDesigner is a pure display layer. It reads from Supabase and sends webhook calls to n8n. It never authenticates with or calls external services (Tebra, CAQH, payer portals) directly. If the n8n layer changes (e.g., Tebra changes their API), no TouchDesigner code changes.

### 1.3 New Supabase Tables for Phase 4

These five tables do not yet exist and must be created before the dashboard can be built. Full DDL with column types, indexes, and seed data is in Section 9 (Plan 03). Summary here for reference:

| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `tebra_appointments` | PHI-stripped appointment display (n8n writes, TD reads) | `appointment_id`, `first_name_only`, `appointment_time`, `appointment_type`, `synced_at` |
| `tebra_billing_summary` | Aggregated billing snapshot (n8n writes, TD reads) | `period`, `claims_submitted`, `claims_denied`, `ar_current`, `ar_30`, `ar_60`, `ar_90plus`, `synced_at` |
| `automation_log` | History of all dashboard-triggered automations | `id`, `action_type`, `triggered_at`, `triggered_by`, `status`, `details`, `completed_at` |
| `dashboard_settings` | Key-value store for configurable preferences | `key`, `value` — keys: `audio_enabled`, `chime_type`, `refresh_interval_seconds` |
| `obligations` | Compliance + ops obligations for calendar/checklist panels | `id`, `title`, `obligation_type`, `due_date`, `status`, `notes`, `snoozed_until`, `completed_at`, `auto_completable` |

**Polling interval configuration:** The global refresh cycle is user-configurable via `dashboard_settings WHERE key='refresh_interval_seconds'`. Default: `1800` (30 minutes). Valid range: `900` (15 min) to `3600` (60 min). The Timer CHOP in `panel_grid` reads this value on startup.

### 1.4 Tebra Integration: Three-Tier Fallback

The dashboard's Tebra data access is designed with three tiers. The developer implements whichever tier is feasible:

**Tier 1 — Tebra SOAP API (Preferred):**
n8n HTTP Request node POSTs to Tebra SOAP endpoint. Auth: `UserName` + `Password` + `CustomerKey` in SOAP RequestHeader (CustomerKey from Tebra portal under Help → Get Customer Key). n8n polls GetAppointments (next 24 hrs) and GetTransactions (last 30 days) every 15–30 min, strips PHI, writes to `tebra_appointments` and `tebra_billing_summary`. Developer must locate WSDL URL from Tebra API Integration Technical Guide PDF (binary — request directly from Tebra support).

**Tier 2 — Tebra Report Export (Fallback):**
Tebra built-in reports → CSV export. n8n watches shared folder (Dropbox/Google Drive) for new CSV files, parses and strips PHI, writes to same Supabase tables. TD behavior is identical to Tier 1 downstream.

**Tier 3 — Manual Data Entry (Last Resort):**
Panels 5 and 6 switch to editable mode. Button COMPs + Text COMPs as input fields. Data written directly to Supabase via n8n webhook.

**HIPAA note for n8n + Tebra:** Self-hosted n8n on DigitalOcean has DigitalOcean BAA coverage at the infra layer but n8n itself has no BAA. Mitigation: configure `EXECUTIONS_DATA_SAVE_ON_SUCCESS=false` in n8n to prevent PHI storage in execution logs. Strip all PHI before writing to Supabase (n8n data transformation step). Alternative: use Keragon (BAA included, 18 Tebra actions, contact sales for pricing) for any workflow that touches patient names.

---

## Section 2: TouchDesigner Network Hierarchy

### 2.1 Top-Level Structure

```
Window COMP (external_monitor_output)
  └── Container COMP: dashboard_root          [full screen, 2560×1440 or 3840×2160]
        ├── Container COMP: overdue_banner     [full width top bar, hidden when no EXPIRED items]
        ├── Container COMP: panel_grid         [3-column layout below banner]
        │     ├── Container COMP: panel_today          [Panel 1 — top-left]
        │     ├── Container COMP: panel_compliance      [Panel 2 — top-center]
        │     ├── Container COMP: panel_credentials     [Panel 3 — top-right]
        │     ├── Container COMP: panel_calendar        [Panel 4 — middle-left]
        │     ├── Container COMP: panel_appointments    [Panel 5 — middle-center]
        │     ├── Container COMP: panel_billing         [Panel 6 — middle-right]
        │     ├── Container COMP: panel_actions         [Panel 7 — bottom-left + center]
        │     └── Container COMP: panel_automation      [Panel 8 — bottom-right]
        └── Container COMP: settings_overlay   [hidden by default, toggled by settings button in panel_today]
```

### 2.2 Window COMP Configuration

| Parameter | Value |
|-----------|-------|
| Output Monitor | External monitor (index 1 or 2 — whichever is the dedicated display) |
| Width | 2560 (or 3840 for 4K) |
| Height | 1440 (or 2160 for 4K) |
| Full Screen | On |
| Open on Startup | On (in Perform Mode) |
| Perform Mode Startup | Yes — enable in Edit > Preferences > General |

**macOS display note:** TouchDesigner uses macOS CoreAudio for audio (not DirectSound). If Valentina uses a Mac Mini for the dedicated display, use macOS system audio output. If running on Valentina's main Mac, configure Audio Device Out CHOP to target the correct output device.

**Auto-launch on startup:** Add TouchDesigner (or a shell script opening the .toe file) to macOS Login Items (System Settings → General → Login Items). This ensures the dashboard restores on reboot without manual intervention.

### 2.3 Grid Layout Dimensions

#### 2560×1440 Layout

```
┌─────────────────────────────────────────────────────────────────────┐  y=0
│  OVERDUE BANNER  (full width × 60px)                                │  y=0–60
├──────────────────────┬──────────────────────┬───────────────────────┤  y=60
│  PANEL 1: TODAY      │  PANEL 2: COMPLIANCE │  PANEL 3: CREDENTIALS │
│  x=0, y=60           │  x=854, y=60         │  x=1708, y=60         │
│  w=853, h=440        │  w=853, h=440         │  w=852, h=440          │
├──────────────────────┼──────────────────────┼───────────────────────┤  y=500
│  PANEL 4: CALENDAR   │  PANEL 5: APPOINTS   │  PANEL 6: BILLING     │
│  x=0, y=500          │  x=854, y=500        │  x=1708, y=500        │
│  w=853, h=440        │  w=853, h=440         │  w=852, h=440          │
├──────────────────────┴──────────────────────┼───────────────────────┤  y=940
│  PANEL 7: ACTIONS                           │  PANEL 8: AUTOMATION  │
│  x=0, y=940                                 │  x=1708, y=940        │
│  w=1707, h=500                              │  w=852, h=500          │
└─────────────────────────────────────────────┴───────────────────────┘  y=1440
```

#### 3840×2160 Layout (Scale factor: 1.5×)

All coordinates multiply by 1.5:

| Component | x | y | w | h |
|-----------|---|---|---|---|
| overdue_banner | 0 | 0 | 3840 | 90 |
| panel_today | 0 | 90 | 1279 | 660 |
| panel_compliance | 1280 | 90 | 1279 | 660 |
| panel_credentials | 2560 | 90 | 1280 | 660 |
| panel_calendar | 0 | 750 | 1279 | 660 |
| panel_appointments | 1280 | 750 | 1279 | 660 |
| panel_billing | 2560 | 750 | 1280 | 660 |
| panel_actions | 0 | 1410 | 2559 | 750 |
| panel_automation | 2560 | 1410 | 1280 | 750 |

**Implementation note:** Use a single `dashboard_settings` key `resolution` (`'2560x1440'` or `'3840x2160'`) to drive a parameter CHOP or expression that scales all Container COMP position and size parameters uniformly. This allows switching resolutions by changing one setting row in Supabase.

### 2.4 Operators Inside Each Container COMP

#### overdue_banner (full width top bar)

| Operator | Type | Purpose |
|----------|------|---------|
| `text_banner_content` | Text TOP | Renders scrolling EXPIRED credential names |
| `pattern_pulse` | Pattern CHOP | Square wave 1 Hz — drives banner background alpha for pulsing |
| `table_expired_items` | Table DAT | Receives EXPIRED rows from Web Client DAT |
| `execute_banner_visibility` | DAT Execute | Hides/shows banner based on table_expired_items row count |
| `null_banner_color` | Null CHOP | Holds current banner background color (full RED when visible) |

#### panel_grid (layout container)

| Operator | Type | Purpose |
|----------|------|---------|
| `timer_global_poll` | Timer CHOP | Master refresh cycle (reads Length from dashboard_settings) |
| `execute_timer_poll` | DAT Execute | onCycle: pulses all Web Client DATs simultaneously |
| `webClient_credentials` | Web Client DAT | GET credential_alert_queue from Supabase |
| `webClient_appointments` | Web Client DAT | GET tebra_appointments from Supabase |
| `webClient_billing` | Web Client DAT | GET tebra_billing_summary from Supabase |
| `webClient_obligations` | Web Client DAT | GET obligations from Supabase |
| `webClient_automation_log` | Web Client DAT | GET automation_log (last 20 rows) from Supabase |
| `webClient_settings` | Web Client DAT | GET dashboard_settings from Supabase |
| `table_header_credentials` | Table DAT | Holds Supabase API headers (apikey, Authorization, Accept) |

**Web Client DAT URL pattern (all data reads):**
```
Base URL: https://{project-ref}.supabase.co/rest/v1/{table_or_view_name}
Method: GET
Headers (via table_header_credentials):
  apikey: {service_role_key}
  Authorization: Bearer {service_role_key}
  Accept: application/json
Query params appended to URL as needed (e.g., ?alert_level=in.(ALERT_30,ALERT_7,EXPIRED)&order=expiry_date.asc)
```

**Timer CHOP onCycle Python (execute_timer_poll):**
```python
def onCycle(timerOp, segment, interrupt):
    op('../webClient_credentials').par.request.pulse()
    op('../webClient_appointments').par.request.pulse()
    op('../webClient_billing').par.request.pulse()
    op('../webClient_obligations').par.request.pulse()
    op('../webClient_automation_log').par.request.pulse()
    return

def onStart(timerOp, segment, interrupt):
    # Refresh immediately on dashboard open/restart
    op('../webClient_credentials').par.request.pulse()
    op('../webClient_settings').par.request.pulse()
    return
```

#### Per-Panel Shared Operator Set

Every panel_* Container COMP includes this base set:

| Operator | Type | Purpose |
|----------|------|---------|
| `text_header` | Text TOP | Panel title in ASCII box border |
| `text_content` | Text TOP | Main content area |
| `pattern_idle_breath` | Pattern CHOP | Sine wave 0.2 Hz — drives idle border animation |
| `pattern_alert_pulse` | Pattern CHOP | Square wave 1 Hz — drives alert border flash |
| `null_border_color` | Null CHOP | Current border color (driven by Python based on alert state) |
| `execute_state` | DAT Execute | Watches relevant Table DAT, updates animation state |
| `table_panel_data` | Table DAT | Parsed data from Web Client DAT response |
| `script_response` | Script DAT | Python: onReceiveResponse — parses JSON into table_panel_data |

#### settings_overlay (hidden by default)

| Operator | Type | Purpose |
|----------|------|---------|
| `toggle_audio_enabled` | Button COMP | ON/OFF toggle for audio alerts |
| `menu_chime_type` | Custom COMP | Dropdown: chime_a.wav / chime_b.wav / chime_c.wav |
| `slider_refresh_interval` | Slider COMP | 900–3600 seconds (15–60 min) |
| `button_save_settings` | Button COMP | Writes new values to Supabase dashboard_settings via POST |
| `button_close_overlay` | Button COMP | Hides settings_overlay |
| `audioPlay_alert` | Audio Play CHOP | Plays chime file on EXPIRED credential detect |

---

## Section 3: ASCII Aesthetic Specification

### 3.1 Typography

| Parameter | Value |
|-----------|-------|
| Primary font | IBM Plex Mono (free, Google Fonts — include .ttf in TD project assets) |
| Fallback font | Courier New (system default) |
| Load method | Text TOP → Font File parameter (point to .ttf asset path) |
| Rendering | Text TOP for all text display; never Geometry COMP for text |

**Font file path convention:** Store font files at `{td_project_root}/assets/fonts/IBMPlexMono-Regular.ttf` and `IBMPlexMono-Bold.ttf`. Reference with relative path in Text TOP Font File parameter.

### 3.2 Color Palette

All colors are specified as normalized RGB (0.0–1.0 range for TD) and hex equivalents:

| Name | TD RGB | Hex | Use |
|------|--------|-----|-----|
| `GREEN` | `(0.0, 0.9, 0.2)` | `#00E633` | Credential OK (90+ days), healthy state |
| `YELLOW` | `(1.0, 0.95, 0.0)` | `#FFF200` | Warning (30–90 days remaining), plan renewal |
| `AMBER` | `(1.0, 0.6, 0.0)` | `#FF9900` | Urgent (7–30 days), initiate renewal now |
| `RED` | `(1.0, 0.1, 0.05)` | `#FF1A0D` | Critical (<7 days or EXPIRED), immediate action |
| `CYAN` | `(0.0, 0.85, 1.0)` | `#00D9FF` | Info/neutral text, empty state messages |
| `WHITE` | `(0.95, 0.95, 0.95)` | `#F2F2F2` | Standard content text |
| `DIM_WHITE` | `(0.5, 0.5, 0.5)` | `#808080` | Secondary text, labels, timestamps |
| `DARK_BG` | `(0.04, 0.04, 0.06)` | `#0A0A0F` | Panel background |
| `PANEL_BG` | `(0.06, 0.06, 0.09)` | `#0F0F17` | Individual panel background (slightly lighter than root) |

**Mapping from `credential_alert_queue.display_color` field:**

| display_color value | TD color name | TD RGB |
|--------------------|---------------|--------|
| `GREEN` | GREEN | `(0.0, 0.9, 0.2)` |
| `YELLOW` | YELLOW | `(1.0, 0.95, 0.0)` |
| `AMBER` | AMBER | `(1.0, 0.6, 0.0)` |
| `RED` | RED | `(1.0, 0.1, 0.05)` |

### 3.3 Panel Border Characters

**Idle border (single line — standard state):**
```
+--------------------------------------------------+
|  Panel Title                                     |
|  Content...                                      |
+--------------------------------------------------+
```
Characters: `+` at corners, `-` for horizontal, `|` for vertical.

**Active/focused border (double line — when a button is clicked or panel is focused):**
```
#===================================================#
|  Panel Title                                     |
|  Content...                                      |
#===================================================#
```
Characters: `#` at corners, `=` for horizontal, `|` for vertical.

**Alert border (same as idle but rendered in alert color with pulsing animation).**

**Implementation:** Borders are rendered via Text TOP as static string constants. The Pattern CHOP drives the Text TOP `Text Color R/G/B` or `BG Color R/G/B` parameters to animate color. Do NOT try to generate borders programmatically per frame — use static string in Text TOP, animate color parameters only.

### 3.4 Four Animation States — All Panels

Every panel implements all four states. State transitions are driven by Python in `execute_state` DAT.

---

#### STATE 1: IDLE

**Trigger:** Panel has data, no alerts, no user interaction.

**Visual behavior:** Slow breathing border. The border color gently oscillates between full opacity and 60% opacity, creating a subtle "alive" feel.

**TD Implementation:**
- `pattern_idle_breath`: Type=Sine, Frequency=0.2 Hz, Amplitude=0.4, Offset=0.6
- Wire `pattern_idle_breath` CHOP output to `null_border_color` channel controlling Text TOP `Text Color A` (alpha)
- Result: border fades 60%→100%→60% alpha over a 5-second cycle, continuously

```python
# In execute_state, set idle state:
def setIdle():
    op('pattern_idle_breath').par.active = 1
    op('pattern_alert_pulse').par.active = 0
    op('text_header').par.textcolorr  = 0.95
    op('text_header').par.textcolorg  = 0.95
    op('text_header').par.textcolorb  = 0.95
```

---

#### STATE 2: LOADING

**Trigger:** Web Client DAT request is in flight (waiting for Supabase response).

**Visual behavior:** Spinning ASCII indicator in panel header, replacing the title momentarily.

**TD Implementation:**
- Python list: `SPINNER = ['|', '/', '-', '\\']`
- `pattern_loading_spin`: Type=Square, Frequency=4 Hz (4 rotations per second)
- In `execute_state` onValueChange (watching pattern_loading_spin), cycle through SPINNER index:

```python
SPINNER = ['|', '/', '-', '\\']
_spin_idx = 0

def onValueChange(channel, sampleIndex, val, prev):
    global _spin_idx
    if channel.name == 'chan1' and val == 1:
        _spin_idx = (_spin_idx + 1) % 4
        op('text_header').par.text = f'[ {SPINNER[_spin_idx]} ] Loading...'
```

- Restore original title in `onReceiveResponse` callback after data parses.

---

#### STATE 3: ALERT

**Trigger:** Panel contains data with `alert_level IN ('ALERT_7', 'EXPIRED')` — critical threshold.

**Visual behavior:** Border flashes between alert color and background color at 1 Hz. Content renders in RED or AMBER depending on severity.

**TD Implementation:**
- `pattern_alert_pulse`: Type=Square, Frequency=1 Hz, Amplitude=1.0, Offset=0.0
- Wire output to a Null CHOP that drives border Text TOP color:

```python
# In CHOP Execute DAT watching pattern_alert_pulse:
def onValueChange(channel, sampleIndex, val, prev):
    if channel.name == 'chan1':
        if val == 1:  # pulse ON
            op('text_header').par.bgcolorr = 1.0
            op('text_header').par.bgcolorg = 0.1
            op('text_header').par.bgcolorb = 0.05  # RED
        else:          # pulse OFF
            op('text_header').par.bgcolorr = 0.06
            op('text_header').par.bgcolorg = 0.06
            op('text_header').par.bgcolorb = 0.09  # PANEL_BG
```

- Disable `pattern_idle_breath` when in ALERT state.

---

#### STATE 4: INTERACTION

**Trigger:** User clicks a button within the panel (e.g., action button pressed, credential row clicked).

**Visual behavior:** Border flashes bright WHITE once (a single bright flash at full opacity), then holds a steady highlighted state (CYAN border) for 2 seconds, then returns to previous state (IDLE or ALERT).

**TD Implementation:**
```python
# In Panel Execute DAT (onValueChange for Button COMP):
import time
_interaction_start = 0

def onValueChange(panelValue):
    global _interaction_start
    if panelValue.val == 1:
        _interaction_start = time.time()
        # Flash border WHITE
        op('text_header').par.textcolorr = 1.0
        op('text_header').par.textcolorg = 1.0
        op('text_header').par.textcolorb = 1.0
        # Schedule return to previous state after 2s
        # Use a Timer CHOP (single shot, 2s) or check elapsed in next cook
```

- A dedicated `timer_interaction` Timer CHOP (Mode=Once, Length=2) fires after 2 seconds and calls Python to restore the pre-interaction border color.

### 3.5 Overdue Banner Animation

The `overdue_banner` Container COMP activates when any credential has `alert_level = 'EXPIRED'` in `credential_alert_queue`.

**Visibility logic:**
```python
# In execute_banner_visibility (DAT Execute watching table_expired_items):
def onTableChange(dat):
    has_expired = dat.numRows > 1  # row 0 is header
    op('/dashboard_root/overdue_banner').par.display = 1 if has_expired else 0
    # When banner shows, shift panel_grid Y position down by banner height
    banner_h = 60 if op('/dashboard_root/webClient_settings')... else 60
    op('/dashboard_root/panel_grid').par.y = banner_h if has_expired else 0
```

**Content:** Banner text scrolls the names of EXPIRED credentials continuously:
```
!!!  CRITICAL: Business License BL-LIC-051057 EXPIRED 61 DAYS  ///  CAQH Re-Attestation EXPIRED — All 17 Payer Contracts at Risk  !!!
```

Text content is assembled in Python from `table_expired_items`, formatted as:
```python
items = []
for row_i in range(1, dat.numRows):
    name  = dat[row_i, 'credential_name'].val
    days  = abs(int(dat[row_i, 'days_until_expiry'].val))
    items.append(f'CRITICAL: {name} EXPIRED {days} DAYS')
scrolling_text = '  ///  '.join(items) + '  ' * 20  # trailing spaces for seamless scroll
op('text_banner_content').par.text = scrolling_text
```

**Scrolling animation:** A Pattern CHOP (Type=Ramp, Frequency=0.02 Hz) drives `text_banner_content` `Translate X` parameter. At 2560px width, a 0.02 Hz ramp produces ~50 seconds per full scroll cycle.

**Pulsing background:** `pattern_pulse` (Square wave, 1 Hz) drives banner background RED channel:
```python
# CHOP Execute DAT watching pattern_pulse:
def onValueChange(channel, sampleIndex, val, prev):
    if channel.name == 'chan1':
        op('text_banner_content').par.bgcolorr = 0.7 if val == 1 else 0.4
        op('text_banner_content').par.bgcolorg = 0.0
        op('text_banner_content').par.bgcolorb = 0.0
```

**Dismissal rule:** Banner CANNOT be manually dismissed. It disappears only when ALL rows with `alert_level='EXPIRED'` are removed from `credential_alert_queue` — meaning the credential's `expiry_date` has been updated to a future date and `status='ACTIVE'` in the `credentials` Supabase table.

### 3.6 Scrolling Text Ticker Pattern

For any panel using a scrolling text banner (not just the overdue banner), the pattern is:

- Text TOP renders full text content (wider than visible area)
- Pattern CHOP (Type=Ramp, Frequency based on desired scroll speed) drives Text TOP `Translate X` parameter
- Translate X wraps at -1× text width to create seamless looping
- Typical frequencies: 0.01–0.05 Hz (slower = more readable, faster = more content visible over time)

### 3.7 Anti-Patterns (Do NOT Build These)

| Anti-Pattern | Problem | Correct Approach |
|--------------|---------|-----------------|
| TD calling Tebra SOAP directly | Authentication state management inside TD; SOAP envelope complexity; blocks cook thread | n8n calls Tebra, writes to Supabase, TD reads Supabase |
| PHI in raw form in Supabase tables TD reads | HIPAA violation if external monitor is visible | n8n strips PHI before writing; tebra_appointments has first_name_only only |
| Polling more than once per 5 minutes | Unnecessary Supabase API load; not needed for a 15-30 min use case | Timer CHOP Length ≥ 900 seconds |
| Synchronous Python in TD callbacks | Blocks render thread; dashboard freezes | Use Web Client DAT async pattern; never time.sleep() in callbacks |
| Single monolithic TD network | Impossible to debug per-panel; cannot reload one panel without full restart | Separate Container COMP per panel; each panel self-contained |
| Generating borders per frame in Python | Performance overhead; not how TD works | Static string in Text TOP; animate color parameters via CHOP wiring |

---

## Section 4: Panel 1 — Today / Morning Briefing (DASH-01)

*[Specification in Plan 01 — see below]*

---

## Section 5: Panel 2 — Compliance Status (DASH-02)

*[Specification in Plan 01 — see below]*

---

## Section 6: Panel 3 — Credentials / Obligations Tracker (DASH-03)

*[Placeholder — to be filled by Plan 02]*

---

## Section 7: Panel 4 — Calendar View (DASH-04)

*[Placeholder — to be filled by Plan 02]*

---

## Section 8: Panel 5 — Appointments (DASH-05) and Panel 6 — Billing Oversight (DASH-06)

*[Placeholder — to be filled by Plan 02]*

---

## Section 9: Panel 7 — Actions (DASH-07), Panel 8 — Automation Tracker (DASH-08), Supabase DDL, Startup Notes

*[Placeholder — to be filled by Plan 03]*

---

<!-- ============================================================ -->
<!-- SECTIONS 4 AND 5: Panel Specifications (filled per Plan 01)  -->
<!-- ============================================================ -->

## Section 4: Panel 1 — Today / Morning Briefing (DASH-01)

### 4.1 Purpose

This is the first panel Valentina sees when she opens the dashboard each morning. It is a situational awareness overview — not a deep-dive into any one data domain. The goal is immediate awareness: who is she seeing today, is anything on fire, what does her billing look like, and what obligations are coming up.

### 4.2 Container COMP

**Operator name:** `panel_today`
**Position in grid:** Top-left (x=0, y=60 at 2560×1440)
**Dimensions:** 853×440 px (at 2560×1440)

### 4.3 Operators Inside panel_today

| Operator | Type | Purpose |
|----------|------|---------|
| `text_header_today` | Text TOP | "BRIGHTER DAYS" ASCII art banner (animated on startup) |
| `text_appointments` | Text TOP | Today's appointment list (first name + time) |
| `text_overdue_badge` | Text TOP | Count of overdue items in RED or AMBER |
| `text_obligations` | Text TOP | Upcoming obligations count and summary |
| `text_billing_snapshot` | Text TOP | Current month billing one-liner |
| `text_empty_appts` | Text TOP | Empty state: "No appointments today" (hidden when data present) |
| `text_empty_overdue` | Text TOP | Empty state: "All clear — no overdue items" in CYAN (hidden when data present) |
| `table_today_appointments` | Table DAT | Parsed tebra_appointments WHERE date = TODAY |
| `table_today_obligations` | Table DAT | Parsed obligations WHERE status != 'completed' AND due_date <= TODAY+7 |
| `table_today_billing` | Table DAT | Parsed tebra_billing_summary WHERE period = current_month |
| `script_appts_response` | Script DAT | Python: parse Web Client DAT response into table_today_appointments |
| `pattern_header_reveal` | Pattern CHOP | Drives character-reveal animation on startup for "BRIGHTER DAYS" banner |
| `timer_header_startup` | Timer CHOP | Mode=Once, fires once on startup to trigger header animation |
| `button_settings` | Button COMP | Opens settings_overlay when clicked |
| `pattern_idle_breath` | Pattern CHOP | Sine wave 0.2 Hz — idle border animation (shared base set) |
| `pattern_alert_pulse` | Pattern CHOP | Square wave 1 Hz — alert border animation (shared base set) |
| `execute_state_today` | DAT Execute | Watches table_today_obligations/appointments, manages animation state |

### 4.4 Data Sources

All data is read from Supabase via the global polling cycle in `panel_grid`. `panel_today` reads pre-populated Table DATs rather than making its own Web Client DAT requests.

| Display Element | Supabase Source | Query / Filter |
|----------------|-----------------|----------------|
| Appointment list | `tebra_appointments` | `appointment_date=eq.{TODAY}&order=appointment_time.asc` |
| Overdue count badge | `credential_alert_queue` | `alert_level=in.(ALERT_30,ALERT_7,EXPIRED)` — count rows |
| Upcoming obligations | `obligations` | `status=neq.completed&due_date=lte.{TODAY+7 days}&order=due_date.asc` |
| Billing snapshot | `tebra_billing_summary` | `period=eq.{YYYY-MM}` where YYYY-MM = current month |

**PHI scope:** The `tebra_appointments` table (written by n8n) contains ONLY `first_name_only` and `appointment_time`. No last names, no diagnoses, no insurance information appears anywhere in this panel or in the Supabase table it reads from.

### 4.5 Panel Layout

```
+-----------------------------------------------+
| [ | ] BRIGHTER DAYS                           |  <- animated header
+-----------------------------------------------+
|  TODAY'S APPOINTMENTS           Mar 01, 2026  |
|  ─────────────────────────────────────────── |
|  Alex       at  09:00 AM                      |
|  Jordan     at  11:00 AM                      |
|  Morgan     at  02:00 PM                      |
|  Sam        at  04:30 PM                      |
|  ─────────────────────────────────────────── |
|  [###] OVERDUE: 2 items require action        |  <- RED if > 0
|  UPCOMING (7 days): 3 obligations             |  <- YELLOW if > 0
|  ─────────────────────────────────────────── |
|  BILLING (Mar 2026)                           |
|  Claims: 47 submitted / 3 denied / AR: $4,820 |
+-----------------------------------------------+
```

**Row heights (approximate, 2560×1440):**
- Header row: 60 px
- Appointments section: 180 px (up to 6 appointments; overflow truncated with "+ N more")
- Overdue + Obligations row: 50 px each
- Divider lines: 2 px each
- Billing row: 50 px

### 4.6 "BRIGHTER DAYS" Header Animation

On startup (single-fire, not repeating):
- `timer_header_startup` (Mode=Once, Length=3 seconds) triggers `pattern_header_reveal`
- Characters appear one at a time left-to-right over 3 seconds
- Python implementation: a list of partial strings `['B', 'BR', 'BRI', ... 'BRIGHTER DAYS']` indexed by a counter driven by the Pattern CHOP value
- After reveal completes, header enters IDLE state breathing animation

**Steady-state header display:** `[ | ] BRIGHTER DAYS` where `[ | ]` is the LOADING spinner character (held at `|` during idle state to maintain the "always alive" aesthetic).

### 4.7 Appointment List Display

Python builds the display string from `table_today_appointments`:

```python
def buildAppointmentList(dat):
    MAX_VISIBLE = 6
    lines = []
    for row_i in range(1, min(dat.numRows, MAX_VISIBLE + 1)):
        first_name = dat[row_i, 'first_name_only'].val
        appt_time  = dat[row_i, 'appointment_time'].val  # format: "09:00 AM"
        lines.append(f'  {first_name:<12} at  {appt_time}')
    overflow = dat.numRows - 1 - MAX_VISIBLE
    if overflow > 0:
        lines.append(f'  + {overflow} more appointments')
    if not lines:
        return 'No appointments today'
    return '\n'.join(lines)
```

### 4.8 Overdue Count Badge

```python
def buildOverdueBadge(credentials_dat):
    expired_count = 0
    for row_i in range(1, credentials_dat.numRows):
        level = credentials_dat[row_i, 'alert_level'].val
        if level in ('EXPIRED', 'ALERT_7', 'ALERT_30'):
            expired_count += 1

    if expired_count == 0:
        op('text_overdue_badge').par.text = 'All clear — no overdue items'
        op('text_overdue_badge').par.textcolorr = 0.0
        op('text_overdue_badge').par.textcolorg = 0.85
        op('text_overdue_badge').par.textcolorb = 1.0  # CYAN
    else:
        op('text_overdue_badge').par.text = f'[###] OVERDUE: {expired_count} items require action'
        op('text_overdue_badge').par.textcolorr = 1.0
        op('text_overdue_badge').par.textcolorg = 0.1
        op('text_overdue_badge').par.textcolorb = 0.05  # RED
```

### 4.9 Upcoming Obligations Display

```python
def buildObligationsSummary(obligations_dat):
    count = obligations_dat.numRows - 1  # subtract header
    if count == 0:
        return ('All obligations current', 'CYAN')
    # Show up to 3 obligation titles with days remaining
    lines = [f'UPCOMING ({count} obligations in 7 days):']
    for row_i in range(1, min(obligations_dat.numRows, 4)):
        title    = obligations_dat[row_i, 'title'].val
        due_date = obligations_dat[row_i, 'due_date'].val
        lines.append(f'  {title[:30]}  —  {due_date}')
    if count > 3:
        lines.append(f'  + {count - 3} more')
    return ('\n'.join(lines), 'YELLOW')
```

### 4.10 Billing Snapshot Display

```python
def buildBillingSnapshot(billing_dat):
    if billing_dat.numRows < 2:
        return 'BILLING: No data available'
    submitted = billing_dat[1, 'claims_submitted'].val or '–'
    denied    = billing_dat[1, 'claims_denied'].val or '–'
    ar_total  = billing_dat[1, 'ar_current'].val or '–'
    period    = billing_dat[1, 'period'].val  # e.g., '2026-03'
    import datetime
    try:
        dt = datetime.datetime.strptime(period, '%Y-%m')
        label = dt.strftime('%b %Y')
    except:
        label = period
    return f'BILLING ({label}): {submitted} submitted / {denied} denied / AR: ${ar_total}'
```

### 4.11 Animation State Logic

```python
# execute_state_today watches table_today_appointments and passes credential data via
# a reference to panel_grid's table_credential_status

def onTableChange(dat):
    # Check for alert-level items
    creds_dat = op('../panel_grid/table_credential_status')  # shared table
    has_expired = any(
        creds_dat[r, 'alert_level'].val in ('EXPIRED', 'ALERT_7')
        for r in range(1, creds_dat.numRows)
    )
    if has_expired:
        setAlert()
    else:
        setIdle()

def setIdle():
    op('pattern_idle_breath').par.active = 1
    op('pattern_alert_pulse').par.active = 0

def setAlert():
    op('pattern_idle_breath').par.active = 0
    op('pattern_alert_pulse').par.active = 1
```

### 4.12 Refresh Behavior

`panel_today` does NOT have its own Timer CHOP. The global `timer_global_poll` in `panel_grid` triggers all Web Client DAT requests simultaneously. `panel_today` reacts to changes in `table_today_appointments`, `table_today_obligations`, and `table_today_billing` via DAT Execute `onTableChange` callbacks. Data freshness is the global polling interval (default 30 min).

### 4.13 Settings Button

The `button_settings` Button COMP (small gear icon `[*]` in header) toggles `settings_overlay` visibility:
```python
# Panel Execute DAT on button_settings:
def onValueChange(panelValue):
    if panelValue.val == 1:
        overlay = op('/dashboard_root/settings_overlay')
        overlay.par.display = 1 - overlay.par.display  # toggle
```

### 4.14 HIPAA Physical Security Note

This panel displays `first_name_only` values from `tebra_appointments`. While first names alone are considered de-identified under HIPAA's Safe Harbor standard when combined with a limited date (time only, no full date), Valentina's physical office must ensure that the external monitor running this dashboard is not visible to unauthorized individuals (patients in waiting area, building common areas, through windows). This is a physical safeguard requirement under the HIPAA Security Rule (45 CFR 164.310(c)).

---

## Section 5: Panel 2 — Compliance Status (DASH-02)

### 5.1 Purpose

At-a-glance red/yellow/green status for every tracked credential, license, BAA, and CAQH attestation. This panel surfaces the same data that drives n8n email alerts — the dashboard makes that data visible without waiting for an email.

### 5.2 Container COMP

**Operator name:** `panel_compliance`
**Position in grid:** Top-center (x=854, y=60 at 2560×1440)
**Dimensions:** 853×440 px (at 2560×1440)

### 5.3 Operators Inside panel_compliance

| Operator | Type | Purpose |
|----------|------|---------|
| `text_header_compliance` | Text TOP | Panel title: "COMPLIANCE STATUS" |
| `text_credential_list` | Text TOP | Scrollable list of credentials with color indicators |
| `scroll_offset` | Pattern CHOP | Ramp driving vertical scroll offset when list exceeds panel height |
| `table_compliance_data` | Table DAT | Parsed credential_alert_queue view data |
| `table_caqh_special` | Table DAT | Separate query for CAQH NULL expiry_date check |
| `script_compliance_response` | Script DAT | Python: parse Web Client DAT response into table_compliance_data |
| `button_scroll_up` | Button COMP | Manual scroll up (visible when list overflows) |
| `button_scroll_down` | Button COMP | Manual scroll down (visible when list overflows) |
| `container_detail_overlay` | Container COMP | Hidden detail popup — shows on credential row click |
| `pattern_idle_breath` | Pattern CHOP | Sine wave 0.2 Hz — idle border animation |
| `pattern_alert_pulse` | Pattern CHOP | Square wave 1 Hz — alert border animation |
| `execute_state_compliance` | DAT Execute | Watches table_compliance_data, manages animation state |

### 5.4 Data Source

**Primary source:** `credential_alert_queue` view (Phase 2 schema) — provides all credentials with expiry dates and computed alert levels.

**Supabase query (via webClient_credentials in panel_grid):**
```
GET /rest/v1/credential_alert_queue
Query params: order=expiry_date.asc
Headers: apikey + Authorization (service role key)
```

Response fields consumed: `credential_name`, `alert_level`, `days_until_expiry`, `display_color`, `credential_number`, `renewal_portal_url`, `vault_entry_ref`, `expiry_date`, `credential_type`

**CAQH special check:** A separate Web Client DAT `webClient_caqh_null` queries for the CAQH row with NULL expiry_date:
```
GET /rest/v1/credentials
Query params: credential_type=eq.caqh&select=id,credential_name,expiry_date,status
```
This detects the NULL expiry case documented in RESEARCH.md Pitfall 2.

### 5.5 Panel Layout

```
+-----------------------------------------------+
| COMPLIANCE STATUS                             |
+-----------------------------------------------+
|  [###] CA Medical License  —  847 days        |  <- GREEN
|  [###] DEA FP3833933       —  613 days        |  <- GREEN
|  [###] NPI 1023579513      —  no expiry       |  <- CYAN (no expiry)
|  [###] CAQH 16149210       —  VERIFY DATE     |  <- AMBER (NULL expiry)
|  [###] ABPN Cert           —  312 days        |  <- GREEN
|  [###] Malpractice Ins     —  143 days        |  <- GREEN
|  [###] Business License    —  EXPIRED -61 d   |  <- RED PULSING
|  [###] Biz License Renew.  —  ~847 days       |  <- GREEN (estimated)
|  ─────────────────────────────────────────── |
|  [^] scroll up   [v] scroll down              |  <- visible only when overflow
+-----------------------------------------------+
```

**Status indicator character:** `[###]` rendered in the row's `display_color`. The `#` characters fill a fixed-width 3-character field, giving a "traffic light block" appearance.

### 5.6 Credential Row Rendering

Python in `script_compliance_response` builds the credential list text:

```python
def buildCredentialList(dat):
    lines = []
    for row_i in range(1, dat.numRows):
        name        = dat[row_i, 'credential_name'].val
        alert_level = dat[row_i, 'alert_level'].val
        days        = dat[row_i, 'days_until_expiry'].val
        color       = dat[row_i, 'display_color'].val
        is_estimated = dat[row_i, 'recred_is_estimated'].val if 'recred_is_estimated' in dat.colNames else ''

        # Build days display
        if alert_level == 'EXPIRED':
            days_str = f'EXPIRED  {abs(int(days))} days ago'
        elif days == '' or days is None:
            days_str = 'no expiry'
        else:
            prefix = '~' if is_estimated == 'true' else ''
            days_str = f'{prefix}{int(days)} days'

        # Credential name padded to 20 chars
        display_name = name[:20].ljust(20)
        line = f'[###]  {display_name}  —  {days_str}'
        lines.append((line, color, alert_level))
    return lines

# Apply colors per row by building composite Text TOP or using a per-row color lookup
```

**Color application:** Because TouchDesigner Text TOP applies a single color to all text, per-row coloring requires one of:
1. **Separate Text TOP per row** (up to ~15 rows = 15 Text TOPs, composited with Over TOP) — simpler to implement, higher operator count
2. **Single Text TOP with rich text / HTML mode** — check if TD version supports HTML color spans in Text TOP
3. **Lookup TOP with per-character color mapping** — most complex, most flexible

**Recommended approach:** Option 1 (separate Text TOP per row) for a credential list of ~15–20 items. Use a Replicator COMP to instance the row template if the count is dynamic.

### 5.7 CAQH NULL Expiry Handling

When `webClient_caqh_null` returns a CAQH row with `expiry_date = null`:

```python
def onReceiveCaqhResponse(webClientDAT, statusCode, headerDict, data, id):
    import json
    if statusCode != 200:
        return
    records = json.loads(data)
    for r in records:
        if r.get('expiry_date') is None:
            # CAQH has no attestation date — display UNKNOWN warning
            op('text_caqh_warning').par.text = (
                '[???] CAQH Attestation  —  VERIFY DATE\n'
                '      Last attestation date unknown\n'
                '      Log in at proview.caqh.org to verify'
            )
            op('text_caqh_warning').par.textcolorr = 1.0
            op('text_caqh_warning').par.textcolorg = 0.6
            op('text_caqh_warning').par.textcolorb = 0.0  # AMBER
            op('text_caqh_warning').par.display = 1
            # Ensure this row is NOT green — explicitly override any display_color='GREEN'
```

**Status indicator for CAQH NULL:** `[???]` (three question marks) in AMBER — visually distinct from `[###]` green/yellow/red credentials. This makes it impossible to mistake "no data" for "all good."

**Pre-launch blocker note:** The CAQH NULL expiry_date is a documented pre-launch blocker (Phase 2 alert-architecture.md Section 6.2). Valentina must:
1. Log into https://proview.caqh.org with CAQH ID 16149210
2. Find last attestation date on the Attestation tab
3. Report to Maxi: Maxi updates `credentials` table: `expiry_date = last_attestation_date + 120 days`
4. CAQH row will then appear correctly in `credential_alert_queue`

### 5.8 Estimated Date Visual Treatment

Payer re-credentialing dates with `recred_is_estimated = true` (9 of 17 payers as of Phase 2) MUST show a `~` prefix in the days display:

```
[###] Blue Cross (re-cred)   —  ~847 days
[###] Aetna (re-cred)        —  ~612 days
```

This applies only to rows sourced from `payer_credentialing_alerts` view (which includes `recred_is_estimated`). Rows from `credential_alert_queue` (credentials table) never have estimated dates.

**Python detection:**
```python
is_estimated = row.get('recred_is_estimated', False)
prefix = '~' if is_estimated else ''
days_str = f'{prefix}{days} days'
```

### 5.9 Scroll Behavior

When the credential list exceeds panel height (~440 px at 2560×1440, ~12–14 visible rows at standard line height):

- `button_scroll_up` and `button_scroll_down` appear at the bottom of the panel
- Each button press adjusts a Python variable `scroll_row_offset` by +1 or -1
- `text_credential_list` rebuilds from `scroll_row_offset` to `scroll_row_offset + MAX_VISIBLE_ROWS`
- `scroll_offset` Pattern CHOP can also drive smooth pixel-level scrolling for auto-scroll mode

**Auto-scroll:** If list exceeds visible rows AND no user has manually scrolled in the last 10 seconds, the list auto-scrolls slowly (Pattern CHOP ramp, 0.005 Hz) to show all credentials in rotation.

### 5.10 Credential Row Transition Animation

When a credential transitions to a worse alert level (e.g., YELLOW → RED, GREEN → YELLOW) on a data refresh, the row should pulse 3 times to draw attention:

```python
# In execute_state_compliance, onTableChange:
def detectTransitions(old_dat, new_dat):
    SEVERITY = {'CURRENT': 0, 'ALERT_90': 1, 'ALERT_60': 2, 'ALERT_30': 3, 'ALERT_7': 4, 'EXPIRED': 5}
    transitions = []
    # Build dict of previous levels (stored in a persistent Python dict)
    global _previous_levels
    for row_i in range(1, new_dat.numRows):
        cred_name  = new_dat[row_i, 'credential_name'].val
        new_level  = new_dat[row_i, 'alert_level'].val
        prev_level = _previous_levels.get(cred_name, 'CURRENT')
        if SEVERITY.get(new_level, 0) > SEVERITY.get(prev_level, 0):
            transitions.append((row_i, cred_name, new_level))
        _previous_levels[cred_name] = new_level
    return transitions

# For each transition, trigger a 3-pulse flash on the affected row's Text TOP
# Using a Timer CHOP (Mode=Once, Segment count=3) or Python counter in script
```

### 5.11 Click-to-Detail Interaction

Clicking any credential row opens `container_detail_overlay` — a popup panel centered on-screen with the following fields:

```
+------------------------------------------+
|  CREDENTIAL DETAIL                    [X] |
|  ─────────────────────────────────────── |
|  Name:         CA Medical License G145321|
|  Number:       G145321                   |
|  Expiry:       2028-06-30 (847 days)     |
|  Status:       ACTIVE                    |
|  Renewal URL:  breeze.ca.gov             |
|  1Password:    "CA Medical License"      |
|  Last Updated: 2026-02-27                |
|  ─────────────────────────────────────── |
|  [OPEN RENEWAL PORTAL]  [CLOSE]          |
+------------------------------------------+
```

**Fields displayed:**
- `credential_name` — human-readable name
- `credential_number` — the actual license/certificate number
- `expiry_date` + computed days remaining
- `status` from credentials table
- `renewal_portal_url` — displayed as text (TD cannot open browser directly; display URL for manual navigation)
- `vault_entry_ref` — 1Password item name (for user to locate credentials)
- `updated_at` — timestamp of last Supabase update

**Implementation:** Row click detection requires per-row Button COMPs (one per row) OR a single touch/click area with Python calculating which row was tapped based on Y coordinate of the click event.

**Close button:** `[X]` button hides `container_detail_overlay`. No data writes occur — detail view is read-only.

### 5.12 Animation State Logic for Compliance Panel

```python
# execute_state_compliance, called when table_compliance_data changes:
def onTableChange(dat):
    has_expired   = False
    has_alert_7   = False
    has_alert_30  = False

    for row_i in range(1, dat.numRows):
        level = dat[row_i, 'alert_level'].val
        if level == 'EXPIRED':
            has_expired = True
        elif level == 'ALERT_7':
            has_alert_7 = True
        elif level == 'ALERT_30':
            has_alert_30 = True

    # Also check CAQH NULL (from table_caqh_special)
    caqh_null = op('table_caqh_special').numRows > 1

    if has_expired or caqh_null:
        setAlertState(color='RED')
    elif has_alert_7:
        setAlertState(color='RED')
    elif has_alert_30:
        setAlertState(color='AMBER')
    else:
        setIdleState()
```

### 5.13 HIPAA Note

The compliance status panel displays credential names and numbers. While credential data is not patient PHI, the display of `credential_number` (e.g., DEA number FP3833933) on an external monitor visible to unauthorized individuals could enable prescriber impersonation. This panel should be on a monitor in a private workspace, consistent with the physical security note in Section 4.14.

---

## Section 6: Panel 3 — Obligations Checklist / Credential Expiry Tracker (DASH-03)

### 6.1 Purpose

Running task list of everything that needs doing — the dashboard IS the task management system for compliance obligations. When Valentina opens the dashboard, the obligations panel tells her exactly what's due and how soon. Unlike a mirror of an external system, this panel owns the obligation lifecycle: items are created here, marked complete here, snoozed here, and auto-completed by n8n automations writing back to Supabase.

### 6.2 Container COMP

`panel_credentials` — positioned top-right in the dashboard grid (see Section 2.3 layout coordinates). Dimensions: 480 × 480 px at 2560×1440 (960 × 960 at 3840×2160).

### 6.3 Data Sources

| Source | Query | Purpose |
|--------|-------|---------|
| `obligations` table | `WHERE status='active' OR (status='snoozed' AND snoozed_until < NOW())` | Primary obligations list |
| `credential_alert_queue` view | All rows with alert_level != 'CURRENT' | Credential-specific countdowns (Phase 2 view) |
| Combined Python merge | Union both sources, dedup by obligation_id | Single sorted list rendered by panel |

**Web Client DAT:** `dat_obligations` — polls Supabase `/rest/v1/obligations?select=*&status=neq.completed&order=due_date.asc` every refresh cycle (Timer CHOP onCycle). Second Web Client DAT `dat_credential_alerts` polls `credential_alert_queue` view.

**Python merge:** A `script_obligations_merge` Text DAT merges both result sets into a single list. Items from `credential_alert_queue` are converted to pseudo-obligation rows with `obligation_id = 'CRED_' + credential_id`, so they participate in the same sort and color-coding as manual obligations.

### 6.4 Obligation Scope

The obligations panel covers two categories:

**Regulatory obligations (from compliance_items + credentials tables or pre-seeded obligations rows):**
- CA Medical License renewal (G145321)
- DEA Certificate renewal (FP3833933) — update address first (active blocker)
- NPI profile review (annual)
- CAQH re-attestation (every 120 days — highest-risk single credential)
- BAA renewals (Google Workspace, Tebra, Spruce Health)
- Malpractice insurance renewal
- Business license renewal (City of Torrance BL-LIC-051057 — OVERDUE as of 12/31/2025)
- DEA telehealth flexibility tracking (expires Dec 31, 2026 — compliance calendar must include this)

**Operational obligations (recurring):**
- Monthly: Third-party biller performance review
- Quarterly: Tax filing / estimated tax payment
- Quarterly: SOP review (rotate through SOP-01 through SOP-05 on 5-quarter cycle)
- Annual: CAQH PECOS re-enrollment review
- Annual: Payer re-credentialing window tracking (all 17 payers)
- Semi-annual: Controlled substance agreement review

**NOT included in this panel:** Individual patient follow-ups, day-to-day clinical tasks, appointment scheduling. Those stay in Tebra.

### 6.5 Display Format

Each obligation row renders as a single line:

```
[COLOR PREFIX] X days until [Obligation Title]
```

**Examples:**
```
[GREEN ]  847 days until CA Medical License Renewal
[YELLOW]   62 days until CAQH Re-Attestation
[RED   ]   14 days until Malpractice Insurance Renewal
[!!!!  ]    0 days — OVERDUE: Business License Renewal (pinned)
[~YELL ]  ~180 days until Blue Cross Re-Cred (est.)
```

**Color coding:**
| Days Remaining | Color | TD constant |
|----------------|-------|-------------|
| > 90 days | GREEN | `(0.2, 1.0, 0.4)` |
| 30–90 days | YELLOW | `(1.0, 1.0, 0.2)` |
| < 30 days | RED | `(1.0, 0.3, 0.2)` |
| Overdue (past due date) | PULSING RED | `(1.0, 0.0, 0.0)` + square wave 1Hz |
| Estimated date | Same color + `~` prefix | see Section 6.6 |

**Overdue items pinned to top:** Items with `status='overdue'` OR `due_date < TODAY()` always appear at the top of the list, above all active items, sorted by most-overdue first.

**Pulsing ASCII border on overdue items:** Overdue rows get an animated border using Pattern CHOP (square wave, 1Hz) that toggles between:
```
!> OVERDUE: Business License Renewal (0 days past due) <!
```
and:
```
   OVERDUE: Business License Renewal (0 days past due)
```
This creates a visible pulsing/blinking effect that is impossible to miss.

### 6.6 Estimated Date Visual Treatment

Obligation items sourced from `payer_tracker` with `recred_is_estimated=true` (9 of 17 payers) must display a `~` prefix on the days count and `(est.)` suffix on the obligation title. This prevents over-trust in estimated dates.

```
[~YELL ]  ~180 days until Blue Cross Re-Cred (est.)
[~YELL ]  ~612 days until Aetna Re-Cred (est.)
```

Python detection (consistent with Section 5.8):
```python
is_estimated = row.get('recred_is_estimated', False)
prefix = '~' if is_estimated else ''
suffix = ' (est.)' if is_estimated else ''
display_title = f"{row['title']}{suffix}"
days_str = f"{prefix}{days} days"
```

### 6.7 Interactivity

Three interactive actions per obligation row:

**Mark Complete:**
- Click `[DONE]` button on any row (Button COMP, per-row)
- Web Client DAT executes PATCH to Supabase: `PATCH /rest/v1/obligations?id=eq.{id}` with body `{"status": "completed", "completed_at": "<NOW_ISO>"}`
- Row disappears from active list on next refresh (or immediately on optimistic update — Python marks row hidden before refresh)
- Completed items are NOT shown by default; a `[SHOW COMPLETED]` toggle Button COMP at panel bottom reveals them in dim CYAN with strikethrough treatment

**Snooze:**
- Click `[ZZZ]` button opens a small inline snooze picker (not a full overlay — just a set of 4 Button COMPs appearing below the row):
  ```
  Snooze for: [1 week] [2 weeks] [1 month] [Custom...]
  ```
- Selection executes PATCH: `{"status": "snoozed", "snoozed_until": "<DATE_ISO>"}`
- Snoozed items disappear from list until `snoozed_until` date passes
- Snooze indicator shows on Today panel (DASH-01) snapshot as count of snoozed items

**Add Notes:**
- Click `[NOTE]` button expands a text input area below the row (Text COMP or Button COMP with keyboard input via Python)
- User types note and presses Enter or clicks `[SAVE NOTE]`
- PATCH to Supabase: `{"notes": "<text>"}`
- Notes preview (first 40 chars) shows inline on the row as dim CYAN text below the main obligation line

### 6.8 Auto-Completion

When `auto_completable = true` on an obligations row AND an n8n workflow writes `status='completed'` to that row (e.g., after a successful CAQH check automation), the dashboard detects the change on next refresh and:

1. Animates the row with a brief GREEN flash (3 pulses using Timer CHOP)
2. Adds a note to the row: `"Auto-completed by [action_type] on [timestamp]"` (the n8n workflow must write this to `obligations.notes` before closing the row)
3. Moves the row to the completed list

The `action_type` values are defined in the automation spec (Phase 5):
- `"CAQH_CHECK"` — CAQH re-attestation workflow
- `"PAYER_STATUS_CHECK"` — payer credentialing status check
- `"REPORT_GENERATE"` — compliance report generation

### 6.9 Initial Data Population (Seed SQL)

On first launch, pre-seed the `obligations` table with all known obligations. A developer should run this SQL against Supabase before first dashboard launch:

```sql
-- Obligations table seed for Brighter Days Dashboard
-- Run once before first dashboard launch

INSERT INTO obligations (
    title, description, category, due_date, recurrence,
    recurrence_interval, auto_completable, action_type, status
) VALUES

-- REGULATORY OBLIGATIONS
('CA Medical License Renewal', 'License G145321 — renew via BreEZe portal at breeze.ca.gov', 'regulatory', '2028-06-30', 'biennial', NULL, false, NULL, 'active'),
('DEA Certificate Renewal', 'DEA FP3833933 — must update address from Walnut Creek to Torrance first (21 CFR 1301.51)', 'regulatory', '2027-03-31', 'triennial', NULL, false, NULL, 'active'),
('CAQH Re-Attestation', 'CAQH ID 16149210 — every 120 days at proview.caqh.org. CRITICAL: missed attestation silently suspends all 17 payer contracts.', 'regulatory', NULL, 'recurring', 120, true, 'CAQH_CHECK', 'active'),
('NPI Profile Annual Review', 'Review NPI 1013141390 profile at nppes.cms.hhs.gov for accuracy', 'regulatory', NULL, 'annual', NULL, false, NULL, 'active'),
('Google Workspace BAA Verification', 'Verify BAA is active in Google Workspace Admin Console — required for HIPAA compliance', 'regulatory', '2026-03-15', NULL, NULL, false, NULL, 'active'),
('Tebra BAA Verification', 'Confirm Tebra BAA on file and up to date', 'regulatory', '2026-03-15', NULL, NULL, false, NULL, 'active'),
('Malpractice Insurance Renewal', 'Renew professional liability insurance — check expiry with carrier', 'regulatory', NULL, NULL, NULL, false, NULL, 'active'),
('Business License Renewal', 'City of Torrance BL-LIC-051057 — EXPIRED 12/31/2025. Renew immediately at torranceca.gov', 'regulatory', '2025-12-31', 'annual', NULL, false, NULL, 'overdue'),
('DEA Telehealth Flexibility Expiry', 'DEA telehealth prescribing flexibility expires Dec 31, 2026 — monitor for extension or new rule', 'regulatory', '2026-12-31', NULL, NULL, false, NULL, 'active'),

-- OPERATIONAL OBLIGATIONS
('Monthly Biller Performance Review', 'Review third-party biller AR report, denial rate, and collections. See SOP-05.', 'operational', NULL, 'monthly', NULL, false, NULL, 'active'),
('Quarterly Tax Filing / Estimated Payment', 'Estimated quarterly tax payment to IRS and CA FTB. Consult CPA.', 'operational', NULL, 'quarterly', NULL, false, NULL, 'active'),
('Annual CAQH PECOS Re-Enrollment Review', 'Verify PECOS enrollment status and CAQH profile completeness for Medicare/Medicaid', 'operational', NULL, 'annual', NULL, true, 'CAQH_CHECK', 'active'),
('SOP Annual Review — SOP-01', 'Annual review of SOP-01 (Patient Intake) per Phase 3 documentation', 'operational', NULL, 'annual', NULL, false, NULL, 'active'),
('SOP Annual Review — SOP-02', 'Annual review of SOP-02 (CURES Protocol) per Phase 3 documentation', 'operational', NULL, 'annual', NULL, false, NULL, 'active'),
('SOP Annual Review — SOP-03', 'Annual review of SOP-03 (Crisis Response) — ensure peer consultation contacts current', 'operational', NULL, 'annual', NULL, false, NULL, 'active'),
('SOP Annual Review — SOP-04', 'Annual review of SOP-04 (Business Structure) — update after attorney/CPA entity guidance', 'operational', NULL, 'annual', NULL, false, NULL, 'active'),
('SOP Annual Review — SOP-05', 'Annual review of SOP-05 (Billing Oversight) per Phase 3 documentation', 'operational', NULL, 'annual', NULL, false, NULL, 'active'),
('Controlled Substance Agreement Semi-Annual Review', 'Review controlled substance agreements for all Schedule II patients per SOP-02', 'operational', NULL, 'semi-annual', NULL, false, NULL, 'active');
```

**After running seed SQL:** Maxi must manually update `due_date` for items with `NULL` due_date using Valentina's actual records. Items without due_date will not display in calendar view — only in obligations checklist.

### 6.10 Scroll Behavior

When the obligations list exceeds panel height (~12–15 visible rows at standard line height):
- `button_obligations_scroll_up` and `button_obligations_scroll_down` appear at panel bottom
- Python variable `obligations_scroll_offset` tracks current top row
- Auto-scroll: if no user interaction in 10 seconds, panel cycles through all items at 0.003 Hz ramp (Pattern CHOP)

### 6.11 Animation States for Obligations Panel

| State | Trigger | Animation |
|-------|---------|-----------|
| IDLE | No overdue, no near-due | Border: sine wave 0.2Hz, subtle shimmer |
| ALERT | Any item < 7 days | Border: square wave 2Hz, AMBER/RED pulsing |
| OVERDUE | Any item past due_date | Border: square wave 1Hz, RED pulsing; overdue rows blink independently |
| LOADING | Web Client DAT fetching | Spinner character cycling `|/-\` in panel header |
| INTERACTION | User clicked DONE/SNOOZE/NOTE | Row highlight flash, button feedback |

### 6.12 Panel Header

```
+================================================+
|  OBLIGATIONS & EXPIRY TRACKER      [REFRESH]   |
|  Active: 14   Snoozed: 2   Overdue: 1   [ALL]  |
+================================================+
```

Header counts update on each data refresh. `[ALL]` toggles to show completed + snoozed items in dim text. `[REFRESH]` triggers an immediate poll cycle (Web Client DAT pulse, bypassing Timer CHOP interval).

---

## Section 7: Panel 4 — Compliance & Operations Calendar (DASH-04)

### 7.1 Purpose

See all deadlines on a timeline — both urgency-sorted (primary view) and date-positioned (secondary view). The calendar panel answers two questions: "What's coming up?" (countdown list) and "When exactly?" (calendar grid). It draws from all dated items across all sources — obligations, credentials, and payer re-credentialing windows.

### 7.2 Container COMP

`panel_calendar` — positioned bottom-left in the dashboard grid (see Section 2.3 layout coordinates). Dimensions: 480 × 480 px at 2560×1440 (960 × 960 at 3840×2160).

### 7.3 Data Sources

Combined query pulling all dated items from three sources:

| Source | Fields | Condition |
|--------|--------|-----------|
| `obligations` table | `title, due_date, category, status` | `status != 'completed' AND due_date IS NOT NULL` |
| `credential_alert_queue` view | `credential_name, expiry_date, alert_level` | All rows |
| `payer_credentialing_alerts` view | `payer_name, recred_due_date, recred_is_estimated` | All rows |

**Python merge into unified calendar items:**
```python
CalendarItem = {
    'title': str,
    'due_date': date,       # Python date object
    'days_remaining': int,  # Negative = overdue
    'category': str,        # 'regulatory', 'operational', 'credential', 'payer'
    'is_estimated': bool,   # True for payer rows with recred_is_estimated=True
    'source': str,          # 'obligations', 'credential', 'payer'
    'source_id': str        # For PATCH/update routing
}
```

All three sources are pulled by a single `script_calendar_merge` that unions them into a list of CalendarItem dicts, then sorts by `days_remaining` ascending.

### 7.4 Two View Modes

The calendar panel has two view modes toggled by a Button COMP in the panel header:

**Mode A (PRIMARY — default): Countdown List**

Chronological list showing all items due in the next 12 months, grouped by month:

```
+================================================+
|  COMPLIANCE CALENDAR    [LIST] / [GRID]         |
+================================================+
|  OVERDUE (1)                                    |
|    [!] Business License          0d OVERDUE     |
|                                                 |
|  MARCH 2026 (3)                                 |
|    [R] Google Workspace BAA     14d             |
|    [R] Tebra BAA Verification   14d             |
|    [O] Monthly Biller Review    28d             |
|                                                 |
|  APRIL 2026 (1)                                 |
|    [R] CAQH Re-Attestation      47d             |
|                                                 |
|  JUNE 2026 (2)                                  |
|    [O] Quarterly Tax Q2         92d             |
|    [R] DEA Telehealth Expires  305d             |
|                                                 |
|  (... more months below, scroll to view)        |
+================================================+
```

Category badges: `[R]` = Regulatory, `[O]` = Operational, `[C]` = Credential, `[P]` = Payer

Color coding matches obligations panel (GREEN/YELLOW/RED by days remaining).

**Mode B (SECONDARY): Monthly Calendar Grid**

ASCII grid of the current month. Each date cell shows obligation count badge if items are due:

```
+================================================+
|  COMPLIANCE CALENDAR    [LIST] / [GRID]        |
|  << MARCH 2026                            >>   |
+================================================+
|  Sun   Mon   Tue   Wed   Thu   Fri   Sat       |
|  ─────────────────────────────────────────     |
|    1     2     3     4     5     6     7        |
|               [1]                               |
|    8     9    10    11    12    13    14        |
|                                  [2]           |
|   15    16    17    18    19    20    21        |
|                                                |
|   22    23    24    25    26    27    28        |
|   [1]                                          |
|   29    30    31                               |
|                                                |
+================================================+
| Click a date to see obligations due that day   |
+================================================+
```

- `[N]` badge = N obligations due on that date. Badge color: GREEN for far-future, AMBER for 30–90 days, RED for < 30 days.
- Overdue dates get a pulsing `[!]` badge in RED instead of a count.
- Navigation arrows `<<` and `>>` step through months (Button COMPs, Python `calendar_month_offset` variable).
- Click a date: Python detects which cell was clicked (Y coordinate + column calculation), shows a detail overlay listing all obligations due on that date.

### 7.5 View Toggle Implementation

```python
# calendar_mode: 'list' or 'grid' — stored in Python global, persists during session
# toggle_calendar Button COMP onOffToOn callback:
def onOffToOn(channel, sampleIndex, val, prev):
    global calendar_mode
    calendar_mode = 'grid' if calendar_mode == 'list' else 'list'
    op('container_calendar_list').par.display = 1 if calendar_mode == 'list' else 0
    op('container_calendar_grid').par.display = 1 if calendar_mode == 'grid' else 0
    # Update toggle button appearance
    op('text_toggle_list').par.textcolorr = 1.0 if calendar_mode == 'list' else 0.4
    op('text_toggle_grid').par.textcolorr = 1.0 if calendar_mode == 'grid' else 0.4
```

Toggle button ASCII display: `[LIST]` is bright (selected) / dim (unselected), `[GRID]` inverse. Both are Button COMPs with Text TOP labels.

### 7.6 Calendar Grid Rendering

The monthly grid is rendered by a Python script (`script_calendar_render`) that builds a multi-line string into a single Text TOP:

```python
import calendar
import datetime

def render_calendar_grid(year, month, obligation_dates: dict) -> str:
    """
    obligation_dates: dict of {day_int: (count, max_severity)}
    max_severity: 'overdue', 'red', 'amber', 'green'
    Returns: multi-line string for Text TOP
    """
    cal = calendar.monthcalendar(year, month)
    header = f"  Sun   Mon   Tue   Wed   Thu   Fri   Sat"
    separator = "  " + "─" * 44
    lines = [header, separator]
    for week in cal:
        # Row 1: date numbers
        date_row = ""
        badge_row = ""
        for day in week:
            if day == 0:
                date_row += "       "
                badge_row += "       "
            else:
                date_row += f"  {day:2d}   "
                if day in obligation_dates:
                    count, severity = obligation_dates[day]
                    if severity == 'overdue':
                        badge_row += f"  [!]  "
                    else:
                        badge_row += f"  [{count}]  "
                else:
                    badge_row += "       "
        lines.append(date_row)
        if any(d != 0 and d in obligation_dates for d in week):
            lines.append(badge_row)
        lines.append("")
    return "\n".join(lines)
```

**Color handling for grid:** A single Text TOP cannot apply per-cell colors. Use a Lookup TOP or Python-built overlay: for each obligation badge cell, a separate small Text TOP renders the badge in the correct color, composited over the grid background via Over TOP chain. Limit to badges only — date numbers are monochrome.

### 7.7 Overdue Escalation in Calendar Panel

The calendar panel participates in overdue escalation (primary escalation defined in Section 3 — overdue banner):

- **Pulsing ASCII border:** When any item is overdue, `panel_calendar` border animates with square wave 1Hz (Pattern CHOP) — same treatment as obligations panel (Section 6.11)
- **Overdue section pinned to top:** In List mode, the OVERDUE group always renders at the top, even if due dates would sort them elsewhere
- **Grid mode overdue:** Past dates with overdue items show `[!]` in RED (see Section 7.4)
- **Audio alerts:** When any item transitions to EXPIRED status (detected on data refresh by comparing new vs. previous alert levels), AND `dashboard_settings.audio_enabled = true`, trigger `Audio Play CHOP` with the configured chime

### 7.8 Audio Alert Configuration

Audio alerts are configurable via a settings overlay accessible from the calendar panel header.

**Settings icon:** Small `[♪]` (or `[SND]` in ASCII terminals) Button COMP in the panel header. Click opens `container_audio_settings` overlay.

**Audio Settings Overlay:**
```
+------------------------------------------+
|  AUDIO ALERT SETTINGS               [X]  |
|  ────────────────────────────────────── |
|                                          |
|  Audio Alerts:    [ON ] / [OFF]          |
|                                          |
|  Chime Sound:                            |
|    ( ) chime_soft.wav                    |
|    (•) chime_clear.wav   (default)       |
|    ( ) chime_urgent.wav                  |
|    ( ) chime_bell.wav                    |
|    ( ) chime_alert.wav                   |
|                                          |
|  Alert Trigger Level:                    |
|    ( ) 30-day warning                    |
|    (•) 7-day warning     (default)       |
|    ( ) Overdue only                      |
|                                          |
|            [SAVE]    [CANCEL]            |
+------------------------------------------+
```

**Settings persistence:** All audio settings are read from and written to the `dashboard_settings` Supabase table:

| Key | Values | Default |
|-----|--------|---------|
| `audio_enabled` | `'true'` / `'false'` | `'false'` |
| `chime_type` | `'chime_soft'` / `'chime_clear'` / `'chime_urgent'` / `'chime_bell'` / `'chime_alert'` | `'chime_clear'` |
| `audio_trigger_level` | `'overdue_only'` / `'7_day'` / `'30_day'` | `'7_day'` |

**`[SAVE]` button:** Executes PATCH to `dashboard_settings` for each changed key. `[CANCEL]` closes overlay without writing. `[X]` behaves same as CANCEL.

**Audio file bundling:** Five `.wav` files (named per `chime_type` values above) are bundled in the TD project directory under `assets/audio/`. The Audio Play CHOP references these by path relative to TD project root. The developer must source or create these audio files — royalty-free chime sounds are recommended. Duration: 0.5–2 seconds per file.

**Audio trigger implementation:**
```python
# In script_calendar_merge, after building CalendarItem list:
# Check for new transitions to EXPIRED on this refresh cycle
global _previous_calendar_levels
audio_enabled = op('table_dashboard_settings')['audio_enabled', 1].val == 'true'
trigger_level = op('table_dashboard_settings')['audio_trigger_level', 1].val

for item in calendar_items:
    prev_level = _previous_calendar_levels.get(item['source_id'], 'green')
    curr_level = item_severity(item)  # returns 'overdue', 'red', 'amber', 'green'

    should_alert = False
    if trigger_level == 'overdue_only' and curr_level == 'overdue' and prev_level != 'overdue':
        should_alert = True
    elif trigger_level == '7_day' and curr_level in ('overdue', 'red') and prev_level not in ('overdue', 'red'):
        should_alert = True
    elif trigger_level == '30_day' and curr_level in ('overdue', 'red', 'amber') and prev_level not in ('overdue', 'red', 'amber'):
        should_alert = True

    if should_alert and audio_enabled:
        chime = op('table_dashboard_settings')['chime_type', 1].val
        op('audio_play_alert').par.file = f"assets/audio/{chime}.wav"
        op('audio_play_alert').par.trigger.pulse()

    _previous_calendar_levels[item['source_id']] = curr_level
```

### 7.9 Animation States for Calendar Panel

| State | Trigger | Animation |
|-------|---------|-----------|
| IDLE | No overdue, no near-due | Border: sine wave 0.2Hz, subtle green shimmer |
| APPROACHING | Any item 7–30 days | Border: sine wave 0.5Hz, YELLOW |
| ALERT | Any item < 7 days | Border: square wave 2Hz, RED border |
| OVERDUE | Any item past due_date | Border: square wave 1Hz, RED; `[!]` overdue items blink |
| LOADING | Fetching calendar data | Spinner in panel header: `|/-\` cycling |

### 7.10 Panel Header

```
+================================================+
|  COMPLIANCE CALENDAR  [LIST] / [GRID]  [SND]  |
|  Items: 22   Overdue: 1   Next due: 14d       |
+================================================+
```

"Next due: 14d" shows the days remaining for the soonest non-overdue item. Updates on each refresh. Clicking `[SND]` opens the audio settings overlay (Section 7.8).

---

## Section 8: Tebra Data Integration (DASH-05) and Billing Oversight Panel (DASH-06)

### 8.1 Overview

Tebra is the existing EHR and billing platform for Brighter Days. The dashboard does not replace Tebra — it provides oversight. This section covers: how appointment and billing data flows from Tebra into Supabase (8A), how the appointments panel displays that data (8B), and how the billing oversight panel renders aggregate billing metrics (8C).

**PHI scope (consistent with Section 4 and locked decisions):** The dashboard displays ONLY:
- Patient first name + appointment time (appointments panel)
- Aggregate billing metrics — claim counts, denial rates, AR totals (billing panel)

No last names, no diagnoses, no CPT codes, no insurance IDs, no patient-level billing detail are ever written to Supabase or displayed on the dashboard.

---

### 8A: Tebra Integration Architecture (DASH-05)

#### 8A.1 Three-Tier Fallback Strategy

The Tebra integration uses a tiered approach because Tebra API access (Tier 1) has LOW confidence from research — actual capabilities need validation during implementation. Whichever tier is implemented, the downstream Supabase schema and TD panel behavior are identical. The developer can implement any tier independently.

**Tier indicator:** A small badge in the header of Panel 5 (Appointments) and Panel 6 (Billing) shows which tier is active:
- `[API]` — Tier 1 (SOAP API)
- `[CSV]` — Tier 2 (CSV export)
- `[MANUAL]` — Tier 3 (manual entry)

This badge is driven by `dashboard_settings.tebra_integration_tier` value (`'api'` / `'csv'` / `'manual'`).

---

#### 8A.2 Tier 1 — Tebra SOAP API (Preferred)

**Overview:** n8n polls the Tebra SOAP API every 15–30 minutes (configurable), extracts appointment and billing data, strips PHI, and writes aggregated results to Supabase. TouchDesigner reads from Supabase only — it never calls the Tebra API directly.

**n8n workflow: Appointments sync**

1. **Schedule Trigger:** Fires every 15 minutes (configurable via n8n workflow settings). Cron: `*/15 * * * *`

2. **HTTP Request node — GetAppointments:**
   ```xml
   <!-- SOAP envelope for GetAppointments -->
   <soapenv:Envelope
     xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
     xmlns:int="http://www.kareo.com/api/schemas/">
     <soapenv:Header/>
     <soapenv:Body>
       <int:GetAppointments>
         <int:request>
           <int:RequestHeader>
             <int:UserName>{{ $credentials.tebraUsername }}</int:UserName>
             <int:Password>{{ $credentials.tebraPassword }}</int:Password>
             <int:CustomerKey>{{ $credentials.tebraCustomerKey }}</int:CustomerKey>
           </int:RequestHeader>
           <int:Filter>
             <int:StartDate>{{ $now.format('YYYY-MM-DD') }}</int:StartDate>
             <int:EndDate>{{ $now.format('YYYY-MM-DD') }}</int:EndDate>
           </int:Filter>
         </int:GetAppointments>
       </int:request>
     </soapenv:Body>
   </soapenv:Envelope>
   ```
   - n8n HTTP Request node: Method=POST, URL=`https://webservice.kareo.com/services/soap/2.1/KareoServices.svc`
   - Header: `Content-Type: text/xml; charset=utf-8`, `SOAPAction: "GetAppointments"`
   - Authentication: Credentials stored in n8n encrypted credential vault (type: Generic Credential, fields: UserName, Password, CustomerKey)

3. **Code node — Parse and strip PHI:**
   ```javascript
   // n8n Code node (JavaScript mode)
   const parser = require('fast-xml-parser');
   const responseXml = $input.first().json.data;  // raw SOAP XML
   const parsed = parser.parse(responseXml);

   // Navigate to appointment list (path varies by Tebra API version — verify during implementation)
   const appointments = parsed?.Envelope?.Body?.GetAppointmentsResponse?.GetAppointmentsResult?.Appointments?.Appointment || [];
   const apptArray = Array.isArray(appointments) ? appointments : [appointments];

   return apptArray.map(appt => ({
     appointment_id: appt.ID,
     patient_first_name: appt.PatientFirstName,  // ONLY first name — never write LastName
     appointment_time: appt.StartDateTime,         // ISO datetime
     appointment_type: appt.PracticeAppointmentTypeName,
     appointment_date: appt.StartDateTime.split('T')[0],
     // NEVER include: LastName, DOB, InsuranceID, CPT codes, DiagnosisCode, Notes
   }));
   ```

4. **Supabase upsert node:** Upserts each appointment row into `tebra_appointments` by `appointment_id`. Existing rows updated, new rows inserted.

5. **Set `tebra_integration_tier`:** After successful sync, n8n PATCH `dashboard_settings` row `tebra_integration_tier = 'api'` and `tebra_last_sync = NOW()`.

**n8n workflow: Billing sync (GetTransactions)**

1. **Schedule Trigger:** Fires every 30 minutes (billing data changes less frequently than appointments). Cron: `*/30 * * * *`

2. **HTTP Request node — GetTransactions:**
   ```xml
   <int:GetTransactions>
     <int:request>
       <int:RequestHeader>
         <int:UserName>{{ $credentials.tebraUsername }}</int:UserName>
         <int:Password>{{ $credentials.tebraPassword }}</int:Password>
         <int:CustomerKey>{{ $credentials.tebraCustomerKey }}</int:CustomerKey>
       </int:RequestHeader>
       <int:Filter>
         <int:FromDate>{{ $now.minus({days: 30}).format('YYYY-MM-DD') }}</int:FromDate>
         <int:ToDate>{{ $now.format('YYYY-MM-DD') }}</int:ToDate>
         <int:TransactionType>Charge</int:TransactionType>
       </int:Filter>
     </int:GetTransactions>
   ```

3. **Code node — Aggregate billing metrics (PHI stripping + aggregation):**
   ```javascript
   const transactions = // ... parse SOAP XML ...

   const today = new Date();
   let claims_submitted = 0, claims_denied = 0;
   let ar_current = 0, ar_30 = 0, ar_60 = 0, ar_90plus = 0;

   for (const tx of transactions) {
     claims_submitted++;
     const age = Math.floor((today - new Date(tx.ServiceDate)) / 86400000);  // days
     const balance = parseFloat(tx.Balance || 0);

     if (tx.DenialCode) claims_denied++;

     // AR aging buckets (by balance age)
     if (age < 30)         ar_current += balance;
     else if (age < 60)    ar_30 += balance;
     else if (age < 90)    ar_60 += balance;
     else                  ar_90plus += balance;

     // NEVER include: PatientID, PatientName, DOB, InsuranceID, CPT, DiagnosisCode
   }

   const denial_rate = claims_submitted > 0 ? (claims_denied / claims_submitted * 100).toFixed(1) : 0;

   return [{
     period: today.toISOString().split('T')[0].substring(0, 7),  // "YYYY-MM"
     claims_submitted, claims_denied, denial_rate: parseFloat(denial_rate),
     ar_current, ar_30, ar_60, ar_90plus,
     total_ar: ar_current + ar_30 + ar_60 + ar_90plus,
     synced_at: new Date().toISOString(),
     sync_method: 'api'
   }];
   ```

4. **Supabase upsert node:** Upserts into `tebra_billing_summary` by `period` (YYYY-MM). One row per month.

**HIPAA compliance options for n8n (developer chooses based on risk tolerance):**

| Option | Description | HIPAA posture |
|--------|-------------|---------------|
| **A — Stateless passthrough** | Set `EXECUTIONS_DATA_SAVE_ON_SUCCESS=false` in n8n environment. PHI passes through n8n memory only, never persisted to disk. | Acceptable if n8n is self-hosted in a secure environment. Document in risk assessment. |
| **B — Keragon** | Use Keragon (HIPAA-native automation platform) instead of n8n. Keragon offers BAA and HIPAA-certified infrastructure. | Preferred if BAA documentation is required for audit. Additional cost. |

The spec recommends Option A for initial implementation (PHI is first-name only — minimal PHI surface), with upgrade path to Keragon if auditors require BAA coverage for the automation layer.

**Tebra setup steps:**
1. Log into Tebra portal → Help → Get Customer Key (or Settings → API Keys)
2. Create a dedicated API user with read-only role (minimum necessary access)
3. Store CustomerKey, Username, Password in n8n credential vault (Credential Type: Generic — do NOT store in n8n environment variables)
4. Test with a single GetAppointments call for today's date — verify response includes appointments and that patient first names are extractable
5. Confirm SOAP endpoint URL: `https://webservice.kareo.com/services/soap/2.1/KareoServices.svc` (verify with Tebra support if endpoint changes)

---

#### 8A.3 Tier 2 — Tebra CSV Export (Fallback)

**Use when:** Tebra API access is not feasible (cost, permissions, technical blockers). Valentina or Maxi manually exports reports from Tebra on a schedule, drops them in a monitored folder.

**Manual export steps from Tebra:**
- **Appointments report:** Tebra → Reports → Appointments → Daily Schedule → Export to CSV. Filter: today's date. Include columns: Patient First Name, Appointment Date, Start Time, Appointment Type. Export frequency: daily (morning).
- **Billing report:** Tebra → Reports → Billing → Accounts Receivable → Export to CSV. Filter: last 30 days. Include columns: Service Date, Charge Amount, Payment Amount, Denial Code, Balance. Export frequency: weekly.

**n8n workflow: CSV watch + import**

1. **Trigger (choose one):**
   - **Google Drive File Trigger:** Monitor a specific shared folder (e.g., `Brighter Days / Dashboard Exports /`). Trigger fires when a new file is created matching `*appointments*.csv` or `*billing*.csv`
   - **Schedule Trigger + Drive Read:** Check folder for new files every 30 minutes using Google Drive List Files node

2. **Google Drive Download node:** Download the CSV file bytes.

3. **Code node — Parse CSV + PHI strip (same rules as Tier 1):**
   ```javascript
   // Appointments CSV:
   const rows = $input.first().json.data.split('\n').map(r => r.split(','));
   const headers = rows[0];
   return rows.slice(1).filter(r => r.length > 1).map(row => ({
     patient_first_name: row[headers.indexOf('Patient First Name')].trim(),
     appointment_time: row[headers.indexOf('Start Time')].trim(),
     appointment_date: row[headers.indexOf('Appointment Date')].trim(),
     appointment_type: row[headers.indexOf('Appointment Type')].trim(),
     appointment_id: `CSV_${row[headers.indexOf('Appointment Date')]}_${row[headers.indexOf('Start Time')]}`,  // synthetic ID
     // NEVER include LastName, DOB, Insurance columns
   }));
   ```

4. **Supabase upsert:** Identical to Tier 1 — upserts into same `tebra_appointments` and `tebra_billing_summary` tables. Downstream behavior is identical.

5. **Mark sync method:** PATCH `dashboard_settings.tebra_integration_tier = 'csv'` and `tebra_last_sync = NOW()`.

6. **Archive processed file:** Move CSV from `/Dashboard Exports/` to `/Dashboard Exports/Processed/` (Google Drive Move node) to prevent re-import on next cycle.

**Shared folder setup:**
- Create Google Drive folder: `Brighter Days > Dashboard Exports` — shared with both Valentina's and Maxi's Google accounts
- Both Valentina and Maxi can drop exports here; n8n picks them up automatically
- Files older than 7 days in `Processed/` can be deleted automatically (optional n8n cleanup step)

---

#### 8A.4 Tier 3 — Manual Data Entry (Last Resort)

**Use when:** Neither API nor CSV export is feasible (rare — this is truly a last resort).

Panel 5 (Appointments) and Panel 6 (Billing) switch to editable input mode, controlled by `tebra_integration_tier = 'manual'` in `dashboard_settings`.

**Appointments entry form (Panel 5 in manual mode):**
```
+================================================+
|  TODAY'S APPOINTMENTS        [MANUAL] [SAVE]  |
|  ─────────────────────────────────────────── |
|  Patient First Name:  [_________________]    |
|  Appointment Time:    [HH:MM] [AM] / [PM]    |
|                       [+ ADD APPOINTMENT]    |
|                                              |
|  Entered:                                   |
|    Alex      —  9:00 AM                     |
|    Jordan    —  11:30 AM     [DEL]          |
|    Casey     —  2:00 PM      [DEL]          |
+================================================+
```

- Each field is a Text COMP (touchscreen keyboard input) or Button COMPs for time picker
- `[+ ADD APPOINTMENT]` writes to `tebra_appointments` with `sync_method = 'manual'`
- `synced_at` field displays "Manual entry — [timestamp]" in the panel footer
- `[DEL]` removes a manually-entered appointment (DELETE to Supabase by `appointment_id`)

**Billing metrics entry form (Panel 6 in manual mode):**
```
+================================================+
|  BILLING OVERSIGHT           [MANUAL] [SAVE]  |
|  ─────────────────────────────────────────── |
|  Claims Submitted:  [____]                   |
|  Claims Denied:     [____]                   |
|  AR Current (<30d): $[_________]             |
|  AR 30-60d:         $[_________]             |
|  AR 60-90d:         $[_________]             |
|  AR 90+d:           $[_________]             |
+================================================+
```

- Maxi enters weekly totals manually (typically from Tebra reports reviewed via email or browser)
- `[SAVE]` writes a single row to `tebra_billing_summary` for current month, `sync_method = 'manual'`
- Partial entry is allowed — empty fields saved as 0, not NULL, to distinguish from missing data

---

### 8B: Panel 5 — Appointments Display (DASH-05 Visualization)

#### 8B.1 Container COMP

`panel_appointments` — positioned bottom-center in the dashboard grid (see Section 2.3 layout coordinates). Dimensions: 480 × 240 px at 2560×1440 (960 × 480 at 3840×2160).

#### 8B.2 Data Source

`dat_appointments` Web Client DAT polls Supabase:
```
GET /rest/v1/tebra_appointments
  ?select=patient_first_name,appointment_time,appointment_type
  &appointment_date=eq.{TODAY_DATE}
  &order=appointment_time.asc
```

Today's date is computed in Python: `datetime.date.today().isoformat()`. If today is Saturday or Sunday, query uses next Monday's date (configurable: `dashboard_settings.show_next_business_day_on_weekends = 'true'`).

#### 8B.3 Display Format (Read-Only Mode — Tiers 1 & 2)

Chronological list of today's appointments with first name and time only:

```
+================================================+
|  TODAY'S APPOINTMENTS              [API] 9:42 |
|  ─────────────────────────────────────────── |
|                                               |
|  9:00 AM   Alex        —  Initial Intake      |
|  11:30 AM  Jordan      —  Follow-Up           |
|  2:00 PM   Casey       —  Follow-Up           |
|  3:30 PM   Riley       —  Initial Intake      |
|                                               |
|  4 appointments today                         |
+================================================+
```

- Format per row: `{HH:MM AM/PM}  {FirstName}  —  {appointment_type}` (or omit type if column missing)
- Last refresh time shown in header: `9:42` (HH:MM in panel's local timezone)
- Tier badge (`[API]`, `[CSV]`, or `[MANUAL]`) in header — driven by `tebra_integration_tier`

**PHI scope reminder (spec note for developer):** `patient_first_name` only. The `tebra_appointments` table must never contain `patient_last_name`, `patient_dob`, `insurance_id`, `diagnosis_code`, or any clinical notes. PHI stripping happens in n8n (Tiers 1–2) before writing to Supabase. The Supabase schema enforces this by not having those columns.

#### 8B.4 Empty State

When no appointments found for today:
```
|  No appointments scheduled today              |
|  (or appointment sync not yet completed)      |
```

Displayed in dim CYAN (consistent with empty states across other panels).

#### 8B.5 Refresh

Inherits the global polling cycle (Timer CHOP onCycle, default 15-min interval). A `[REFRESH]` button in the panel header triggers immediate `dat_appointments` pulse.

#### 8B.6 Animation States

| State | Trigger | Animation |
|-------|---------|-----------|
| IDLE | Appointments loaded, none starting soon | Border: sine wave 0.2Hz, subtle CYAN |
| UPCOMING | Next appointment < 15 minutes away | Border: square wave 0.5Hz, GREEN |
| LOADING | Fetching data | Spinner `|/-\` in header |
| MANUAL | `tebra_integration_tier = 'manual'` | Input fields visible, read-only list hidden |

---

### 8C: Panel 6 — Billing Oversight (DASH-06)

#### 8C.1 Purpose

Monitor third-party biller activity — oversight, not direct billing. Dr. Park does not process claims directly; the dashboard shows whether the biller is performing effectively. The billing panel answers: "How many claims were submitted? How many denied? How much money is sitting uncollected and for how long?"

#### 8C.2 Container COMP

`panel_billing` — positioned bottom-right in the main area (see Section 2.3 layout coordinates). Dimensions: 480 × 240 px at 2560×1440 (960 × 480 at 3840×2160).

#### 8C.3 Data Source

`dat_billing` Web Client DAT polls Supabase:
```
GET /rest/v1/tebra_billing_summary
  ?select=*
  &order=period.desc
  &limit=2
```

Returns current month and previous month rows. Python computes month-over-month deltas.

#### 8C.4 Display Layout

```
+================================================+
|  BILLING OVERSIGHT                 [CSV] 9:42 |
|  ─────────────────────────────────────────── |
|                                               |
|  Claims Submitted:   47   (+3 vs last month)  |
|  Claims Denied:       4   (8.5%)  [AMBER]     |
|                                               |
|  AR Aging:                                    |
|  Current  [###########.....] $12,400          |
|  30-60d   [######..........] $6,800           |
|  60-90d   [###.............] $3,100           |
|  90+d     [#...............] $900   [RED]     |
|                                               |
|  Total AR:  $23,200   Last sync: 3h ago       |
+================================================+
```

**Claims row:**
- `claims_submitted` count for current month period
- Delta from previous month: `(+N vs last month)` or `(-N vs last month)` in dim text
- `claims_denied` count + denial rate percentage `(X.X%)`
- Denial rate color coding: < 5% = normal (dim text), 5–10% = AMBER, > 10% = RED

**AR aging bar chart:** ASCII progress bars using `#` and `.` characters, 16 characters wide. Bar width is proportional to the bucket's share of total AR:
```python
def ar_bar(amount, total_ar, width=16):
    if total_ar == 0 or amount == 0:
        return '.' * width
    filled = round((amount / total_ar) * width)
    return '#' * filled + '.' * (width - filled)
```

- AR 90+d > $0: always displayed in RED (per spec — no exceptions, any uncollected 90+d AR is a risk signal)
- AR 90+d = $0: displayed in GREEN

**Last sync display:** `Last sync: {N}h ago` — computed from `tebra_billing_summary.synced_at` vs. current time. If `sync_method = 'manual'`, displays `Manual entry — {date}` instead.

#### 8C.5 Month-over-Month Delta Calculation

```python
# dat_billing returns 2 rows: [0] = current month, [1] = previous month
def compute_billing_display(current, previous):
    delta_submitted = current['claims_submitted'] - previous.get('claims_submitted', 0)
    delta_sign = '+' if delta_submitted >= 0 else ''
    delta_str = f"({delta_sign}{delta_submitted} vs last month)"

    denial_rate = current['denial_rate']
    if denial_rate > 10.0:
        denial_color = 'RED'
    elif denial_rate > 5.0:
        denial_color = 'AMBER'
    else:
        denial_color = 'NORMAL'

    ar_90plus_color = 'RED' if current['ar_90plus'] > 0 else 'GREEN'

    return {
        'claims_submitted': current['claims_submitted'],
        'delta_str': delta_str,
        'claims_denied': current['claims_denied'],
        'denial_rate': f"{denial_rate:.1f}%",
        'denial_color': denial_color,
        'ar_current': current['ar_current'],
        'ar_30': current['ar_30'],
        'ar_60': current['ar_60'],
        'ar_90plus': current['ar_90plus'],
        'total_ar': current['total_ar'],
        'ar_90plus_color': ar_90plus_color,
    }
```

#### 8C.6 Tier 3 Mode (Manual Entry)

When `tebra_integration_tier = 'manual'`, the panel replaces the read-only display with the editable form described in Section 8A.4. A `[SWITCH TO MANUAL]` button appears in the panel header at all times, allowing Maxi to override to manual mode even when API or CSV sync is configured (useful during sync failures).

#### 8C.7 HIPAA Note

The billing panel displays only aggregate metrics. No patient names, no individual claim details, no CPT codes, no insurance member IDs appear anywhere on this panel or in the underlying `tebra_billing_summary` table. All aggregation occurs in n8n (Tier 1/2) before writing to Supabase.

A printed copy or screenshot of the billing panel is not PHI. However, the physical monitor displaying the panel must still follow the physical security guidelines in Section 4.14, since the appointments panel (showing first names) may be visible at the same time.

#### 8C.8 Animation States

| State | Trigger | Animation |
|-------|---------|-----------|
| IDLE | Normal billing activity | Border: sine wave 0.2Hz, subtle CYAN |
| WARNING | Denial rate 5–10% OR AR 90+d > $0 | Border: square wave 0.5Hz, AMBER |
| ALERT | Denial rate > 10% | Border: square wave 2Hz, RED |
| STALE | `synced_at` older than 2x polling interval | Border dim, `[STALE DATA]` indicator in header |
| MANUAL | `tebra_integration_tier = 'manual'` | Input form visible |

#### 8C.9 Supabase Table DDL Reference

The `tebra_appointments` and `tebra_billing_summary` tables are defined with complete DDL in Section 9 (Plan 03). The columns required by this section are:

**`tebra_appointments` required columns:**
| Column | Type | Notes |
|--------|------|-------|
| `appointment_id` | text | Primary key. SOAP API: native ID. CSV: synthetic `CSV_{date}_{time}`. Manual: `MANUAL_{uuid}` |
| `patient_first_name` | text | ONLY first name — never last name |
| `appointment_time` | timestamptz | Full ISO datetime with timezone |
| `appointment_date` | date | Extracted date (for WHERE filter) |
| `appointment_type` | text | "Initial Intake", "Follow-Up", etc. |
| `sync_method` | text | `'api'` / `'csv'` / `'manual'` |
| `synced_at` | timestamptz | When this row was written to Supabase |

**`tebra_billing_summary` required columns:**
| Column | Type | Notes |
|--------|------|-------|
| `period` | text | Primary key. Format: `YYYY-MM` (e.g., `2026-03`) |
| `claims_submitted` | integer | Count of claims submitted this month |
| `claims_denied` | integer | Count of denied claims |
| `denial_rate` | numeric(5,2) | Percentage, pre-computed by n8n |
| `ar_current` | numeric(10,2) | AR balance aged < 30 days |
| `ar_30` | numeric(10,2) | AR balance aged 30–59 days |
| `ar_60` | numeric(10,2) | AR balance aged 60–89 days |
| `ar_90plus` | numeric(10,2) | AR balance aged 90+ days |
| `total_ar` | numeric(10,2) | Sum of all AR buckets |
| `sync_method` | text | `'api'` / `'csv'` / `'manual'` |
| `synced_at` | timestamptz | When this row was written/updated |

Full DDL (CREATE TABLE statements) for both tables is in Section 9 (Plan 03).

---

## Section 9: Panel 7 — Action Buttons (DASH-07)

### 9.1 Purpose

This panel is what makes the dashboard a command center rather than just a display. The four action buttons trigger real automations — checking CAQH status, generating compliance reports, polling payer portals, and sending patient communications. Every button press initiates a real-world action with a traceable audit trail in `automation_log`.

**Container COMP:** `panel_actions` — positioned bottom-left spanning two columns (see Section 2.3 layout coordinates). Dimensions: 1707 × 500 px at 2560×1440 (2559 × 750 at 3840×2160).

---

### 9.2 Operators Inside panel_actions

| Operator | Type | Purpose |
|----------|------|---------|
| `text_header_actions` | Text TOP | Panel title: "COMMAND CENTER" |
| `button_caqh_check` | Button COMP | Trigger CAQH Re-Attestation Check automation |
| `button_compliance_report` | Button COMP | Trigger Compliance Report generation |
| `button_payer_status` | Button COMP | Trigger Payer Status Check across portals |
| `button_send_comms` | Button COMP | Open confirmation dialog for Send Communication |
| `text_badge_caqh` | Text TOP | Inline status badge for CAQH CHECK button |
| `text_badge_report` | Text TOP | Inline status badge for COMPLIANCE REPORT button |
| `text_badge_payer` | Text TOP | Inline status badge for PAYER STATUS button |
| `text_badge_comms` | Text TOP | Inline status badge for SEND COMMS button |
| `container_confirm_dialog` | Container COMP | Confirmation overlay (hidden by default, shown for CONFIRM REQUIRED actions) |
| `webClient_action_post` | Web Client DAT | POSTs webhook payloads to n8n when buttons clicked |
| `webClient_action_poll` | Web Client DAT | Quick-polls `automation_log` 5 seconds after any button press |
| `execute_action_state` | DAT Execute | Watches `webClient_action_poll` response, updates badge states |
| `timer_post_action_poll` | Timer CHOP | Mode=Once, Length=5 — fires 5 seconds after any button press to trigger quick poll |
| `timer_badge_reset_failed` | Timer CHOP | Mode=Once, Length=30 — resets FAILED badges back to IDLE after 30 seconds |
| `pattern_idle_breath` | Pattern CHOP | Sine wave 0.2 Hz — idle border animation |
| `pattern_alert_pulse` | Pattern CHOP | Square wave 1 Hz — alert border animation |
| `execute_state_actions` | DAT Execute | Manages panel animation state |

---

### 9.3 Button Flow: From Click to Result

Every button press follows this flow:

```
1. User clicks Button COMP in panel_actions
2. Panel Execute DAT onOffToOn callback fires
3. Python builds JSON payload dict
4. Python sets webClient_action_post URL to n8n webhook URL
5. Python sets webClient_action_post Method = POST, Body = JSON payload
6. Python calls webClient_action_post.par.request.pulse()
7. Button's inline badge transitions: IDLE → RUNNING
8. timer_post_action_poll starts (5 second countdown)
9. n8n receives POST, executes workflow, writes result to automation_log
10. timer_post_action_poll fires → webClient_action_poll pulse (quick-poll automation_log)
11. execute_action_state reads latest automation_log row for this action_type
12. If status='completed': badge transitions RUNNING → DONE
13. If status='failed': badge transitions RUNNING → FAILED (holds 30s, then IDLE)
```

**Web Client DAT POST configuration (webClient_action_post):**
```
Method: POST
URL: {set dynamically per button — n8n webhook URL}
Body: {JSON string — set dynamically per button}
Headers (via table_header_credentials):
  apikey: {service_role_key}
  Authorization: Bearer {service_role_key}
  Content-Type: application/json
```

**Quick-poll URL (webClient_action_poll):**
```
Method: GET
URL: https://{project-ref}.supabase.co/rest/v1/automation_log
  ?action_type=eq.{last_action_type}
  &order=triggered_at.desc
  &limit=1
```

---

### 9.4 Button 1: CAQH Re-Attestation Check

**Label:** `[ CAQH CHECK ]`
**Confirmation tier:** IMMEDIATE (read-only check — does not modify any state, only reads CAQH portal and writes the result)
**n8n webhook URL:** `https://{n8n_host}/webhook/caqh-recheck`

**JSON payload:**
```json
{
  "action": "caqh_recheck",
  "triggered_by": "dashboard_button",
  "triggered_at": "{ISO timestamp}"
}
```

**n8n workflow actions:**
1. Authenticate to CAQH ProView (proview.caqh.org) using stored credentials
2. Scrape or query attestation status — check days until next attestation deadline
3. Write result to `automation_log` (status: `completed` or `failed`, details: attestation date or error)
4. If new attestation date found: PATCH `credentials` table CAQH row `expiry_date = {found_date + 120 days}`
5. Write completion timestamp to `automation_log.completed_at`

**Python (Panel Execute DAT — button_caqh_check onOffToOn):**
```python
import datetime

def onOffToOn(channel, sampleIndex, val, prev):
    payload = {
        "action": "caqh_recheck",
        "triggered_by": "dashboard_button",
        "triggered_at": datetime.datetime.utcnow().isoformat() + "Z"
    }
    import json
    wc = op('webClient_action_post')
    wc.par.url = 'https://{n8n_host}/webhook/caqh-recheck'
    wc.par.submitbody = json.dumps(payload)
    wc.par.method = 'POST'
    wc.par.request.pulse()
    # Set badge to RUNNING
    setBadgeState('caqh', 'RUNNING')
    # Store last action type for quick-poll
    parent().store('last_action_type', 'caqh_recheck')
    # Start 5-second poll timer
    op('timer_post_action_poll').par.start.pulse()
```

**Result display (if DONE):** Badge shows `[ CAQH CHECK OK ]` in GREEN. Tooltip (via Text TOP adjacent to badge, shown on hover — or always-visible sub-text): `"Last attested: {date}  Next due: {date}"`. Next refresh cycle will update compliance panel CAQH row with new expiry date.

**Result display (if FAILED):** Badge shows `[ CAQH CHECK ERR ]` in RED. `timer_badge_reset_failed` starts (30-second countdown). After 30 seconds, badge returns to IDLE. Error detail is visible in Automation Tracker (Panel 8).

---

### 9.5 Button 2: Generate Compliance Report

**Label:** `[ COMPLIANCE REPORT ]`
**Confirmation tier:** IMMEDIATE (generates a document — read-only query of Supabase, no external state modification)
**n8n webhook URL:** `https://{n8n_host}/webhook/compliance-report`

**JSON payload:**
```json
{
  "action": "compliance_report",
  "triggered_by": "dashboard_button",
  "triggered_at": "{ISO timestamp}"
}
```

**n8n workflow actions:**
1. Query `credential_alert_queue` — get all credentials with alert levels
2. Query `payer_credentialing_alerts` — get all payer re-cred urgency data
3. Query `obligations` — get all active and overdue obligations
4. Generate formatted markdown or PDF report covering: credential summary, payer re-cred status, obligation checklist, HIPAA compliance flags
5. Save report to designated Google Drive folder (`Brighter Days / Compliance Reports / report-{YYYY-MM-DD}.pdf`)
6. Write file URL to `automation_log.details`
7. Write `status='completed'` to `automation_log`

**Result display (if DONE):** Badge shows `[ COMPLIANCE REPORT OK ]` in GREEN. Automation Tracker entry shows: `[HH:MM] COMPLIANCE REPORT .......... OK (report-2026-03-01.pdf)`. The file URL in `automation_log.details` is visible when expanding the tracker entry.

**Result display (if FAILED):** Badge shows `[ COMPLIANCE REPORT ERR ]` in RED. Holds 30 seconds then resets to IDLE.

---

### 9.6 Button 3: Trigger Payer Status Checks

**Label:** `[ PAYER STATUS ]`
**Confirmation tier:** IMMEDIATE (read-only checks across payer portals — no state modification beyond writing automation_log and updating payer_tracker if new info found)
**n8n webhook URL:** `https://{n8n_host}/webhook/payer-status-check`

**JSON payload:**
```json
{
  "action": "payer_status_check",
  "triggered_by": "dashboard_button",
  "triggered_at": "{ISO timestamp}"
}
```

**n8n workflow actions:**
1. For each payer in `payer_tracker` with a `portal_url` value, check credentialing status via web automation (where feasible)
2. Write summary of results to `automation_log.details` (e.g., `"Checked 6/17 payers — 5 active, 1 pending. 11 payers require manual portal login."`)
3. If new contract or re-cred date found for any payer: PATCH `payer_tracker` row with updated data
4. Write `status='completed'` to `automation_log`

**Automation caveat (IMPORTANT):** Many payer portals require manual login with 2FA or do not have automated check endpoints. The initial n8n implementation may only automate a subset of the 17 payers. The `automation_log.details` field documents which payers were checked vs. which require manual action. The developer should note which portals are automatable in the n8n workflow documentation.

**Result display:** Badge shows `[ PAYER STATUS OK ]` in GREEN. Tracker shows status with count of portals checked.

---

### 9.7 Button 4: Send Patient Communications

**Label:** `[ SEND COMMS ]`
**Confirmation tier:** CONFIRM REQUIRED — this button sends an external email and must not fire accidentally. A confirmation dialog overlay is required before the webhook fires.

**Flow:**
1. User clicks `[ SEND COMMS ]` button
2. `container_confirm_dialog` overlay appears (centered on screen, PANEL_BG background with 70% opacity dark overlay behind)
3. User selects communication type and enters recipient info
4. User clicks `[ CONFIRM SEND ]` → webhook fires
5. User clicks `[ CANCEL ]` → dialog closes, no action taken

**Confirmation dialog spec (container_confirm_dialog):**

```
+===================================================+
|  SEND PATIENT COMMUNICATION                       |
+===================================================+
|                                                   |
|  Communication Type:                              |
|    [INTAKE PACKET] [APPOINTMENT REMINDER]         |
|    [CONSENT FORMS]                                |
|                                                   |
|  Recipient First Name:  [________________]        |
|  Recipient Email:       [________________]        |
|                                                   |
|  ─────────────────────────────────────────────   |
|  PREVIEW:                                         |
|  "Hello {name}, please find attached..."          |
|                                                   |
|  ─────────────────────────────────────────────   |
|                                                   |
|         [ CONFIRM SEND ]     [ CANCEL ]           |
|                                                   |
+===================================================+
```

**Dialog operators:**
| Operator | Type | Purpose |
|----------|------|---------|
| `text_dialog_header` | Text TOP | "SEND PATIENT COMMUNICATION" in active border |
| `button_type_intake` | Button COMP | Select "Intake Packet" comm type |
| `button_type_reminder` | Button COMP | Select "Appointment Reminder" comm type |
| `button_type_consent` | Button COMP | Select "Consent Forms" comm type |
| `text_input_first_name` | Text COMP | Recipient first name input field |
| `text_input_email` | Text COMP | Recipient email input field |
| `text_preview` | Text TOP | Template preview text (updates based on comm type selection) |
| `button_confirm_send` | Button COMP | GREEN — triggers webhook |
| `button_cancel` | Button COMP | RED — closes dialog, no action |

**n8n webhook URL (fired on Confirm):** `https://{n8n_host}/webhook/send-communication`

**JSON payload (fired on Confirm):**
```json
{
  "action": "send_communication",
  "comm_type": "{intake_packet | appointment_reminder | consent_forms}",
  "recipient_email": "{email entered by user}",
  "recipient_first_name": "{first name entered by user}",
  "triggered_by": "dashboard_button",
  "triggered_at": "{ISO timestamp}"
}
```

**PHI handling note:** The email address entered in the dialog is sent in the webhook payload to n8n and used for email delivery. It is NOT stored in Supabase. The `automation_log` row records only the `action_type` (`send_communication`), `comm_type`, and `triggered_at` — not the recipient email or first name. This keeps patient contact info out of the dashboard data layer.

**n8n workflow actions:**
1. Receive webhook payload
2. Select email template based on `comm_type`
3. Send templated email via SendGrid (or n8n Email node) to `recipient_email`
4. Write `status='completed'` or `status='failed'` to `automation_log` — details field includes `comm_type` and anonymized result (`"sent to [email]"` — note: including email in details field is acceptable since automation_log is not patient record; developer may omit if preferred)
5. Do NOT write `recipient_email` to any Supabase table other than `automation_log.details` (optional)

**Google Workspace requirement:** The SendGrid account or n8n Email node must use a Google Workspace–based sender address (`@brighterdays...` domain) with active BAA. Consumer Gmail sender addresses cannot be used for patient communications (HIPAA violation). This is a pre-launch blocker documented in Section 11B.

**Python (Panel Execute DAT — button_send_comms onOffToOn):**
```python
def onOffToOn(channel, sampleIndex, val, prev):
    # Show confirmation dialog — DO NOT fire webhook yet
    op('container_confirm_dialog').par.display = 1
    # Reset dialog fields
    parent().store('comm_type', None)
    op('text_input_first_name').par.text = ''
    op('text_input_email').par.text = ''
    op('text_preview').par.text = 'Select a communication type above to see preview'
```

**Python (button_confirm_send onOffToOn):**
```python
import datetime, json

def onOffToOn(channel, sampleIndex, val, prev):
    comm_type = parent().fetch('comm_type', None)
    first_name = op('text_input_first_name').par.text
    email = op('text_input_email').par.text

    if not comm_type or not first_name or not email:
        op('text_preview').par.text = 'ERROR: All fields required before sending.'
        return

    payload = {
        "action": "send_communication",
        "comm_type": comm_type,
        "recipient_email": email,
        "recipient_first_name": first_name,
        "triggered_by": "dashboard_button",
        "triggered_at": datetime.datetime.utcnow().isoformat() + "Z"
    }
    wc = op('webClient_action_post')
    wc.par.url = 'https://{n8n_host}/webhook/send-communication'
    wc.par.submitbody = json.dumps(payload)
    wc.par.method = 'POST'
    wc.par.request.pulse()
    # Hide dialog, set badge to RUNNING
    op('container_confirm_dialog').par.display = 0
    setBadgeState('comms', 'RUNNING')
    parent().store('last_action_type', 'send_communication')
    op('timer_post_action_poll').par.start.pulse()
```

---

### 9.8 Inline Status Badge State Machine

Each button has a dedicated Text TOP badge (`text_badge_caqh`, `text_badge_report`, `text_badge_payer`, `text_badge_comms`). The badge transitions through four states:

**State machine:**
```
IDLE → (button pressed) → RUNNING → (n8n completes) → DONE
                                   → (n8n fails)    → FAILED → (30s timer) → IDLE
```

**Visual states per button (using CAQH CHECK as example):**

| State | Badge Text | Color | Animation |
|-------|-----------|-------|-----------|
| IDLE | `[ CAQH CHECK ]` | GREEN | None — static |
| RUNNING | `[ CAQH CHECK ... ]` | AMBER | Pattern CHOP (Square, 4Hz) drives character cycle `\|/-\` appended to label |
| DONE | `[ CAQH CHECK OK ]` | GREEN | 3-pulse flash (Timer CHOP Once, 3 segments), then static |
| FAILED | `[ CAQH CHECK ERR ]` | RED | Static for 30 seconds, then fade back to IDLE |

**Python setBadgeState function (shared utility in a Script DAT):**
```python
def setBadgeState(button_name, state):
    """
    button_name: 'caqh' | 'report' | 'payer' | 'comms'
    state: 'IDLE' | 'RUNNING' | 'DONE' | 'FAILED'
    """
    labels = {
        'caqh':   ('CAQH CHECK',        'CAQH CHECK ... ', 'CAQH CHECK OK ', 'CAQH CHECK ERR'),
        'report': ('COMPLIANCE REPORT', 'REPORT ...     ', 'REPORT OK      ', 'REPORT ERR    '),
        'payer':  ('PAYER STATUS',      'PAYER STATUS ..', 'PAYER STATUS OK', 'PAYER STATUS ER'),
        'comms':  ('SEND COMMS',        'SEND COMMS ... ', 'SEND COMMS OK  ', 'SEND COMMS ERR'),
    }
    colors = {
        'IDLE':    (0.0,  0.9,  0.2),   # GREEN
        'RUNNING': (1.0,  0.6,  0.0),   # AMBER
        'DONE':    (0.0,  0.9,  0.2),   # GREEN
        'FAILED':  (1.0,  0.1,  0.05),  # RED
    }
    state_idx = {'IDLE': 0, 'RUNNING': 1, 'DONE': 2, 'FAILED': 3}

    badge_op = op(f'text_badge_{button_name}')
    label_set = labels[button_name]
    color = colors[state]
    idx = state_idx[state]

    badge_op.par.text = f'[ {label_set[idx]} ]'
    badge_op.par.textcolorr = color[0]
    badge_op.par.textcolorg = color[1]
    badge_op.par.textcolorb = color[2]

    if state == 'FAILED':
        op('timer_badge_reset_failed').par.start.pulse()
    if state == 'DONE':
        op('timer_badge_flash_done').par.start.pulse()  # 3-pulse flash timer
```

**State driven by automation_log:** The `execute_action_state` DAT Execute watches `webClient_action_poll` responses. When `webClient_action_poll` receives data:
```python
def onReceiveResponse(webClientDAT, statusCode, headerDict, data, id):
    import json
    if statusCode != 200:
        return
    rows = json.loads(data)
    if not rows:
        return
    row = rows[0]  # Latest log entry for this action_type
    status = row.get('status', 'pending')
    action_type = row.get('action_type', '')

    # Map action_type to button_name
    button_map = {
        'caqh_recheck': 'caqh',
        'compliance_report': 'report',
        'payer_status_check': 'payer',
        'send_communication': 'comms',
    }
    button_name = button_map.get(action_type)
    if not button_name:
        return

    if status == 'completed':
        setBadgeState(button_name, 'DONE')
    elif status == 'failed':
        setBadgeState(button_name, 'FAILED')
    # If status == 'running' or 'pending': no change needed (badge already shows RUNNING)
```

---

### 9.9 Panel Layout

```
+#=====================================================================#+
|  COMMAND CENTER                                                        |
+#=====================================================================#+
|                                                                        |
|   [ CAQH CHECK ]           [ COMPLIANCE REPORT ]                      |
|   [ CAQH CHECK OK ]         Last run: 09:00                           |
|                                                                        |
|   [ PAYER STATUS ]          [ SEND COMMS ]                            |
|   [ PAYER STATUS OK ]        Last run: 08:45                          |
|                                                                        |
|   Tip: Click any button to trigger an automation. Results appear       |
|   in the Automation Tracker (right panel) within 30-60 seconds.       |
|                                                                        |
+#=====================================================================#+
```

Buttons are arranged in a 2×2 grid. Each button has its badge directly below it. The panel occupies the full bottom-left two-column span of the dashboard grid.

**Button COMP configuration:**
- Each Button COMP is styled as a large clickable region (not a physical button graphic — styled as a Text TOP with a border that changes on hover/click)
- Hover state: Border color brightens (CYAN), achieved via Panel Execute DAT watching `rollover` value
- Active (pressed) state: Border flashes WHITE once (INTERACTION state — Section 3.4)

---

## Section 10: Panel 8 — Automation Process Tracker (DASH-08)

### 10.1 Purpose

Full scrollable history of every automation triggered from the dashboard — what ran, when, whether it succeeded, and any details (file links, error messages, counts of items checked). This panel provides the audit trail and the operational feedback loop: Valentina can see at a glance whether last week's CAQH check succeeded or whether the compliance report is ready.

**Container COMP:** `panel_automation` — positioned bottom-right (see Section 2.3 layout coordinates). Dimensions: 852 × 500 px at 2560×1440 (1280 × 750 at 3840×2160).

---

### 10.2 Operators Inside panel_automation

| Operator | Type | Purpose |
|----------|------|---------|
| `text_header_automation` | Text TOP | Panel title: "AUTOMATION LOG" |
| `text_log_content` | Text TOP | Scrolling ASCII log of automation history |
| `table_automation_data` | Table DAT | Parsed `automation_log` rows from Supabase |
| `script_log_response` | Script DAT | Python: parse Web Client DAT JSON response into table_automation_data |
| `button_scroll_up` | Button COMP | Scroll log up (older entries) |
| `button_scroll_down` | Button COMP | Scroll log down (newer entries) |
| `container_log_detail` | Container COMP | Hidden detail overlay — expands on log entry click |
| `pattern_idle_breath` | Pattern CHOP | Sine wave 0.2 Hz — idle border animation |
| `pattern_alert_pulse` | Pattern CHOP | Square wave 1 Hz — alert border animation for FAILED entries |
| `execute_state_automation` | DAT Execute | Watches table_automation_data, manages scroll and state |
| `execute_detail_overlay` | DAT Execute | Manages log_detail overlay show/hide |

---

### 10.3 Data Source

**Supabase query (via webClient_automation_log in panel_grid):**
```
GET /rest/v1/automation_log
  ?select=id,action_type,triggered_at,triggered_by,status,details,completed_at
  &order=triggered_at.desc
  &limit=20
```

Returns the 20 most recent automation log entries, newest first.

**Quick-poll after button press (from panel_actions):** `webClient_action_poll` (in `panel_actions`) fires 5 seconds after any button click and updates `table_automation_data` in this panel. This ensures the RUNNING → DONE/FAILED transition appears promptly without waiting for the global refresh cycle.

**Refresh cadence:**
- Normal: Global polling cycle (Timer CHOP onCycle, default 30-min interval)
- Post-action: 5-second quick poll after any button press (triggered by `timer_post_action_poll` in `panel_actions`)

---

### 10.4 Display Format — Scrolling ASCII Log

Each entry in the automation log renders as a single line using dot-leader fill for alignment:

```
+================================================+
|  AUTOMATION LOG               [20 entries]    |
+================================================+
|                                                |
|  [14:32] CAQH CHECK ............... OK         |
|  [14:30] COMPLIANCE REPORT ......... OK        |
|  [09:15] PAYER STATUS .............. FAILED    |
|  [09:00] SEND COMMS ................ OK        |
|  [08:45] CAQH CHECK ................ OK        |
|  [Yesterday 14:00] COMPLIANCE REPORT .. OK     |
|                                                |
|  (scroll up for older entries)                 |
|                                               |
|  [^] scroll up                 [v] scroll down |
+================================================+
```

**Dot-leader fill:** Each log line uses dots between the action name and status to fill a fixed-width column (similar to a table of contents). The fill width is calculated so all status labels align in the rightmost column:

```python
def format_log_line(action_type, triggered_at, status, details=None):
    import datetime
    # Format time
    try:
        dt = datetime.datetime.fromisoformat(triggered_at.replace('Z', '+00:00'))
        # Convert to local time for display
        time_str = dt.strftime('[%H:%M]')
    except:
        time_str = '[??:??]'

    # Action type display name mapping
    action_labels = {
        'caqh_recheck': 'CAQH CHECK',
        'compliance_report': 'COMPLIANCE REPORT',
        'payer_status_check': 'PAYER STATUS',
        'send_communication': 'SEND COMMS',
        'credential_alert_email': 'CRED ALERT EMAIL',
        'obligation_autocomplete': 'AUTO-COMPLETE',
    }
    label = action_labels.get(action_type, action_type.upper()[:18])

    # Status display
    status_map = {
        'completed': 'OK',
        'failed': 'FAILED',
        'running': 'RUNNING...',
        'pending': 'PENDING...',
    }
    status_str = status_map.get(status, status.upper())

    # Optional short detail suffix
    detail_suffix = ''
    if details and status == 'completed':
        # Show first 20 chars of details in parentheses
        short = str(details)[:20].rstrip()
        detail_suffix = f' ({short})'

    # Dot-leader fill: total line width = 48 chars
    LINE_WIDTH = 48
    left_part = f'{time_str} {label}'
    right_part = f'{status_str}{detail_suffix}'
    dots_count = max(1, LINE_WIDTH - len(left_part) - len(right_part))
    dots = '.' * dots_count

    return f'{left_part} {dots} {right_part}'
```

**Color coding per status:**
- `OK` / `completed`: GREEN `(0.0, 0.9, 0.2)`
- `FAILED`: RED `(1.0, 0.1, 0.05)` — and triggers `pattern_alert_pulse` on the panel border
- `RUNNING...` / `PENDING...`: AMBER `(1.0, 0.6, 0.0)` with spinning indicator
- Timestamps and dot leaders: DIM_WHITE `(0.5, 0.5, 0.5)`

**Per-line color:** Because each log entry may have a different color, use one Text TOP per visible log line (up to 10 visible at a time), composited with Over TOP chain — consistent with the per-row approach in the compliance panel (Section 5.6).

---

### 10.5 Scroll Behavior

- Default: shows last 20 entries, newest at top. Panel displays ~8–10 entries in the visible area.
- `button_scroll_up`: shifts `log_scroll_offset` by +1 (shows older entries — earlier in time)
- `button_scroll_down`: shifts `log_scroll_offset` by -1 (shows newer entries — back to top)
- Auto-scroll: When new entry appears (detected by comparing `table_automation_data` row count or latest `triggered_at` vs previous), panel automatically scrolls back to top to show the new entry.

**Auto-scroll Python (in execute_state_automation):**
```python
_previous_top_id = None

def onTableChange(dat):
    global _previous_top_id
    if dat.numRows < 2:
        return
    current_top_id = dat[1, 'id'].val
    if current_top_id != _previous_top_id:
        # New entry appeared — reset to top
        parent().store('log_scroll_offset', 0)
        _previous_top_id = current_top_id
    rebuild_log_display(dat)
```

---

### 10.6 Expandable Detail Overlay

Clicking any log entry opens `container_log_detail` — a popup overlaying the bottom portion of the dashboard showing the full details for that automation run:

```
+=========================================================+
|  AUTOMATION DETAIL                               [CLOSE] |
+=========================================================+
|                                                          |
|  Action:         CAQH RE-ATTESTATION CHECK               |
|  Triggered:      2026-03-01T14:32:00Z                   |
|  Completed:      2026-03-01T14:32:47Z                   |
|  Duration:       47 seconds                              |
|  Triggered by:   dashboard_button                        |
|                                                          |
|  Status:         OK (completed)                          |
|                                                          |
|  Details:                                                |
|    Last attested: 2026-01-01. Next due: 2026-05-01.     |
|    Credentials table updated: CAQH expiry_date set.     |
|                                                          |
+=========================================================+
```

**Fields displayed:**
- `action_type` → human-readable label (use `action_labels` dict from Section 10.4)
- `triggered_at` → full ISO timestamp
- `completed_at` → full ISO timestamp (if available; `null` if still running or failed early)
- Duration: `completed_at - triggered_at` in seconds (or `"—"` if not completed)
- `triggered_by` → value from `automation_log.triggered_by` column
- `status` → full status string
- `details` → full text of `automation_log.details` column (unrestricted length in overlay, unlike the truncated version in the log line)

**Click detection:** A Panel Execute DAT on each log-line Button COMP (or Y-coordinate calculation for the log content area) detects which row was clicked. The clicked row's `id` is stored in Python and used to display the correct detail overlay content.

**Close button:** `[CLOSE]` button sets `container_log_detail.par.display = 0`.

---

### 10.7 Running Indicator in Log

When a log entry has `status='running'` or `status='pending'`, the status column shows an animated spinner:

```python
SPINNER = ['|', '/', '-', '\\']
_spin_idx = 0

def onValueChange(channel, sampleIndex, val, prev):
    global _spin_idx
    # Pattern CHOP (Square, 4Hz) drives this callback
    if channel.name == 'chan1' and val == 1:
        _spin_idx = (_spin_idx + 1) % 4
        # Find running/pending rows in table_automation_data and update their display
        rebuild_log_display_with_spinner(_spin_idx)
```

**Spinner display:** `RUNNING... |` → `RUNNING... /` → `RUNNING... -` → `RUNNING... \` cycling at 4 Hz.

---

### 10.8 Animation States for Automation Panel

| State | Trigger | Animation |
|-------|---------|-----------|
| IDLE | All entries are `completed` or `failed` | Border: sine wave 0.2Hz, subtle CYAN |
| RUNNING | Any entry has `status='running'` | Border: square wave 0.5Hz, AMBER + spinner in status column |
| FAILED | Latest entry has `status='failed'` | Border: square wave 1Hz, RED pulse (clears after 60s or next successful run) |
| LOADING | Web Client DAT fetching | Spinner in panel header |

---

### 10.9 automation_log Table DDL

The `automation_log` table must be created in Supabase before the dashboard can be used. This DDL should be run as part of the Phase 4 database migration:

```sql
-- automation_log: history of all dashboard-triggered and scheduled automations
CREATE TABLE automation_log (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    action_type     text NOT NULL,
        -- Values: 'caqh_recheck', 'compliance_report', 'payer_status_check',
        --         'send_communication', 'credential_alert_email', 'obligation_autocomplete'
    triggered_at    timestamptz NOT NULL DEFAULT now(),
    triggered_by    text NOT NULL DEFAULT 'dashboard_button',
        -- Values: 'dashboard_button', 'scheduled', 'auto'
    status          text NOT NULL DEFAULT 'pending',
        -- Values: 'pending', 'running', 'completed', 'failed'
    details         text,           -- Free-form result text (error message, file URL, summary)
    completed_at    timestamptz,    -- NULL until automation finishes (success or failure)
    created_at      timestamptz NOT NULL DEFAULT now()
);

-- Index for dashboard queries (newest first, filtered by action_type)
CREATE INDEX automation_log_triggered_at_idx ON automation_log (triggered_at DESC);
CREATE INDEX automation_log_action_type_idx ON automation_log (action_type, triggered_at DESC);

-- Row-level security: service role key has full access (consistent with other tables)
ALTER TABLE automation_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service role full access" ON automation_log
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');
```

**n8n automation_log write pattern:** Every n8n workflow triggered by a dashboard button must follow this write sequence:

```javascript
// Step 1: Write 'running' status immediately when webhook received
// (n8n Supabase node: INSERT into automation_log)
const log_id = uuid();
await supabase.from('automation_log').insert({
    id: log_id,
    action_type: payload.action,
    triggered_at: payload.triggered_at,
    triggered_by: payload.triggered_by,
    status: 'running'
});

// ... workflow executes ...

// Step 2: Update to 'completed' or 'failed' when done
await supabase.from('automation_log').update({
    status: 'completed',  // or 'failed'
    details: 'Result description here',
    completed_at: new Date().toISOString()
}).eq('id', log_id);
```

This two-step write ensures the dashboard badge transitions through RUNNING before settling on DONE or FAILED — providing real-time feedback even for long-running automations.

---

### 10.10 Full Phase 4 Supabase DDL Migration

All five new tables for Phase 4 in one migration script. Run against Supabase via the Management API (see developer notes in Section 11A, Step 7):

```sql
-- ============================================================
-- Phase 4: Brighter Days Dashboard — New Table DDL
-- Run once before first dashboard launch
-- ============================================================

-- 1. tebra_appointments: PHI-stripped appointment display data
CREATE TABLE tebra_appointments (
    appointment_id  text PRIMARY KEY,
        -- SOAP API: native Tebra appointment ID (integer as text)
        -- CSV: 'CSV_{YYYY-MM-DD}_{HH:MM}'
        -- Manual: 'MANUAL_' || gen_random_uuid()::text
    patient_first_name  text NOT NULL,  -- First name ONLY. Never last name or full name.
    appointment_time    timestamptz NOT NULL,
    appointment_date    date NOT NULL,  -- Extracted date (for WHERE appointment_date = TODAY)
    appointment_type    text,           -- 'Initial Intake', 'Follow-Up', etc.
    sync_method         text NOT NULL DEFAULT 'api',
        -- Values: 'api', 'csv', 'manual'
    synced_at           timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX tebra_appts_date_idx ON tebra_appointments (appointment_date, appointment_time ASC);

ALTER TABLE tebra_appointments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service role full access" ON tebra_appointments
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- 2. tebra_billing_summary: aggregated billing data (no patient detail)
CREATE TABLE tebra_billing_summary (
    period              text PRIMARY KEY,   -- Format: 'YYYY-MM' (one row per month)
    claims_submitted    integer NOT NULL DEFAULT 0,
    claims_denied       integer NOT NULL DEFAULT 0,
    denial_rate         numeric(5,2) NOT NULL DEFAULT 0,  -- Percentage, pre-computed
    ar_current          numeric(10,2) NOT NULL DEFAULT 0,  -- AR aged < 30 days
    ar_30               numeric(10,2) NOT NULL DEFAULT 0,  -- AR aged 30-59 days
    ar_60               numeric(10,2) NOT NULL DEFAULT 0,  -- AR aged 60-89 days
    ar_90plus           numeric(10,2) NOT NULL DEFAULT 0,  -- AR aged 90+ days
    total_ar            numeric(10,2) NOT NULL DEFAULT 0,  -- Sum of all AR buckets
    sync_method         text NOT NULL DEFAULT 'api',
    synced_at           timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE tebra_billing_summary ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service role full access" ON tebra_billing_summary
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- 3. automation_log: history of all dashboard-triggered and scheduled automations
-- (See Section 10.9 for full DDL — reproduced here for completeness)
CREATE TABLE IF NOT EXISTS automation_log (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    action_type     text NOT NULL,
    triggered_at    timestamptz NOT NULL DEFAULT now(),
    triggered_by    text NOT NULL DEFAULT 'dashboard_button',
    status          text NOT NULL DEFAULT 'pending',
    details         text,
    completed_at    timestamptz,
    created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS automation_log_triggered_at_idx ON automation_log (triggered_at DESC);
CREATE INDEX IF NOT EXISTS automation_log_action_type_idx ON automation_log (action_type, triggered_at DESC);

ALTER TABLE automation_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service role full access" ON automation_log
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- 4. dashboard_settings: key-value store for configurable preferences
CREATE TABLE dashboard_settings (
    key     text PRIMARY KEY,
    value   text NOT NULL
);

-- Seed with default values
INSERT INTO dashboard_settings (key, value) VALUES
    ('audio_enabled',                   'false'),
    ('chime_type',                      'chime_clear'),
    ('audio_trigger_level',             '7_day'),
    ('refresh_interval_seconds',        '1800'),
    ('tebra_integration_tier',          'manual'),
    ('tebra_last_sync',                 NULL),
    ('show_next_business_day_on_weekends', 'true'),
    ('resolution',                      '2560x1440')
ON CONFLICT (key) DO NOTHING;

ALTER TABLE dashboard_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service role full access" ON dashboard_settings
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- 5. obligations: compliance and operational obligations checklist
CREATE TABLE obligations (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title               text NOT NULL,
    description         text,
    category            text NOT NULL DEFAULT 'operational',
        -- Values: 'regulatory', 'operational'
    due_date            date,           -- NULL for recurring items without a fixed date
    recurrence          text,           -- 'annual', 'semi-annual', 'quarterly', 'monthly', 'recurring', NULL
    recurrence_interval integer,        -- Days between recurrences (for recurrence='recurring')
    status              text NOT NULL DEFAULT 'active',
        -- Values: 'active', 'snoozed', 'completed', 'overdue'
    notes               text,
    snoozed_until       date,           -- NULL unless status='snoozed'
    completed_at        timestamptz,    -- NULL unless status='completed'
    auto_completable    boolean NOT NULL DEFAULT false,
    action_type         text,           -- Matches automation_log.action_type values (for auto-complete linking)
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX obligations_status_due_idx ON obligations (status, due_date ASC NULLS LAST);
CREATE INDEX obligations_action_type_idx ON obligations (action_type) WHERE action_type IS NOT NULL;

-- Trigger to auto-update updated_at on any row change
CREATE OR REPLACE FUNCTION update_obligations_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER obligations_updated_at_trigger
    BEFORE UPDATE ON obligations
    FOR EACH ROW EXECUTE FUNCTION update_obligations_updated_at();

ALTER TABLE obligations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service role full access" ON obligations
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');
```

**Run order:** Create tables in the order listed (1 → 5). There are no foreign key dependencies between Phase 4 tables or between Phase 4 and Phase 1/2 tables. The obligations table is standalone (it does not FK into credentials or compliance_items — it references them by `action_type` string matching only).

---

## Section 11: Developer Implementation Guide

### 11A: Setup Checklist

Complete these steps in order before first dashboard launch:

1. **Install TouchDesigner** 2023.11340 or newer from [derivative.ca](https://derivative.ca). Use the commercial or non-commercial license based on deployment context.

2. **Create TD project** with Container COMP hierarchy per Section 2.1. Set up Window COMP for external monitor output at target resolution (Section 2.2).

3. **Load IBM Plex Mono font:** Download from Google Fonts, place `IBMPlexMono-Regular.ttf` and `IBMPlexMono-Bold.ttf` at `{td_project_root}/assets/fonts/`. Reference with relative path in all Text TOP Font File parameters.

4. **Configure Supabase connection:**
   - Store Supabase URL and `service_role_key` in a TD Table DAT named `config_secrets` — NOT in Python code or n8n environment variables
   - Set up Web Client DAT headers per Section 2.4 (`webClient_credentials`, `webClient_appointments`, etc.)
   - Test with a GET to `credential_alert_queue` — verify JSON response with credential rows

5. **Set up n8n on DigitalOcean (178.128.12.34 or new droplet):**
   - Install n8n via Docker (`docker run -it --rm --name n8n -p 5678:5678 n8nio/n8n`) or npm global install
   - Set environment variable: `EXECUTIONS_DATA_SAVE_ON_SUCCESS=false` (PHI safety — see Section 8A.2)
   - Configure webhook URLs for all 4 action buttons (Section 9.3–9.7)
   - Store Tebra Customer Key in n8n credential vault (NEVER in TD, Supabase, or environment variables)
   - Set up all 8 n8n workflows listed in Section 11C

6. **Run Phase 4 Supabase schema migration** (Section 10.10 DDL):
   - Use Supabase Management API: `POST api.supabase.com/v1/projects/{ref}/database/query` with `sbp_*` key
   - Run DDL in order: tebra_appointments → tebra_billing_summary → automation_log → dashboard_settings → obligations
   - After DDL, reload PostgREST: `NOTIFY pgrst, 'reload schema'`
   - Verify all 5 tables appear in Supabase Table Editor

7. **Seed initial data:**
   - `dashboard_settings` seeded automatically by the DDL (INSERT … ON CONFLICT DO NOTHING)
   - `obligations` table: run seed SQL from Section 6.9
   - After seeding, manually update `due_date` values for items where Valentina's actual dates are known

8. **Configure macOS auto-launch:**
   - Add TouchDesigner (or a shell script opening the `.toe` file) to macOS Login Items: System Settings → General → Login Items → click `+` → select TouchDesigner or the script
   - Enable Perform Mode startup in TouchDesigner: Edit → Preferences → General → "Open in Perform Mode on startup"

9. **Verify end-to-end data flow:**
   - Trigger a manual CAQH CHECK from the dashboard
   - Confirm `automation_log` row appears in Supabase with `status='running'` then `status='completed'`
   - Confirm Automation Tracker panel (Panel 8) updates within 10 seconds of button press
   - Confirm badge transitions IDLE → RUNNING → DONE

---

### 11B: Pre-Launch Data Requirements

These items MUST be resolved before the dashboard can function correctly. None of them are developer tasks — they require input from Valentina or Maxi:

**1. CAQH Attestation Date (BLOCKER — Dashboard shows `[???]` until resolved)**
Valentina must:
- Log into [proview.caqh.org](https://proview.caqh.org) with CAQH ID 16149210
- Navigate to the Attestation tab
- Find the last attestation date
- Report the date to Maxi

Maxi then: `UPDATE credentials SET expiry_date = '{last_attestation_date}'::date + INTERVAL '120 days' WHERE credential_type = 'caqh';`

Until this is done, the CAQH row shows `[???]` in AMBER — never GREEN — per the locked architectural decision in STATE.md.

**2. Tebra Customer Key**
- Retrieve from Tebra portal: Help → Get Customer Key (or Settings → API Keys)
- Required for Tier 1 SOAP API integration
- Store in n8n credential vault (Credential Type: Generic, field name: `tebraCustomerKey`)
- Without this: dashboard defaults to Tier 3 (manual entry mode) for appointment and billing panels

**3. Nine Payer Contract Date Confirmations**
These 9 payers have ESTIMATED re-credentialing dates (marked with `~` prefix on dashboard). Valentina must confirm actual re-cred dates with each payer's provider relations line:
- California Health & Wellness
- Coastal Communities (Prospect Medical)
- Facey Medical Group
- Health Net CA
- Hoag Health Network
- Magellan Health
- Providence Health
- Torrance IPA
- Torrance Memorial Medical Center IPA

Once confirmed: `UPDATE payer_tracker SET recred_is_estimated = false, recred_due_date = '{confirmed_date}' WHERE payer_name = '{name}';`

**4. Business License Renewal (OVERDUE — Active Blocker)**
City of Torrance BL-LIC-051057 expired 2025-12-31. Dashboard shows pulsing RED `[EXPIRED]` badge until renewed. Valentina must renew at [torranceca.gov](https://torranceca.gov). After renewal: update `obligations` table row and `credentials` table if the business license is tracked there.

**5. Google Workspace Migration (Required for SEND COMMS Button)**
The `[ SEND COMMS ]` action button requires a Google Workspace email account with BAA enabled. Consumer Gmail (`valentinaparkmd@gmail.com`) cannot send HIPAA-covered patient communications. Target date: 2026-03-15. Until this is resolved: the SEND COMMS button can fire but the n8n workflow will fail with a HIPAA compliance error.

---

### 11C: n8n Workflow Inventory

Every n8n workflow required by this spec, with trigger type, actions, and which Supabase table(s) each writes to:

| Workflow | Trigger | Key Actions | Writes To |
|----------|---------|-------------|-----------|
| Tebra Appointment Sync | Schedule (every 15 min) | SOAP GetAppointments → strip PHI (first name only) → upsert | `tebra_appointments` |
| Tebra Billing Sync | Schedule (every 30 min) | SOAP GetTransactions → aggregate into buckets → upsert | `tebra_billing_summary` |
| CAQH Re-Attestation Check | Webhook (`/webhook/caqh-recheck`) | Authenticate to CAQH ProView → check attestation status → update credentials if new date found | `automation_log`, `credentials` |
| Compliance Report Generator | Webhook (`/webhook/compliance-report`) | Query all credential/payer/obligation tables → generate markdown/PDF → save to Google Drive → log file URL | `automation_log` |
| Payer Status Check | Webhook (`/webhook/payer-status-check`) | Check automatable payer portals → log count and results → update payer_tracker if new info found | `automation_log`, `payer_tracker` |
| Send Communication | Webhook (`/webhook/send-communication`) | Select email template by comm_type → send via SendGrid/Email node → log result | `automation_log` |
| Credential Alert Email | Schedule (daily 7:00 AM PT) | Query `credential_alert_queue` for items expiring within 30 days → compose summary email → send to Valentina | `automation_log` |
| Obligation Auto-Complete | Internal trigger (called by other workflows on success) | Check if completed automation matches `auto_completable=true` obligations → PATCH obligation status to `completed` | `obligations` |

**Workflow count:** 8 workflows total. Minimum required for dashboard to function: workflows 1–6. Workflows 7–8 are enhancement workflows that add automation beyond the core dashboard display.

**n8n credential vault entries required:**
- `Tebra API` (type: Generic) — fields: `tebraUsername`, `tebraPassword`, `tebraCustomerKey`
- `Supabase Brighter Days` (type: Generic) — fields: `supabaseUrl`, `serviceRoleKey`
- `Google Drive` (type: OAuth2) — for CSV export monitoring and report file saving
- `SendGrid` (type: Generic API) — field: `apiKey` — OR use n8n Email node with SMTP credentials for Google Workspace
- `CAQH ProView` (type: Generic) — fields: `username`, `password` (Valentina's CAQH login)

---

### 11D: HIPAA Compliance Summary

All HIPAA notes from throughout this spec consolidated for easy review and audit documentation:

**PHI scope on dashboard:**
- Patient first name + appointment time only (Panel 1 and Panel 5)
- No last names, no dates of birth, no diagnoses, no insurance IDs, no CPT codes, no clinical notes appear anywhere on the dashboard or in the Supabase tables the dashboard reads from

**n8n PHI handling:**
- Self-hosted n8n on DigitalOcean: set `EXECUTIONS_DATA_SAVE_ON_SUCCESS=false` to prevent PHI storage in execution logs (Option A — stateless passthrough)
- Alternative: Keragon (HIPAA-native, BAA included) for any workflow that touches patient names (Option B — see Section 8A.2)
- PHI stripping occurs in n8n Code nodes BEFORE writing to Supabase — Supabase never receives full patient records

**Tebra credentials:**
- Tebra Customer Key: stored ONLY in n8n credential vault. Never in TD, Supabase, environment variables, or any file on disk.
- Tebra API user: create a dedicated read-only user for API access (minimum necessary access per HIPAA minimum necessary standard)

**Email communications:**
- `[ SEND COMMS ]` button requires Google Workspace sender with active BAA — consumer Gmail is not permitted for patient communications
- `recipient_email` entered in dialog: transmitted to n8n in webhook payload, used for email delivery, NOT stored in Supabase (only `action_type` and timestamp logged)

**Physical security:**
- External monitor must be in Valentina's private workspace — not visible to patients in waiting areas, building common areas, or through windows (HIPAA Security Rule 45 CFR 164.310(c) physical safeguard)
- Screenshots or prints of the appointments panel (showing first names + times) should be treated as limited PHI

**Supabase access control:**
- All dashboard tables use Row Level Security with service role access only
- Service role key stored in TD `config_secrets` Table DAT — not in Python code
- Supabase project dedicated to Brighter Days — NOT shared with FindItNOW or any other project

---

### 11E: Open Questions for Developer

Remaining unknowns that the developer must resolve during implementation. None of these are blockers for building the TD project or n8n scaffolding, but they must be answered before going live:

1. **Tebra SOAP WSDL URL:** The exact WSDL endpoint URL must be confirmed from the Tebra API Integration Technical Guide PDF. Request directly from Tebra support after obtaining the Customer Key. The spec uses `https://webservice.kareo.com/services/soap/2.1/KareoServices.svc` as the documented endpoint — verify this is current.

2. **Tebra rate limits:** Not publicly documented. The 15–30 minute polling interval is safe for a solo practice (~4–8 appointments/day volume). If Tebra imposes rate limits that cause API errors, fall back to Tier 2 (CSV export) for the affected workflows.

3. **Keragon pricing:** Contact Keragon sales (`hello@keragon.com`) if PHI-in-workflow risk tolerance requires a BAA-covered automation platform. Keragon has 18 Tebra-specific actions. Compare cost vs. self-hosted n8n + stateless passthrough (Option A).

4. **macOS vs. Windows for TD runtime:** This spec assumes macOS (CoreAudio for audio output). If Valentina's dedicated display machine runs Windows: replace `Audio Device Out CHOP` CoreAudio configuration with DirectSound equivalent. All other TD functionality is cross-platform.

5. **Always-on behavior:** A dedicated Mac Mini or similar low-power desktop (not a laptop) is recommended for always-on dashboard operation. Laptops may sleep when lid is closed. Configure macOS Energy Saver to "Prevent computer from sleeping automatically" when the AC adapter is connected.

6. **CAQH ProView automation:** CAQH ProView may require multi-factor authentication or CAPTCHA during login, which could block automated scraping. Developer should verify whether CAQH has an API endpoint for attestation status queries, or whether n8n will need a browser automation node (e.g., Selenium via n8n Code node). If automation is not feasible, the CAQH Check button degrades to a URL-display action (opening the CAQH portal URL for Valentina to check manually).

---

### 11F: Phase 5 Handoff Notes

What the Phase 5 (AI Automation) implementation plan needs from this spec:

**Shared data surfaces:**
- `automation_log` is the integration point between the dashboard and AI systems. Phase 5 AI workflows write to `automation_log` using the same schema — the dashboard will automatically display AI-triggered automations in Panel 8 without code changes.
- `obligations` table supports `auto_completable=true` and `action_type` columns specifically designed for AI workflow integration. Phase 5 AI workflows mark obligations complete by writing to this table.

**n8n workflow inventory as starting point:**
- Section 11C's 8-workflow inventory is the baseline for Phase 5. AI automation expands the scheduled trigger workflows (Credential Alert Email, Obligation Auto-Complete) and adds new proactive monitoring workflows.

**Regulatory monitoring integration:**
- Phase 5 AI regulatory monitoring (AI-02, AI-03, AI-04) will write new obligation rows to the `obligations` table when new compliance requirements are detected. The dashboard's Panel 3 (Obligations Checklist) already renders all `obligations` rows — no TD changes required to display AI-generated obligations.

**AI form pre-fill (AI-01):**
- The credential and payer data in Supabase (`credentials` table, `payer_tracker` table, `credential_alert_queue` view) is the data source for AI-assisted form pre-fill. Phase 5 reads these tables directly — no new Supabase tables needed for AI-01.

**Context for Phase 5 developer:**
- TD and n8n are already in place. Phase 5 extends n8n workflows — it does not modify TD.
- The dashboard spec (this document) is the single source of truth for the data model. Phase 5 adds workflows that write to existing tables — it does not add new tables.
- The `automation_log.triggered_by` field distinguishes dashboard-button triggers (`'dashboard_button'`) from AI triggers (`'ai_scheduled'` or `'ai_triggered'`) from scheduled triggers (`'scheduled'`). Phase 5 workflows must use `triggered_by = 'ai_triggered'` when writing to `automation_log`.
