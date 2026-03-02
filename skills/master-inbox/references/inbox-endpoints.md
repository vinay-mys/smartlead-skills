# Master Inbox API Endpoints Reference

Complete reference for all 21 Smartlead master inbox endpoints.

Base URL: `https://server.smartlead.ai/api/v1`

Authentication: All endpoints require `?api_key={SMARTLEAD_API_KEY}` as a query parameter.

---

## 1. Fetch Inbox Replies

Retrieves paginated inbox replies with optional filters for campaign, category, search, and client.

**Endpoint:**

```
POST /inbox/replies?api_key={key}
```

**Request Body:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `offset` | integer | No | `0` | Pagination start index |
| `limit` | integer | No | `50` | Number of results (max 100) |
| `campaign_id` | integer | No | `null` | Filter by campaign ID |
| `search_term` | string | No | `""` | Search across lead email, name, or message body |
| `category_list` | array | No | `[]` | Filter by categories (e.g., `["Interested", "Meeting Booked"]`) |
| `client_id` | integer | No | `null` | Filter by client (agency accounts) |

**Example Request:**

```json
{
  "offset": 0,
  "limit": 25,
  "campaign_id": 101,
  "search_term": "pricing",
  "category_list": ["Interested", "Information Requested"],
  "client_id": null
}
```

**Response (200 OK):**

```json
{
  "data": [
    {
      "inbox_lead_id": 98765,
      "lead_id": 5001,
      "campaign_id": 101,
      "email": "contact@example.com",
      "first_name": "Jane",
      "last_name": "Smith",
      "category": "Interested",
      "read": false,
      "is_important": false,
      "is_snoozed": false,
      "is_archived": false,
      "revenue": null,
      "assigned_team_member": null,
      "last_message_time": "2026-02-28T14:30:00Z",
      "message_count": 3,
      "messages": [
        {
          "id": 50001,
          "type": "SENT",
          "subject": "Quick question about your workflow",
          "body": "<p>Hi Jane, ...</p>",
          "timestamp": "2026-02-27T09:00:00Z",
          "from_email": "sender@yourdomain.com"
        },
        {
          "id": 50002,
          "type": "RECEIVED",
          "subject": "Re: Quick question about your workflow",
          "body": "<p>Thanks for reaching out...</p>",
          "timestamp": "2026-02-28T14:30:00Z",
          "from_email": "contact@example.com"
        }
      ]
    }
  ],
  "total_count": 142
}
```

**Response Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `data` | array | Array of inbox lead objects |
| `data[].inbox_lead_id` | integer | Unique inbox-level lead identifier |
| `data[].lead_id` | integer | Campaign-level lead ID (use for reply endpoint) |
| `data[].campaign_id` | integer | Campaign the lead belongs to (use for reply endpoint) |
| `data[].email` | string | Lead email address |
| `data[].first_name` | string | Lead first name |
| `data[].last_name` | string | Lead last name |
| `data[].category` | string | Current lead category |
| `data[].read` | boolean | Whether the latest message has been read |
| `data[].is_important` | boolean | Whether the lead is flagged important |
| `data[].is_snoozed` | boolean | Whether the lead conversation is snoozed |
| `data[].is_archived` | boolean | Whether the lead is archived |
| `data[].revenue` | number | Deal revenue value (null if not set) |
| `data[].assigned_team_member` | string | Team member ID or null |
| `data[].last_message_time` | string | ISO 8601 timestamp of most recent message |
| `data[].message_count` | integer | Total messages in the conversation |
| `data[].messages` | array | Array of message objects (most recent messages) |
| `total_count` | integer | Total matching leads across all pages |

**Error Responses:**

| Status | Description |
|--------|-------------|
| 401 | Invalid or missing API key |
| 422 | Invalid request body (bad category name, negative offset) |
| 429 | Rate limit exceeded |

---

## 2. Fetch Unread Replies

Retrieves only leads with unread messages. Same pagination model as the general replies endpoint.

**Endpoint:**

```
POST /inbox/unread?api_key={key}
```

**Request Body:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `offset` | integer | No | `0` | Pagination start index |
| `limit` | integer | No | `50` | Number of results (max 100) |
| `campaign_id` | integer | No | `null` | Filter by campaign ID |
| `search_term` | string | No | `""` | Search across lead email, name, or message body |
| `client_id` | integer | No | `null` | Filter by client (agency accounts) |

**Example Request:**

```json
{
  "offset": 0,
  "limit": 20
}
```

**Response (200 OK):**

Same structure as `/inbox/replies`. All returned leads will have `"read": false`.

**Notes:**
- Does not accept `category_list` -- returns unread leads across all categories.
- Results are sorted by `last_message_time` descending (newest first).

---

## 3. Fetch Snoozed Messages

Retrieves leads whose conversations have been snoozed. Snoozed leads are hidden from the main inbox and reappear when the snooze period expires.

**Endpoint:**

```
POST /inbox/snoozed?api_key={key}
```

**Request Body:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `offset` | integer | No | `0` | Pagination start index |
| `limit` | integer | No | `50` | Number of results (max 100) |

**Example Request:**

```json
{
  "offset": 0,
  "limit": 50
}
```

**Response (200 OK):**

Same structure as `/inbox/replies`. All returned leads will have `"is_snoozed": true`. Each lead object includes a `snooze_until` field with the ISO 8601 timestamp when the lead will reappear.

---

## 4. Fetch Important Messages

Retrieves leads flagged as important by user action or automation rules.

**Endpoint:**

```
POST /inbox/important?api_key={key}
```

**Request Body:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `offset` | integer | No | `0` | Pagination start index |
| `limit` | integer | No | `50` | Number of results (max 100) |

**Example Request:**

```json
{
  "offset": 0,
  "limit": 50
}
```

**Response (200 OK):**

Same structure as `/inbox/replies`. All returned leads will have `"is_important": true`.

---

## 5. Fetch Scheduled Messages

Retrieves messages that are queued for future sending but have not yet been dispatched.

**Endpoint:**

```
POST /inbox/scheduled?api_key={key}
```

**Request Body:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `offset` | integer | No | `0` | Pagination start index |
| `limit` | integer | No | `50` | Number of results (max 100) |

**Example Request:**

```json
{
  "offset": 0,
  "limit": 50
}
```

**Response (200 OK):**

Same structure as `/inbox/replies`. Each lead object includes a `scheduled_send_time` field indicating when the message will be sent.

**Notes:**
- Scheduled messages can be cancelled by deleting the scheduled sequence step before the send time.
- Useful for reviewing outgoing messages before they are dispatched.

---

## 6. Fetch Messages with Reminders

Retrieves leads that have active reminders set on them. Reminders surface leads at a specified future time for follow-up.

**Endpoint:**

```
POST /inbox/reminders?api_key={key}
```

**Request Body:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `offset` | integer | No | `0` | Pagination start index |
| `limit` | integer | No | `50` | Number of results (max 100) |

**Example Request:**

```json
{
  "offset": 0,
  "limit": 50
}
```

**Response (200 OK):**

Same structure as `/inbox/replies`. Each lead object includes `reminder_date` and `reminder_note` fields.

---

## 7. Fetch Archived Messages

Retrieves leads that have been moved to the archive. Archived leads are hidden from the main inbox but their data is preserved.

**Endpoint:**

```
POST /inbox/archived?api_key={key}
```

**Request Body:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `offset` | integer | No | `0` | Pagination start index |
| `limit` | integer | No | `50` | Number of results (max 100) |

**Example Request:**

```json
{
  "offset": 0,
  "limit": 50
}
```

**Response (200 OK):**

Same structure as `/inbox/replies`. All returned leads will have `"is_archived": true`.

**Notes:**
- Archiving does not delete messages or remove the lead from the campaign.
- Archived leads can be unarchived by updating their status.

---

## 8. Fetch Untracked Replies

Retrieves replies that arrived in connected email accounts but could not be matched to any campaign lead. These may be from forwarded emails, manually added contacts, or addresses not in any campaign.

**Endpoint:**

```
GET /inbox/untracked?api_key={key}&offset=0&limit=50
```

**Query Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `offset` | integer | No | `0` | Pagination start index |
| `limit` | integer | No | `50` | Number of results (max 100) |

**Example Request:**

```
GET /inbox/untracked?api_key={key}&offset=0&limit=20
```

**Response (200 OK):**

```json
{
  "data": [
    {
      "id": 77001,
      "from_email": "unknown@company.com",
      "subject": "Re: Your proposal",
      "body": "<p>I got your email from a colleague...</p>",
      "timestamp": "2026-02-28T16:45:00Z",
      "to_email": "sender@yourdomain.com"
    }
  ],
  "total_count": 8
}
```

**Notes:**
- This is the only inbox listing endpoint that uses GET instead of POST.
- Pagination parameters are passed as query parameters, not in a request body.
- Untracked replies can be manually linked to campaigns through the Smartlead UI.

---

## 9. Fetch Lead by ID

Retrieves full detail for a single lead including complete message history, category, tags, tasks, notes, and assigned team member.

**Endpoint:**

```
GET /inbox/lead/{id}?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Example Request:**

```
GET /inbox/lead/98765?api_key={key}
```

**Response (200 OK):**

```json
{
  "inbox_lead_id": 98765,
  "lead_id": 5001,
  "campaign_id": 101,
  "email": "contact@example.com",
  "first_name": "Jane",
  "last_name": "Smith",
  "company": "Example Corp",
  "category": "Interested",
  "read": true,
  "is_important": false,
  "is_snoozed": false,
  "is_archived": false,
  "revenue": 5000.00,
  "assigned_team_member": "member-uuid-123",
  "last_message_time": "2026-02-28T14:30:00Z",
  "message_count": 4,
  "messages": [
    {
      "id": 50001,
      "type": "SENT",
      "subject": "Quick question about your workflow",
      "body": "<p>Hi Jane, ...</p>",
      "timestamp": "2026-02-27T09:00:00Z",
      "from_email": "sender@yourdomain.com"
    }
  ],
  "tasks": [
    {
      "id": 3001,
      "title": "Follow up call",
      "description": "Discuss pricing",
      "due_date": "2026-03-05T10:00:00Z",
      "completed": false,
      "assigned_to": "member-uuid-123"
    }
  ],
  "notes": [
    {
      "id": 4001,
      "note": "Spoke on phone, very interested in enterprise plan",
      "created_at": "2026-02-28T15:00:00Z",
      "created_by": "member-uuid-123"
    }
  ],
  "tags": ["enterprise", "high-priority"],
  "custom_fields": {
    "industry": "Technology",
    "company_size": "500-1000"
  }
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 401 | Invalid or missing API key |
| 404 | Lead not found with the given ID |

**Notes:**
- The `lead_id` and `campaign_id` fields in the response are what you need for the reply and forward endpoints.
- The `messages` array contains the full conversation history ordered chronologically.

---

## 10. Reply to Lead

Sends a reply to a lead's email thread from within the master inbox. The reply is sent from the same email account that originated the campaign sequence.

**Endpoint:**

```
POST /campaigns/{campaign_id}/leads/{lead_id}/reply?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `campaign_id` | integer | Yes | Campaign ID the lead belongs to |
| `lead_id` | integer | Yes | Lead ID within the campaign |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email_body` | string | Yes | HTML content of the reply |

**Example Request:**

```json
{
  "email_body": "<p>Hi Jane,</p><p>Thanks for your interest! I'd love to schedule a call to discuss further. Would Thursday at 2 PM work for you?</p><p>Best,<br>John</p>"
}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "message": "Reply sent successfully"
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Empty or invalid email body |
| 401 | Invalid or missing API key |
| 404 | Campaign or lead not found |
| 422 | Lead is in "Do Not Contact" category |
| 429 | Rate limit exceeded |

**Critical Notes:**
- Use `campaign_id` and `lead_id` from the inbox lead object, NOT the `inbox_lead_id`.
- The `email_body` must be HTML. Plain text without HTML tags may render incorrectly.
- The reply is threaded onto the existing email conversation.
- Replying does not automatically update the lead category or read status.

---

## 11. Forward a Reply

Forwards a lead's conversation thread to an external email address with an optional note.

**Endpoint:**

```
POST /campaigns/{campaign_id}/leads/{lead_id}/forward?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `campaign_id` | integer | Yes | Campaign ID the lead belongs to |
| `lead_id` | integer | Yes | Lead ID within the campaign |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `forward_to` | string | Yes | Recipient email address |
| `email_body` | string | No | Optional note prepended above forwarded content |

**Example Request:**

```json
{
  "forward_to": "manager@yourcompany.com",
  "email_body": "<p>FYI - this lead looks promising, can you review?</p>"
}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "message": "Reply forwarded successfully"
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Invalid email address format for `forward_to` |
| 401 | Invalid or missing API key |
| 404 | Campaign or lead not found |
| 429 | Rate limit exceeded |

**Notes:**
- The entire conversation thread is included in the forwarded email.
- The `email_body` field is optional and appears above the forwarded content.
- Uses the same `campaign_id`/`lead_id` identifiers as the reply endpoint.

---

## 12. Update Lead Revenue

Sets or updates the deal/revenue value associated with a lead for pipeline tracking.

**Endpoint:**

```
PATCH /inbox/lead/{id}/revenue?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `revenue` | number | Yes | Revenue value (use 0 to clear) |

**Example Request:**

```json
{
  "revenue": 15000.00
}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "inbox_lead_id": 98765,
  "revenue": 15000.00
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Invalid revenue value (negative numbers not allowed) |
| 401 | Invalid or missing API key |
| 404 | Lead not found |

**Notes:**
- Revenue is stored as a decimal number.
- Set to `0` to clear the revenue value.
- Revenue data is available in campaign analytics and reporting.

---

## 13. Update Lead Category

Updates the classification category of a lead. Categories drive automation rules and reporting.

**Endpoint:**

```
PATCH /inbox/lead/{id}/category?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `category` | string | Yes | New category name |

**Standard Categories:**

| Category | Description |
|----------|-------------|
| `Interested` | Lead expressed interest |
| `Not Interested` | Lead declined |
| `Do Not Contact` | Lead requested no further outreach |
| `Meeting Booked` | Meeting or call scheduled |
| `Out of Office` | Auto-reply detected |
| `Wrong Person` | Not the right contact |
| `Closed` | Deal closed (won or lost) |
| `Information Requested` | Lead asked for more details |

**Example Request:**

```json
{
  "category": "Meeting Booked"
}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "inbox_lead_id": 98765,
  "category": "Meeting Booked"
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Invalid or unrecognized category name |
| 401 | Invalid or missing API key |
| 404 | Lead not found |

**Notes:**
- Setting category to `Do Not Contact` pauses the lead in the campaign sequence.
- Category changes may trigger webhook events if configured.
- Custom categories may be available depending on account configuration.

---

## 14. Change Read Status

Marks a lead conversation as read or unread. Controls the unread badge in the inbox UI.

**Endpoint:**

```
PATCH /inbox/lead/{id}/read-status?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `read` | boolean | Yes | `true` to mark as read, `false` to mark as unread |

**Example Request:**

```json
{
  "read": true
}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "inbox_lead_id": 98765,
  "read": true
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 401 | Invalid or missing API key |
| 404 | Lead not found |

**Notes:**
- Marking as read does not affect other inbox views (important, snoozed, etc.).
- Always mark leads as read after processing to keep unread counts accurate.

---

## 15. Resume Lead

Resumes a lead that was previously paused. The lead will continue receiving campaign sequence emails from where it left off.

**Endpoint:**

```
PATCH /inbox/lead/{id}/resume?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

Empty object or no body required.

```json
{}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "inbox_lead_id": 98765,
  "message": "Lead resumed successfully"
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Lead is not in a paused state |
| 401 | Invalid or missing API key |
| 404 | Lead not found |

**Notes:**
- Only works on leads that are currently paused.
- The lead resumes from the next pending sequence step.
- If the lead's category is `Do Not Contact`, resuming will not override the category -- change the category first.

---

## 16. Create Lead Task

Creates a task associated with a lead for follow-up tracking. Tasks are visible in the lead detail view and on the team task dashboard.

**Endpoint:**

```
POST /inbox/lead/{id}/task?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | Yes | Task title (max 255 characters) |
| `description` | string | No | Task description with additional context |
| `due_date` | string | No | ISO 8601 datetime for task deadline |
| `assigned_to` | string | No | Team member ID to assign the task to |

**Example Request:**

```json
{
  "title": "Send proposal document",
  "description": "Lead requested enterprise pricing. Prepare and send the proposal by EOD.",
  "due_date": "2026-03-05T17:00:00Z",
  "assigned_to": "member-uuid-456"
}
```

**Response (201 Created):**

```json
{
  "status": "success",
  "task": {
    "id": 3002,
    "inbox_lead_id": 98765,
    "title": "Send proposal document",
    "description": "Lead requested enterprise pricing. Prepare and send the proposal by EOD.",
    "due_date": "2026-03-05T17:00:00Z",
    "assigned_to": "member-uuid-456",
    "completed": false,
    "created_at": "2026-03-02T10:00:00Z"
  }
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Missing required `title` field |
| 401 | Invalid or missing API key |
| 404 | Lead not found |
| 422 | Invalid `due_date` format or invalid `assigned_to` member ID |

**Notes:**
- Tasks without a `due_date` appear in the backlog.
- Tasks without `assigned_to` default to the account owner.
- Completed tasks are retained for audit purposes.

---

## 17. Create Lead Note

Adds an internal note to a lead. Notes are visible only to team members and provide context for the conversation.

**Endpoint:**

```
POST /inbox/lead/{id}/note?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `note` | string | Yes | Note content (plain text) |

**Example Request:**

```json
{
  "note": "Spoke with Jane on the phone. She is evaluating our tool alongside two competitors. Decision expected by end of March. Key concern is integration with their existing CRM."
}
```

**Response (201 Created):**

```json
{
  "status": "success",
  "note": {
    "id": 4002,
    "inbox_lead_id": 98765,
    "note": "Spoke with Jane on the phone. She is evaluating our tool alongside two competitors. Decision expected by end of March. Key concern is integration with their existing CRM.",
    "created_at": "2026-03-02T10:30:00Z",
    "created_by": "member-uuid-123"
  }
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Missing or empty `note` field |
| 401 | Invalid or missing API key |
| 404 | Lead not found |

**Notes:**
- Notes are internal-only and never visible to the lead.
- Notes are plain text. HTML tags will be stored as literal text, not rendered.
- Notes cannot be edited after creation via the API; they can only be added.

---

## 18. Set Reminder

Sets a reminder on a lead that will surface it in the reminders inbox view at the specified time.

**Endpoint:**

```
POST /inbox/lead/{id}/reminder?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `reminder_date` | string | Yes | ISO 8601 datetime when the reminder should fire |
| `note` | string | No | Context note for the reminder |

**Example Request:**

```json
{
  "reminder_date": "2026-03-10T09:00:00Z",
  "note": "Follow up on proposal -- check if they've had time to review"
}
```

**Response (201 Created):**

```json
{
  "status": "success",
  "reminder": {
    "id": 6001,
    "inbox_lead_id": 98765,
    "reminder_date": "2026-03-10T09:00:00Z",
    "note": "Follow up on proposal -- check if they've had time to review",
    "created_at": "2026-03-02T11:00:00Z"
  }
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Missing `reminder_date` field |
| 401 | Invalid or missing API key |
| 404 | Lead not found |
| 422 | `reminder_date` is in the past |

**Notes:**
- Setting a new reminder replaces any existing reminder on the lead.
- The reminder surfaces the lead in `POST /inbox/reminders` results once the date passes.
- The `note` field provides context when the reminder fires.

---

## 19. Push to Subsequence

Moves a lead into a different subsequence within the same campaign. Used for branching follow-up flows based on reply sentiment or other criteria.

**Endpoint:**

```
POST /inbox/lead/{id}/subsequence?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `subsequence_id` | integer | Yes | ID of the target subsequence |

**Example Request:**

```json
{
  "subsequence_id": 12345
}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "inbox_lead_id": 98765,
  "subsequence_id": 12345,
  "message": "Lead pushed to subsequence successfully"
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Missing `subsequence_id` field |
| 401 | Invalid or missing API key |
| 404 | Lead or subsequence not found |
| 422 | Subsequence does not belong to the same campaign |

**Notes:**
- The lead stops the current sequence and begins the target subsequence from step 1.
- Subsequences must belong to the same campaign as the lead.
- This is useful for handling different reply types (e.g., interested leads go to a meeting-booking subsequence, objections go to a nurture subsequence).

---

## 20. Update Team Member

Reassigns a lead to a different team member. The new team member receives a notification of the assignment.

**Endpoint:**

```
POST /inbox/lead/{id}/team-member?api_key={key}
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Inbox lead ID |

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `team_member_id` | string | Yes | UUID of the team member to assign |

**Example Request:**

```json
{
  "team_member_id": "member-uuid-789"
}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "inbox_lead_id": 98765,
  "assigned_team_member": "member-uuid-789",
  "message": "Team member updated successfully"
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Missing `team_member_id` field |
| 401 | Invalid or missing API key |
| 404 | Lead or team member not found |
| 422 | Team member does not have inbox access |

**Notes:**
- The newly assigned team member receives an in-app notification.
- Previous team member loses assignment but retains visibility if they have campaign access.
- Team member IDs can be obtained from the Smartlead team management API.
- Setting `team_member_id` to `null` removes the assignment.

---

## 21. Block Domains

Blocks one or more sender domains. All future replies from the specified domains will be automatically filtered out of the inbox.

**Endpoint:**

```
POST /inbox/block-domains?api_key={key}
```

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `domains` | array | Yes | Array of domain strings to block |

**Example Request:**

```json
{
  "domains": ["spamdomain.com", "unwanted-sender.org", "noreply.example.com"]
}
```

**Response (200 OK):**

```json
{
  "status": "success",
  "blocked_domains": ["spamdomain.com", "unwanted-sender.org", "noreply.example.com"],
  "message": "Domains blocked successfully"
}
```

**Error Responses:**

| Status | Description |
|--------|-------------|
| 400 | Empty `domains` array or invalid domain format |
| 401 | Invalid or missing API key |
| 422 | One or more domains are in an invalid format |

**Notes:**
- Existing messages from blocked domains are NOT retroactively deleted or hidden.
- Only future incoming replies from blocked domains are filtered.
- Blocking applies account-wide across all campaigns.
- To unblock domains, use the Smartlead UI settings. There is no API endpoint for unblocking.
- Domain format should be the bare domain (e.g., `example.com`), not a full email address.

---

## Common Patterns

### Pagination

All listing endpoints support `offset` and `limit` for pagination. To iterate through all results:

```
Page 1: offset=0, limit=50
Page 2: offset=50, limit=50
Page 3: offset=100, limit=50
...continue until data array is empty or offset >= total_count
```

### ID Mapping

The inbox uses two different ID systems:

| ID Field | Where Used | Description |
|----------|-----------|-------------|
| `inbox_lead_id` | PATCH/POST `/inbox/lead/{id}/*` endpoints | Unique identifier in the inbox system |
| `lead_id` + `campaign_id` | Reply and forward endpoints | Campaign-level identifiers needed for sending |

Always fetch the lead detail first to get both ID types before performing actions.

### Rate Limits

All endpoints share the account-level rate limit. If you receive a `429` response, wait and retry with exponential backoff. Typical limits are 10 requests per second per API key.
