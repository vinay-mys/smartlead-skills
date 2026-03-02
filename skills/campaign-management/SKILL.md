---
name: campaign-management
description: >-
  When the user wants to create, configure, schedule, or manage email outreach campaigns
  in Smartlead. Also use when the user mentions "campaign," "sequence," "outreach schedule,"
  "campaign status." For lead operations within campaigns, see lead-management. For campaign
  performance data, see campaign-analytics.
metadata:
  version: 1.0.0
---

# Campaign Management

## Role

You are an expert in Smartlead campaign management. Your goal is to help users create, configure, schedule, and manage email outreach campaigns via the Smartlead API. You understand the full campaign lifecycle from creation through execution and monitoring, and you guide users through each step while enforcing best practices that prevent common errors.

## Context Check

Before proceeding with any campaign operation, read the `smartlead-context` skill to load:

- **Authentication**: The API key and how to pass it as a query parameter (`?api_key=YOUR_API_KEY`).
- **Base URL**: `https://server.smartlead.ai/api/v1`
- **Rate Limits**: Current rate limit thresholds to avoid 429 errors.
- **Client ID**: If the user operates under a white-label or sub-account setup.

All endpoints below are relative to the base URL. Every request must include the `api_key` query parameter.

## Initial Assessment

When a user asks for help with campaigns, gather the following before making any API calls:

1. **Campaign Goal** -- Are they creating a new campaign, updating an existing one, or managing campaign status (pause/start/stop)?
2. **Campaign ID** -- If updating or managing an existing campaign, do they have the campaign ID? If not, offer to list all campaigns so they can identify it.
3. **Sequence Details** -- How many sequence steps do they need? What delay between steps? Do they want A/B variants?
4. **Email Accounts** -- Which email accounts should send for this campaign? (If unknown, reference `email-account-management` to list available accounts.)
5. **Schedule Preferences** -- What timezone? Which days of the week? What sending hours? What is the maximum number of new leads per day?

## Core API Endpoints

### 1. Create a Campaign

```
POST /campaigns/create?api_key={api_key}
```

**Request Body:**

```json
{
  "name": "Q1 Outbound - Decision Makers",
  "client_id": null
}
```

- `name` (string, required): A descriptive name for the campaign.
- `client_id` (integer or null, optional): Pass a client ID for white-label setups. Use `null` for the default account.

**Response:** Returns the newly created campaign object including its `id`. Store this ID for all subsequent operations.

---

### 2. Configure Campaign Schedule

```
POST /campaigns/{campaign_id}/schedule?api_key={api_key}
```

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

- `timezone` (string, required): IANA timezone identifier.
- `days_of_the_week` (array of integers, required): 1 = Monday through 7 = Sunday.
- `start_hour` / `end_hour` (string, required): 24-hour format sending window.
- `min_time_btw_emails` (integer, optional): Minimum minutes between consecutive emails.
- `max_new_leads_per_day` (integer, optional): Daily cap for new lead engagement.
- `schedule_start_time` (string, optional): ISO 8601 datetime for campaign start.

---

### 3. Update Campaign Settings

```
POST /campaigns/{campaign_id}/settings?api_key={api_key}
```

**Request Body:**

```json
{
  "track_settings": ["TRACK_EMAIL_OPEN", "TRACK_LINK_CLICK"],
  "stop_lead_settings": "REPLY_TO_AN_EMAIL",
  "send_as_plain_text": false,
  "follow_up_percentage": 100,
  "add_unsubscribe_tag": true
}
```

- `track_settings` (array of strings, optional): Tracking options -- `TRACK_EMAIL_OPEN`, `TRACK_LINK_CLICK`.
- `stop_lead_settings` (string, optional): When to stop emailing a lead -- `REPLY_TO_AN_EMAIL`, `CLICK_ON_LINK`, etc.
- `send_as_plain_text` (boolean, optional): Send emails without HTML formatting.
- `follow_up_percentage` (integer, optional): Percentage of leads that receive follow-ups.
- `add_unsubscribe_tag` (boolean, optional): Include an unsubscribe link.

---

### 4. Get Campaign by ID

```
GET /campaigns/{campaign_id}?api_key={api_key}
```

No request body. Returns the full campaign object with settings, schedule, status, and metadata.

---

### 5. Save Campaign Sequences

```
POST /campaigns/{campaign_id}/sequences?api_key={api_key}
```

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
      "email_body": "Hi {{first_name}},\n\nI noticed {{company}} is scaling rapidly...",
      "variant_label": "A"
    },
    {
      "seq_number": 2,
      "seq_delay_details": {
        "delay_in_days": 3
      },
      "subject": "Re: Quick question about {{company}}",
      "email_body": "Hi {{first_name}},\n\nJust circling back on my previous email...",
      "variant_label": "A"
    },
    {
      "seq_number": 2,
      "seq_delay_details": {
        "delay_in_days": 3
      },
      "subject": "{{first_name}}, one more thought",
      "email_body": "Hi {{first_name}},\n\nI had another idea that might interest you...",
      "variant_label": "B"
    }
  ]
}
```

- `sequences` (array, required): Array of sequence step objects.
  - `seq_number` (integer): Step number in the sequence. Steps with the same `seq_number` but different `variant_label` are A/B test variants.
  - `seq_delay_details` (object): Contains `delay_in_days` (integer) -- how many days to wait after the previous step.
  - `subject` (string): Email subject line. Supports merge tags like `{{first_name}}`, `{{company}}`.
  - `email_body` (string): HTML or plain-text email body. Supports merge tags.
  - `variant_label` (string): Label for A/B variants -- typically `"A"`, `"B"`, `"C"`, etc.

---

### 6. List All Campaigns

```
GET /campaigns?api_key={api_key}
```

No request body. Returns an array of all campaign objects. Use this when the user does not know their campaign ID.

---

### 7. Change Campaign Status

```
POST /campaigns/{campaign_id}/status?api_key={api_key}
```

**Request Body:**

```json
{
  "status": "START"
}
```

- `status` (string, required): One of `PAUSED`, `STOPPED`, or `START`.
  - `START` -- Activates the campaign and begins sending.
  - `PAUSED` -- Temporarily halts sending. Can be resumed with `START`.
  - `STOPPED` -- Permanently stops the campaign. Cannot be restarted.

---

### 8. Fetch Sequence Data

```
GET /campaigns/{campaign_id}/sequences?api_key={api_key}
```

No request body. Returns the saved sequences for a campaign including all steps, variants, and delay configurations.

---

### 9. Delete Campaign

```
DELETE /campaigns/{campaign_id}?api_key={api_key}
```

No request body. Permanently deletes the campaign. This action cannot be undone.

---

### 10. Create Subsequence

```
POST /campaigns/create-subsequence?api_key={api_key}
```

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

- `name` (string, required): Name of the subsequence.
- `parent_campaign_id` (integer, required): Parent campaign ID.
- `client_id` (integer, optional): Client ID for whitelabel accounts.
- `delayForNewLeads` (integer, optional): Delay in days before leads enter the subsequence.
- `stopLeadOnParentCampaignReply` (boolean, optional): Stop leads on parent campaign reply.
- `conditionEvents` (array, required): Event rules that trigger the subsequence.

---

### 11. Export Campaign Data as CSV

```
GET /campaigns/{campaign_id}/leads-export?api_key={api_key}
```

No request body. Returns campaign lead data in CSV format. Use for reporting or external data analysis.

---

## End-to-End Campaign Creation Workflow

Follow these steps in order to create and launch a campaign successfully:

### Step 1: Create the Campaign

Call `POST /campaigns/create` with a descriptive name. Save the returned `id`.

### Step 2: Configure the Schedule

Call `POST /campaigns/{id}/schedule` with timezone, sending days, hours, and daily lead limits. Always set the timezone explicitly -- do not rely on defaults.

### Step 3: Set Up Sequences

Call `POST /campaigns/{id}/sequences` with the full array of sequence steps. Include:
- A minimum of one step (the initial outreach email).
- Appropriate delays between follow-up steps (typically 2-5 days).
- A/B variants if the user wants to test different subject lines or email bodies.

### Step 4: Attach Email Accounts

Reference the `email-account-management` skill. Call the appropriate endpoint to link one or more verified email accounts to this campaign. Without attached email accounts, the campaign cannot send.

### Step 5: Add Leads

Reference the `lead-management` skill. Upload leads to the campaign by providing lead email addresses and any merge tag data (first name, company, etc.). Leads must be added before starting.

### Step 6: Start the Campaign

Call `POST /campaigns/{id}/status` with `{"status": "START"}`. Verify the response confirms the campaign is active.

### Post-Launch

- Monitor performance using the `campaign-analytics` skill.
- Pause with `{"status": "PAUSED"}` if adjustments are needed.
- Stop permanently with `{"status": "STOPPED"}` only when the campaign is finished.

## Common Mistakes and How to Avoid Them

| Mistake | Consequence | Prevention |
|---|---|---|
| Starting a campaign before attaching email accounts | Campaign fails silently or throws an error; no emails are sent. | Always verify at least one email account is attached before calling the status endpoint with `START`. |
| Not setting timezone in schedule | Emails send at unexpected times, potentially outside business hours for the target audience. | Always explicitly include the `timezone` field with a valid IANA timezone string. |
| Using invalid status values | API returns a 400 error. | Only use `PAUSED`, `STOPPED`, or `START`. These values are case-sensitive and must be uppercase. |
| Forgetting to save sequences before starting | Campaign starts with no email content, resulting in no sends. | Always call `POST /campaigns/{id}/sequences` and verify the response before changing status to `START`. |
| Deleting active campaigns without pausing first | May cause incomplete sends or data loss. | Always set status to `PAUSED` or `STOPPED` before calling `DELETE`. |
| Omitting merge tags in email body | Leads receive generic emails with raw tag placeholders like `{{first_name}}`. | Verify that all merge tags used in sequences correspond to fields present in your lead data. |
| Setting delay_in_days to 0 for all steps | All emails in the sequence fire on the same day, which looks spammy and harms deliverability. | Use delays of at least 1-3 days between follow-up steps. |
| Exceeding rate limits during bulk operations | API returns 429 errors and requests are dropped. | Check rate limits in `smartlead-context` and add appropriate delays between API calls. |

## Validation Checklist

Before starting any campaign, confirm the following:

- [ ] Campaign has a descriptive name.
- [ ] Schedule is configured with explicit timezone.
- [ ] At least one sequence step is saved.
- [ ] Merge tags in sequences match lead data fields.
- [ ] At least one verified email account is attached.
- [ ] Leads have been uploaded to the campaign.
- [ ] Campaign settings (tracking, unsubscribe tag) are configured.
- [ ] Schedule start time is in the future (if set).

## Related Skills

| Skill | When to Use |
|---|---|
| `smartlead-context` | Load authentication, base URL, rate limits, and global configuration before any API call. |
| `lead-management` | Upload, update, remove, or query leads within a campaign. |
| `email-account-management` | List, add, verify, or attach email sending accounts to campaigns. |
| `campaign-analytics` | Retrieve open rates, click rates, reply rates, and other performance metrics for campaigns. |
| `webhook-management` | Set up webhooks to receive real-time notifications for campaign events (replies, bounces, opens). |
| `master-inbox` | Access the unified inbox to view and respond to lead replies across all campaigns. |
