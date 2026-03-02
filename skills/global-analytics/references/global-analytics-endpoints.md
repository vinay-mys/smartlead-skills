# Global Analytics Endpoints Reference

Complete reference for all 22 Smartlead global analytics API endpoints.

**Base URL:** `https://server.smartlead.ai/api/v1`

**Authentication:** All endpoints require the `api_key` query parameter.

---

## 1. GET /analytics/overall-stats

Returns account-wide aggregate statistics across all campaigns.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD). Defaults to account creation date |
| `end_date` | string | No | End date (YYYY-MM-DD). Defaults to today |
| `client_id` | integer | No | Filter by client ID (agency accounts) |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "total_emails_sent": 125430,
    "total_emails_opened": 61210,
    "total_emails_clicked": 10034,
    "total_emails_replied": 6897,
    "total_emails_bounced": 2509,
    "total_emails_unsubscribed": 312,
    "open_rate": 48.8,
    "click_rate": 8.0,
    "reply_rate": 5.5,
    "bounce_rate": 2.0,
    "unsubscribe_rate": 0.25,
    "total_leads": 89200,
    "total_leads_contacted": 72340,
    "total_positive_replies": 3102,
    "positive_reply_rate": 2.47
  }
}
```

### Notes
- Rates are returned as percentages (0-100).
- Counts are cumulative within the specified date range.
- Omitting date filters returns all-time stats.

---

## 2. GET /analytics/day-wise-stats

Returns a day-by-day breakdown of email performance metrics.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD). Defaults to 30 days ago |
| `end_date` | string | No | End date (YYYY-MM-DD). Defaults to today |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "date": "2026-02-01",
      "sent": 4200,
      "opened": 2058,
      "clicked": 336,
      "replied": 231,
      "bounced": 84,
      "unsubscribed": 10,
      "open_rate": 49.0,
      "click_rate": 8.0,
      "reply_rate": 5.5,
      "bounce_rate": 2.0
    }
  ]
}
```

### Notes
- Returns one object per day within the range.
- Useful for trend analysis and spotting performance changes.
- Maximum range is 365 days per request.

---

## 3. GET /analytics/day-wise-stats-sent-time

Returns stats broken down by the hour of day emails were sent.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |
| `timezone` | string | No | Timezone for hour grouping (e.g., "America/New_York"). Defaults to UTC |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "sent_hour": 9,
      "sent_hour_label": "9:00 AM",
      "sent": 12400,
      "opened": 6324,
      "clicked": 1116,
      "replied": 806,
      "open_rate": 51.0,
      "click_rate": 9.0,
      "reply_rate": 6.5
    }
  ]
}
```

### Notes
- Returns 24 entries (one per hour, 0-23).
- Use this to identify optimal sending windows.
- Combine with timezone parameter for localized insights.

---

## 4. GET /analytics/campaigns

Returns a list of campaigns available for analytics filtering.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `client_id` | integer | No | Filter by client ID |
| `status` | string | No | Filter by status: `active`, `paused`, `completed`, `draft` |
| `search` | string | No | Search campaigns by name |
| `offset` | integer | No | Pagination offset (default 0) |
| `limit` | integer | No | Results per page (default 25, max 100) |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "campaigns": [
      {
        "id": 12345,
        "name": "Q1 Outreach - Tech Founders",
        "status": "active",
        "created_at": "2026-01-15T10:30:00Z",
        "total_leads": 2500,
        "total_sent": 8900
      }
    ],
    "total_count": 48,
    "offset": 0,
    "limit": 25
  }
}
```

### Notes
- Use the returned campaign IDs to filter other analytics endpoints.
- Supports pagination for accounts with many campaigns.

---

## 5. GET /analytics/campaign-stats

Returns aggregate statistics across one or more campaigns.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_ids` | string | No | Comma-separated campaign IDs to include |
| `offset` | integer | No | Pagination offset (default 0) |
| `limit` | integer | No | Results per page (default 25, max 100) |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "campaigns": [
      {
        "campaign_id": 12345,
        "campaign_name": "Q1 Outreach - Tech Founders",
        "status": "active",
        "sent": 8900,
        "opened": 4361,
        "clicked": 712,
        "replied": 490,
        "bounced": 178,
        "unsubscribed": 22,
        "open_rate": 49.0,
        "click_rate": 8.0,
        "reply_rate": 5.5,
        "bounce_rate": 2.0,
        "positive_replies": 220,
        "positive_reply_rate": 2.47
      }
    ],
    "total_count": 48,
    "offset": 0,
    "limit": 25
  }
}
```

### Notes
- Without campaign_ids filter, returns stats for all campaigns.
- Useful for comparing campaign performance side by side.

---

## 6. GET /analytics/campaign-response

Returns response category breakdown per campaign.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_ids` | string | No | Comma-separated campaign IDs |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "campaign_id": 12345,
      "campaign_name": "Q1 Outreach - Tech Founders",
      "total_replies": 490,
      "positive": 220,
      "negative": 85,
      "neutral": 130,
      "out_of_office": 40,
      "do_not_contact": 15,
      "positive_rate": 44.9,
      "negative_rate": 17.3,
      "neutral_rate": 26.5,
      "ooo_rate": 8.2,
      "dnc_rate": 3.1
    }
  ]
}
```

### Notes
- Response categories are AI-classified by Smartlead.
- Rates are calculated as a percentage of total replies for that campaign.
- Use this to evaluate reply quality, not just reply volume.

---

## 7. GET /analytics/campaign-status

Returns the distribution of campaigns by status.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `client_id` | integer | No | Filter by client ID |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "total_campaigns": 48,
    "active": 12,
    "paused": 8,
    "completed": 22,
    "draft": 6,
    "active_rate": 25.0,
    "paused_rate": 16.7,
    "completed_rate": 45.8,
    "draft_rate": 12.5
  }
}
```

### Notes
- Useful for a quick overview of campaign lifecycle distribution.
- High paused count may indicate operational issues worth investigating.

---

## 8. GET /analytics/clients

Returns a list of clients available for analytics filtering (agency accounts).

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `search` | string | No | Search clients by name |
| `offset` | integer | No | Pagination offset (default 0) |
| `limit` | integer | No | Results per page (default 25, max 100) |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "clients": [
      {
        "id": 501,
        "name": "Acme Corp",
        "email": "contact@acmecorp.com",
        "total_campaigns": 5,
        "created_at": "2025-06-10T14:00:00Z"
      }
    ],
    "total_count": 32,
    "offset": 0,
    "limit": 25
  }
}
```

### Notes
- Only relevant for agency-tier Smartlead accounts.
- Use returned client IDs to filter other analytics endpoints.

---

## 9. GET /analytics/client-count

Returns month-wise count of active clients over time.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD). Defaults to 12 months ago |
| `end_date` | string | No | End date (YYYY-MM-DD). Defaults to today |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "month": "2026-01",
      "month_label": "January 2026",
      "active_clients": 28,
      "new_clients": 3,
      "churned_clients": 1,
      "net_change": 2
    }
  ]
}
```

### Notes
- Returns one entry per month in the range.
- Useful for tracking agency growth and client retention.

---

## 10. GET /analytics/client-stats

Returns aggregate stats filtered by client.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `client_id` | integer | No | Specific client ID. If omitted, returns stats per client |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `offset` | integer | No | Pagination offset (default 0) |
| `limit` | integer | No | Results per page (default 25, max 100) |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "clients": [
      {
        "client_id": 501,
        "client_name": "Acme Corp",
        "total_campaigns": 5,
        "sent": 15200,
        "opened": 7448,
        "clicked": 1216,
        "replied": 836,
        "bounced": 304,
        "open_rate": 49.0,
        "click_rate": 8.0,
        "reply_rate": 5.5,
        "bounce_rate": 2.0,
        "positive_replies": 376,
        "positive_reply_rate": 2.47
      }
    ],
    "total_count": 32,
    "offset": 0,
    "limit": 25
  }
}
```

### Notes
- Without client_id, returns a row per client for comparison.
- With client_id, returns a single client's aggregate stats.

---

## 11. GET /analytics/lead-stats

Returns lead-level aggregate statistics.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "total_leads": 89200,
    "total_contacted": 72340,
    "total_replied": 6897,
    "total_interested": 3102,
    "total_not_interested": 1450,
    "total_do_not_contact": 312,
    "total_wrong_person": 189,
    "total_out_of_office": 844,
    "contacted_rate": 81.1,
    "reply_rate": 9.5,
    "interested_rate": 4.3,
    "not_interested_rate": 2.0,
    "dnc_rate": 0.43
  }
}
```

### Notes
- Lead stats reflect unique lead counts, not email event counts.
- A lead who replied multiple times is counted once in total_replied.
- Rates are calculated against total_leads.

---

## 12. GET /analytics/lead-category-response

Returns response counts broken down by lead category.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |
| `category` | string | No | Filter by specific category |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "category": "Interested",
      "lead_count": 3102,
      "reply_count": 4580,
      "percentage": 44.9
    },
    {
      "category": "Not Interested",
      "lead_count": 1450,
      "reply_count": 1620,
      "percentage": 21.0
    },
    {
      "category": "Out of Office",
      "lead_count": 844,
      "reply_count": 844,
      "percentage": 12.2
    },
    {
      "category": "Neutral",
      "lead_count": 1189,
      "reply_count": 1530,
      "percentage": 17.2
    },
    {
      "category": "Do Not Contact",
      "lead_count": 312,
      "reply_count": 323,
      "percentage": 4.5
    }
  ]
}
```

### Notes
- Categories are AI-classified by Smartlead.
- reply_count may exceed lead_count when leads reply multiple times.
- Percentage is based on total responding leads.

---

## 13. GET /analytics/first-reply-time

Returns distribution of time elapsed before leads first replied.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "average_first_reply_hours": 18.4,
    "median_first_reply_hours": 12.2,
    "distribution": [
      {
        "bucket": "0-1 hours",
        "count": 420,
        "percentage": 6.1
      },
      {
        "bucket": "1-4 hours",
        "count": 1380,
        "percentage": 20.0
      },
      {
        "bucket": "4-12 hours",
        "count": 2070,
        "percentage": 30.0
      },
      {
        "bucket": "12-24 hours",
        "count": 1725,
        "percentage": 25.0
      },
      {
        "bucket": "24-48 hours",
        "count": 897,
        "percentage": 13.0
      },
      {
        "bucket": "48+ hours",
        "count": 405,
        "percentage": 5.9
      }
    ]
  }
}
```

### Notes
- Time is measured from the first email sent to a lead to their first reply.
- Useful for understanding engagement velocity.
- Lower first-reply times generally indicate stronger messaging.

---

## 14. GET /analytics/follow-up-reply-rate

Returns reply rate for each follow-up step in the email sequence.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "step": 1,
      "step_label": "Initial Email",
      "sent": 72340,
      "replied": 3448,
      "reply_rate": 4.8,
      "positive_replies": 1552,
      "positive_rate": 2.1
    },
    {
      "step": 2,
      "step_label": "Follow-up 1",
      "sent": 58200,
      "replied": 1920,
      "reply_rate": 3.3,
      "positive_replies": 864,
      "positive_rate": 1.5
    },
    {
      "step": 3,
      "step_label": "Follow-up 2",
      "sent": 42100,
      "replied": 1050,
      "reply_rate": 2.5,
      "positive_replies": 472,
      "positive_rate": 1.1
    },
    {
      "step": 4,
      "step_label": "Follow-up 3",
      "sent": 31500,
      "replied": 479,
      "reply_rate": 1.5,
      "positive_replies": 214,
      "positive_rate": 0.7
    }
  ]
}
```

### Notes
- Steps are numbered sequentially (1 = initial email, 2+ = follow-ups).
- Sent count decreases as leads reply or are removed from sequence.
- Use this to identify which follow-up steps are underperforming.

---

## 15. GET /analytics/lead-reply-time

Returns average time between sending an email and receiving a reply.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |
| `group_by` | string | No | Group results: `day`, `week`, `month`. Default `day` |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "overall_average_hours": 16.8,
    "overall_median_hours": 11.5,
    "trend": [
      {
        "period": "2026-02-01",
        "average_hours": 17.2,
        "median_hours": 12.0,
        "reply_count": 231
      },
      {
        "period": "2026-02-02",
        "average_hours": 15.8,
        "median_hours": 10.8,
        "reply_count": 245
      }
    ]
  }
}
```

### Notes
- Measures time from email-sent to reply-received for each reply event.
- Different from first-reply-time which only considers the first reply per lead.
- Trend data helps identify whether engagement speed is improving.

---

## 16. GET /analytics/positive-reply-stats

Returns day-wise counts and rates of positive replies.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD). Defaults to 30 days ago |
| `end_date` | string | No | End date (YYYY-MM-DD). Defaults to today |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "date": "2026-02-01",
      "total_sent": 4200,
      "total_replies": 231,
      "positive_replies": 104,
      "positive_rate_of_sent": 2.48,
      "positive_rate_of_replies": 45.0
    }
  ]
}
```

### Notes
- Two rate perspectives: positive as % of sent and positive as % of replies.
- Positive classification is AI-driven by Smartlead.
- Track this daily to measure campaign quality over time.

---

## 17. GET /analytics/positive-reply-stats-sent-time

Returns positive reply rates segmented by the hour the original email was sent.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |
| `timezone` | string | No | Timezone for hour grouping. Defaults to UTC |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "sent_hour": 9,
      "sent_hour_label": "9:00 AM",
      "total_sent": 12400,
      "positive_replies": 372,
      "positive_rate": 3.0
    },
    {
      "sent_hour": 10,
      "sent_hour_label": "10:00 AM",
      "total_sent": 14200,
      "positive_replies": 398,
      "positive_rate": 2.8
    }
  ]
}
```

### Notes
- Returns up to 24 entries (one per hour with sending activity).
- Identifies which sending hours produce the most positive responses.
- Combine with timezone parameter for recipient-local analysis.

---

## 18. GET /analytics/email-health

Returns per-email-account health scores and deliverability metrics.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `client_id` | integer | No | Filter by client ID |
| `health_status` | string | No | Filter: `healthy`, `warning`, `critical` |
| `offset` | integer | No | Pagination offset (default 0) |
| `limit` | integer | No | Results per page (default 25, max 100) |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "email_accounts": [
      {
        "email_account_id": 1001,
        "email": "john@company.com",
        "provider": "Google",
        "health_score": 92,
        "health_status": "healthy",
        "sent_last_7d": 280,
        "bounce_rate_7d": 1.2,
        "spam_rate_7d": 0.1,
        "open_rate_7d": 52.0,
        "reply_rate_7d": 6.1,
        "warmup_status": "completed",
        "daily_sending_limit": 50,
        "last_checked_at": "2026-03-01T08:00:00Z"
      }
    ],
    "summary": {
      "total_accounts": 15,
      "healthy": 11,
      "warning": 3,
      "critical": 1
    },
    "total_count": 15,
    "offset": 0,
    "limit": 25
  }
}
```

### Notes
- Health score ranges: 80-100 = healthy, 50-79 = warning, 0-49 = critical.
- Monitor this proactively; declining scores predict future deliverability issues.
- Accounts in warmup may have lower scores that improve over time.

---

## 19. GET /analytics/domain-health

Returns per-domain deliverability health metrics.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `client_id` | integer | No | Filter by client ID |
| `health_status` | string | No | Filter: `healthy`, `warning`, `critical` |
| `offset` | integer | No | Pagination offset (default 0) |
| `limit` | integer | No | Results per page (default 25, max 100) |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "domains": [
      {
        "domain": "company.com",
        "total_email_accounts": 5,
        "health_score": 88,
        "health_status": "healthy",
        "sent_last_7d": 1400,
        "bounce_rate_7d": 1.5,
        "spam_rate_7d": 0.2,
        "open_rate_7d": 49.5,
        "reply_rate_7d": 5.8,
        "spf_valid": true,
        "dkim_valid": true,
        "dmarc_valid": true,
        "blacklist_status": "clean",
        "last_checked_at": "2026-03-01T08:00:00Z"
      }
    ],
    "summary": {
      "total_domains": 6,
      "healthy": 4,
      "warning": 1,
      "critical": 1
    },
    "total_count": 6,
    "offset": 0,
    "limit": 25
  }
}
```

### Notes
- Includes DNS authentication status (SPF, DKIM, DMARC).
- Blacklist status indicates whether the domain appears on known email blacklists.
- A domain with invalid SPF/DKIM/DMARC should be fixed immediately.

---

## 20. GET /analytics/provider-performance

Returns performance metrics broken down by email provider.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |

### Response Schema

```json
{
  "ok": true,
  "data": [
    {
      "provider": "Google",
      "email_accounts": 8,
      "sent": 56000,
      "opened": 28560,
      "clicked": 4480,
      "replied": 3080,
      "bounced": 1008,
      "open_rate": 51.0,
      "click_rate": 8.0,
      "reply_rate": 5.5,
      "bounce_rate": 1.8,
      "average_health_score": 90
    },
    {
      "provider": "Microsoft (Outlook)",
      "email_accounts": 5,
      "sent": 42000,
      "opened": 19740,
      "clicked": 3360,
      "replied": 2310,
      "bounced": 882,
      "open_rate": 47.0,
      "click_rate": 8.0,
      "reply_rate": 5.5,
      "bounce_rate": 2.1,
      "average_health_score": 85
    },
    {
      "provider": "SMTP",
      "email_accounts": 2,
      "sent": 27430,
      "opened": 12910,
      "clicked": 2194,
      "replied": 1507,
      "bounced": 619,
      "open_rate": 47.1,
      "click_rate": 8.0,
      "reply_rate": 5.5,
      "bounce_rate": 2.3,
      "average_health_score": 82
    }
  ]
}
```

### Notes
- Providers typically include Google, Microsoft (Outlook), SMTP, and others.
- Compare bounce rates across providers to detect provider-specific issues.
- Average health score gives a quick read on provider reliability.

---

## 21. GET /analytics/mailbox-stats

Returns per-mailbox sending and deliverability statistics.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `client_id` | integer | No | Filter by client ID |
| `campaign_id` | integer | No | Filter by campaign ID |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `sort_by` | string | No | Sort field: `sent`, `bounce_rate`, `reply_rate`, `health_score`. Default `sent` |
| `sort_order` | string | No | `asc` or `desc`. Default `desc` |
| `offset` | integer | No | Pagination offset (default 0) |
| `limit` | integer | No | Results per page (default 25, max 100) |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "mailboxes": [
      {
        "email_account_id": 1001,
        "email": "john@company.com",
        "provider": "Google",
        "campaigns_active": 3,
        "sent": 4200,
        "opened": 2100,
        "clicked": 336,
        "replied": 231,
        "bounced": 63,
        "open_rate": 50.0,
        "click_rate": 8.0,
        "reply_rate": 5.5,
        "bounce_rate": 1.5,
        "health_score": 92,
        "daily_sending_limit": 50,
        "emails_sent_today": 38,
        "warmup_status": "completed",
        "warmup_reputation": 95,
        "last_sent_at": "2026-03-01T15:30:00Z"
      }
    ],
    "total_count": 15,
    "offset": 0,
    "limit": 25
  }
}
```

### Notes
- Most granular deliverability view - individual mailbox performance.
- Check emails_sent_today against daily_sending_limit to monitor capacity.
- Sort by bounce_rate descending to surface problem mailboxes quickly.

---

## 22. GET /analytics/team-board

Returns team member performance leaderboard and statistics.

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Smartlead API key |
| `start_date` | string | No | Start date (YYYY-MM-DD) |
| `end_date` | string | No | End date (YYYY-MM-DD) |
| `client_id` | integer | No | Filter by client ID |
| `sort_by` | string | No | Sort field: `sent`, `replied`, `positive_replies`, `reply_rate`. Default `sent` |
| `sort_order` | string | No | `asc` or `desc`. Default `desc` |

### Response Schema

```json
{
  "ok": true,
  "data": {
    "team_members": [
      {
        "user_id": 201,
        "name": "Alice Johnson",
        "email": "alice@agency.com",
        "role": "admin",
        "campaigns_owned": 8,
        "total_sent": 34200,
        "total_opened": 16758,
        "total_clicked": 2736,
        "total_replied": 1881,
        "total_bounced": 684,
        "total_positive_replies": 846,
        "open_rate": 49.0,
        "click_rate": 8.0,
        "reply_rate": 5.5,
        "bounce_rate": 2.0,
        "positive_reply_rate": 2.47
      },
      {
        "user_id": 202,
        "name": "Bob Smith",
        "email": "bob@agency.com",
        "role": "member",
        "campaigns_owned": 5,
        "total_sent": 22100,
        "total_opened": 10828,
        "total_clicked": 1768,
        "total_replied": 1216,
        "total_bounced": 464,
        "total_positive_replies": 547,
        "open_rate": 49.0,
        "click_rate": 8.0,
        "reply_rate": 5.5,
        "bounce_rate": 2.1,
        "positive_reply_rate": 2.48
      }
    ],
    "team_totals": {
      "total_members": 4,
      "total_sent": 125430,
      "total_replied": 6897,
      "total_positive_replies": 3102,
      "overall_reply_rate": 5.5,
      "overall_positive_rate": 2.47
    }
  }
}
```

### Notes
- Stats are attributed to the campaign owner (the team member who created or owns the campaign).
- Team totals provide the aggregate for quick benchmarking.
- Useful for performance reviews and workload distribution analysis.

---

## Error Responses

All endpoints return errors in a consistent format:

```json
{
  "ok": false,
  "error": {
    "code": "INVALID_API_KEY",
    "message": "The provided API key is invalid or expired."
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `INVALID_API_KEY` | 401 | API key is missing, invalid, or expired |
| `UNAUTHORIZED` | 403 | API key does not have permission for this resource |
| `INVALID_DATE_RANGE` | 400 | start_date is after end_date or format is invalid |
| `INVALID_CLIENT_ID` | 400 | Specified client_id does not exist |
| `INVALID_CAMPAIGN_ID` | 400 | Specified campaign_id does not exist |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests. Retry after the period in Retry-After header |
| `INTERNAL_ERROR` | 500 | Server-side error. Retry with exponential backoff |

### Rate Limits

- Default: 60 requests per minute per API key.
- Rate limit headers are included in every response:
  - `X-RateLimit-Limit`: Maximum requests per window
  - `X-RateLimit-Remaining`: Requests remaining in current window
  - `X-RateLimit-Reset`: Unix timestamp when the window resets
