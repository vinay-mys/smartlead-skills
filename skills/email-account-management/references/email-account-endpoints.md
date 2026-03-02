# Email Account Endpoints Reference

Complete API reference for all 16 Smartlead email account endpoints.

**Base URL:** `https://server.smartlead.ai/api/v1`

**Authentication:** All endpoints require the query parameter `?api_key={your_api_key}`.

---

## Table of Contents

1. [Create Email Account](#1-create-email-account)
2. [List All Email Accounts](#2-list-all-email-accounts)
3. [Get Email Account by ID](#3-get-email-account-by-id)
4. [Update Email Account](#4-update-email-account)
5. [Configure Warmup](#5-configure-warmup)
6. [Get Warmup Stats](#6-get-warmup-stats)
7. [Bulk Reconnect Email Accounts](#7-bulk-reconnect-email-accounts)
8. [Add Email Accounts to Campaign](#8-add-email-accounts-to-campaign)
9. [Remove Email Accounts from Campaign](#9-remove-email-accounts-from-campaign)
10. [List Campaign Email Accounts](#10-list-campaign-email-accounts)
11. [Add Tags to Email Accounts](#11-add-tags-to-email-accounts)
12. [Remove Tags from Email Accounts](#12-remove-tags-from-email-accounts)
13. [Get Email Account Tags](#13-get-email-account-tags)
14. [Delete Email Account](#14-delete-email-account)
15. [Test Email Account Connection](#15-test-email-account-connection)
16. [Get All Email Accounts Warmup Stats](#16-get-all-email-accounts-warmup-stats)

---

## 1. Create Email Account

Creates a new email sending account with SMTP/IMAP configuration and optional warmup settings.

**Endpoint:** `POST /api/v1/email-accounts/save?api_key={api_key}`

**Request Body:**

```json
{
  "id": null,
  "from_name": "John Doe",
  "from_email": "john@example.com",
  "user_name": "john@example.com",
  "password": "app-password-here",
  "smtp_host": "smtp.gmail.com",
  "smtp_port": 465,
  "smtp_port_type": "SSL",
  "imap_host": "imap.gmail.com",
  "imap_port": 993,
  "max_email_per_day": 30,
  "warmup_enabled": true,
  "total_warmup_per_day": 20,
  "daily_rampup": 2,
  "reply_rate_percentage": 30,
  "client_id": 0
}
```

**Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer/null | Yes | Must be `null` for new accounts. Use existing ID to update. |
| `from_name` | string | Yes | Display name shown in the "From" header. |
| `from_email` | string | Yes | Email address used as the sender. |
| `user_name` | string | Yes | SMTP/IMAP login username (usually same as from_email). |
| `password` | string | Yes | SMTP/IMAP password or app-specific password. |
| `smtp_host` | string | Yes | Outgoing SMTP server hostname. |
| `smtp_port` | integer | Yes | SMTP port (465 for SSL, 587 for STARTTLS). |
| `smtp_port_type` | string | No | `"SSL"` or `"TLS"`. Defaults based on port. |
| `imap_host` | string | Yes | Incoming IMAP server hostname. |
| `imap_port` | integer | Yes | IMAP port (typically 993). |
| `max_email_per_day` | integer | No | Maximum campaign emails per day. Default: 25. |
| `warmup_enabled` | boolean | No | Enable warmup on creation. Default: false. |
| `total_warmup_per_day` | integer | No | Target warmup emails per day. Default: 20. |
| `daily_rampup` | integer | No | Daily increase in warmup volume. Default: 2. |
| `reply_rate_percentage` | integer | No | Percentage of warmup emails that get auto-replies. Default: 30. |
| `client_id` | integer | No | Client ID for agency assignment. Use 0 for non-agency. |

**Success Response (200):**

```json
{
  "id": 12345,
  "from_name": "John Doe",
  "from_email": "john@example.com",
  "smtp_host": "smtp.gmail.com",
  "smtp_port": 465,
  "imap_host": "imap.gmail.com",
  "imap_port": 993,
  "max_email_per_day": 30,
  "warmup_enabled": true,
  "total_warmup_per_day": 20,
  "daily_rampup": 2,
  "reply_rate_percentage": 30,
  "status": "CONNECTED",
  "created_at": "2026-01-15T10:30:00Z"
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 400 | `ACCOUNT_ALREADY_EXIST` | An account with this email address already exists. |
| 400 | `ACCOUNT_VERIFICATION_FAILED` | SMTP/IMAP credentials could not be verified. |
| 401 | `UNAUTHORIZED` | Invalid or missing API key. |

---

## 2. List All Email Accounts

Retrieves a paginated list of all email accounts in the workspace.

**Endpoint:** `GET /api/v1/email-accounts/?api_key={api_key}&offset={offset}&limit={limit}`

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `offset` | integer | No | Starting index for pagination. Default: 0. |
| `limit` | integer | No | Number of accounts to return. Default: 100. Max: 100. |

**Success Response (200):**

```json
[
  {
    "id": 12345,
    "created_at": "2026-01-15T10:30:00Z",
    "from_name": "John Doe",
    "from_email": "john@example.com",
    "user_name": "john@example.com",
    "smtp_host": "smtp.gmail.com",
    "smtp_port": 465,
    "imap_host": "imap.gmail.com",
    "imap_port": 993,
    "max_email_per_day": 30,
    "warmup_enabled": true,
    "total_warmup_per_day": 20,
    "daily_rampup": 2,
    "reply_rate_percentage": 30,
    "status": "CONNECTED",
    "client_id": 0,
    "tags": ["warmup-phase", "gmail"]
  },
  {
    "id": 12346,
    "created_at": "2026-01-16T14:00:00Z",
    "from_name": "Jane Smith",
    "from_email": "jane@company.com",
    "user_name": "jane@company.com",
    "smtp_host": "smtp.office365.com",
    "smtp_port": 587,
    "imap_host": "outlook.office365.com",
    "imap_port": 993,
    "max_email_per_day": 50,
    "warmup_enabled": true,
    "total_warmup_per_day": 30,
    "daily_rampup": 3,
    "reply_rate_percentage": 30,
    "status": "CONNECTED",
    "client_id": 0,
    "tags": ["outlook", "client-acme"]
  }
]
```

**Notes:**
- Returns an empty array `[]` if no accounts exist.
- To retrieve all accounts when you have more than 100, paginate with increasing `offset` values.

---

## 3. Get Email Account by ID

Retrieves full details for a single email account.

**Endpoint:** `GET /api/v1/email-accounts/{emailAccountId}?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `emailAccountId` | integer | Yes | The unique ID of the email account. |

**Success Response (200):**

```json
{
  "id": 12345,
  "created_at": "2026-01-15T10:30:00Z",
  "from_name": "John Doe",
  "from_email": "john@example.com",
  "user_name": "john@example.com",
  "smtp_host": "smtp.gmail.com",
  "smtp_port": 465,
  "imap_host": "imap.gmail.com",
  "imap_port": 993,
  "max_email_per_day": 30,
  "warmup_enabled": true,
  "total_warmup_per_day": 20,
  "daily_rampup": 2,
  "reply_rate_percentage": 30,
  "status": "CONNECTED",
  "bcc": null,
  "signature": null,
  "custom_tracking_url": null,
  "time_to_wait_in_mins": 10,
  "client_id": 0,
  "tags": ["warmup-phase"],
  "campaigns": [
    {
      "campaign_id": 501,
      "campaign_name": "Q1 Outreach"
    }
  ]
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 404 | `ACCOUNT_NOT_FOUND` | No account exists with the given ID. |

---

## 4. Update Email Account

Updates mutable fields of an existing email account. Only include the fields you want to change.

**Endpoint:** `POST /api/v1/email-accounts/{emailAccountId}?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `emailAccountId` | integer | Yes | The unique ID of the email account to update. |

**Request Body (all fields optional):**

```json
{
  "max_email_per_day": 50,
  "bcc": "tracking@example.com",
  "signature": "<p>Best regards,<br>John Doe<br>Acme Corp</p>",
  "client_id": 42,
  "time_to_wait_in_mins": 12,
  "custom_tracking_url": "https://track.example.com",
  "from_name": "John D."
}
```

**Parameters:**

| Field | Type | Description |
|-------|------|-------------|
| `max_email_per_day` | integer | Maximum campaign emails per day. |
| `bcc` | string | BCC email address added to all outgoing emails. Set to `""` to clear. |
| `signature` | string | HTML email signature appended to emails. Set to `""` to clear. |
| `client_id` | integer | Client ID for agency reassignment. |
| `time_to_wait_in_mins` | integer | Minimum minutes to wait between consecutive sends from this account. |
| `custom_tracking_url` | string | Custom domain URL for tracking opens/clicks. Set to `""` to clear. |
| `from_name` | string | Update the display name. |

**Success Response (200):**

```json
{
  "id": 12345,
  "from_name": "John D.",
  "from_email": "john@example.com",
  "max_email_per_day": 50,
  "bcc": "tracking@example.com",
  "signature": "<p>Best regards,<br>John Doe<br>Acme Corp</p>",
  "time_to_wait_in_mins": 12,
  "custom_tracking_url": "https://track.example.com",
  "status": "CONNECTED",
  "updated_at": "2026-02-01T09:15:00Z"
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 404 | `ACCOUNT_NOT_FOUND` | No account exists with the given ID. |

---

## 5. Configure Warmup

Enables, disables, or reconfigures warmup settings for an email account.

**Endpoint:** `POST /api/v1/email-accounts/{emailAccountId}/warmup?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `emailAccountId` | integer | Yes | The unique ID of the email account. |

**Request Body:**

```json
{
  "warmup_enabled": true,
  "total_warmup_per_day": 30,
  "daily_rampup": 3,
  "reply_rate_percentage": 30,
  "warmup_key_id": null
}
```

**Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `warmup_enabled` | boolean | Yes | Toggle warmup on or off. |
| `total_warmup_per_day` | integer | No | Target warmup emails per day. Recommended: 20-40. |
| `daily_rampup` | integer | No | Number of additional warmup emails added daily until target is reached. |
| `reply_rate_percentage` | integer | No | Percentage of warmup emails that receive auto-replies (1-100). |
| `warmup_key_id` | integer/null | No | Custom warmup seed pool key ID. Use `null` for the default pool. |

**Success Response (200):**

```json
{
  "id": 12345,
  "warmup_enabled": true,
  "total_warmup_per_day": 30,
  "daily_rampup": 3,
  "reply_rate_percentage": 30,
  "warmup_key_id": null,
  "warmup_status": "ACTIVE",
  "updated_at": "2026-02-01T09:20:00Z"
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 404 | `ACCOUNT_NOT_FOUND` | No account exists with the given ID. |

---

## 6. Get Warmup Stats

Returns warmup performance statistics for the past 7 days.

**Endpoint:** `GET /api/v1/email-accounts/{emailAccountId}/warmup-stats?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `emailAccountId` | integer | Yes | The unique ID of the email account. |

**Success Response (200):**

```json
{
  "email_account_id": 12345,
  "warmup_stats": [
    {
      "date": "2026-02-24",
      "total_sent": 28,
      "landed_in_inbox": 25,
      "saved_from_spam": 3,
      "inbox_rate": 89.3
    },
    {
      "date": "2026-02-25",
      "total_sent": 30,
      "landed_in_inbox": 28,
      "saved_from_spam": 2,
      "inbox_rate": 93.3
    },
    {
      "date": "2026-02-26",
      "total_sent": 30,
      "landed_in_inbox": 29,
      "saved_from_spam": 1,
      "inbox_rate": 96.7
    },
    {
      "date": "2026-02-27",
      "total_sent": 30,
      "landed_in_inbox": 27,
      "saved_from_spam": 4,
      "inbox_rate": 90.0
    },
    {
      "date": "2026-02-28",
      "total_sent": 30,
      "landed_in_inbox": 30,
      "saved_from_spam": 0,
      "inbox_rate": 100.0
    },
    {
      "date": "2026-03-01",
      "total_sent": 30,
      "landed_in_inbox": 28,
      "saved_from_spam": 2,
      "inbox_rate": 93.3
    },
    {
      "date": "2026-03-02",
      "total_sent": 15,
      "landed_in_inbox": 14,
      "saved_from_spam": 1,
      "inbox_rate": 93.3
    }
  ],
  "summary": {
    "total_sent_7d": 193,
    "total_inbox_7d": 181,
    "total_saved_from_spam_7d": 13,
    "avg_inbox_rate_7d": 93.8
  }
}
```

**Response Fields:**

| Field | Description |
|-------|-------------|
| `total_sent` | Number of warmup emails sent on that day. |
| `landed_in_inbox` | Number that landed in the primary inbox. |
| `saved_from_spam` | Number that Smartlead's warmup network rescued from spam. |
| `inbox_rate` | Percentage of sent emails that landed in inbox. |

---

## 7. Bulk Reconnect Email Accounts

Reconnects one or more disconnected email accounts by re-verifying SMTP/IMAP credentials.

**Endpoint:** `POST /api/v1/email-accounts/reconnect?api_key={api_key}`

**Rate Limit:** Maximum 3 calls per 24-hour period.

**Request Body:**

```json
{
  "email_account_ids": [12345, 12346, 12347]
}
```

**Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email_account_ids` | array[integer] | Yes | List of email account IDs to reconnect. |

**Success Response (200):**

```json
{
  "success": true,
  "results": [
    {
      "id": 12345,
      "status": "CONNECTED",
      "message": "Successfully reconnected"
    },
    {
      "id": 12346,
      "status": "CONNECTED",
      "message": "Successfully reconnected"
    },
    {
      "id": 12347,
      "status": "FAILED",
      "message": "ACCOUNT_VERIFICATION_FAILED: Check SMTP credentials"
    }
  ],
  "reconnects_remaining_24h": 2
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 429 | `RATE_LIMIT_EXCEEDED` | Reconnect limit exceeded. Maximum 3 per 24 hours. |

---

## 8. Add Email Accounts to Campaign

Associates one or more email accounts with a campaign for sending.

**Endpoint:** `POST /api/v1/campaigns/{campaignId}/email-accounts?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `campaignId` | integer | Yes | The campaign ID. |

**Request Body:**

```json
{
  "email_account_ids": [12345, 12346]
}
```

**Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email_account_ids` | array[integer] | Yes | List of email account IDs to attach. |

**Success Response (200):**

```json
{
  "success": true,
  "campaign_id": 501,
  "added_accounts": [12345, 12346],
  "total_accounts_in_campaign": 4
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 404 | `CAMPAIGN_NOT_FOUND` | No campaign exists with the given ID. |
| 404 | `ACCOUNT_NOT_FOUND` | One or more email account IDs are invalid. |

---

## 9. Remove Email Accounts from Campaign

Detaches one or more email accounts from a campaign.

**Endpoint:** `DELETE /api/v1/campaigns/{campaignId}/email-accounts?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `campaignId` | integer | Yes | The campaign ID. |

**Request Body:**

```json
{
  "email_account_ids": [12345]
}
```

**Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email_account_ids` | array[integer] | Yes | List of email account IDs to remove. |

**Success Response (200):**

```json
{
  "success": true,
  "campaign_id": 501,
  "removed_accounts": [12345],
  "total_accounts_in_campaign": 3
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 404 | `CAMPAIGN_NOT_FOUND` | No campaign exists with the given ID. |

---

## 10. List Campaign Email Accounts

Returns all email accounts currently associated with a specific campaign.

**Endpoint:** `GET /api/v1/campaigns/{campaignId}/email-accounts?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `campaignId` | integer | Yes | The campaign ID. |

**Success Response (200):**

```json
{
  "campaign_id": 501,
  "email_accounts": [
    {
      "id": 12345,
      "from_name": "John Doe",
      "from_email": "john@example.com",
      "status": "CONNECTED",
      "max_email_per_day": 50,
      "warmup_enabled": true
    },
    {
      "id": 12346,
      "from_name": "Jane Smith",
      "from_email": "jane@company.com",
      "status": "CONNECTED",
      "max_email_per_day": 40,
      "warmup_enabled": true
    }
  ],
  "total_count": 2
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 404 | `CAMPAIGN_NOT_FOUND` | No campaign exists with the given ID. |

---

## 11. Add Tags to Email Accounts

Adds one or more tags to one or more email accounts. Tags are created automatically if they do not exist.

**Endpoint:** `POST /api/v1/email-accounts/tags/add?api_key={api_key}`

**Request Body:**

```json
{
  "email_account_ids": [12345, 12346],
  "tags": ["client-acme", "warmup-phase", "gmail"]
}
```

**Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email_account_ids` | array[integer] | Yes | List of email account IDs to tag. |
| `tags` | array[string] | Yes | List of tag names to add. |

**Success Response (200):**

```json
{
  "success": true,
  "tagged_accounts": [12345, 12346],
  "tags_applied": ["client-acme", "warmup-phase", "gmail"]
}
```

---

## 12. Remove Tags from Email Accounts

Removes one or more tags from one or more email accounts.

**Endpoint:** `DELETE /api/v1/email-accounts/tags/remove?api_key={api_key}`

**Request Body:**

```json
{
  "email_account_ids": [12345, 12346],
  "tags": ["warmup-phase"]
}
```

**Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email_account_ids` | array[integer] | Yes | List of email account IDs to untag. |
| `tags` | array[string] | Yes | List of tag names to remove. |

**Success Response (200):**

```json
{
  "success": true,
  "untagged_accounts": [12345, 12346],
  "tags_removed": ["warmup-phase"]
}
```

---

## 13. Get Email Account Tags

Retrieves all tags associated with a specific email account.

**Endpoint:** `GET /api/v1/email-accounts/{emailAccountId}/tags?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `emailAccountId` | integer | Yes | The unique ID of the email account. |

**Success Response (200):**

```json
{
  "email_account_id": 12345,
  "tags": [
    {
      "tag_id": 1,
      "name": "client-acme"
    },
    {
      "tag_id": 2,
      "name": "gmail"
    }
  ]
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 404 | `ACCOUNT_NOT_FOUND` | No account exists with the given ID. |

---

## 14. Delete Email Account

Permanently deletes an email account. This removes it from all campaigns and stops warmup.

**Endpoint:** `DELETE /api/v1/email-accounts/{emailAccountId}?api_key={api_key}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `emailAccountId` | integer | Yes | The unique ID of the email account to delete. |

**Success Response (200):**

```json
{
  "success": true,
  "deleted_account_id": 12345,
  "message": "Email account permanently deleted"
}
```

**Error Responses:**

| Status | Code | Description |
|--------|------|-------------|
| 404 | `ACCOUNT_NOT_FOUND` | No account exists with the given ID. |

**Warning:** This action is irreversible. The account will be removed from all campaigns and all warmup history will be lost. Confirm with the user before executing.

---

## 15. Test Email Account Connection

Tests the SMTP and IMAP connectivity for an email account without creating or modifying it. Useful for validating credentials before account creation.

**Endpoint:** `POST /api/v1/email-accounts/test-connection?api_key={api_key}`

**Request Body:**

```json
{
  "user_name": "john@example.com",
  "password": "app-password-here",
  "smtp_host": "smtp.gmail.com",
  "smtp_port": 465,
  "imap_host": "imap.gmail.com",
  "imap_port": 993
}
```

**Parameters:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_name` | string | Yes | SMTP/IMAP login username. |
| `password` | string | Yes | SMTP/IMAP password or app password. |
| `smtp_host` | string | Yes | Outgoing SMTP server hostname. |
| `smtp_port` | integer | Yes | SMTP port number. |
| `imap_host` | string | Yes | Incoming IMAP server hostname. |
| `imap_port` | integer | Yes | IMAP port number. |

**Success Response (200):**

```json
{
  "success": true,
  "smtp_status": "CONNECTED",
  "imap_status": "CONNECTED",
  "message": "Both SMTP and IMAP connections verified successfully"
}
```

**Failure Response (200 with error details):**

```json
{
  "success": false,
  "smtp_status": "FAILED",
  "imap_status": "CONNECTED",
  "message": "SMTP connection failed: Authentication error. Check username and password.",
  "error_details": {
    "smtp_error": "535 5.7.8 Authentication credentials invalid",
    "imap_error": null
  }
}
```

---

## 16. Get All Email Accounts Warmup Stats

Retrieves aggregated warmup statistics across all email accounts in the workspace. Provides a high-level overview of warmup health.

**Endpoint:** `GET /api/v1/email-accounts/warmup-stats/all?api_key={api_key}&offset={offset}&limit={limit}`

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `offset` | integer | No | Starting index for pagination. Default: 0. |
| `limit` | integer | No | Number of accounts to include. Default: 50. Max: 100. |

**Success Response (200):**

```json
{
  "accounts": [
    {
      "email_account_id": 12345,
      "from_email": "john@example.com",
      "warmup_enabled": true,
      "warmup_status": "ACTIVE",
      "stats_7d": {
        "total_sent": 193,
        "landed_in_inbox": 181,
        "saved_from_spam": 13,
        "avg_inbox_rate": 93.8
      }
    },
    {
      "email_account_id": 12346,
      "from_email": "jane@company.com",
      "warmup_enabled": true,
      "warmup_status": "ACTIVE",
      "stats_7d": {
        "total_sent": 210,
        "landed_in_inbox": 200,
        "saved_from_spam": 8,
        "avg_inbox_rate": 95.2
      }
    },
    {
      "email_account_id": 12347,
      "from_email": "sales@example.com",
      "warmup_enabled": false,
      "warmup_status": "DISABLED",
      "stats_7d": {
        "total_sent": 0,
        "landed_in_inbox": 0,
        "saved_from_spam": 0,
        "avg_inbox_rate": 0
      }
    }
  ],
  "summary": {
    "total_accounts": 3,
    "warmup_active": 2,
    "warmup_disabled": 1,
    "overall_avg_inbox_rate": 94.5
  },
  "pagination": {
    "offset": 0,
    "limit": 50,
    "has_more": false
  }
}
```

**Response Fields:**

| Field | Description |
|-------|-------------|
| `warmup_status` | Current warmup state: `ACTIVE`, `DISABLED`, `PAUSED`, or `PENDING`. |
| `stats_7d.total_sent` | Total warmup emails sent over the past 7 days. |
| `stats_7d.landed_in_inbox` | Total that reached primary inbox over 7 days. |
| `stats_7d.saved_from_spam` | Total rescued from spam by the warmup network. |
| `stats_7d.avg_inbox_rate` | Average inbox placement rate as a percentage. |
| `summary.overall_avg_inbox_rate` | Weighted average across all active warmup accounts. |

---

## Common Error Codes Reference

All endpoints may return the following errors:

| Status | Code | Description |
|--------|------|-------------|
| 401 | `UNAUTHORIZED` | Invalid or missing API key. |
| 400 | `BAD_REQUEST` | Malformed request body or missing required fields. |
| 404 | `ACCOUNT_NOT_FOUND` | The specified email account ID does not exist. |
| 404 | `CAMPAIGN_NOT_FOUND` | The specified campaign ID does not exist. |
| 400 | `ACCOUNT_ALREADY_EXIST` | An account with this email address already exists. |
| 400 | `ACCOUNT_VERIFICATION_FAILED` | SMTP/IMAP credentials could not be verified. |
| 429 | `RATE_LIMIT_EXCEEDED` | Too many requests (applies to reconnect endpoint). |
| 500 | `INTERNAL_SERVER_ERROR` | Unexpected server error. Retry or contact support. |

---

## Authentication

All requests must include the API key as a query parameter:

```
GET /api/v1/email-accounts/?api_key=YOUR_API_KEY_HERE
```

The API key is associated with your Smartlead workspace and can be found in Settings > API Keys within the Smartlead dashboard.

---

## Rate Limits

| Endpoint | Limit | Window |
|----------|-------|--------|
| Reconnect (`POST /email-accounts/reconnect`) | 3 requests | 24 hours |
| All other endpoints | Standard | Per-minute (varies by plan) |

For reconnect operations, plan your batches carefully. Combine all disconnected account IDs into a single request to conserve rate limit allowance.
