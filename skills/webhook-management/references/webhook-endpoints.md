# Webhook Endpoints Reference

Complete reference for all Smartlead webhook API endpoints. Every request requires the query parameter `api_key={API_KEY}`.

**Base URL:** `https://server.smartlead.ai/api/v1`

---

## 1. Fetch All Webhooks for a Campaign

Retrieves every webhook configured on a specific campaign.

### Request

```
GET /campaigns/{campaign_id}/webhooks?api_key={API_KEY}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The numeric ID of the campaign |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |

### Example Request

```bash
curl -X GET \
  "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks?api_key=SL_abc123def456"
```

### Example Response (200 OK)

```json
[
  {
    "id": 101,
    "campaign_id": 45678,
    "webhook_url": "https://hooks.zapier.com/hooks/catch/12345/abcdef/",
    "event_type": "EMAIL_REPLIED",
    "is_active": true,
    "created_at": "2025-08-10T09:15:00Z",
    "updated_at": "2025-08-10T09:15:00Z"
  },
  {
    "id": 102,
    "campaign_id": 45678,
    "webhook_url": "https://hooks.zapier.com/hooks/catch/12345/ghijkl/",
    "event_type": "EMAIL_OPENED",
    "is_active": true,
    "created_at": "2025-08-10T09:16:00Z",
    "updated_at": "2025-08-10T09:16:00Z"
  },
  {
    "id": 103,
    "campaign_id": 45678,
    "webhook_url": "https://hooks.zapier.com/hooks/catch/12345/mnopqr/",
    "event_type": "EMAIL_BOUNCED",
    "is_active": false,
    "created_at": "2025-08-12T11:00:00Z",
    "updated_at": "2025-09-01T14:22:00Z"
  }
]
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `id` | integer | Unique identifier for the webhook |
| `campaign_id` | integer | The campaign this webhook belongs to |
| `webhook_url` | string | The URL that receives the POST payload |
| `event_type` | string | One of the supported event types |
| `is_active` | boolean | Whether the webhook is currently firing |
| `created_at` | string (ISO 8601) | Timestamp of creation |
| `updated_at` | string (ISO 8601) | Timestamp of last modification |

### Error Responses

| Status | Cause |
|---|---|
| `401 Unauthorized` | Invalid or missing API key |
| `404 Not Found` | Campaign ID does not exist |

---

## 2. Add or Update a Webhook

Creates a new webhook on a campaign or updates an existing one. Each webhook handles exactly one event type.

### Request

```
POST /campaigns/{campaign_id}/webhooks?api_key={API_KEY}
Content-Type: application/json
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The numeric ID of the campaign |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |

### Request Body

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | integer or null | Yes | Set to `null` to create a new webhook. Set to an existing webhook ID to update it. |
| `webhook_url` | string | Yes | The publicly accessible HTTPS URL that will receive POST payloads |
| `event_type` | string | Yes | One of: `EMAIL_SENT`, `EMAIL_OPENED`, `EMAIL_CLICKED`, `EMAIL_REPLIED`, `EMAIL_BOUNCED`, `LEAD_UNSUBSCRIBED`, `LEAD_CATEGORY_UPDATED` |
| `is_active` | boolean | Yes | Set to `true` to enable the webhook, `false` to pause it |

### Example: Create a New Webhook

```bash
curl -X POST \
  "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks?api_key=SL_abc123def456" \
  -H "Content-Type: application/json" \
  -d '{
    "id": null,
    "webhook_url": "https://hooks.zapier.com/hooks/catch/12345/abcdef/",
    "event_type": "EMAIL_REPLIED",
    "is_active": true
  }'
```

### Example Response for Creation (200 OK)

```json
{
  "id": 104,
  "campaign_id": 45678,
  "webhook_url": "https://hooks.zapier.com/hooks/catch/12345/abcdef/",
  "event_type": "EMAIL_REPLIED",
  "is_active": true,
  "created_at": "2025-09-15T10:30:00Z",
  "updated_at": "2025-09-15T10:30:00Z"
}
```

### Example: Update an Existing Webhook

This changes the URL and deactivates the webhook:

```bash
curl -X POST \
  "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks?api_key=SL_abc123def456" \
  -H "Content-Type: application/json" \
  -d '{
    "id": 104,
    "webhook_url": "https://new-endpoint.example.com/smartlead-hook",
    "event_type": "EMAIL_REPLIED",
    "is_active": false
  }'
```

### Example Response for Update (200 OK)

```json
{
  "id": 104,
  "campaign_id": 45678,
  "webhook_url": "https://new-endpoint.example.com/smartlead-hook",
  "event_type": "EMAIL_REPLIED",
  "is_active": false,
  "created_at": "2025-09-15T10:30:00Z",
  "updated_at": "2025-09-15T14:45:00Z"
}
```

### Example: Create Multiple Webhooks for Different Events

To listen for replies, clicks, and bounces on the same campaign, send three separate requests:

```bash
# Webhook for EMAIL_REPLIED
curl -X POST \
  "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks?api_key=SL_abc123def456" \
  -H "Content-Type: application/json" \
  -d '{
    "id": null,
    "webhook_url": "https://automation.example.com/replied",
    "event_type": "EMAIL_REPLIED",
    "is_active": true
  }'

# Webhook for EMAIL_CLICKED
curl -X POST \
  "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks?api_key=SL_abc123def456" \
  -H "Content-Type: application/json" \
  -d '{
    "id": null,
    "webhook_url": "https://automation.example.com/clicked",
    "event_type": "EMAIL_CLICKED",
    "is_active": true
  }'

# Webhook for EMAIL_BOUNCED
curl -X POST \
  "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks?api_key=SL_abc123def456" \
  -H "Content-Type: application/json" \
  -d '{
    "id": null,
    "webhook_url": "https://automation.example.com/bounced",
    "event_type": "EMAIL_BOUNCED",
    "is_active": true
  }'
```

### Error Responses

| Status | Cause |
|---|---|
| `400 Bad Request` | Missing required field, invalid event type, or malformed JSON |
| `401 Unauthorized` | Invalid or missing API key |
| `404 Not Found` | Campaign ID does not exist, or webhook ID does not exist (for updates) |
| `422 Unprocessable Entity` | Webhook URL is not a valid URL format |

### Important Notes

- **Create vs. Update**: The `id` field controls behavior. `null` always creates. An integer always updates.
- **One event per webhook**: You cannot pass an array of event types. Create one webhook per event.
- **URL validation**: The URL must be a properly formatted HTTPS URL. HTTP URLs may be accepted but are strongly discouraged.
- **Duplicate prevention**: The API does not prevent duplicate webhooks for the same event type and URL. Always check existing webhooks first with the GET endpoint.

---

## 3. Delete a Webhook

Deletes a webhook from a campaign.

### Request

```
DELETE /campaigns/{campaign_id}/webhooks?api_key={API_KEY}
Content-Type: application/json

{
  "id": 101
}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | Campaign ID |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Smartlead API key |

### Request Body

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | integer | Yes | Webhook ID to delete |

### Example Request

```bash
curl -X DELETE   "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks?api_key=SL_abc123def456"   -H "Content-Type: application/json"   -d '{"id": 101}'
```

## 4. Get Webhook Publish Summary

Returns webhook publish summary for a campaign within a time window.

### Request

```
GET /campaigns/{campaign_id}/webhooks/summary?api_key={API_KEY}&fromTime={ISO_FROM}&toTime={ISO_TO}
```

### Required Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Smartlead API key |
| `fromTime` | string (ISO 8601) | Yes | Start time |
| `toTime` | string (ISO 8601) | Yes | End time |

### Example Request

```bash
curl -X GET   "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks/summary?api_key=SL_abc123def456&fromTime=2025-03-21T00:00:00.000Z&toTime=2025-03-28T00:00:00.000Z"
```

## 5. Retrigger Failed Webhook Events

Replays failed webhook events for a campaign within a time window.

### Request

```
POST /campaigns/{campaign_id}/webhooks/retrigger-failed-events?api_key={API_KEY}
Content-Type: application/json

{
  "fromTime": "2025-03-21T00:00:00.000Z",
  "toTime": "2025-03-28T00:00:00.000Z"
}
```

### Request Body

| Field | Type | Required | Description |
|---|---|---|---|
| `fromTime` | string (ISO 8601) | Yes | Start time |
| `toTime` | string (ISO 8601) | Yes | End time |

### Example Request

```bash
curl -X POST   "https://server.smartlead.ai/api/v1/campaigns/45678/webhooks/retrigger-failed-events?api_key=SL_abc123def456"   -H "Content-Type: application/json"   -d '{
    "fromTime": "2025-03-21T00:00:00.000Z",
    "toTime": "2025-03-28T00:00:00.000Z"
  }'
```

## Webhook Payload Examples by Event Type

For reference, here are representative payloads delivered to your webhook URL for each event type.

### EMAIL_SENT

```json
{
  "event_type": "EMAIL_SENT",
  "campaign_id": 45678,
  "lead_id": 99001,
  "lead_email": "jane@example.com",
  "email_account": "outreach@yourcompany.com",
  "timestamp": "2025-09-15T08:00:00Z",
  "message_id": "<msg-001@mail.yourcompany.com>",
  "subject": "Quick question about your workflow",
  "sequence_number": 1
}
```

### EMAIL_OPENED

```json
{
  "event_type": "EMAIL_OPENED",
  "campaign_id": 45678,
  "lead_id": 99001,
  "lead_email": "jane@example.com",
  "email_account": "outreach@yourcompany.com",
  "timestamp": "2025-09-15T09:22:00Z",
  "message_id": "<msg-001@mail.yourcompany.com>",
  "open_count": 1
}
```

### EMAIL_CLICKED

```json
{
  "event_type": "EMAIL_CLICKED",
  "campaign_id": 45678,
  "lead_id": 99001,
  "lead_email": "jane@example.com",
  "email_account": "outreach@yourcompany.com",
  "timestamp": "2025-09-15T09:25:00Z",
  "message_id": "<msg-001@mail.yourcompany.com>",
  "clicked_url": "https://yourcompany.com/demo",
  "click_count": 1
}
```

### EMAIL_REPLIED

```json
{
  "event_type": "EMAIL_REPLIED",
  "campaign_id": 45678,
  "lead_id": 99001,
  "lead_email": "jane@example.com",
  "email_account": "outreach@yourcompany.com",
  "timestamp": "2025-09-15T14:32:00Z",
  "message_id": "<reply-001@mail.example.com>",
  "subject": "Re: Quick question about your workflow",
  "body_preview": "Hi, thanks for reaching out. I would love to learn more about..."
}
```

### EMAIL_BOUNCED

```json
{
  "event_type": "EMAIL_BOUNCED",
  "campaign_id": 45678,
  "lead_id": 99002,
  "lead_email": "invalid@nonexistent-domain.com",
  "email_account": "outreach@yourcompany.com",
  "timestamp": "2025-09-15T08:01:00Z",
  "message_id": "<msg-002@mail.yourcompany.com>",
  "bounce_type": "hard",
  "bounce_reason": "550 5.1.1 The email account that you tried to reach does not exist"
}
```

### LEAD_UNSUBSCRIBED

```json
{
  "event_type": "LEAD_UNSUBSCRIBED",
  "campaign_id": 45678,
  "lead_id": 99003,
  "lead_email": "opted-out@example.com",
  "email_account": "outreach@yourcompany.com",
  "timestamp": "2025-09-16T11:05:00Z",
  "unsubscribe_method": "link_click"
}
```

### LEAD_CATEGORY_UPDATED

```json
{
  "event_type": "LEAD_CATEGORY_UPDATED",
  "campaign_id": 45678,
  "lead_id": 99001,
  "lead_email": "jane@example.com",
  "timestamp": "2025-09-16T15:00:00Z",
  "old_category": "Interested",
  "new_category": "Meeting Booked",
  "updated_by": "manual"
}
```

---

## HTTP Response Expectations

Smartlead expects your webhook endpoint to:

1. **Return a `2xx` status code** (200, 201, 202, 204) within **10 seconds**.
2. Any non-2xx response or timeout is treated as a **failed delivery**.
3. Failed deliveries are logged and can be replayed via the retrigger endpoint.
4. Smartlead sends payloads as `POST` requests with `Content-Type: application/json`.

### Recommended Endpoint Implementation

Your receiving endpoint should:

- Accept `POST` with `Content-Type: application/json`.
- Parse the `event_type` field to route processing.
- Return `200 OK` immediately, then process the payload asynchronously.
- Log the raw payload for debugging.
- Implement idempotency (the same event may be delivered more than once after a retrigger).
