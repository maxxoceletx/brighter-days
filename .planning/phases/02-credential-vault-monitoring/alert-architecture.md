# Alert Architecture Specification
## Credential Expiry & Re-Credentialing Monitoring
## Valentina Park MD, Professional Corporation

**Version:** 1.0
**Date:** 2026-02-27
**Phase:** 2 (Credential Vault & Monitoring) — Specification only
**Authored for:** Phase 4 (TouchDesigner dashboard) and Phase 5 (n8n automation)

---

**Purpose:** This document specifies the alerting system for credential expiry, CAQH re-attestation, and payer re-credentialing deadlines. It is a build specification for Phase 4 (TouchDesigner dashboard) and Phase 5 (n8n automation). Phase 2 produces this spec only — no working automation is built in Phase 2.

**Scope:** Three alert types are defined:
1. Credential expiry alerts (licenses, DEA, malpractice, business license)
2. CAQH re-attestation alerts (120-day cycle — highest risk)
3. Payer re-credentialing alerts (3-year cycles across 17 panels)

**Data source:** Supabase (Brighter Days project) — `credential_alert_queue` and `payer_credentialing_alerts` views created in Phase 2 Plan 01 schema migration.

---

## Section 1: Credential Expiry Alerts

### 1.1 Trigger Conditions

n8n polls the following query daily at 7:00 AM Pacific:

```sql
SELECT
  id,
  credential_name,
  credential_type,
  credential_number,
  expiry_date,
  status,
  renewal_portal_url,
  vault_entry_ref,
  days_until_expiry,
  alert_level
FROM credential_alert_queue
WHERE alert_level IN ('ALERT_90', 'ALERT_60', 'ALERT_30', 'ALERT_7', 'EXPIRED');
```

The `credential_alert_queue` view recalculates `days_until_expiry` and `alert_level` in real time on each query. No static scheduled rows — the view drives everything.

### 1.2 Delivery Targets

**Both channels must fire for every alert — belt and suspenders for high-stakes deadlines.**

| Channel | Recipient | Details |
|---------|-----------|---------|
| Email | admin@valentinaparkmd.com | Valentina's practice inbox |
| Email | Maxi's email | See 1Password vault — "Brighter Days Practice" > Infrastructure & Tech |
| Google Calendar | Both users' calendars | Create/update event on the credential's expiry_date |

No role split — both Maxi and Valentina receive all alerts for all credential types.

### 1.3 Alert Cadence

| Alert Level | Days Before Expiry | Action |
|-------------|-------------------|--------|
| ALERT_90 | 90 days | First notice — plan renewal |
| ALERT_60 | 60 days | Second notice — initiate renewal process |
| ALERT_30 | 30 days | Urgent notice — renewal must be in progress |
| ALERT_7 | 7 days | Critical notice — submit renewal immediately |
| EXPIRED | Past expiry date | Emergency notice — credential lapsed |

### 1.4 Deduplication Rule

One alert per credential per `alert_level` per calendar day.

- If ALERT_90 fired today, do not fire again tomorrow at ALERT_90.
- Resume firing when `days_until_expiry` crosses the next threshold (ALERT_90 → ALERT_60 = when days_until_expiry < 60).
- Implementation pattern: before sending, query a `alert_log` table (or n8n internal state) for: `credential_id + alert_level + date(today)`. If a record exists, skip. If not, send and log.

### 1.5 Alert Payload Format

```
Subject: [ALERT] {credential_name} expires in {days_until_expiry} days — action required

Body:
  Credential:       {credential_name}
  Number:           {credential_number}
  Expiry:           {expiry_date}
  Days remaining:   {days_until_expiry}
  Alert level:      {alert_level}
  Renewal portal:   {renewal_portal_url}
  1Password entry:  {vault_entry_ref}

  Action: Log in at {renewal_portal_url} and complete renewal before {expiry_date}.
  Update the Supabase credentials table after renewal to stop these alerts.
```

For EXPIRED credentials:
```
Subject: [EXPIRED] {credential_name} — EXPIRED {abs(days_until_expiry)} days ago — immediate action required

Body:
  Credential:       {credential_name}
  Number:           {credential_number}
  Expired:          {expiry_date} ({abs(days_until_expiry)} days ago)
  Renewal portal:   {renewal_portal_url}
  1Password entry:  {vault_entry_ref}

  Action: Renew immediately at {renewal_portal_url}. This credential has lapsed.
  Update Supabase after renewal to stop these alerts.
```

### 1.6 Completion Gate

Alerts stop when **both** conditions are true in the `credentials` table:
- `credentials.expiry_date` is updated to a future date (after CURRENT_DATE)
- `credentials.status = 'ACTIVE'`

n8n checks these conditions before sending. If both are true, the credential no longer appears in `credential_alert_queue` at actionable alert levels and no notification fires.

**Process:** Valentina completes renewal → Maxi updates `credentials` table (new `expiry_date`, `status = 'ACTIVE'`, `updated_at = now()`) → alert stops on next daily poll.

---

## Section 2: CAQH Re-Attestation Alerts (Special Case)

### 2.1 Why CAQH Is the Highest-Risk Single Credential

**One missed 120-day CAQH re-attestation cycle can silently suspend in-network status with all 17 payer panels simultaneously.**

Unlike a single license expiry (which affects only that license), a lapsed CAQH profile causes every commercial payer to remove the provider from active network status until re-attestation is completed. This can halt billing across the entire practice without any direct payer communication — it happens silently through CAQH's automated verification feeds.

CAQH re-attestation gets dedicated alert logic with urgent language beyond the standard credential template.

### 2.2 Trigger Conditions

CAQH appears in the standard `credential_alert_queue` view because it has an `expiry_date` in the `credentials` table (last_attestation_date + 120 days). n8n identifies it with:

```sql
SELECT *
FROM credential_alert_queue
WHERE credential_name LIKE 'CAQH%'
  AND alert_level IN ('ALERT_90', 'ALERT_60', 'ALERT_30', 'ALERT_7', 'EXPIRED');
```

**CAQH 120-day cycle note:** The 90-day alert fires when 30 days have elapsed since the last attestation (120 - 90 = 30 days into the new cycle). This is the correct early warning — it gives 90 days of lead time within the 120-day window. Do not interpret this as "90 days before the deadline"; it is "90 days remaining in the current cycle."

### 2.3 Alert Cadence

Same 90 / 60 / 30 / 7 threshold structure as standard credentials, applied against the 120-day attestation window:

| Alert Level | Days Remaining in Cycle | Elapsed Since Last Attest |
|-------------|------------------------|--------------------------|
| ALERT_90 | 90 days | 30 days elapsed |
| ALERT_60 | 60 days | 60 days elapsed |
| ALERT_30 | 30 days | 90 days elapsed |
| ALERT_7 | 7 days | 113 days elapsed |
| EXPIRED | 0 or negative | Cycle lapsed |

### 2.4 CAQH Alert Payload (Urgent Format)

```
Subject: [URGENT] CAQH Re-Attestation Due in {days_until_expiry} days — All 17 Payer Contracts at Risk

Body:
  Your CAQH ProView profile requires re-attestation every 120 days.
  Missing this deadline can silently suspend in-network status with ALL 17 payers simultaneously.

  CAQH ID:          16149210
  Last attested:    {issue_date}
  Due:              {expiry_date}
  Days remaining:   {days_until_expiry}
  Alert level:      {alert_level}

  Re-attest now:    https://proview.caqh.org
  Time required:    5–20 minutes

  Steps:
    1. Log in at https://proview.caqh.org with CAQH ID 16149210
    2. Navigate to the Attestation tab
    3. Review all current information for accuracy
    4. Submit attestation

  After completing re-attestation: notify Maxi to update the Supabase credentials
  table with new expiry_date (today + 120 days) and updated issue_date.
```

For EXPIRED CAQH:
```
Subject: [CRITICAL] CAQH Re-Attestation EXPIRED — All 17 Payer Contracts Suspended

Body:
  Your CAQH ProView attestation has lapsed. All 17 payer panels may already be
  suspending your in-network status. This requires IMMEDIATE action.

  Re-attest immediately: https://proview.caqh.org
  Contact CAQH support if access issues: 1-888-599-1771
```

### 2.5 Completion Gate

Valentina logs into CAQH and re-attests. Maxi then updates the `credentials` table:

```sql
UPDATE credentials
SET
  expiry_date = CURRENT_DATE + INTERVAL '120 days',
  issue_date  = CURRENT_DATE,
  status      = 'ACTIVE',
  updated_at  = now()
WHERE credential_name LIKE 'CAQH%';
```

Alert stops on the next daily poll once `expiry_date` is future-dated.

---

## Section 3: Payer Re-Credentialing Alerts

### 3.1 Trigger Conditions

n8n polls the following query daily at 7:00 AM Pacific:

```sql
SELECT
  id,
  payer_name,
  payer_short,
  contract_status,
  recred_due_date,
  recred_is_estimated,
  can_bill,
  provider_relations_phone,
  credentialing_rep_name,
  credentialing_rep_email,
  days_until_recred,
  recred_urgency
FROM payer_credentialing_alerts
WHERE recred_urgency IN ('DUE_SOON', 'OVERDUE');
```

The `payer_credentialing_alerts` view recalculates urgency daily based on `recred_due_date`. Only payers with a non-NULL `recred_due_date` appear in the view.

### 3.2 Alert Window

Payer re-credentialing alerts begin at **180 days** before the re-credentialing deadline — earlier than the 90-day credential alert window because:
- Re-credentialing typically requires 90-day advance submission to the payer
- Application preparation (credentialing documents, attestations) takes 2–4 weeks
- Mary (credentialing agent) needs lead time to manage submissions across multiple panels

The `payer_credentialing_alerts` view uses `DUE_SOON` for deadlines within 90 days and `DUE_QUARTER` for 90–180 days. For Phase 4/5 implementation, set n8n to also query `DUE_QUARTER` and send lower-priority alerts:

```sql
-- Extended query for 180-day window
SELECT * FROM payer_credentialing_alerts
WHERE recred_urgency IN ('DUE_QUARTER', 'DUE_SOON', 'OVERDUE');
```

### 3.3 Alert Payload Format

```
Subject: [RE-CRED] {payer_name} re-credentialing due in {days_until_recred} days

Body:
  Payer:                {payer_name}
  Re-credentialing due: {recred_due_date} {estimated_flag}
  Days remaining:       {days_until_recred}
  Urgency:              {recred_urgency}
  Can currently bill:   {can_bill}

  Credentialing rep:    {credentialing_rep_name} ({credentialing_rep_email})
  Provider relations:   {provider_relations_phone}

  Action: Contact {credentialing_rep_name or "payer credentialing department"} to
  initiate re-credentialing process. Allow 90 days for payer processing.
  Engage credentialing agent Mary for application preparation.
```

**Estimated date disclaimer** — when `recred_is_estimated = true`, append to body:

```
  Note: This re-credentialing date is ESTIMATED (credentialing date + 3 years,
  industry standard). Verify the actual re-credentialing deadline with the payer
  before initiating the re-credentialing process.
```

### 3.4 Completion Gate

Payer re-credentialing is complete when:
- `payer_tracker.recred_due_date` is updated to the next cycle (current due + 3 years)
- `payer_tracker.contract_status = 'ACTIVE'`
- `payer_tracker.recred_is_estimated` updated to reflect whether new date is confirmed or still estimated

Maxi updates the `payer_tracker` row after Valentina and Mary confirm the re-credentialing application was submitted and accepted.

---

## Section 4: Implementation Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Automation engine | n8n (self-hosted) | Polls Supabase views, routes to email + calendar |
| Data source | Supabase REST API | Queries `credential_alert_queue` and `payer_credentialing_alerts` views |
| Polling schedule | Daily at 7:00 AM Pacific | Single daily sweep catches all active alerts |
| Email delivery | Google Workspace SMTP or n8n email node | Sends to admin@valentinaparkmd.com and Maxi |
| Calendar integration | Google Calendar API | Creates/updates events for expiry dates |
| Dashboard display | TouchDesigner (TD) | Pulls same Supabase views for real-time display |
| Dedup state | n8n internal state or `alert_log` Supabase table | Prevents duplicate alerts per credential per level per day |

**Division of responsibilities:**
- n8n handles **push notifications** (email + calendar events)
- TouchDesigner handles **pull display** (dashboard renders current state)
- Both poll the same Supabase views independently — no shared state between them

**Supabase connection for n8n:**
- Use Supabase REST API with service role key (stored in n8n credentials vault)
- Base URL: Brighter Days project URL from Supabase dashboard
- Headers: `apikey: {service_role_key}`, `Authorization: Bearer {service_role_key}`

---

## Section 5: Data Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Supabase (Brighter Days)              │
│                                                         │
│  credentials table ──► credential_alert_queue (view)    │
│  payer_tracker table ──► payer_credentialing_alerts (view)│
└─────────────────────────┬───────────────────────────────┘
                          │
              ┌───────────┴────────────┐
              │                        │
              ▼                        ▼
   ┌─────────────────────┐   ┌──────────────────────────┐
   │   n8n (Phase 5)     │   │  TouchDesigner (Phase 4) │
   │  Daily poll 7AM PT  │   │  Poll on dashboard open  │
   │                     │   │  or periodic refresh      │
   │  ┌───────────────┐  │   │                          │
   │  │ Check dedup   │  │   │  Renders alert levels    │
   │  └───────┬───────┘  │   │  as color indicators:    │
   │          │          │   │  GREEN / YELLOW /        │
   │  ┌───────▼───────┐  │   │  AMBER / RED             │
   │  │  Send email   │  │   └──────────────────────────┘
   │  │  (both users) │  │
   │  └───────┬───────┘  │
   │          │          │
   │  ┌───────▼───────┐  │
   │  │ Create/update │  │
   │  │ Calendar event│  │
   │  └───────────────┘  │
   └─────────────────────┘
              │
              ▼
   ┌─────────────────────────────────┐
   │  Human completes renewal        │
   │  Maxi updates Supabase:         │
   │    credentials.expiry_date      │
   │    credentials.status = ACTIVE  │
   └───────────────┬─────────────────┘
                   │
                   ▼
          Alert stops on next poll
```

---

## Section 6: Edge Cases and Failure Modes

### 6.1 n8n Is Down

**Scenario:** n8n service is offline for the daily poll.

**Impact:** Alerts do not fire. Email and calendar notifications do not send.

**Mitigation:**
- TouchDesigner dashboard still displays current credential status from Supabase views — visual monitoring continues even when automation is offline.
- Google Calendar events already created for upcoming expiry dates still notify from within Google Calendar.
- n8n should have health monitoring and automatic restart configured.
- If n8n is down more than 24 hours, check manually via `credential_alert_queue` in Supabase dashboard.

### 6.2 CAQH expiry_date Is NULL

**Scenario:** The `credentials` table has `expiry_date = NULL` for the CAQH row (this is the current state as of Phase 2 — Valentina has not yet verified her last attestation date in the CAQH portal).

**Impact:** CAQH row does not appear in `credential_alert_queue` (view filters `WHERE expiry_date IS NOT NULL`). **No CAQH alert fires. This is a silent failure for the highest-risk credential.**

**Required action before Phase 5 go-live:**
1. Valentina logs into https://proview.caqh.org with CAQH ID 16149210
2. Finds last attestation date on the Attestation tab
3. Maxi updates the `credentials` table: `expiry_date = last_attestation_date + 120 days`
4. Verify CAQH row now appears in `credential_alert_queue` before Phase 5 deployment

**This NULL expiry check must be part of Phase 5 pre-launch verification.**

### 6.3 Payer recred_is_estimated = true

**Scenario:** Most payer re-credentialing dates are estimates (credentialing_date + 3 years).

**Impact:** Alert fires based on estimated date. May be early or late relative to actual deadline.

**Decision:** Alert on estimated dates rather than miss actual deadlines. The alert payload includes an explicit disclaimer ("This re-credentialing date is ESTIMATED — verify with payer before initiating process"). Better to alert on an approximate date than to miss the deadline entirely.

### 6.4 Credential Renewed but Supabase Not Updated

**Scenario:** Valentina renews her CA Medical License but Maxi does not update the `credentials` table.

**Impact:** Alerts continue firing even after the renewal is complete.

**Operational instruction:** Every renewal must trigger an immediate Supabase update. The workflow is:
1. Valentina completes renewal and notifies Maxi
2. Maxi updates `credentials`: new `expiry_date`, `status = 'ACTIVE'`, `updated_at = now()`
3. Alert stops on next daily poll

This update is mandatory — alerts will not self-resolve without it.

### 6.5 New Credential or New Payer Added

**Scenario:** A new credential type (e.g., DEA update) or a new payer panel is added after Phase 5 deployment.

**Impact:** The alert system automatically includes the new row on the next daily poll — no n8n reconfiguration needed. The Supabase views are dynamic; adding a new row with `expiry_date` populated automatically makes it alertable.

### 6.6 Google Calendar API Auth Token Expires

**Scenario:** The Google Calendar OAuth2 token used by n8n expires.

**Impact:** Calendar event creation fails silently. Email alerts still fire (separate delivery path).

**Mitigation:** Configure n8n Google Calendar credential with refresh token and monitor n8n execution logs for calendar errors. Email alerts serve as backup for all calendar failures.

---

## Operational Instructions for Phase 5 Builders

1. **Pre-launch checklist:**
   - Verify CAQH `expiry_date` is not NULL in `credentials` table before enabling alerts
   - Confirm Supabase REST API access from n8n environment
   - Test Google Workspace SMTP connection
   - Test Google Calendar API OAuth2 credentials
   - Send test alert to both admin@valentinaparkmd.com and Maxi's email
   - Verify TouchDesigner can query both views successfully

2. **Supabase REST API pattern:**
   ```
   GET https://{project-ref}.supabase.co/rest/v1/credential_alert_queue
   Headers:
     apikey: {service_role_key}
     Authorization: Bearer {service_role_key}
   Query params:
     alert_level=in.(ALERT_90,ALERT_60,ALERT_30,ALERT_7,EXPIRED)
   ```

3. **Update Supabase after every renewal.** Alerts will not self-resolve. The human-in-the-loop step is non-optional: Valentina renews → Maxi updates Supabase → alert stops.

4. **TouchDesigner display color mapping** (from `credential_alert_queue.display_color`):
   - `GREEN` — Current, no action needed
   - `YELLOW` — 60–90 days remaining, plan renewal
   - `AMBER` — 30–60 days remaining, initiate renewal
   - `RED` — Under 30 days or EXPIRED, urgent action

---

*Alert Architecture Specification v1.0*
*Phase: 02-credential-vault-monitoring*
*Produced: 2026-02-27*
*Build target: Phase 4 (TouchDesigner) and Phase 5 (n8n automation)*
