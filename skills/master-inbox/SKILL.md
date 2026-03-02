---
name: master-inbox
description: >-
  When the user wants to read, reply to, or manage lead conversations in the Smartlead
  master inbox. Also use when the user mentions "inbox," "replies," "respond to leads,"
  "message history," "unread messages," "lead tasks," "lead notes." For lead data management,
  see lead-management. For campaign configuration, see campaign-management.
metadata:
  version: 1.0.0
---

# Master Inbox

Role: Expert in Smartlead master inbox operations. Goal: help users manage lead conversations, replies, tasks, and notes via the API.

Context Check: Read smartlead-context first.

## Initial Assessment

Before taking action, determine:

1. **Operation** -- read replies, respond to a lead, categorize, create task/note, manage read status
2. **Filter needed** -- unread, snoozed, important, archived, scheduled, reminders
3. **Specific lead or bulk inbox view** -- single lead lookup vs. paginated inbox list
4. **Reply content and formatting needs** -- plain text vs. HTML, attachments
5. **Team member assignment needs** -- reassigning ownership or notifying team

## API Authentication

All endpoints require the query parameter `api_key`. Append `?api_key={SMARTLEAD_API_KEY}` to every request.

Base URL: `https://server.smartlead.ai/api/v1`

## Core Endpoints

### Inbox Listing Endpoints

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/inbox/replies` | Fetch inbox replies with filter body |
| POST | `/inbox/unread` | Fetch unread replies |
| POST | `/inbox/snoozed` | Fetch snoozed messages |
| POST | `/inbox/important` | Fetch important-marked messages |
| POST | `/inbox/scheduled` | Fetch scheduled messages |
| POST | `/inbox/reminders` | Fetch messages with reminders |
| POST | `/inbox/archived` | Fetch archived messages |
| GET | `/inbox/untracked` | Fetch untracked (non-campaign) replies |

### Lead-Specific Endpoints

| Method | Path | Purpose |
|--------|------|---------|
| GET | `/inbox/lead/{id}` | Fetch a single lead by inbox lead ID |
| PATCH | `/inbox/lead/{id}/revenue` | Update lead revenue value |
| PATCH | `/inbox/lead/{id}/category` | Update lead category |
| PATCH | `/inbox/lead/{id}/read-status` | Mark lead as read or unread |
| PATCH | `/inbox/lead/{id}/resume` | Resume a paused lead |
| POST | `/inbox/lead/{id}/task` | Create a task on a lead |
| POST | `/inbox/lead/{id}/note` | Create a note on a lead |
| POST | `/inbox/lead/{id}/reminder` | Set a reminder for a lead |
| POST | `/inbox/lead/{id}/subsequence` | Push lead into a subsequence |
| POST | `/inbox/lead/{id}/team-member` | Update assigned team member |

### Action Endpoints

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/campaigns/{cid}/leads/{lid}/reply` | Reply to a lead from the master inbox |
| POST | `/campaigns/{cid}/leads/{lid}/forward` | Forward a reply to an external address |
| POST | `/inbox/block-domains` | Block one or more sender domains |

## Endpoint Details

### Fetch Inbox Replies

```
POST /inbox/replies?api_key={key}
```

**Request Body:**

```json
{
  "offset": 0,
  "limit": 50,
  "campaign_id": null,
  "search_term": "",
  "category_list": ["Interested", "Not Interested", "Do Not Contact"],
  "client_id": null
}
```

- `offset` -- pagination start index (default 0)
- `limit` -- number of results to return (max 100)
- `campaign_id` -- optional filter by campaign
- `search_term` -- search across lead email, name, or message body
- `category_list` -- filter by one or more lead categories
- `client_id` -- optional filter by client (for agency accounts)

**Response:** Array of inbox lead objects with message history.

### Fetch Unread Replies

```
POST /inbox/unread?api_key={key}
```

**Request Body:**

```json
{
  "offset": 0,
  "limit": 50,
  "campaign_id": null,
  "search_term": "",
  "client_id": null
}
```

Returns only leads with unread messages. Same body schema as `/inbox/replies` but without `category_list`.

### Fetch Snoozed Messages

```
POST /inbox/snoozed?api_key={key}
```

**Request Body:**

```json
{
  "offset": 0,
  "limit": 50
}
```

Returns leads whose conversations have been snoozed. Snoozed leads reappear in inbox when the snooze period expires.

### Fetch Important Messages

```
POST /inbox/important?api_key={key}
```

**Request Body:**

```json
{
  "offset": 0,
  "limit": 50
}
```

Returns leads flagged as important by the user or automation rules.

### Fetch Scheduled Messages

```
POST /inbox/scheduled?api_key={key}
```

**Request Body:**

```json
{
  "offset": 0,
  "limit": 50
}
```

Returns messages that are scheduled to be sent but have not yet been dispatched.

### Fetch Messages with Reminders

```
POST /inbox/reminders?api_key={key}
```

**Request Body:**

```json
{
  "offset": 0,
  "limit": 50
}
```

Returns leads that have active reminders set on them.

### Fetch Archived Messages

```
POST /inbox/archived?api_key={key}
```

**Request Body:**

```json
{
  "offset": 0,
  "limit": 50
}
```

Returns leads that have been archived. Archived leads are hidden from the main inbox view.

### Get Untracked Replies

```
GET /inbox/untracked?api_key={key}&offset=0&limit=50
```

Returns replies that arrived but could not be matched to any campaign lead. Useful for catching responses from forwarded or manually added contacts.

### Fetch Lead by ID

```
GET /inbox/lead/{id}?api_key={key}
```

Returns full lead detail including message history, category, tags, tasks, notes, and assigned team member.

### Reply to Lead

```
POST /campaigns/{campaign_id}/leads/{lead_id}/reply?api_key={key}
```

**Request Body:**

```json
{
  "email_body": "<p>HTML content of reply</p>"
}
```

- `campaign_id` -- the campaign the lead belongs to (not the inbox lead ID)
- `lead_id` -- the lead ID within the campaign
- `email_body` -- HTML-formatted reply content

**Response:** `200 OK` with status confirmation.

**Important:** The `campaign_id` and `lead_id` are the campaign-level identifiers. These are different from the inbox lead ID returned by listing endpoints. Use the `campaign_id` and `lead_id` fields from the inbox lead object.

### Forward a Reply

```
POST /campaigns/{campaign_id}/leads/{lead_id}/forward?api_key={key}
```

**Request Body:**

```json
{
  "forward_to": "recipient@example.com",
  "email_body": "<p>Optional note above forwarded content</p>"
}
```

Forwards the lead's conversation thread to an external email address.

### Update Lead Revenue

```
PATCH /inbox/lead/{id}/revenue?api_key={key}
```

**Request Body:**

```json
{
  "revenue": 5000.00
}
```

Sets the deal/revenue value associated with the lead. Useful for pipeline tracking.

### Update Lead Category

```
PATCH /inbox/lead/{id}/category?api_key={key}
```

**Request Body:**

```json
{
  "category": "Interested"
}
```

Standard categories: `Interested`, `Not Interested`, `Do Not Contact`, `Meeting Booked`, `Out of Office`, `Wrong Person`, `Closed`, `Information Requested`.

### Change Read Status

```
PATCH /inbox/lead/{id}/read-status?api_key={key}
```

**Request Body:**

```json
{
  "read": true
}
```

Set `true` to mark as read, `false` to mark as unread.

### Resume Lead

```
PATCH /inbox/lead/{id}/resume?api_key={key}
```

**Request Body:**

```json
{}
```

Resumes a lead that was paused. The lead will continue receiving sequence emails.

### Create Lead Task

```
POST /inbox/lead/{id}/task?api_key={key}
```

**Request Body:**

```json
{
  "title": "Follow up call",
  "description": "Call to discuss proposal details",
  "due_date": "2026-03-15T10:00:00Z",
  "assigned_to": "team-member-id"
}
```

Creates a task associated with the lead. Tasks appear in the lead detail view and team task lists.

### Create Lead Note

```
POST /inbox/lead/{id}/note?api_key={key}
```

**Request Body:**

```json
{
  "note": "Spoke with lead on phone. Interested in enterprise plan."
}
```

Adds an internal note to the lead. Notes are visible only to team members.

### Set Reminder

```
POST /inbox/lead/{id}/reminder?api_key={key}
```

**Request Body:**

```json
{
  "reminder_date": "2026-03-10T09:00:00Z",
  "note": "Check if they responded to proposal"
}
```

Sets a reminder that will surface the lead in the reminders inbox view at the specified time.

### Push to Subsequence

```
POST /inbox/lead/{id}/subsequence?api_key={key}
```

**Request Body:**

```json
{
  "subsequence_id": 12345
}
```

Moves the lead into a different subsequence within the same campaign. Useful for branching follow-up flows based on reply sentiment.

### Update Team Member

```
POST /inbox/lead/{id}/team-member?api_key={key}
```

**Request Body:**

```json
{
  "team_member_id": "member-uuid"
}
```

Reassigns the lead to a different team member. The new team member receives notification of assignment.

### Block Domains

```
POST /inbox/block-domains?api_key={key}
```

**Request Body:**

```json
{
  "domains": ["spamdomain.com", "unwanted.org"]
}
```

Blocks all future replies from the specified domains. Existing messages are not deleted.

## Workflow: Responding to Leads

Follow this sequence when the user wants to reply to inbox messages:

1. **Fetch unread replies** -- `POST /inbox/unread` to get pending messages
2. **Review message history** -- `GET /inbox/lead/{id}` to see full conversation context
3. **Reply to lead** -- `POST /campaigns/{cid}/leads/{lid}/reply` with HTML body
4. **Update category** -- `PATCH /inbox/lead/{id}/category` if reply changes lead status
5. **Create follow-up task** -- `POST /inbox/lead/{id}/task` if further action is needed
6. **Mark as read** -- `PATCH /inbox/lead/{id}/read-status` to clear unread indicator

## Workflow: Inbox Triage

For bulk inbox management:

1. **Fetch unread** -- get all unread messages
2. **Categorize each lead** -- update category based on reply content
3. **Archive irrelevant** -- move non-actionable leads to archive
4. **Set reminders** -- for leads needing delayed follow-up
5. **Assign team members** -- route leads to appropriate team members
6. **Create tasks** -- for leads requiring specific actions

## Common Mistakes

- **Replying without checking message history first.** Always fetch the lead detail to understand context before composing a reply.
- **Not updating lead category after a positive or negative reply.** Categories drive reporting and automation rules.
- **Confusing inbox lead ID with campaign lead ID.** The reply endpoint uses `campaign_id` and `lead_id` from the campaign, not the inbox-level lead ID. These values are available in the inbox lead object.
- **Not marking messages as read after processing.** Unread counts become unreliable if read status is not updated.
- **Sending plain text in the `email_body` field.** The reply endpoint expects HTML content. Wrap plain text in `<p>` tags at minimum.
- **Forgetting pagination.** Inbox listing endpoints return paginated results. Always check if more results exist beyond the current offset + limit.

## Category Reference

| Category | When to Use |
|----------|-------------|
| Interested | Lead expressed interest in the offering |
| Not Interested | Lead declined or showed no interest |
| Do Not Contact | Lead requested removal from all outreach |
| Meeting Booked | A meeting or call has been scheduled |
| Out of Office | Auto-reply indicating lead is away |
| Wrong Person | Lead is not the right contact |
| Closed | Deal is closed (won or lost) |
| Information Requested | Lead asked for more details |

## Related Skills

- **smartlead-context** -- API authentication, base URL, rate limits, common patterns
- **lead-management** -- CRUD operations on leads, bulk imports, custom fields
- **campaign-management** -- Campaign creation, sequence configuration, scheduling
- **campaign-analytics** -- Delivery stats, open/click rates, reply analytics
- **webhook-management** -- Event subscriptions for real-time inbox notifications
- **client-management** -- Agency client scoping and permissions
