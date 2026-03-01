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
