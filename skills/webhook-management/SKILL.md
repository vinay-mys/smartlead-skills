---
name: webhook-management
description: >-
  When the user wants to set up, update, or manage webhooks for Smartlead campaign events.
  Also use when the user mentions "webhook," "callback," "event notification," "automation
  trigger," "Zapier," "integration." For campaign configuration, see campaign-management.
  For client setup, see client-management.
metadata:
  version: 1.0.0
---

# Webhook Management

You are an expert in Smartlead webhook configuration and event-driven automation. Your goal is to help users set up, update, monitor, and troubleshoot campaign webhooks so they can integrate Smartlead events with external platforms and workflows.

## Context Check

Before proceeding, read the `smartlead-context` skill to confirm:
- The user's API key is available.
- The base URL is `https://server.smartlead.ai/api/v1`.
- All requests require the query parameter `api_key={API_KEY}`.

## Initial Assessment

When a user requests webhook help, determine:

1. **Campaign ID** -- Which campaign should the webhook be attached to? If unknown, list campaigns first via `GET /campaigns` (see campaign-management).
2. **Event types needed** -- Which events should fire the webhook?
3. **Target webhook URL** -- Where should payloads be delivered?
4. **Create vs. update** -- Is this a new webhook or a modification of an existing one?
5. **Integration platform** -- Zapier, Make (Integromat), n8n, custom server, or another tool?

## Event Types Reference

| Event Type | Description | Common Use Cases |
|---|---|---|
| `EMAIL_SENT` | Fires when an email is successfully sent to a lead | Logging send activity, CRM sync, send volume tracking |
| `EMAIL_OPENED` | Fires when a lead opens an email (pixel-tracked) | Engagement scoring, triggering follow-up workflows |
| `EMAIL_CLICKED` | Fires when a lead clicks a tracked link in the email | Interest qualification, redirecting to sales team |
| `EMAIL_REPLIED` | Fires when a lead replies to an outreach email | High-priority alert, CRM deal creation, auto-categorization |
| `EMAIL_BOUNCED` | Fires when an email bounces (hard or soft) | List hygiene, domain reputation monitoring |
| `LEAD_UNSUBSCRIBED` | Fires when a lead opts out via the unsubscribe link | Suppression list sync, compliance tracking |
| `LEAD_CATEGORY_UPDATED` | Fires when a lead's category label changes | Pipeline stage updates, reporting dashboards |

## Core Endpoints

### 1. Fetch All Webhooks for a Campaign

```
GET /campaigns/{campaign_id}/webhooks?api_key={API_KEY}
```

Returns an array of all webhook objects configured on the campaign. Use this to audit existing hooks before creating new ones.

### 2. Add or Update a Webhook

```
POST /campaigns/{campaign_id}/webhooks?api_key={API_KEY}
Content-Type: application/json

{
  "id": null,
  "webhook_url": "https://hooks.example.com/smartlead",
  "event_type": "EMAIL_REPLIED",
  "is_active": true
}
```

- Set `id` to `null` to **create** a new webhook.
- Set `id` to an existing webhook ID (integer) to **update** that webhook.
- Each webhook handles **one** event type. To listen for multiple events, create one webhook per event type.

### 3. Delete a Webhook

```
DELETE /campaigns/{campaign_id}/webhooks/{webhook_id}?api_key={API_KEY}
```

Permanently removes the webhook. This cannot be undone.

### 4. Get Webhook Publish Summary

```
GET /webhooks/publish-summary?api_key={API_KEY}
```

Returns aggregated delivery statistics across all webhooks: total published, succeeded, failed, and pending counts. Use for monitoring overall health.

### 5. Retrigger Failed Webhook Events

```
POST /webhooks/retrigger?api_key={API_KEY}
Content-Type: application/json

{
  "webhook_ids": [101, 102],
  "event_types": ["EMAIL_REPLIED"]
}
```

Replays failed deliveries. Use after fixing the receiving endpoint or resolving network issues.

## Recommended Workflow

Follow this sequence when setting up webhooks for a campaign:

### Step 1 -- Audit Existing Webhooks

```
GET /campaigns/{campaign_id}/webhooks?api_key={API_KEY}
```

Check whether webhooks already exist for the desired event types to avoid duplicates.

### Step 2 -- Create Webhooks

For each required event type, send a separate POST request:

```
POST /campaigns/{campaign_id}/webhooks?api_key={API_KEY}

{
  "id": null,
  "webhook_url": "https://hooks.zapier.com/hooks/catch/12345/abcdef/",
  "event_type": "EMAIL_REPLIED",
  "is_active": true
}
```

Repeat for every event type the user needs.

### Step 3 -- Test the Webhook

Recommend the user test with a tool like [webhook.site](https://webhook.site) or [RequestBin](https://requestbin.com) before pointing to a production endpoint:

1. Create a temporary URL on webhook.site.
2. Set that URL as the `webhook_url`.
3. Trigger a test event (e.g., send a test email from the campaign).
4. Verify the payload arrives and inspect its structure.
5. Update the webhook URL to the real production endpoint once confirmed.

### Step 4 -- Connect to Automation Platform

Platform-specific guidance:

- **Zapier**: Use "Webhooks by Zapier" trigger with "Catch Hook." Copy the Zapier webhook URL into the `webhook_url` field.
- **Make (Integromat)**: Use a "Custom Webhook" module. Copy the generated URL into `webhook_url`.
- **n8n**: Use the "Webhook" trigger node. Use the production webhook URL from n8n.
- **Custom server**: Ensure the endpoint returns a `200` status within 10 seconds to avoid timeout-based retries.

### Step 5 -- Monitor Delivery

```
GET /webhooks/publish-summary?api_key={API_KEY}
```

Check this periodically or build a monitoring dashboard. Look for rising failure counts.

### Step 6 -- Retrigger Failures

If failures are detected and the root cause is resolved:

```
POST /webhooks/retrigger?api_key={API_KEY}

{
  "webhook_ids": [101],
  "event_types": ["EMAIL_REPLIED"]
}
```

## Webhook Payload Structure

A typical webhook payload delivered to the target URL looks like this (structure varies by event type):

```json
{
  "event_type": "EMAIL_REPLIED",
  "campaign_id": 45678,
  "lead_id": 99001,
  "lead_email": "jane@example.com",
  "email_account": "outreach@yourcompany.com",
  "timestamp": "2025-09-15T14:32:00Z",
  "message_id": "<abc123@mail.yourcompany.com>",
  "subject": "Re: Quick question about your workflow",
  "body_preview": "Hi, thanks for reaching out..."
}
```

Fields included depend on the event type. `EMAIL_BOUNCED` payloads include a `bounce_type` field (`hard` or `soft`). `LEAD_CATEGORY_UPDATED` includes `old_category` and `new_category`.

## Common Mistakes

| Mistake | Why It Happens | How to Fix |
|---|---|---|
| Setting `id` to a non-null value when creating | Causes an update to a non-existent webhook or overwrites an existing one | Always use `"id": null` for new webhooks |
| Webhook URL is not publicly accessible | Localhost, VPN-only, or firewall-blocked URLs will silently fail | Use a publicly routable HTTPS URL; test with webhook.site first |
| Creating one webhook for multiple event types | The API only accepts one `event_type` per webhook object | Create a separate webhook for each event type |
| Not monitoring the publish summary | Failed deliveries go unnoticed, data is lost | Check `GET /webhooks/publish-summary` regularly or automate monitoring |
| Using HTTP instead of HTTPS | Payloads may contain lead PII; HTTP exposes data in transit | Always use HTTPS endpoints |
| Forgetting to set `is_active` to `true` | Webhook is created but will not fire | Explicitly include `"is_active": true` in the request body |
| Not retriggering after fixing endpoint issues | Historical failures are never replayed | Use `POST /webhooks/retrigger` after resolving the root cause |

## Decision Tree

```
User wants webhook help
|
+-- Wants to see existing webhooks?
|   --> GET /campaigns/{id}/webhooks
|
+-- Wants to create a new webhook?
|   --> Confirm: campaign ID, event type, webhook URL
|   --> POST /campaigns/{id}/webhooks with id: null
|
+-- Wants to update an existing webhook?
|   --> GET existing webhooks to find the webhook ID
|   --> POST /campaigns/{id}/webhooks with id: {webhook_id}
|
+-- Wants to delete a webhook?
|   --> Confirm webhook ID
|   --> DELETE /campaigns/{id}/webhooks/{webhook_id}
|
+-- Wants to check delivery health?
|   --> GET /webhooks/publish-summary
|
+-- Wants to replay failed events?
|   --> POST /webhooks/retrigger with webhook_ids and event_types
```

## Multi-Campaign Webhook Setup

When the user needs the same webhooks across many campaigns:

1. Retrieve the list of target campaign IDs.
2. For each campaign, call `GET /campaigns/{id}/webhooks` to check for existing hooks.
3. For each campaign, create the required webhooks via `POST /campaigns/{id}/webhooks`.
4. Summarize results: how many webhooks were created, any errors encountered.

Always confirm with the user before bulk-creating webhooks across multiple campaigns.

## Related Skills

| Skill | When to Use |
|---|---|
| `smartlead-context` | API key setup, base URL, authentication details |
| `campaign-management` | Creating or configuring campaigns before adding webhooks |
| `lead-management` | Managing the leads whose events trigger webhooks |
| `client-management` | White-label client setup and permissions |
| `campaign-analytics` | Viewing campaign metrics beyond webhook event data |
| `master-inbox` | Managing replies and conversations that arrive via email |
