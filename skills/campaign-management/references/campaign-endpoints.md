# Campaign Management API Endpoints Reference

Base URL: `https://server.smartlead.ai/api/v1`

All endpoints require the `api_key` query parameter for authentication.

---

## Table of Contents

1. [Create a Campaign](#1-create-a-campaign)
2. [Configure Campaign Schedule](#2-configure-campaign-schedule)
3. [Update Campaign Settings](#3-update-campaign-settings)
4. [Get Campaign by ID](#4-get-campaign-by-id)
5. [Save Campaign Sequences](#5-save-campaign-sequences)
6. [List All Campaigns](#6-list-all-campaigns)
7. [Change Campaign Status](#7-change-campaign-status)
8. [Fetch Sequence Data](#8-fetch-sequence-data)
9. [Delete Campaign](#9-delete-campaign)
10. [Create Subsequence](#10-create-subsequence)
11. [Export Campaign Data as CSV](#11-export-campaign-data-as-csv)
12. [Update Campaign Name](#12-update-campaign-name)
13. [Get Campaign Status](#13-get-campaign-status)

---

## 1. Create a Campaign

**Endpoint:**

```
POST https://server.smartlead.ai/api/v1/campaigns/create?api_key={api_key}
```

**Method:** POST

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:**

```json
{
  "name": "Q1 Outbound - Decision Makers",
  "client_id": null
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | Yes | The campaign name. Must be non-empty. Use descriptive names for easy identification. |
| `client_id` | integer or null | No | Client ID for white-label or sub-account setups. Pass `null` for the default account. |

**Success Response (200):**

```json
{
  "ok": true,
  "id": 14523,
  "name": "Q1 Outbound - Decision Makers",
  "status": "DRAFTED",
  "created_at": "2025-03-15T10:30:00.000Z",
  "client_id": null
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 400 | `{"ok": false, "error": "Campaign name is required"}` | The `name` field was empty or missing. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 2. Configure Campaign Schedule

**Endpoint:**

```
POST https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/schedule?api_key={api_key}
```

**Method:** POST

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:**

```json
{
  "timezone": "America/New_York",
  "days_of_the_week": [1, 2, 3, 4, 5],
  "start_hour": "09:00",
  "end_hour": "17:00",
  "min_time_btw_emails": 8,
  "max_new_leads_per_day": 50,
  "schedule_start_time": "2025-04-01T09:00:00"
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `timezone` | string | Yes | IANA timezone identifier (e.g., `America/New_York`, `Europe/London`, `Asia/Kolkata`). |
| `days_of_the_week` | array of integers | Yes | Days to send emails. 1 = Monday, 2 = Tuesday, ..., 7 = Sunday. |
| `start_hour` | string | Yes | Start of the daily sending window in 24-hour format (e.g., `"09:00"`). |
| `end_hour` | string | Yes | End of the daily sending window in 24-hour format (e.g., `"17:00"`). |
| `min_time_btw_emails` | integer | No | Minimum gap in minutes between sending consecutive emails. Default: 8. |
| `max_new_leads_per_day` | integer | No | Maximum number of new leads to contact per day. Default varies by plan. |
| `schedule_start_time` | string | No | ISO 8601 datetime for when the campaign schedule begins. Must be in the future. |

**Success Response (200):**

```json
{
  "ok": true,
  "campaign_id": 14523,
  "schedule": {
    "timezone": "America/New_York",
    "days_of_the_week": [1, 2, 3, 4, 5],
    "start_hour": "09:00",
    "end_hour": "17:00",
    "min_time_btw_emails": 8,
    "max_new_leads_per_day": 50,
    "schedule_start_time": "2025-04-01T09:00:00"
  }
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 400 | `{"ok": false, "error": "Invalid timezone"}` | The timezone string is not a valid IANA timezone. |
| 400 | `{"ok": false, "error": "start_hour must be before end_hour"}` | The sending window is inverted. |
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 3. Update Campaign Settings

**Endpoint:**

```
POST https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/settings?api_key={api_key}
```

**Method:** POST

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:**

```json
{
  "track_settings": ["TRACK_EMAIL_OPEN", "TRACK_LINK_CLICK"],
  "stop_lead_settings": "REPLY_TO_AN_EMAIL",
  "send_as_plain_text": false,
  "follow_up_percentage": 100,
  "add_unsubscribe_tag": true,
  "unsubscribe_text": "Unsubscribe",
  "ignore_ss_mailfail": false
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `track_settings` | array of strings | No | Tracking features to enable. Options: `TRACK_EMAIL_OPEN`, `TRACK_LINK_CLICK`. Pass empty array to disable all tracking. |
| `stop_lead_settings` | string | No | Condition for stopping emails to a lead. Options: `REPLY_TO_AN_EMAIL`, `CLICK_ON_LINK`, `OPEN_AN_EMAIL`. |
| `send_as_plain_text` | boolean | No | If `true`, sends emails as plain text (no HTML). Default: `false`. |
| `follow_up_percentage` | integer | No | Percentage of leads (0-100) that receive follow-up emails. Default: 100. |
| `add_unsubscribe_tag` | boolean | No | Include an unsubscribe link in emails. Default: `true`. |
| `unsubscribe_text` | string | No | Custom text for the unsubscribe link. Default: `"Unsubscribe"`. |
| `ignore_ss_mailfail` | boolean | No | If `true`, ignore mail failures during sending. Default: `false`. |

**Success Response (200):**

```json
{
  "ok": true,
  "campaign_id": 14523,
  "settings": {
    "track_settings": ["TRACK_EMAIL_OPEN", "TRACK_LINK_CLICK"],
    "stop_lead_settings": "REPLY_TO_AN_EMAIL",
    "send_as_plain_text": false,
    "follow_up_percentage": 100,
    "add_unsubscribe_tag": true,
    "unsubscribe_text": "Unsubscribe",
    "ignore_ss_mailfail": false
  }
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 400 | `{"ok": false, "error": "Invalid track_settings value"}` | One or more tracking options are not recognized. |
| 400 | `{"ok": false, "error": "follow_up_percentage must be between 0 and 100"}` | Value is out of the valid range. |
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 4. Get Campaign by ID

**Endpoint:**

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}?api_key={api_key}
```

**Method:** GET

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign to retrieve. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:** None.

**Success Response (200):**

```json
{
  "ok": true,
  "id": 14523,
  "name": "Q1 Outbound - Decision Makers",
  "status": "DRAFTED",
  "created_at": "2025-03-15T10:30:00.000Z",
  "updated_at": "2025-03-16T14:00:00.000Z",
  "client_id": null,
  "schedule": {
    "timezone": "America/New_York",
    "days_of_the_week": [1, 2, 3, 4, 5],
    "start_hour": "09:00",
    "end_hour": "17:00",
    "min_time_btw_emails": 8,
    "max_new_leads_per_day": 50
  },
  "settings": {
    "track_settings": ["TRACK_EMAIL_OPEN", "TRACK_LINK_CLICK"],
    "stop_lead_settings": "REPLY_TO_AN_EMAIL",
    "send_as_plain_text": false,
    "follow_up_percentage": 100,
    "add_unsubscribe_tag": true
  },
  "email_accounts_count": 3,
  "leads_count": 1250,
  "sequence_steps_count": 4
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 5. Save Campaign Sequences

**Endpoint:**

```
POST https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/sequences?api_key={api_key}
```

**Method:** POST

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:**

```json
{
  "sequences": [
    {
      "seq_number": 1,
      "seq_delay_details": {
        "delay_in_days": 0
      },
      "subject": "Quick question about {{company}}",
      "email_body": "<p>Hi {{first_name}},</p><p>I noticed {{company}} is scaling rapidly and wanted to share how we've helped similar companies reduce outbound costs by 40%.</p><p>Would you be open to a quick 15-min chat this week?</p><p>Best,<br/>{{sender_name}}</p>",
      "variant_label": "A"
    },
    {
      "seq_number": 1,
      "seq_delay_details": {
        "delay_in_days": 0
      },
      "subject": "{{first_name}}, quick thought for {{company}}",
      "email_body": "<p>Hey {{first_name}},</p><p>Saw that {{company}} is growing fast. We recently helped a company in your space cut their outreach time in half.</p><p>Mind if I share how?</p><p>Cheers,<br/>{{sender_name}}</p>",
      "variant_label": "B"
    },
    {
      "seq_number": 2,
      "seq_delay_details": {
        "delay_in_days": 3
      },
      "subject": "Re: Quick question about {{company}}",
      "email_body": "<p>Hi {{first_name}},</p><p>Just circling back on my previous email. I know things get busy.</p><p>Would a brief call this week work for you?</p><p>Best,<br/>{{sender_name}}</p>",
      "variant_label": "A"
    },
    {
      "seq_number": 3,
      "seq_delay_details": {
        "delay_in_days": 5
      },
      "subject": "Last check-in, {{first_name}}",
      "email_body": "<p>Hi {{first_name}},</p><p>I don't want to be a pest, so this will be my last note. If the timing isn't right, no worries at all.</p><p>If you'd like to learn more, just reply and we can set something up.</p><p>All the best,<br/>{{sender_name}}</p>",
      "variant_label": "A"
    }
  ]
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `sequences` | array | Yes | Array of sequence step objects. |
| `sequences[].seq_number` | integer | Yes | Step number (1-indexed). Multiple entries with the same `seq_number` and different `variant_label` create A/B variants. |
| `sequences[].seq_delay_details` | object | Yes | Delay configuration for this step. |
| `sequences[].seq_delay_details.delay_in_days` | integer | Yes | Number of days to wait after the previous step. Use `0` for the first step. |
| `sequences[].subject` | string | Yes | Email subject line. Supports merge tags: `{{first_name}}`, `{{last_name}}`, `{{company}}`, `{{email}}`, custom fields. |
| `sequences[].email_body` | string | Yes | Email body in HTML or plain text. Supports the same merge tags as `subject`. |
| `sequences[].variant_label` | string | Yes | Variant identifier for A/B testing. Typically `"A"`, `"B"`, `"C"`. |

**Success Response (200):**

```json
{
  "ok": true,
  "campaign_id": 14523,
  "sequences_saved": 4,
  "sequences": [
    {
      "id": 98001,
      "seq_number": 1,
      "variant_label": "A",
      "subject": "Quick question about {{company}}"
    },
    {
      "id": 98002,
      "seq_number": 1,
      "variant_label": "B",
      "subject": "{{first_name}}, quick thought for {{company}}"
    },
    {
      "id": 98003,
      "seq_number": 2,
      "variant_label": "A",
      "subject": "Re: Quick question about {{company}}"
    },
    {
      "id": 98004,
      "seq_number": 3,
      "variant_label": "A",
      "subject": "Last check-in, {{first_name}}"
    }
  ]
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 400 | `{"ok": false, "error": "sequences array is required"}` | The `sequences` field is missing or empty. |
| 400 | `{"ok": false, "error": "Each sequence must have a subject and email_body"}` | A sequence step is missing required fields. |
| 400 | `{"ok": false, "error": "Invalid seq_number: must be a positive integer"}` | The `seq_number` value is zero, negative, or not an integer. |
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 6. List All Campaigns

**Endpoint:**

```
GET https://server.smartlead.ai/api/v1/campaigns?api_key={api_key}
```

**Method:** GET

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:** None.

**Success Response (200):**

```json
[
  {
    "id": 14523,
    "name": "Q1 Outbound - Decision Makers",
    "status": "STARTED",
    "created_at": "2025-03-15T10:30:00.000Z",
    "leads_count": 1250,
    "email_accounts_count": 3
  },
  {
    "id": 14100,
    "name": "Product Launch - Beta Users",
    "status": "PAUSED",
    "created_at": "2025-02-20T08:00:00.000Z",
    "leads_count": 500,
    "email_accounts_count": 2
  },
  {
    "id": 13890,
    "name": "Re-engagement - Churned Leads",
    "status": "COMPLETED",
    "created_at": "2025-01-10T12:00:00.000Z",
    "leads_count": 800,
    "email_accounts_count": 1
  }
]
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 7. Change Campaign Status

**Endpoint:**

```
POST https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/status?api_key={api_key}
```

**Method:** POST

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:**

```json
{
  "status": "START"
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `status` | string | Yes | The desired campaign status. Must be one of: `START`, `PAUSED`, `STOPPED`. Values are case-sensitive and must be uppercase. |

**Status Transitions:**

| From | To | Allowed |
|---|---|---|
| DRAFTED | START | Yes |
| DRAFTED | PAUSED | No |
| DRAFTED | STOPPED | No |
| STARTED | PAUSED | Yes |
| STARTED | STOPPED | Yes |
| PAUSED | START | Yes |
| PAUSED | STOPPED | Yes |
| STOPPED | START | No (permanent) |
| STOPPED | PAUSED | No (permanent) |

**Success Response (200):**

```json
{
  "ok": true,
  "campaign_id": 14523,
  "status": "STARTED",
  "message": "Campaign started successfully"
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 400 | `{"ok": false, "error": "Invalid status value. Must be START, PAUSED, or STOPPED"}` | The status value is not one of the allowed options. |
| 400 | `{"ok": false, "error": "Cannot start campaign: no email accounts attached"}` | The campaign has no email sending accounts linked. |
| 400 | `{"ok": false, "error": "Cannot start campaign: no sequences configured"}` | The campaign has no sequence steps saved. |
| 400 | `{"ok": false, "error": "Cannot start campaign: no leads added"}` | The campaign has no leads uploaded. |
| 400 | `{"ok": false, "error": "Cannot restart a stopped campaign"}` | A stopped campaign cannot be restarted. |
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 8. Fetch Sequence Data

**Endpoint:**

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/sequences?api_key={api_key}
```

**Method:** GET

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:** None.

**Success Response (200):**

```json
{
  "ok": true,
  "campaign_id": 14523,
  "sequences": [
    {
      "id": 98001,
      "seq_number": 1,
      "seq_delay_details": {
        "delay_in_days": 0
      },
      "subject": "Quick question about {{company}}",
      "email_body": "<p>Hi {{first_name}},</p><p>I noticed {{company}} is scaling rapidly...</p>",
      "variant_label": "A",
      "created_at": "2025-03-16T14:00:00.000Z"
    },
    {
      "id": 98002,
      "seq_number": 1,
      "seq_delay_details": {
        "delay_in_days": 0
      },
      "subject": "{{first_name}}, quick thought for {{company}}",
      "email_body": "<p>Hey {{first_name}},</p><p>Saw that {{company}} is growing fast...</p>",
      "variant_label": "B",
      "created_at": "2025-03-16T14:00:00.000Z"
    },
    {
      "id": 98003,
      "seq_number": 2,
      "seq_delay_details": {
        "delay_in_days": 3
      },
      "subject": "Re: Quick question about {{company}}",
      "email_body": "<p>Hi {{first_name}},</p><p>Just circling back...</p>",
      "variant_label": "A",
      "created_at": "2025-03-16T14:00:00.000Z"
    }
  ]
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 9. Delete Campaign

**Endpoint:**

```
DELETE https://server.smartlead.ai/api/v1/campaigns/{campaign_id}?api_key={api_key}
```

**Method:** DELETE

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign to delete. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:** None.

**Success Response (200):**

```json
{
  "ok": true,
  "message": "Campaign 14523 deleted successfully"
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 400 | `{"ok": false, "error": "Cannot delete an active campaign. Pause or stop it first."}` | The campaign is currently running. Change status to PAUSED or STOPPED before deleting. |
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 10. Create Subsequence

**Endpoint:**

```
POST https://server.smartlead.ai/api/v1/campaigns/create-subsequence?api_key={api_key}
```

**Method:** POST

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:**

```json
{
  "name": "Follow-up Subsequence",
  "parent_campaign_id": 2415561,
  "client_id": 123,
  "delayForNewLeads": 3,
  "stopLeadOnParentCampaignReply": true,
  "conditionEvents": [
    {
      "eventType": "REPLY_AN_EMAIL",
      "eventSubType": null,
      "categoryId": null,
      "text": null
    }
  ]
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | Yes | Name of the subsequence. |
| `parent_campaign_id` | integer | Yes | Parent campaign ID. |
| `client_id` | integer | No | Client ID for whitelabel accounts. |
| `delayForNewLeads` | integer | No | Delay in days before new leads enter the subsequence. |
| `stopLeadOnParentCampaignReply` | boolean | No | Stop leads when they reply in parent campaign. |
| `conditionEvents` | array | Yes | Trigger rules for this subsequence. |

**Success Response (200):**

```json
{
  "ok": true,
  "id": 12345,
  "name": "Follow-up Subsequence",
  "parent_campaign_id": 2415561,
  "created_at": "2024-10-02T12:00:00.000Z"
}
```

## 11. Export Campaign Data as CSV

**Endpoint:**

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/leads-export?api_key={api_key}
```

**Method:** GET

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign to export. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:** None.

**Success Response (200):**

Returns a CSV file with `Content-Type: text/csv` header.

```csv
email,first_name,last_name,company,status,opens,clicks,replies,last_activity
john@example.com,John,Doe,Acme Corp,INTERESTED,3,1,1,2025-03-20T14:30:00.000Z
jane@example.com,Jane,Smith,Beta Inc,NOT_INTERESTED,2,0,0,2025-03-19T09:15:00.000Z
bob@example.com,Bob,Johnson,Gamma LLC,LEAD,1,0,0,2025-03-18T11:00:00.000Z
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 400 | `{"ok": false, "error": "Campaign has no leads to export"}` | The campaign has no leads uploaded. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 12. Update Campaign Name

**Endpoint:**

```
POST https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/update?api_key={api_key}
```

**Method:** POST

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:**

```json
{
  "name": "Q1 Outbound - VP Engineering (Updated)"
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | Yes | The new name for the campaign. Must be non-empty. |

**Success Response (200):**

```json
{
  "ok": true,
  "campaign_id": 14523,
  "name": "Q1 Outbound - VP Engineering (Updated)",
  "updated_at": "2025-03-21T10:00:00.000Z"
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 400 | `{"ok": false, "error": "Campaign name is required"}` | The `name` field was empty or missing. |
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## 13. Get Campaign Status

**Endpoint:**

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/status?api_key={api_key}
```

**Method:** GET

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The ID of the campaign. |

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

**Request Body:** None.

**Success Response (200):**

```json
{
  "ok": true,
  "campaign_id": 14523,
  "status": "STARTED",
  "started_at": "2025-04-01T09:00:00.000Z",
  "leads_contacted": 320,
  "leads_remaining": 930,
  "email_accounts_active": 3
}
```

**Error Responses:**

| Status Code | Error | Description |
|---|---|---|
| 404 | `{"ok": false, "error": "Campaign not found"}` | No campaign exists with the given ID. |
| 401 | `{"ok": false, "error": "Invalid API key"}` | The provided API key is invalid or expired. |
| 429 | `{"ok": false, "error": "Rate limit exceeded"}` | Too many requests. Wait and retry. |

---

## Common Query Parameters Summary

All endpoints share these common query parameters:

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key for authentication. Included on every request. |

## Rate Limiting

All endpoints are subject to rate limiting. When rate limited, the API returns:

- **Status Code:** 429
- **Response Body:** `{"ok": false, "error": "Rate limit exceeded"}`
- **Headers:** `Retry-After` header indicates how many seconds to wait before retrying.

Best practice: Implement exponential backoff with a base delay of 1 second and a maximum of 5 retries.

## Merge Tags Reference

The following merge tags can be used in sequence `subject` and `email_body` fields:

| Tag | Description |
|---|---|
| `{{first_name}}` | Lead's first name. |
| `{{last_name}}` | Lead's last name. |
| `{{email}}` | Lead's email address. |
| `{{company}}` | Lead's company name. |
| `{{phone}}` | Lead's phone number. |
| `{{city}}` | Lead's city. |
| `{{title}}` | Lead's job title. |
| `{{sender_name}}` | Sending email account's display name. |
| `{{sender_email}}` | Sending email account's email address. |
| `{{unsubscribe_link}}` | Auto-generated unsubscribe URL. |
| `{{custom_field_N}}` | Custom fields uploaded with lead data (e.g., `{{custom_field_1}}`). |
