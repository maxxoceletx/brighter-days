# n8n as Automation Backbone — Architecture Research

*Date: 2026-02-27 | Context: Phase 4/5 architecture evaluation*

## TL;DR

n8n is a strong fit as the middleware layer between TouchDesigner and external services. Self-hosted on DigitalOcean ($24-44/mo), it handles all scheduled monitoring, outbound communications, and Tebra API calls. TouchDesigner becomes pure visualization — reads from Supabase, renders ASCII dashboard, triggers n8n webhooks on button press.

**Key constraint:** n8n does NOT sign a BAA. Self-hosted n8n on a DO droplet with a DO BAA is architecturally defensible for non-PHI workflows. Workflows touching patient identifiers need legal review or Keragon (HIPAA-native alternative with Tebra integration).

## Architecture

```
TouchDesigner Dashboard (Desktop)
    |
    ├── [Outbound] Web Client DAT → n8n Webhook → Tebra API / SendGrid / Supabase
    |
    └── [Inbound] Timer DAT polls Supabase REST every 60s → updates ASCII panels

n8n (self-hosted, DigitalOcean)
    |
    ├── Schedule Trigger (cron) → check Supabase for expiry dates → send alerts
    ├── Webhook Trigger → receive from TD → call Tebra / send email / update Supabase
    └── Tebra FHIR polling → sync billing/appointment data → write to Supabase

Supabase (shared source of truth)
    └── compliance_items, credentials, billing_status tables
    └── Both n8n and TD read/write here
```

## Integration Details

### Tebra
- **No dedicated n8n node** — use HTTP Request node
- Three API surfaces: SOAP (legacy), FHIR (cleanest), Clinical Open API (developer-friendly)
- Swagger: https://api.kareo.com/clinical/v1/swagger/
- Requires Tebra developer portal approval

### Supabase
- **First-class n8n node** — get, get many, insert, update, delete
- Authentication via service role key in n8n's encrypted credential vault
- Vector Store node available for AI/semantic search

### TouchDesigner ↔ n8n
- TD → n8n: Web Client DAT POSTs to n8n Webhook node
- n8n → TD: Writes to Supabase, TD polls on Timer DAT (simpler than persistent socket)
- TD Web Server DAT can receive push notifications if always running

### Notifications
- SendGrid node for formal alerts (license renewals, credentialing deadlines)
- Slack node for internal real-time notifications
- Twilio SMS for urgent alerts

## Credential Expiry Monitoring (Concrete Example)

1. n8n Schedule Trigger: daily at 8 AM
2. Supabase Get Many Rows: `expiry_date < NOW() + INTERVAL '90 days'`
3. IF node: branch on 90/60/30/7 days remaining
4. SendGrid: alert email with credential type, expiry date, required action
5. Supabase Update: write `last_alerted_at` to prevent alert flooding
6. Write to `notifications` table → TD polls and displays as ASCII banner

## HIPAA Analysis

| Option | BAA Available | PHI Safe | Cost |
|--------|--------------|----------|------|
| n8n Cloud | No | No | $24-60/mo |
| Self-hosted on standard hosting | No BAA with n8n | Requires infra controls | $24-44/mo |
| Self-hosted on DO with BAA | BAA with DO | Architecturally defensible | $24-44/mo |
| Keragon (cloud, HIPAA-native) | Yes — signs BAA | Yes, purpose-built | Higher (pricing on request) |

**Recommendation:** Use self-hosted n8n for non-PHI workflows (compliance calendar, credential expiry, billing totals without patient identifiers). Evaluate Keragon if workflows must touch patient names/DOBs.

**Risk mitigation for self-hosted n8n:**
- Disable execution data saving (env vars: EXECUTIONS_DATA_SAVE_ON_SUCCESS=false)
- Design workflows as stateless passthroughs
- Encrypt database at rest
- DigitalOcean BAA covers infrastructure layer

## Alternatives Rejected

| Alternative | Reason |
|-------------|--------|
| Temporal | Overkill — distributed workflow orchestration for a solo practice |
| Custom Python | Maintenance burden, no visual debugging, no built-in retry |
| Make/Zapier | No BAA, cannot touch PHI, disqualified for healthcare |

## Cost Summary

- n8n Community Edition: **Free** (unlimited workflows/executions)
- DigitalOcean droplet (4GB/2vCPU): **$24/mo**
- Managed Postgres (optional): **$15/mo**
- **Total: $24-44/mo**
- Can potentially share the existing DO droplet at 178.128.12.34

## Sources

- [n8n Supabase node](https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.supabase/)
- [n8n Webhook node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)
- [TouchDesigner Web Client DAT](https://docs.derivative.ca/Web_Client_DAT)
- [Tebra API docs](https://helpme.tebra.com/Tebra_PM/12_API_and_Integration/01_Get_Started_with_Tebra_API_Integration/Tebra_API_Integration_User_Guide)
- [n8n DigitalOcean marketplace](https://marketplace.digitalocean.com/apps/n8n)
- [n8n HIPAA community discussion](https://community.n8n.io/t/looking-for-advice-self-hosting-n8n-for-hipaa-compliance-on-a-budget/184590)
- [Keragon HIPAA alternative](https://www.keragon.com/hipaa-n8n-alternative)
- [Keragon Tebra integration](https://www.keragon.com/integrations/kareo)
