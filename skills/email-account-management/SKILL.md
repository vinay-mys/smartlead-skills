---
name: email-account-management
description: >-
  When the user wants to set up, configure, or manage email sending accounts and warmup
  in Smartlead. Also use when the user mentions "email account," "mailbox," "SMTP," "IMAP,"
  "warmup," "sending limit," "reconnect." For domain purchasing, see smart-senders.
  For attaching accounts to campaigns, see campaign-management.
metadata:
  version: 1.0.0
---

# Email Account Management

You are an expert in Smartlead email account infrastructure. Your goal is to help users create, configure, and maintain email sending accounts with warmup capabilities.

## Context Check

Read the `smartlead-context` skill first to understand the user's API key configuration, base URL, and authentication pattern before proceeding with any operations.

## Initial Assessment

Before taking action, determine:

1. **Operation type** - What does the user need? (create, update, warmup config, reconnect, list, tag)
2. **Email provider** - Which provider? (Gmail, Outlook, Yahoo, custom SMTP/IMAP)
3. **SMTP/IMAP credentials** - Does the user have the host, port, username, and password ready?
4. **Warmup preferences** - Should warmup be enabled? What daily volume, rampup increment, and reply rate?
5. **Client assignment** - Does the account need to be assigned to a specific client (for agency use)?

## Core API Endpoints

### Account CRUD Operations

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/v1/email-accounts/save` | Create a new email account (set `id=null`) or update existing |
| GET | `/api/v1/email-accounts/?offset=0&limit=100` | List all email accounts with pagination |
| GET | `/api/v1/email-accounts/{emailAccountId}` | Get a single email account by ID |
| POST | `/api/v1/email-accounts/{emailAccountId}` | Update an existing email account |

### Warmup Operations

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/v1/email-accounts/{emailAccountId}/warmup` | Enable/disable or configure warmup settings |
| GET | `/api/v1/email-accounts/{emailAccountId}/warmup-stats` | Get 7-day warmup statistics (sent, landed in inbox, saved from spam) |

### Reconnect

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/v1/email-accounts/reconnect` | Bulk reconnect disconnected email accounts (rate limited) |

### Campaign Association

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/v1/campaigns/{campaignId}/email-accounts` | Add email accounts to a campaign |
| DELETE | `/api/v1/campaigns/{campaignId}/email-accounts` | Remove email accounts from a campaign |
| GET | `/api/v1/campaigns/{campaignId}/email-accounts` | List email accounts attached to a campaign |

### Tagging

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/v1/email-accounts/tags/add` | Add tags to email accounts |
| DELETE | `/api/v1/email-accounts/tags/remove` | Remove tags from email accounts |

## Create Account - Request Body

When creating a new email account, use `POST /api/v1/email-accounts/save` with the following body:

```json
{
  "id": null,
  "from_name": "John Doe",
  "from_email": "john@example.com",
  "user_name": "john@example.com",
  "password": "app-password-here",
  "smtp_host": "smtp.gmail.com",
  "smtp_port": 465,
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

**Key fields:**

- `id` - Set to `null` for new accounts. Use the account ID when updating.
- `from_name` - Display name shown to recipients.
- `from_email` - The email address used in the "From" header.
- `user_name` - Login username for SMTP/IMAP authentication (usually the same as from_email).
- `password` - App password or account password. For Gmail, this must be a Google App Password.
- `smtp_host` / `smtp_port` - Outgoing mail server and port.
- `imap_host` / `imap_port` - Incoming mail server and port.
- `max_email_per_day` - Maximum emails this account can send per day (campaign emails only, excludes warmup).
- `warmup_enabled` - Boolean to enable warmup from creation.
- `total_warmup_per_day` - Number of warmup emails sent per day.
- `daily_rampup` - Number of additional warmup emails added each day.
- `reply_rate_percentage` - Percentage of warmup emails that get auto-replied to (helps build sender reputation).
- `client_id` - For agency accounts, the client ID to assign this mailbox to. Use `0` or omit for non-agency use.

## Update Account - Request Body

Use `POST /api/v1/email-accounts/{emailAccountId}` with only the fields you want to change:

```json
{
  "max_email_per_day": 50,
  "bcc": "tracking@example.com",
  "signature": "<p>Best regards,<br>John Doe</p>",
  "client_id": 0,
  "time_to_wait_in_mins": 12,
  "custom_tracking_url": "https://track.example.com"
}
```

**Additional update fields:**

- `bcc` - BCC address added to every outgoing email from this account.
- `signature` - HTML signature appended to emails.
- `time_to_wait_in_mins` - Minimum wait time between emails sent from this account.
- `custom_tracking_url` - Custom domain for open/click tracking.

## Warmup Configuration

Use `POST /api/v1/email-accounts/{emailAccountId}/warmup`:

```json
{
  "warmup_enabled": true,
  "total_warmup_per_day": 30,
  "daily_rampup": 3,
  "reply_rate_percentage": 30,
  "warmup_key_id": null
}
```

**Fields:**

- `warmup_enabled` - Toggle warmup on or off.
- `total_warmup_per_day` - Target number of warmup emails per day.
- `daily_rampup` - How many additional warmup emails are added daily until the target is reached.
- `reply_rate_percentage` - Percentage of warmup emails that receive automatic replies.
- `warmup_key_id` - Optional. Custom warmup seed key ID for dedicated warmup pools.

## Common SMTP/IMAP Configurations

| Provider | SMTP Host | SMTP Port | IMAP Host | IMAP Port | Notes |
|----------|-----------|-----------|-----------|-----------|-------|
| Gmail | smtp.gmail.com | 465 | imap.gmail.com | 993 | Requires Google App Password |
| Outlook / Office 365 | smtp.office365.com | 587 | outlook.office365.com | 993 | May require admin consent for SMTP AUTH |
| Yahoo | smtp.mail.yahoo.com | 465 | imap.mail.yahoo.com | 993 | Requires Yahoo App Password |
| Zoho | smtp.zoho.com | 465 | imap.zoho.com | 993 | Use full email as username |
| GoDaddy (Workspace) | smtpout.secureserver.net | 465 | imap.secureserver.net | 993 | - |
| Custom / Self-hosted | Varies | 465 or 587 | Varies | 993 | Check with your hosting provider |

**Port guidance:**
- Port **465** = SSL/TLS (implicit encryption, recommended)
- Port **587** = STARTTLS (explicit encryption, required by some providers like Outlook)

## Warmup Best Practices

### For New Accounts (< 2 weeks old)
- Start with `total_warmup_per_day`: 15-20
- Set `daily_rampup`: 2
- Set `reply_rate_percentage`: 30-40
- Do NOT send campaign emails for the first 2 weeks

### For Established Accounts (2-4 weeks)
- Increase to `total_warmup_per_day`: 30-40
- Set `daily_rampup`: 3
- Begin campaign sending at low volume (10-15/day)

### For Mature Accounts (4+ weeks)
- Maintain `total_warmup_per_day`: 30-40 alongside campaign sending
- Set `max_email_per_day`: 40-75 depending on domain age and reputation
- Never disable warmup entirely while running campaigns

### General Rules
- Never exceed 40 warmup emails/day for accounts less than 2 weeks old
- Keep reply rate between 25-40%
- Total daily volume (warmup + campaign) should not exceed 100 for most accounts
- Always keep warmup enabled when sending campaign emails

## Reconnect Operations

Use `POST /api/v1/email-accounts/reconnect`:

```json
{
  "email_account_ids": [101, 102, 103]
}
```

**Rate limit:** Maximum 3 reconnect requests per 24-hour period. Plan reconnects carefully.

**When to reconnect:**
- Account shows "disconnected" status
- After changing password or app password
- After re-enabling SMTP/IMAP access in provider settings
- After resolving authentication issues

## Campaign Association

### Add Accounts to Campaign

`POST /api/v1/campaigns/{campaignId}/email-accounts`:

```json
{
  "email_account_ids": [101, 102, 103]
}
```

### Remove Accounts from Campaign

`DELETE /api/v1/campaigns/{campaignId}/email-accounts`:

```json
{
  "email_account_ids": [101]
}
```

### List Campaign Accounts

`GET /api/v1/campaigns/{campaignId}/email-accounts` returns all email accounts currently attached to a campaign.

## Tagging

### Add Tags

`POST /api/v1/email-accounts/tags/add`:

```json
{
  "email_account_ids": [101, 102],
  "tags": ["client-acme", "warmup-phase"]
}
```

### Remove Tags

`DELETE /api/v1/email-accounts/tags/remove`:

```json
{
  "email_account_ids": [101, 102],
  "tags": ["warmup-phase"]
}
```

Tags are useful for organizing accounts by client, domain, warmup stage, or campaign purpose.

## Common Mistakes to Avoid

1. **Wrong SMTP port** - Using port 465 for providers that require 587 (Outlook), or vice versa. Always check the provider table above.
2. **Not using App Passwords** - Gmail and Yahoo require app-specific passwords. Regular account passwords will fail authentication.
3. **Aggressive warmup on new accounts** - Setting `total_warmup_per_day` above 40 on accounts less than 2 weeks old damages deliverability.
4. **Exceeding reconnect rate limit** - Only 3 bulk reconnect calls per 24 hours. Batch your disconnected accounts into a single call.
5. **Creating duplicate accounts** - Adding the same email address twice causes an `ACCOUNT_ALREADY_EXIST` error. List existing accounts first.
6. **Disabling warmup while campaigning** - Turning off warmup while sending campaign emails weakens inbox placement.
7. **Missing IMAP configuration** - Both SMTP and IMAP must be configured. IMAP is required for warmup reply handling.
8. **Sending campaigns before warmup** - New accounts need at least 2 weeks of warmup-only activity before campaign sending.

## Error Responses

| Error Code | Meaning | Resolution |
|------------|---------|------------|
| `ACCOUNT_ALREADY_EXIST` | An account with this email address is already registered | List accounts to find the existing one and update it instead |
| `ACCOUNT_NOT_FOUND` | The email account ID does not exist | Verify the ID by listing all accounts |
| `ACCOUNT_VERIFICATION_FAILED` | SMTP/IMAP credentials could not be verified | Check host, port, username, password, and ensure SMTP/IMAP is enabled at the provider |
| `RATE_LIMIT_EXCEEDED` | Too many reconnect attempts in 24 hours | Wait and retry after the rate limit window resets |

## Workflows

### Workflow: Set Up a New Gmail Account

1. User generates a Google App Password at https://myaccount.google.com/apppasswords
2. Create the account via `POST /email-accounts/save` with Gmail SMTP/IMAP settings
3. Enable warmup with conservative settings (20/day, rampup 2, reply rate 30%)
4. Wait 2 weeks before attaching to any campaign
5. After warmup period, add to campaign and begin sending at 10-15 emails/day

### Workflow: Bulk Reconnect Disconnected Accounts

1. List all accounts via `GET /email-accounts/?offset=0&limit=100`
2. Filter for disconnected accounts in the response
3. Collect their IDs into a single array
4. Call `POST /email-accounts/reconnect` with all IDs at once (respect 3x/24hr limit)
5. Re-check account status after a few minutes

### Workflow: Organize Accounts with Tags

1. List all accounts to review the current inventory
2. Plan a tagging scheme (e.g., by client, domain, warmup stage)
3. Use `POST /email-accounts/tags/add` to apply tags in batches
4. Use tags for filtering and campaign assignment decisions

## Related Skills

- **smartlead-context** - API key setup, base URL, authentication
- **campaign-management** - Creating and managing campaigns, attaching email accounts to campaigns
- **smart-delivery** - Deliverability optimization, inbox rotation, sending patterns
- **smart-senders** - Purchasing and managing sending domains and mailboxes
- **campaign-analytics** - Tracking campaign performance, open rates, reply rates
- **lead-management** - Managing leads and lead lists for campaigns
