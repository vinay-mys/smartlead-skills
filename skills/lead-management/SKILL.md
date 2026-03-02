---
name: lead-management
description: >-
  When the user wants to add, update, pause, resume, delete, or organize leads in Smartlead
  campaigns. Also use when the user mentions "leads," "contacts," "unsubscribe," "block list,"
  "lead status," "lead category." For campaign-level operations, see campaign-management.
  For replying to leads, see master-inbox.
metadata:
  version: 1.0.0
---

# Lead Management

You are an expert in Smartlead lead management. Your goal is to help users add, update, organize, and manage leads across campaigns via the Smartlead API.

## Context Check

Before performing any operation, read the `smartlead-context` skill to confirm:

- **Base URL**: `https://server.smartlead.ai/api/v1`
- **Authentication**: All requests require `?api_key={API_KEY}` as a query parameter.
- **Rate limits**: Respect Smartlead rate limits (see smartlead-context for current thresholds).
- **Client ID**: Some endpoints require a `client_id` field; use `null` for non-whitelabel accounts.

## Initial Assessment

When a user requests a lead operation, determine:

1. **Operation type** -- add, update, pause, resume, delete, block, unsubscribe, or categorize.
2. **Identifiers available** -- do they have a `campaign_id` and/or `lead_id`? If not, help them look these up first.
3. **Scale** -- single lead or bulk operation? Bulk adds use the `lead_list` array.
4. **Custom fields** -- are custom fields needed? Smartlead enforces a maximum of **20 custom fields** per lead.
5. **Category management** -- do they need to assign, change, or query lead categories?

## Core Endpoints

### Add Leads to a Campaign

```
POST /campaigns/{campaign_id}/leads?api_key={API_KEY}
```

**Request body:**

```json
{
  "lead_list": [
    {
      "first_name": "Jane",
      "last_name": "Doe",
      "email": "jane@example.com",
      "phone_number": "+14155551234",
      "company_name": "Acme Inc",
      "website": "https://acme.com",
      "location": "San Francisco, CA",
      "custom_fields": {
        "title": "VP of Sales",
        "industry": "SaaS"
      },
      "linkedin_profile": "https://linkedin.com/in/janedoe",
      "company_url": "https://acme.com"
    }
  ],
  "settings": {
    "ignore_global_block_list": false,
    "ignore_unsubscribe_list": false
  }
}
```

**Key notes:**

- `email` is the only **required** field per lead object.
- You may include up to **20 custom fields** per lead.
- `settings.ignore_global_block_list` defaults to `false`; set to `true` only when the user explicitly requests it.
- `settings.ignore_unsubscribe_list` defaults to `false`; override with caution.

### List Leads by Campaign

```
GET /campaigns/{campaign_id}/leads?api_key={API_KEY}&offset=0&limit=100
```

- **offset**: Starting index (default `0`).
- **limit**: Number of leads to return (default/max `100`).
- Paginate by incrementing `offset` by `limit` until fewer results than `limit` are returned.

### Fetch Lead by Email

```
GET /leads/?api_key={API_KEY}&email={email}
```

Returns lead data across all campaigns for the given email address.

### Fetch All Leads (Account-Wide)

```
GET /leads?api_key={API_KEY}
```

Returns all leads in the entire account. Use with caution on large accounts; prefer campaign-scoped queries when possible.

### Update a Lead

```
POST /campaigns/{campaign_id}/leads/{lead_id}?api_key={API_KEY}
```

**Request body** -- send the full lead input object with updated fields:

```json
{
  "first_name": "Jane",
  "last_name": "Smith",
  "email": "jane@example.com",
  "phone_number": "+14155551234",
  "company_name": "Acme Inc",
  "website": "https://acme.com",
  "location": "New York, NY",
  "custom_fields": {
    "title": "CRO",
    "industry": "SaaS"
  },
  "linkedin_profile": "https://linkedin.com/in/janesmith",
  "company_url": "https://acme.com"
}
```

### Resume a Lead

```
POST /campaigns/{campaign_id}/leads/{lead_id}/resume?api_key={API_KEY}
```

**Request body:**

```json
{
  "resume_lead_with_delay_days": 0
}
```

- Set `resume_lead_with_delay_days` to `0` for immediate resume, or a positive integer to delay.

### Pause a Lead

```
POST /campaigns/{campaign_id}/leads/{lead_id}/pause?api_key={API_KEY}
```

No request body required. The lead's sequence progression is halted until explicitly resumed.

### Delete a Lead

```
DELETE /campaigns/{campaign_id}/leads/{lead_id}?api_key={API_KEY}
```

Permanently removes the lead from the campaign. This action is **irreversible**.

### Unsubscribe Lead from a Campaign

```
POST /campaigns/{campaign_id}/leads/{lead_id}/unsubscribe?api_key={API_KEY}
```

Unsubscribes the lead from **one specific campaign**. The lead remains in other campaigns.

### Unsubscribe Lead Globally

```
POST /leads/{lead_id}/unsubscribe?api_key={API_KEY}
```

Unsubscribes the lead from **all campaigns** in the account. This is harder to reverse than a campaign-level unsubscribe.

### Add to Domain Block List

```
POST /leads/add-domain-block-list?api_key={API_KEY}
```

**Request body:**

```json
{
  "domain_block_list": [
    "blocked@domain.com",
    "entireblockedomain.com"
  ],
  "client_id": null
}
```

- Accepts individual emails or entire domains.
- Set `client_id` to `null` unless operating in a whitelabel context.

### Update Lead Category

```
POST /campaigns/{campaign_id}/leads/{lead_id}/category?api_key={API_KEY}
```

**Request body:**

```json
{
  "category_id": 143,
  "pause_lead": false
}
```

- `category_id`: The numeric ID of the target category (fetch available categories first).
- `pause_lead`: Set to `true` to also pause the lead when changing its category.

### Fetch Lead Categories

```
GET /leads/categories?api_key={API_KEY}
```

Returns all available lead categories for the account. Use the returned `id` values when updating a lead's category.

### Get Lead Message History

```
GET /campaigns/{campaign_id}/leads/{lead_id}/message-history?api_key={API_KEY}
```

Returns the full email thread history between the system and the lead within the specified campaign.

### Export Leads as CSV

```
GET /campaigns/{campaign_id}/leads-export?api_key={API_KEY}
```

Returns a CSV file of all leads in the campaign. Useful for bulk analysis or external processing.

## Lead Input Schema

The standard lead object accepted by add and update endpoints:

| Field              | Type   | Required | Description                          |
|--------------------|--------|----------|--------------------------------------|
| `first_name`       | string | No       | Lead's first name                    |
| `last_name`        | string | No       | Lead's last name                     |
| `email`            | string | **Yes**  | Lead's email address                 |
| `phone_number`     | string | No       | Phone number (include country code)  |
| `company_name`     | string | No       | Company or organization name         |
| `website`          | string | No       | Lead's personal or company website   |
| `location`         | string | No       | Geographic location (free-form text) |
| `custom_fields`    | object | No       | Key-value pairs (max 20 fields)      |
| `linkedin_profile` | string | No       | Full LinkedIn profile URL            |
| `company_url`      | string | No       | Company website URL                  |

## Lead Statuses

Leads progress through these statuses during a campaign:

| Status           | Description                                                  |
|------------------|--------------------------------------------------------------|
| `UPLOADED`       | Lead added to campaign but sequence not yet started          |
| `NOT_STARTED`    | Lead is queued but no emails have been sent                  |
| `IN_PROGRESS`    | Sequence is actively sending to this lead                    |
| `COMPLETED`      | All sequence steps have been sent                            |
| `FAILED`         | Delivery failed (bounce, invalid email, etc.)                |
| `BLOCKED`        | Lead is on the global block list                             |
| `UNSUBSCRIBED`   | Lead has unsubscribed                                        |
| `INTERESTED`     | Manually or automatically marked as interested               |
| `NOT_INTERESTED` | Manually or automatically marked as not interested           |

## Decision Guide

Use this to pick the right endpoint:

```
User wants to...
  add leads          --> POST /campaigns/{id}/leads
  list leads         --> GET  /campaigns/{id}/leads?offset=0&limit=100
  find by email      --> GET  /leads/?email={email}
  update a lead      --> POST /campaigns/{cid}/leads/{lid}
  pause a lead       --> POST /campaigns/{cid}/leads/{lid}/pause
  resume a lead      --> POST /campaigns/{cid}/leads/{lid}/resume
  delete a lead      --> DELETE /campaigns/{cid}/leads/{lid}
  unsub from one     --> POST /campaigns/{cid}/leads/{lid}/unsubscribe
  unsub globally     --> POST /leads/{lid}/unsubscribe
  block a domain     --> POST /leads/add-domain-block-list
  change category    --> POST /campaigns/{cid}/leads/{lid}/category
  get categories     --> GET  /leads/categories
  view messages      --> GET  /campaigns/{cid}/leads/{lid}/message-history
  export CSV         --> GET  /campaigns/{id}/leads-export
  list all leads     --> GET  /leads
```

## Common Mistakes

1. **Exceeding 20 custom fields per lead.** The API silently drops fields beyond the limit or returns an error. Always count custom fields before sending.
2. **Missing the `email` field.** Every lead object must include `email`. The add endpoint will reject the entire batch if any lead is missing it.
3. **Forgetting pagination parameters.** The list endpoint defaults to a limited result set. Always pass `offset` and `limit` and loop until all results are fetched.
4. **Adding leads to an unconfigured campaign.** Ensure the campaign has at least one sequence step and one connected email account before adding leads.
5. **Confusing unsubscribe with pause.** Pausing a lead stops the sequence temporarily and is easily reversed. Unsubscribing is a stronger action, especially global unsubscribe, which is harder to undo.
6. **Not checking the global block list.** Before adding leads, consider whether `ignore_global_block_list` should be `false` (the safe default). Adding blocked leads wastes sending capacity.
7. **Ignoring rate limits.** Bulk adds with large `lead_list` arrays can hit rate limits. Batch into groups of 100-200 leads per request.
8. **Using DELETE without confirmation.** Lead deletion is permanent. Always confirm the user's intent before calling the delete endpoint.

## Workflows

### Bulk Add Leads

1. Confirm the user has a `campaign_id` (if not, list campaigns via campaign-management).
2. Validate that every lead object has an `email` field.
3. Check custom fields count (must be 20 or fewer per lead).
4. Chunk large lists into batches of 100-200.
5. Call `POST /campaigns/{id}/leads` for each batch.
6. Report results: how many added, any failures.

### Find and Update a Lead

1. If the user has an email but no `lead_id`, call `GET /leads/?email={email}` to retrieve the lead.
2. Extract the `lead_id` and `campaign_id` from the response.
3. Construct the updated lead object.
4. Call `POST /campaigns/{cid}/leads/{lid}` with the updated body.
5. Confirm the update succeeded.

### Unsubscribe with Safety Check

1. Ask the user: campaign-level or global unsubscribe?
2. Warn that global unsubscribe affects **all** campaigns and is difficult to reverse.
3. If campaign-level: call `POST /campaigns/{cid}/leads/{lid}/unsubscribe`.
4. If global: call `POST /leads/{lid}/unsubscribe`.
5. Confirm completion.

### Categorize Leads

1. Fetch available categories with `GET /leads/categories`.
2. Present the list to the user and ask which category to assign.
3. Ask if the lead should also be paused (`pause_lead: true/false`).
4. Call `POST /campaigns/{cid}/leads/{lid}/category`.
5. Confirm the category change.

## Related Skills

| Skill                      | When to Use                                          |
|----------------------------|------------------------------------------------------|
| `smartlead-context`        | Auth setup, base URL, rate limits, global config     |
| `campaign-management`      | Creating, updating, or configuring campaigns         |
| `master-inbox`             | Replying to leads, managing inbox conversations      |
| `campaign-analytics`       | Viewing campaign stats, open rates, reply rates      |
| `email-account-management` | Adding or managing email sending accounts            |
| `webhook-management`       | Setting up webhooks for lead events                  |
