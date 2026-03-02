# Lead Management API Endpoints Reference

Complete reference for all Smartlead lead management endpoints.

**Base URL:** `https://server.smartlead.ai/api/v1`
**Authentication:** All endpoints require `?api_key={API_KEY}` as a query parameter.

---

## Table of Contents

1. [Add Leads to Campaign](#1-add-leads-to-campaign)
2. [List Leads by Campaign](#2-list-leads-by-campaign)
3. [Fetch Lead by Email](#3-fetch-lead-by-email)
4. [Fetch All Leads (Account-Wide)](#4-fetch-all-leads-account-wide)
5. [Update a Lead](#5-update-a-lead)
6. [Resume a Lead](#6-resume-a-lead)
7. [Pause a Lead](#7-pause-a-lead)
8. [Delete a Lead](#8-delete-a-lead)
9. [Unsubscribe Lead from Campaign](#9-unsubscribe-lead-from-campaign)
10. [Unsubscribe Lead Globally](#10-unsubscribe-lead-globally)
11. [Add to Domain Block List](#11-add-to-domain-block-list)
12. [Update Lead Category](#12-update-lead-category)
13. [Fetch Lead Categories](#13-fetch-lead-categories)
14. [Get Lead Message History](#14-get-lead-message-history)
15. [Export Leads as CSV](#15-export-leads-as-csv)

---

## 1. Add Leads to Campaign

Add one or more leads to a specific campaign.

**Endpoint:**

```
POST /campaigns/{campaign_id}/leads?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description                |
|---------------|---------|----------|----------------------------|
| `campaign_id` | integer | Yes      | The target campaign's ID   |

**Query Parameters:**

| Parameter | Type   | Required | Description          |
|-----------|--------|----------|----------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

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

**Request Body Fields:**

| Field                                | Type    | Required | Description                                              |
|--------------------------------------|---------|----------|----------------------------------------------------------|
| `lead_list`                          | array   | Yes      | Array of lead objects                                    |
| `lead_list[].email`                  | string  | **Yes**  | Lead's email address (the only required field per lead)  |
| `lead_list[].first_name`            | string  | No       | Lead's first name                                        |
| `lead_list[].last_name`             | string  | No       | Lead's last name                                         |
| `lead_list[].phone_number`          | string  | No       | Phone number with country code                           |
| `lead_list[].company_name`          | string  | No       | Company or organization name                             |
| `lead_list[].website`               | string  | No       | Personal or company website                              |
| `lead_list[].location`              | string  | No       | Geographic location (free-form text)                     |
| `lead_list[].custom_fields`         | object  | No       | Key-value pairs, max 20 fields                           |
| `lead_list[].linkedin_profile`      | string  | No       | Full LinkedIn profile URL                                |
| `lead_list[].company_url`           | string  | No       | Company website URL                                      |
| `settings`                           | object  | No       | Controls for block list and unsubscribe list behavior    |
| `settings.ignore_global_block_list` | boolean | No       | If `true`, adds leads even if on global block list. Default: `false` |
| `settings.ignore_unsubscribe_list`  | boolean | No       | If `true`, adds leads even if previously unsubscribed. Default: `false` |

**Success Response (200):**

```json
{
  "status": "success",
  "upload_count": 1,
  "already_exists_count": 0,
  "blocked_count": 0,
  "unsubscribed_count": 0,
  "failed_count": 0,
  "message": "Leads added successfully"
}
```

**Response Fields:**

| Field                   | Type    | Description                                      |
|-------------------------|---------|--------------------------------------------------|
| `status`                | string  | `"success"` or `"error"`                         |
| `upload_count`          | integer | Number of leads successfully added               |
| `already_exists_count`  | integer | Number of leads already in the campaign          |
| `blocked_count`         | integer | Number of leads rejected due to block list       |
| `unsubscribed_count`    | integer | Number of leads rejected due to unsubscribe list |
| `failed_count`          | integer | Number of leads that failed to add               |
| `message`               | string  | Human-readable result message                    |

**Error Responses:**

| Status Code | Cause                                     | Example Response                                            |
|-------------|-------------------------------------------|-------------------------------------------------------------|
| 400         | Missing email in one or more leads        | `{"status": "error", "message": "Email is required for all leads"}` |
| 400         | Exceeded 20 custom fields                 | `{"status": "error", "message": "Maximum 20 custom fields allowed"}` |
| 404         | Campaign not found                        | `{"status": "error", "message": "Campaign not found"}`     |
| 401         | Invalid API key                           | `{"status": "error", "message": "Unauthorized"}`           |
| 429         | Rate limit exceeded                       | `{"status": "error", "message": "Rate limit exceeded"}`    |

**Notes:**

- Batch leads into groups of 100-200 per request to avoid rate limits.
- The campaign must have at least one sequence step and one connected email account.
- Duplicate leads (same email) within the same campaign are counted in `already_exists_count` and are not re-added.

---

## 2. List Leads by Campaign

Retrieve a paginated list of leads belonging to a specific campaign.

**Endpoint:**

```
GET /campaigns/{campaign_id}/leads?api_key={API_KEY}&offset=0&limit=100
```

**Path Parameters:**

| Parameter     | Type    | Required | Description              |
|---------------|---------|----------|--------------------------|
| `campaign_id` | integer | Yes      | The campaign's ID        |

**Query Parameters:**

| Parameter | Type    | Required | Default | Description                        |
|-----------|---------|----------|---------|------------------------------------|
| `api_key` | string  | Yes      | --      | Your Smartlead API key             |
| `offset`  | integer | No       | `0`     | Starting index for pagination      |
| `limit`   | integer | No       | `100`   | Number of leads to return (max 100)|

**Success Response (200):**

```json
[
  {
    "id": 12345,
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
    "company_url": "https://acme.com",
    "lead_status": "IN_PROGRESS",
    "lead_category": null,
    "created_at": "2026-01-15T10:30:00Z",
    "updated_at": "2026-02-01T14:22:00Z"
  }
]
```

**Response Fields (per lead):**

| Field              | Type        | Description                                     |
|--------------------|-------------|-------------------------------------------------|
| `id`               | integer     | Unique lead ID                                  |
| `first_name`       | string      | Lead's first name                               |
| `last_name`        | string      | Lead's last name                                |
| `email`            | string      | Lead's email address                            |
| `phone_number`     | string      | Phone number                                    |
| `company_name`     | string      | Company name                                    |
| `website`          | string      | Website URL                                     |
| `location`         | string      | Location string                                 |
| `custom_fields`    | object      | Custom key-value fields                         |
| `linkedin_profile` | string      | LinkedIn URL                                    |
| `company_url`      | string      | Company URL                                     |
| `lead_status`      | string      | Current status (see Lead Statuses below)        |
| `lead_category`    | object/null | Assigned category, or null                      |
| `created_at`       | string      | ISO 8601 timestamp of creation                  |
| `updated_at`       | string      | ISO 8601 timestamp of last update               |

**Error Responses:**

| Status Code | Cause              | Example Response                                        |
|-------------|--------------------|---------------------------------------------------------|
| 404         | Campaign not found | `{"status": "error", "message": "Campaign not found"}` |
| 401         | Invalid API key    | `{"status": "error", "message": "Unauthorized"}`       |

**Pagination:**

To fetch all leads, loop with incrementing offset:

```
GET /campaigns/{id}/leads?api_key={key}&offset=0&limit=100
GET /campaigns/{id}/leads?api_key={key}&offset=100&limit=100
GET /campaigns/{id}/leads?api_key={key}&offset=200&limit=100
# ... continue until response array length < limit
```

---

## 3. Fetch Lead by Email

Look up a lead across all campaigns using their email address.

**Endpoint:**

```
GET /leads/?api_key={API_KEY}&email={email}
```

**Query Parameters:**

| Parameter | Type   | Required | Description                 |
|-----------|--------|----------|-----------------------------|
| `api_key` | string | Yes      | Your Smartlead API key      |
| `email`   | string | Yes      | The email address to search |

**Success Response (200):**

```json
{
  "id": 12345,
  "first_name": "Jane",
  "last_name": "Doe",
  "email": "jane@example.com",
  "phone_number": "+14155551234",
  "company_name": "Acme Inc",
  "website": "https://acme.com",
  "location": "San Francisco, CA",
  "custom_fields": {
    "title": "VP of Sales"
  },
  "linkedin_profile": "https://linkedin.com/in/janedoe",
  "company_url": "https://acme.com",
  "campaigns": [
    {
      "campaign_id": 678,
      "campaign_name": "Q1 Outreach",
      "lead_status": "IN_PROGRESS"
    }
  ]
}
```

**Response Fields:**

| Field       | Type   | Description                                              |
|-------------|--------|----------------------------------------------------------|
| `id`        | integer| Global lead ID                                           |
| `email`     | string | The lead's email address                                 |
| `campaigns` | array  | List of campaigns this lead belongs to, with status info |

All other fields match the standard lead schema.

**Error Responses:**

| Status Code | Cause           | Example Response                                    |
|-------------|-----------------|-----------------------------------------------------|
| 404         | Lead not found  | `{"status": "error", "message": "Lead not found"}` |
| 401         | Invalid API key | `{"status": "error", "message": "Unauthorized"}`   |

---

## 4. Fetch All Leads (Account-Wide)

Retrieve all leads across the entire account.

**Endpoint:**

```
GET /leads?api_key={API_KEY}
```

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Success Response (200):**

```json
[
  {
    "id": 12345,
    "email": "jane@example.com",
    "first_name": "Jane",
    "last_name": "Doe",
    "company_name": "Acme Inc",
    "lead_status": "IN_PROGRESS",
    "created_at": "2026-01-15T10:30:00Z"
  }
]
```

Returns an array of lead objects.

**Error Responses:**

| Status Code | Cause           | Example Response                                  |
|-------------|-----------------|---------------------------------------------------|
| 401         | Invalid API key | `{"status": "error", "message": "Unauthorized"}` |

**Notes:**

- This endpoint can return very large result sets. Use campaign-scoped queries when possible.
- Consider using the export endpoint for bulk data retrieval.

---

## 5. Update a Lead

Update the details of an existing lead within a campaign.

**Endpoint:**

```
POST /campaigns/{campaign_id}/leads/{lead_id}?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description          |
|---------------|---------|----------|----------------------|
| `campaign_id` | integer | Yes      | The campaign's ID    |
| `lead_id`     | integer | Yes      | The lead's ID        |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

Send the full lead input object with the fields you want to update:

```json
{
  "first_name": "Jane",
  "last_name": "Smith",
  "email": "jane@example.com",
  "phone_number": "+14155559876",
  "company_name": "Acme Corp",
  "website": "https://acmecorp.com",
  "location": "New York, NY",
  "custom_fields": {
    "title": "CRO",
    "industry": "SaaS",
    "deal_size": "$50k"
  },
  "linkedin_profile": "https://linkedin.com/in/janesmith",
  "company_url": "https://acmecorp.com"
}
```

**Request Body Fields:**

| Field              | Type   | Required | Description                          |
|--------------------|--------|----------|--------------------------------------|
| `first_name`       | string | No       | Updated first name                   |
| `last_name`        | string | No       | Updated last name                    |
| `email`            | string | Yes      | Email address (cannot be changed, used for identification) |
| `phone_number`     | string | No       | Updated phone number                 |
| `company_name`     | string | No       | Updated company name                 |
| `website`          | string | No       | Updated website                      |
| `location`         | string | No       | Updated location                     |
| `custom_fields`    | object | No       | Updated custom fields (max 20)       |
| `linkedin_profile` | string | No       | Updated LinkedIn URL                 |
| `company_url`      | string | No       | Updated company URL                  |

**Success Response (200):**

```json
{
  "status": "success",
  "message": "Lead updated successfully",
  "lead": {
    "id": 12345,
    "email": "jane@example.com",
    "first_name": "Jane",
    "last_name": "Smith"
  }
}
```

**Error Responses:**

| Status Code | Cause              | Example Response                                        |
|-------------|--------------------|---------------------------------------------------------|
| 404         | Lead not found     | `{"status": "error", "message": "Lead not found"}`     |
| 404         | Campaign not found | `{"status": "error", "message": "Campaign not found"}` |
| 400         | Over 20 custom fields | `{"status": "error", "message": "Maximum 20 custom fields allowed"}` |
| 401         | Invalid API key    | `{"status": "error", "message": "Unauthorized"}`       |

---

## 6. Resume a Lead

Resume a previously paused lead so the campaign sequence continues.

**Endpoint:**

```
POST /campaigns/{campaign_id}/leads/{lead_id}/resume?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description       |
|---------------|---------|----------|-------------------|
| `campaign_id` | integer | Yes      | The campaign's ID |
| `lead_id`     | integer | Yes      | The lead's ID     |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

```json
{
  "resume_lead_with_delay_days": 0
}
```

**Request Body Fields:**

| Field                          | Type    | Required | Default | Description                                               |
|--------------------------------|---------|----------|---------|-----------------------------------------------------------|
| `resume_lead_with_delay_days`  | integer | No       | `0`     | Number of days to wait before resuming. `0` = immediately |

**Success Response (200):**

```json
{
  "status": "success",
  "message": "Lead resumed successfully"
}
```

**Error Responses:**

| Status Code | Cause                 | Example Response                                           |
|-------------|-----------------------|------------------------------------------------------------|
| 404         | Lead not found        | `{"status": "error", "message": "Lead not found"}`        |
| 400         | Lead is not paused    | `{"status": "error", "message": "Lead is not paused"}`    |
| 401         | Invalid API key       | `{"status": "error", "message": "Unauthorized"}`          |

---

## 7. Pause a Lead

Pause a lead to temporarily halt the campaign sequence for that lead.

**Endpoint:**

```
POST /campaigns/{campaign_id}/leads/{lead_id}/pause?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description       |
|---------------|---------|----------|-------------------|
| `campaign_id` | integer | Yes      | The campaign's ID |
| `lead_id`     | integer | Yes      | The lead's ID     |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

No request body required.

**Success Response (200):**

```json
{
  "status": "success",
  "message": "Lead paused successfully"
}
```

**Error Responses:**

| Status Code | Cause                   | Example Response                                              |
|-------------|-------------------------|---------------------------------------------------------------|
| 404         | Lead not found          | `{"status": "error", "message": "Lead not found"}`           |
| 400         | Lead already paused     | `{"status": "error", "message": "Lead is already paused"}`   |
| 400         | Lead already completed  | `{"status": "error", "message": "Cannot pause completed lead"}` |
| 401         | Invalid API key         | `{"status": "error", "message": "Unauthorized"}`             |

**Notes:**

- Pausing is easily reversible via the resume endpoint.
- A paused lead does not receive any further emails until resumed.
- Pause does not affect other campaigns the lead may be part of.

---

## 8. Delete a Lead

Permanently remove a lead from a campaign.

**Endpoint:**

```
DELETE /campaigns/{campaign_id}/leads/{lead_id}?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description       |
|---------------|---------|----------|-------------------|
| `campaign_id` | integer | Yes      | The campaign's ID |
| `lead_id`     | integer | Yes      | The lead's ID     |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

No request body.

**Success Response (200):**

```json
{
  "status": "success",
  "message": "Lead deleted successfully"
}
```

**Error Responses:**

| Status Code | Cause              | Example Response                                        |
|-------------|--------------------|---------------------------------------------------------|
| 404         | Lead not found     | `{"status": "error", "message": "Lead not found"}`     |
| 404         | Campaign not found | `{"status": "error", "message": "Campaign not found"}` |
| 401         | Invalid API key    | `{"status": "error", "message": "Unauthorized"}`       |

**WARNING:** This action is irreversible. The lead and all associated data (message history, status, category) within this campaign are permanently removed. Always confirm with the user before calling this endpoint.

---

## 9. Unsubscribe Lead from Campaign

Unsubscribe a lead from a single specific campaign.

**Endpoint:**

```
POST /campaigns/{campaign_id}/leads/{lead_id}/unsubscribe?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description       |
|---------------|---------|----------|-------------------|
| `campaign_id` | integer | Yes      | The campaign's ID |
| `lead_id`     | integer | Yes      | The lead's ID     |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

No request body.

**Success Response (200):**

```json
{
  "status": "success",
  "message": "Lead unsubscribed from campaign successfully"
}
```

**Error Responses:**

| Status Code | Cause                      | Example Response                                                  |
|-------------|----------------------------|-------------------------------------------------------------------|
| 404         | Lead not found             | `{"status": "error", "message": "Lead not found"}`               |
| 400         | Lead already unsubscribed  | `{"status": "error", "message": "Lead is already unsubscribed"}` |
| 401         | Invalid API key            | `{"status": "error", "message": "Unauthorized"}`                 |

**Notes:**

- This only affects the specified campaign. The lead can still receive emails from other campaigns.
- Unsubscribing is harder to reverse than pausing. Use pause if the intent is a temporary stop.

---

## 10. Unsubscribe Lead Globally

Unsubscribe a lead from all campaigns in the account.

**Endpoint:**

```
POST /leads/{lead_id}/unsubscribe?api_key={API_KEY}
```

**Path Parameters:**

| Parameter | Type    | Required | Description   |
|-----------|---------|----------|---------------|
| `lead_id` | integer | Yes      | The lead's ID |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

No request body.

**Success Response (200):**

```json
{
  "status": "success",
  "message": "Lead unsubscribed globally"
}
```

**Error Responses:**

| Status Code | Cause                      | Example Response                                                  |
|-------------|----------------------------|-------------------------------------------------------------------|
| 404         | Lead not found             | `{"status": "error", "message": "Lead not found"}`               |
| 400         | Lead already unsubscribed  | `{"status": "error", "message": "Lead is already unsubscribed"}` |
| 401         | Invalid API key            | `{"status": "error", "message": "Unauthorized"}`                 |

**WARNING:** This is a strong, account-wide action. The lead will be unsubscribed from every campaign and will not receive any further emails. Reversing this requires manual intervention. Always confirm with the user and consider whether campaign-level unsubscribe is more appropriate.

---

## 11. Add to Domain Block List

Block specific email addresses or entire domains from being added to campaigns.

**Endpoint:**

```
POST /leads/add-domain-block-list?api_key={API_KEY}
```

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

```json
{
  "domain_block_list": [
    "competitor@rival.com",
    "rivaldomain.com",
    "donotcontact.org"
  ],
  "client_id": null
}
```

**Request Body Fields:**

| Field               | Type         | Required | Description                                                     |
|---------------------|--------------|----------|-----------------------------------------------------------------|
| `domain_block_list` | array        | Yes      | Array of email addresses or domain strings to block             |
| `client_id`         | integer/null | No       | Whitelabel client ID, or `null` for non-whitelabel accounts     |

**Accepted formats in `domain_block_list`:**

- `"user@domain.com"` -- blocks a specific email address
- `"domain.com"` -- blocks the entire domain (all emails @domain.com)

**Success Response (200):**

```json
{
  "status": "success",
  "message": "Domain block list updated successfully",
  "blocked_count": 3
}
```

**Error Responses:**

| Status Code | Cause                    | Example Response                                                  |
|-------------|--------------------------|-------------------------------------------------------------------|
| 400         | Empty block list         | `{"status": "error", "message": "domain_block_list is required"}` |
| 400         | Invalid format           | `{"status": "error", "message": "Invalid email or domain format"}`|
| 401         | Invalid API key          | `{"status": "error", "message": "Unauthorized"}`                 |

**Notes:**

- Blocked domains prevent future lead additions. Existing leads already in active campaigns are not automatically removed.
- Entries are additive; calling this endpoint multiple times appends to the block list.

---

## 12. Update Lead Category

Assign or change the category of a lead within a campaign.

**Endpoint:**

```
POST /campaigns/{campaign_id}/leads/{lead_id}/category?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description       |
|---------------|---------|----------|-------------------|
| `campaign_id` | integer | Yes      | The campaign's ID |
| `lead_id`     | integer | Yes      | The lead's ID     |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Request Body:**

```json
{
  "category_id": 143,
  "pause_lead": false
}
```

**Request Body Fields:**

| Field         | Type    | Required | Default | Description                                              |
|---------------|---------|----------|---------|----------------------------------------------------------|
| `category_id` | integer | Yes      | --      | Numeric ID of the target category (from `/leads/categories`) |
| `pause_lead`  | boolean | No       | `false` | If `true`, also pauses the lead when changing category   |

**Success Response (200):**

```json
{
  "status": "success",
  "message": "Lead category updated successfully"
}
```

**Error Responses:**

| Status Code | Cause                | Example Response                                            |
|-------------|----------------------|-------------------------------------------------------------|
| 404         | Lead not found       | `{"status": "error", "message": "Lead not found"}`         |
| 404         | Category not found   | `{"status": "error", "message": "Category not found"}`     |
| 404         | Campaign not found   | `{"status": "error", "message": "Campaign not found"}`     |
| 401         | Invalid API key      | `{"status": "error", "message": "Unauthorized"}`           |

**Notes:**

- Fetch the list of valid categories first using `GET /leads/categories`.
- Setting `pause_lead: true` is useful for leads categorized as "Not Interested" or "Do Not Contact."

---

## 13. Fetch Lead Categories

Retrieve all lead categories available in the account.

**Endpoint:**

```
GET /leads/categories?api_key={API_KEY}
```

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Success Response (200):**

```json
[
  {
    "id": 143,
    "name": "Interested",
    "color": "#22c55e"
  },
  {
    "id": 144,
    "name": "Not Interested",
    "color": "#ef4444"
  },
  {
    "id": 145,
    "name": "Meeting Booked",
    "color": "#3b82f6"
  },
  {
    "id": 146,
    "name": "Out of Office",
    "color": "#f59e0b"
  },
  {
    "id": 147,
    "name": "Wrong Person",
    "color": "#8b5cf6"
  }
]
```

**Response Fields (per category):**

| Field   | Type    | Description                        |
|---------|---------|------------------------------------|
| `id`    | integer | Category ID (use in update calls)  |
| `name`  | string  | Human-readable category name       |
| `color` | string  | Hex color code for UI display      |

**Error Responses:**

| Status Code | Cause           | Example Response                                  |
|-------------|-----------------|---------------------------------------------------|
| 401         | Invalid API key | `{"status": "error", "message": "Unauthorized"}` |

---

## 14. Get Lead Message History

Retrieve the full email exchange history between the system and a lead within a campaign.

**Endpoint:**

```
GET /campaigns/{campaign_id}/leads/{lead_id}/message-history?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description       |
|---------------|---------|----------|-------------------|
| `campaign_id` | integer | Yes      | The campaign's ID |
| `lead_id`     | integer | Yes      | The lead's ID     |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Success Response (200):**

```json
[
  {
    "id": 99001,
    "type": "SENT",
    "subject": "Quick question about Acme's sales process",
    "body": "<p>Hi Jane, I noticed that...</p>",
    "from_email": "sender@outreach.com",
    "to_email": "jane@example.com",
    "sent_at": "2026-01-16T09:00:00Z",
    "sequence_step": 1,
    "opened": true,
    "clicked": false
  },
  {
    "id": 99002,
    "type": "REPLY",
    "subject": "Re: Quick question about Acme's sales process",
    "body": "<p>Thanks for reaching out! We are currently...</p>",
    "from_email": "jane@example.com",
    "to_email": "sender@outreach.com",
    "sent_at": "2026-01-17T14:22:00Z",
    "sequence_step": null,
    "opened": null,
    "clicked": null
  }
]
```

**Response Fields (per message):**

| Field           | Type         | Description                                          |
|-----------------|--------------|------------------------------------------------------|
| `id`            | integer      | Message ID                                           |
| `type`          | string       | `"SENT"` (outbound) or `"REPLY"` (inbound from lead)|
| `subject`       | string       | Email subject line                                   |
| `body`          | string       | Email body (HTML)                                    |
| `from_email`    | string       | Sender email address                                 |
| `to_email`      | string       | Recipient email address                              |
| `sent_at`       | string       | ISO 8601 timestamp                                   |
| `sequence_step` | integer/null | The sequence step number (null for replies)          |
| `opened`        | boolean/null | Whether the email was opened (null for replies)      |
| `clicked`       | boolean/null | Whether any link was clicked (null for replies)      |

**Error Responses:**

| Status Code | Cause              | Example Response                                        |
|-------------|--------------------|---------------------------------------------------------|
| 404         | Lead not found     | `{"status": "error", "message": "Lead not found"}`     |
| 404         | Campaign not found | `{"status": "error", "message": "Campaign not found"}` |
| 401         | Invalid API key    | `{"status": "error", "message": "Unauthorized"}`       |

---

## 15. Export Leads as CSV

Export all leads from a campaign as a CSV file.

**Endpoint:**

```
GET /campaigns/{campaign_id}/leads-export?api_key={API_KEY}
```

**Path Parameters:**

| Parameter     | Type    | Required | Description       |
|---------------|---------|----------|-------------------|
| `campaign_id` | integer | Yes      | The campaign's ID |

**Query Parameters:**

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

**Success Response (200):**

Returns a CSV file with `Content-Type: text/csv` header.

**CSV Columns:**

```
id,first_name,last_name,email,phone_number,company_name,website,location,linkedin_profile,company_url,lead_status,created_at,updated_at,custom_field_1,...,custom_field_n
```

The CSV includes all standard lead fields plus any custom fields as additional columns.

**Error Responses:**

| Status Code | Cause              | Example Response                                        |
|-------------|--------------------|---------------------------------------------------------|
| 404         | Campaign not found | `{"status": "error", "message": "Campaign not found"}` |
| 401         | Invalid API key    | `{"status": "error", "message": "Unauthorized"}`       |

**Notes:**

- The response is a downloadable CSV, not JSON.
- Large campaigns may result in slow response times. Consider paginated fetching via the list endpoint for programmatic processing.

---

## Lead Statuses Reference

| Status           | Description                                              | Can Transition To                                       |
|------------------|----------------------------------------------------------|---------------------------------------------------------|
| `UPLOADED`       | Lead added but sequence not started                      | NOT_STARTED, BLOCKED                                    |
| `NOT_STARTED`    | Queued, no emails sent yet                               | IN_PROGRESS, BLOCKED, UNSUBSCRIBED                      |
| `IN_PROGRESS`    | Actively receiving sequence emails                       | COMPLETED, FAILED, BLOCKED, UNSUBSCRIBED, INTERESTED, NOT_INTERESTED |
| `COMPLETED`      | All sequence steps sent                                  | INTERESTED, NOT_INTERESTED, UNSUBSCRIBED                |
| `FAILED`         | Delivery failure (bounce, invalid email)                 | (terminal state)                                        |
| `BLOCKED`        | On global block list                                     | (terminal state unless removed from block list)         |
| `UNSUBSCRIBED`   | Lead unsubscribed (campaign or global)                   | (terminal state)                                        |
| `INTERESTED`     | Marked as interested (manual or automatic)               | UNSUBSCRIBED                                            |
| `NOT_INTERESTED` | Marked as not interested (manual or automatic)           | UNSUBSCRIBED                                            |

---

## Common Query Parameter Reference

These query parameters are shared across multiple endpoints:

| Parameter | Type    | Endpoints                        | Description                              |
|-----------|---------|----------------------------------|------------------------------------------|
| `api_key` | string  | All endpoints                    | Required for authentication              |
| `offset`  | integer | List leads by campaign           | Pagination start index (default: 0)      |
| `limit`   | integer | List leads by campaign           | Number of results per page (default: 100)|
| `email`   | string  | Fetch lead by email              | Email address to search for              |

---

## Error Code Reference

Standard error codes returned across all lead management endpoints:

| HTTP Status | Error Code     | Description                                                    |
|-------------|----------------|----------------------------------------------------------------|
| 400         | `bad_request`  | Malformed request body or missing required fields              |
| 401         | `unauthorized` | Invalid or missing API key                                     |
| 404         | `not_found`    | The specified campaign, lead, or category does not exist       |
| 429         | `rate_limited` | Too many requests; back off and retry with exponential backoff |
| 500         | `server_error` | Internal Smartlead server error; retry after a short delay     |

**Retry Strategy:**

For `429` and `500` errors, implement exponential backoff:

1. Wait 1 second, retry.
2. Wait 2 seconds, retry.
3. Wait 4 seconds, retry.
4. Wait 8 seconds, retry.
5. After 5 retries, report the failure to the user.

---

## Rate Limiting

- **Bulk add leads**: Batch into 100-200 leads per request. Avoid sending more than 5 bulk-add requests per minute.
- **Read endpoints**: Generally safe at higher throughput, but respect 429 responses.
- **Write endpoints** (update, pause, resume, delete, unsubscribe, category): Space sequential calls by at least 200ms.
- Refer to `smartlead-context` for the latest rate limit thresholds.
