# Campaign Analytics Endpoints Reference

Base URL: `https://server.smartlead.ai/api/v1`

All endpoints require the `api_key` query parameter for authentication.

---

## 1. GET /campaigns/{campaign_id}/statistics

### Description

Returns raw aggregate counts for a campaign. This is the primary endpoint for absolute numbers without any rate calculations.

### URL

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/statistics?api_key={api_key}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The unique identifier of the campaign. |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

### Response Schema

```json
{
  "id": 12345,
  "campaign_name": "Q1 SaaS Outreach",
  "status": "STARTED",
  "total_leads": 1500,
  "sent_count": 1240,
  "open_count": 682,
  "click_count": 43,
  "reply_count": 124,
  "bounce_count": 18,
  "unsubscribe_count": 6,
  "failed_count": 3,
  "interested_count": 47,
  "not_interested_count": 46,
  "not_now_count": 31,
  "do_not_contact_count": 2,
  "wrong_person_count": 4,
  "pending_count": 260,
  "in_progress_count": 0
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `id` | integer | Campaign ID. |
| `campaign_name` | string | Name of the campaign. |
| `status` | string | Current campaign status (`DRAFT`, `STARTED`, `PAUSED`, `STOPPED`, `COMPLETED`). |
| `total_leads` | integer | Total number of leads in the campaign. |
| `sent_count` | integer | Total emails sent (excludes warmup emails). |
| `open_count` | integer | Total unique opens tracked. |
| `click_count` | integer | Total unique link clicks tracked. |
| `reply_count` | integer | Total replies received. |
| `bounce_count` | integer | Total bounced emails. |
| `unsubscribe_count` | integer | Total unsubscribe actions. |
| `failed_count` | integer | Emails that failed to send due to technical errors. |
| `interested_count` | integer | Replies categorized as "Interested." |
| `not_interested_count` | integer | Replies categorized as "Not Interested." |
| `not_now_count` | integer | Replies categorized as "Not Now" or "Maybe Later." |
| `do_not_contact_count` | integer | Replies requesting removal from contact. |
| `wrong_person_count` | integer | Replies indicating wrong recipient. |
| `pending_count` | integer | Leads not yet contacted. |
| `in_progress_count` | integer | Leads currently being processed in the sending queue. |

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/campaigns/12345/statistics?api_key=YOUR_API_KEY"
```

---

## 2. GET /campaigns/{campaign_id}/statistics-by-date

### Description

Returns raw aggregate counts filtered to a specific date range. Identical response shape to the `/statistics` endpoint but scoped to the provided window. Preferred for performance when querying long-running campaigns.

### URL

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/statistics-by-date?api_key={api_key}&start_date={start_date}&end_date={end_date}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The unique identifier of the campaign. |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |
| `start_date` | string | Yes | Start of the date range in `YYYY-MM-DD` format. |
| `end_date` | string | Yes | End of the date range in `YYYY-MM-DD` format (inclusive). |

### Response Schema

```json
{
  "id": 12345,
  "campaign_name": "Q1 SaaS Outreach",
  "start_date": "2026-01-01",
  "end_date": "2026-01-31",
  "sent_count": 840,
  "open_count": 462,
  "click_count": 29,
  "reply_count": 88,
  "bounce_count": 12,
  "unsubscribe_count": 4,
  "failed_count": 1,
  "interested_count": 33,
  "not_interested_count": 28,
  "not_now_count": 17,
  "do_not_contact_count": 1,
  "wrong_person_count": 9
}
```

### Response Fields

Same as the `/statistics` endpoint, with the addition of:

| Field | Type | Description |
|---|---|---|
| `start_date` | string | The start date of the queried range. |
| `end_date` | string | The end date of the queried range. |

### Notes

- Both `start_date` and `end_date` are inclusive.
- If `start_date` is after `end_date`, the API returns an empty result set with zero counts.
- Dates are interpreted in the account's configured timezone.

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/campaigns/12345/statistics-by-date?api_key=YOUR_API_KEY&start_date=2026-01-01&end_date=2026-01-31"
```

---

## 3. GET /campaigns/{campaign_id}/analytics

### Description

Returns top-level analytics with both raw counts and calculated percentage rates. This is the recommended endpoint for a quick campaign performance snapshot.

### URL

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/analytics?api_key={api_key}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The unique identifier of the campaign. |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

### Response Schema

```json
{
  "id": 12345,
  "campaign_name": "Q1 SaaS Outreach",
  "status": "STARTED",
  "sent_count": 1240,
  "open_count": 682,
  "open_rate": 55.0,
  "click_count": 43,
  "click_rate": 3.47,
  "reply_count": 124,
  "reply_rate": 10.0,
  "positive_reply_count": 47,
  "positive_reply_rate": 37.9,
  "bounce_count": 18,
  "bounce_rate": 1.45,
  "unsubscribe_count": 6,
  "unsubscribe_rate": 0.48,
  "health_score": 82
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `id` | integer | Campaign ID. |
| `campaign_name` | string | Name of the campaign. |
| `status` | string | Current campaign status. |
| `sent_count` | integer | Total emails sent. |
| `open_count` | integer | Total unique opens. |
| `open_rate` | float | Open percentage: `(open_count / sent_count) * 100`. |
| `click_count` | integer | Total unique clicks. |
| `click_rate` | float | Click percentage: `(click_count / sent_count) * 100`. |
| `reply_count` | integer | Total replies. |
| `reply_rate` | float | Reply percentage: `(reply_count / sent_count) * 100`. |
| `positive_reply_count` | integer | Replies marked as "Interested." |
| `positive_reply_rate` | float | Positive reply percentage: `(positive_reply_count / reply_count) * 100`. |
| `bounce_count` | integer | Total bounces. |
| `bounce_rate` | float | Bounce percentage: `(bounce_count / sent_count) * 100`. |
| `unsubscribe_count` | integer | Total unsubscribes. |
| `unsubscribe_rate` | float | Unsubscribe percentage: `(unsubscribe_count / sent_count) * 100`. |
| `health_score` | integer | Campaign health score from 0 to 100. Factors in deliverability, engagement, and bounce metrics. |

### Notes

- All rate fields are floats rounded to two decimal places.
- `positive_reply_rate` is calculated against `reply_count`, not `sent_count`.
- `health_score` is a composite metric. Scores below 50 indicate significant issues.

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/campaigns/12345/analytics?api_key=YOUR_API_KEY"
```

---

## 4. GET /campaigns/{campaign_id}/analytics-by-date

### Description

Returns calculated analytics rates scoped to a specific date range. Combines the rate calculations of `/analytics` with the date filtering of `/statistics-by-date`.

### URL

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/analytics-by-date?api_key={api_key}&start_date={start_date}&end_date={end_date}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The unique identifier of the campaign. |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |
| `start_date` | string | Yes | Start of the date range in `YYYY-MM-DD` format. |
| `end_date` | string | Yes | End of the date range in `YYYY-MM-DD` format (inclusive). |

### Response Schema

```json
{
  "id": 12345,
  "campaign_name": "Q1 SaaS Outreach",
  "start_date": "2026-01-01",
  "end_date": "2026-01-31",
  "sent_count": 840,
  "open_count": 462,
  "open_rate": 55.0,
  "click_count": 29,
  "click_rate": 3.45,
  "reply_count": 88,
  "reply_rate": 10.48,
  "positive_reply_count": 33,
  "positive_reply_rate": 37.5,
  "bounce_count": 12,
  "bounce_rate": 1.43,
  "unsubscribe_count": 4,
  "unsubscribe_rate": 0.48,
  "health_score": 84,
  "daily_breakdown": [
    {
      "date": "2026-01-01",
      "sent": 42,
      "opens": 23,
      "clicks": 1,
      "replies": 3,
      "bounces": 0
    },
    {
      "date": "2026-01-02",
      "sent": 45,
      "opens": 26,
      "clicks": 2,
      "replies": 4,
      "bounces": 1
    }
  ]
}
```

### Response Fields

All fields from the `/analytics` endpoint, plus:

| Field | Type | Description |
|---|---|---|
| `start_date` | string | The start date of the queried range. |
| `end_date` | string | The end date of the queried range. |
| `daily_breakdown` | array | Array of daily metric objects within the range. |
| `daily_breakdown[].date` | string | The date in `YYYY-MM-DD` format. |
| `daily_breakdown[].sent` | integer | Emails sent on this date. |
| `daily_breakdown[].opens` | integer | Opens recorded on this date. |
| `daily_breakdown[].clicks` | integer | Clicks recorded on this date. |
| `daily_breakdown[].replies` | integer | Replies received on this date. |
| `daily_breakdown[].bounces` | integer | Bounces recorded on this date. |

### Notes

- The `daily_breakdown` array contains one entry per day in the range that had any activity.
- Days with zero activity across all metrics may be omitted from the array.
- Useful for charting trends over time.

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/campaigns/12345/analytics-by-date?api_key=YOUR_API_KEY&start_date=2026-01-01&end_date=2026-01-31"
```

---

## 5. GET /campaigns/{campaign_id}/lead-statistics

### Description

Returns per-lead engagement data for every lead in the campaign. Each entry shows what actions (open, click, reply, bounce) occurred for that specific lead. Useful for identifying engaged leads or diagnosing domain-level deliverability.

### URL

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/lead-statistics?api_key={api_key}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The unique identifier of the campaign. |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |
| `offset` | integer | No | Number of records to skip for pagination. Default: `0`. |
| `limit` | integer | No | Maximum number of records to return. Default: `100`. Max: `500`. |

### Response Schema

```json
{
  "total_count": 1500,
  "offset": 0,
  "limit": 100,
  "leads": [
    {
      "lead_id": 98765,
      "email": "jane.doe@example.com",
      "first_name": "Jane",
      "last_name": "Doe",
      "company": "Example Corp",
      "status": "INTERESTED",
      "sent_count": 3,
      "open_count": 2,
      "click_count": 1,
      "reply_count": 1,
      "bounce_count": 0,
      "last_open_at": "2026-01-15T14:32:00Z",
      "last_reply_at": "2026-01-16T09:15:00Z",
      "sequence_step": 2,
      "reply_category": "Interested"
    },
    {
      "lead_id": 98766,
      "email": "john.smith@example.com",
      "first_name": "John",
      "last_name": "Smith",
      "company": "Smith LLC",
      "status": "BOUNCED",
      "sent_count": 1,
      "open_count": 0,
      "click_count": 0,
      "reply_count": 0,
      "bounce_count": 1,
      "last_open_at": null,
      "last_reply_at": null,
      "sequence_step": 1,
      "reply_category": null
    }
  ]
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `total_count` | integer | Total number of leads in the campaign. |
| `offset` | integer | Current pagination offset. |
| `limit` | integer | Number of records returned. |
| `leads` | array | Array of per-lead statistic objects. |
| `leads[].lead_id` | integer | Unique lead identifier. |
| `leads[].email` | string | Lead's email address. |
| `leads[].first_name` | string | Lead's first name. |
| `leads[].last_name` | string | Lead's last name. |
| `leads[].company` | string | Lead's company name. |
| `leads[].status` | string | Lead status: `PENDING`, `IN_PROGRESS`, `COMPLETED`, `REPLIED`, `INTERESTED`, `NOT_INTERESTED`, `NOT_NOW`, `BOUNCED`, `UNSUBSCRIBED`, `DO_NOT_CONTACT`. |
| `leads[].sent_count` | integer | Number of emails sent to this lead. |
| `leads[].open_count` | integer | Number of times this lead opened emails. |
| `leads[].click_count` | integer | Number of link clicks by this lead. |
| `leads[].reply_count` | integer | Number of replies from this lead. |
| `leads[].bounce_count` | integer | Number of bounced emails for this lead. |
| `leads[].last_open_at` | string (ISO 8601) or null | Timestamp of the last open event. Null if never opened. |
| `leads[].last_reply_at` | string (ISO 8601) or null | Timestamp of the last reply. Null if no reply. |
| `leads[].sequence_step` | integer | The last sequence step reached for this lead. |
| `leads[].reply_category` | string or null | Categorization of the reply: `Interested`, `Not Interested`, `Not Now`, `Wrong Person`, `Do Not Contact`, or null. |

### Notes

- Results are paginated. Use `offset` and `limit` to page through large lead lists.
- The `status` field reflects the most recent disposition of the lead.
- `open_count` may exceed `sent_count` if the lead opens the same email multiple times.

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/campaigns/12345/lead-statistics?api_key=YOUR_API_KEY&offset=0&limit=100"
```

---

## 6. GET /campaigns/{campaign_id}/mailbox-statistics

### Description

Returns performance metrics grouped by each sending mailbox (email account) used in the campaign. Essential for diagnosing deliverability issues isolated to specific mailboxes.

### URL

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/mailbox-statistics?api_key={api_key}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The unique identifier of the campaign. |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

### Response Schema

```json
{
  "campaign_id": 12345,
  "campaign_name": "Q1 SaaS Outreach",
  "mailboxes": [
    {
      "mailbox_id": 501,
      "email": "alex@company.com",
      "sent_count": 420,
      "open_count": 245,
      "open_rate": 58.33,
      "click_count": 16,
      "click_rate": 3.81,
      "reply_count": 51,
      "reply_rate": 12.14,
      "bounce_count": 3,
      "bounce_rate": 0.71,
      "unsubscribe_count": 2,
      "unsubscribe_rate": 0.48,
      "warmup_emails_sent": 15,
      "daily_limit": 50,
      "is_active": true
    },
    {
      "mailbox_id": 502,
      "email": "jordan@company.com",
      "sent_count": 410,
      "open_count": 230,
      "open_rate": 56.1,
      "click_count": 14,
      "click_rate": 3.41,
      "reply_count": 40,
      "reply_rate": 9.76,
      "bounce_count": 5,
      "bounce_rate": 1.22,
      "unsubscribe_count": 2,
      "unsubscribe_rate": 0.49,
      "warmup_emails_sent": 12,
      "daily_limit": 50,
      "is_active": true
    },
    {
      "mailbox_id": 503,
      "email": "sam@company.com",
      "sent_count": 410,
      "open_count": 207,
      "open_rate": 50.49,
      "click_count": 13,
      "click_rate": 3.17,
      "reply_count": 34,
      "reply_rate": 8.29,
      "bounce_count": 12,
      "bounce_rate": 2.93,
      "unsubscribe_count": 2,
      "unsubscribe_rate": 0.49,
      "warmup_emails_sent": 10,
      "daily_limit": 50,
      "is_active": true
    }
  ]
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `campaign_id` | integer | Campaign ID. |
| `campaign_name` | string | Campaign name. |
| `mailboxes` | array | Array of per-mailbox statistic objects. |
| `mailboxes[].mailbox_id` | integer | Unique mailbox identifier. |
| `mailboxes[].email` | string | The sending email address. |
| `mailboxes[].sent_count` | integer | Emails sent from this mailbox for this campaign. |
| `mailboxes[].open_count` | integer | Opens attributed to emails from this mailbox. |
| `mailboxes[].open_rate` | float | Open rate for this mailbox. |
| `mailboxes[].click_count` | integer | Clicks on emails from this mailbox. |
| `mailboxes[].click_rate` | float | Click rate for this mailbox. |
| `mailboxes[].reply_count` | integer | Replies to emails from this mailbox. |
| `mailboxes[].reply_rate` | float | Reply rate for this mailbox. |
| `mailboxes[].bounce_count` | integer | Bounces from this mailbox. |
| `mailboxes[].bounce_rate` | float | Bounce rate for this mailbox. |
| `mailboxes[].unsubscribe_count` | integer | Unsubscribes from this mailbox. |
| `mailboxes[].unsubscribe_rate` | float | Unsubscribe rate for this mailbox. |
| `mailboxes[].warmup_emails_sent` | integer | Number of warmup emails sent (not included in `sent_count`). |
| `mailboxes[].daily_limit` | integer | Configured daily sending limit for this mailbox. |
| `mailboxes[].is_active` | boolean | Whether the mailbox is currently active in the campaign. |

### Notes

- `warmup_emails_sent` is tracked separately and is NOT included in `sent_count`.
- A mailbox with `bounce_rate` above 3% should be investigated immediately.
- Large discrepancies in `open_rate` between mailboxes often indicate deliverability differences tied to domain reputation.

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/campaigns/12345/mailbox-statistics?api_key=YOUR_API_KEY"
```

---

## 7. GET /campaigns/{campaign_id}/sequence-analytics

### Description

Returns engagement metrics for each step in the campaign's email sequence. Shows how each step (initial email, follow-up 1, follow-up 2, etc.) performs individually. Critical for optimizing sequence structure and identifying drop-off points.

### URL

```
GET https://server.smartlead.ai/api/v1/campaigns/{campaign_id}/sequence-analytics?api_key={api_key}
```

### Path Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `campaign_id` | integer | Yes | The unique identifier of the campaign. |

### Query Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key. |

### Response Schema

```json
{
  "campaign_id": 12345,
  "campaign_name": "Q1 SaaS Outreach",
  "total_steps": 4,
  "steps": [
    {
      "step_number": 1,
      "step_type": "EMAIL",
      "subject": "Quick question about {{company}}",
      "sent_count": 1240,
      "open_count": 580,
      "open_rate": 46.77,
      "click_count": 28,
      "click_rate": 2.26,
      "reply_count": 62,
      "reply_rate": 5.0,
      "bounce_count": 18,
      "bounce_rate": 1.45,
      "unsubscribe_count": 3,
      "variant_stats": [
        {
          "variant": "A",
          "subject": "Quick question about {{company}}",
          "sent_count": 620,
          "open_count": 310,
          "open_rate": 50.0,
          "reply_count": 38,
          "reply_rate": 6.13
        },
        {
          "variant": "B",
          "subject": "Idea for {{company}}",
          "sent_count": 620,
          "open_count": 270,
          "open_rate": 43.55,
          "reply_count": 24,
          "reply_rate": 3.87
        }
      ]
    },
    {
      "step_number": 2,
      "step_type": "EMAIL",
      "subject": "Re: Quick question about {{company}}",
      "sent_count": 1060,
      "open_count": 420,
      "open_rate": 39.62,
      "click_count": 10,
      "click_rate": 0.94,
      "reply_count": 38,
      "reply_rate": 3.58,
      "bounce_count": 0,
      "bounce_rate": 0.0,
      "unsubscribe_count": 2,
      "variant_stats": null
    },
    {
      "step_number": 3,
      "step_type": "EMAIL",
      "subject": "Re: Quick question about {{company}}",
      "sent_count": 920,
      "open_count": 310,
      "open_rate": 33.7,
      "click_count": 5,
      "click_rate": 0.54,
      "reply_count": 20,
      "reply_rate": 2.17,
      "bounce_count": 0,
      "bounce_rate": 0.0,
      "unsubscribe_count": 1,
      "variant_stats": null
    },
    {
      "step_number": 4,
      "step_type": "EMAIL",
      "subject": "Closing the loop",
      "sent_count": 800,
      "open_count": 190,
      "open_rate": 23.75,
      "click_count": 0,
      "click_rate": 0.0,
      "reply_count": 4,
      "reply_rate": 0.5,
      "bounce_count": 0,
      "bounce_rate": 0.0,
      "unsubscribe_count": 0,
      "variant_stats": null
    }
  ]
}
```

### Response Fields

| Field | Type | Description |
|---|---|---|
| `campaign_id` | integer | Campaign ID. |
| `campaign_name` | string | Campaign name. |
| `total_steps` | integer | Total number of steps in the sequence. |
| `steps` | array | Array of per-step analytic objects. |
| `steps[].step_number` | integer | The position of this step in the sequence (1-indexed). |
| `steps[].step_type` | string | Type of step: `EMAIL`, `MANUAL_EMAIL`, `LINKEDIN`, `WEBHOOK`, `DELAY`. |
| `steps[].subject` | string | The subject line for this step (may include template variables). |
| `steps[].sent_count` | integer | Emails sent at this step. |
| `steps[].open_count` | integer | Opens at this step. |
| `steps[].open_rate` | float | Open rate for this step. |
| `steps[].click_count` | integer | Clicks at this step. |
| `steps[].click_rate` | float | Click rate for this step. |
| `steps[].reply_count` | integer | Replies at this step. |
| `steps[].reply_rate` | float | Reply rate for this step. |
| `steps[].bounce_count` | integer | Bounces at this step. |
| `steps[].bounce_rate` | float | Bounce rate for this step. |
| `steps[].unsubscribe_count` | integer | Unsubscribes at this step. |
| `steps[].variant_stats` | array or null | If A/B testing is active on this step, an array of per-variant stats. Null if no variants. |
| `steps[].variant_stats[].variant` | string | Variant label (e.g., `A`, `B`, `C`). |
| `steps[].variant_stats[].subject` | string | Subject line for this variant. |
| `steps[].variant_stats[].sent_count` | integer | Emails sent for this variant. |
| `steps[].variant_stats[].open_count` | integer | Opens for this variant. |
| `steps[].variant_stats[].open_rate` | float | Open rate for this variant. |
| `steps[].variant_stats[].reply_count` | integer | Replies for this variant. |
| `steps[].variant_stats[].reply_rate` | float | Reply rate for this variant. |

### Notes

- `sent_count` decreases across steps because leads who reply, bounce, or unsubscribe are removed from subsequent steps.
- Bounces almost always occur at Step 1 since invalid addresses are caught on the first send.
- When `variant_stats` is present, use it to determine A/B test winners. The variant with the higher `reply_rate` is generally the winner.
- `step_type` values other than `EMAIL` (such as `LINKEDIN` or `WEBHOOK`) will not have open or click tracking.

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/campaigns/12345/sequence-analytics?api_key=YOUR_API_KEY"
```

---

## Error Responses

All endpoints share a common error response format.

### 401 Unauthorized

```json
{
  "error": "UNAUTHORIZED",
  "message": "Invalid or missing API key."
}
```

### 404 Not Found

```json
{
  "error": "NOT_FOUND",
  "message": "Campaign with ID 99999 not found."
}
```

### 400 Bad Request

```json
{
  "error": "BAD_REQUEST",
  "message": "Invalid date format. Expected YYYY-MM-DD."
}
```

### 429 Too Many Requests

```json
{
  "error": "RATE_LIMITED",
  "message": "Rate limit exceeded. Please retry after 60 seconds.",
  "retry_after": 60
}
```

### 500 Internal Server Error

```json
{
  "error": "INTERNAL_ERROR",
  "message": "An unexpected error occurred. Please try again later."
}
```

## Rate Limits

- Default rate limit: 60 requests per minute per API key.
- The `/lead-statistics` endpoint with large campaigns (10,000+ leads) may take several seconds to respond. Use pagination (`offset` and `limit`) to keep response times manageable.
- If you receive a `429` response, wait for the number of seconds specified in `retry_after` before retrying.
