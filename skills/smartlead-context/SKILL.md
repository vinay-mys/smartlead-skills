---
name: smartlead-context
description: >-
  When the user wants to interact with the Smartlead API. Also use when the user mentions
  "smartlead," "outbound," "cold email," "email campaign API." This is the shared context
  skill that all other Smartlead skills depend on. For campaign operations, see
  campaign-management. For lead operations, see lead-management.
metadata:
  version: 1.0.0
---

# Smartlead API Context

You are an expert in the Smartlead cold email outreach platform and its REST API. Your goal is to provide shared context, authentication patterns, and common schemas that all Smartlead skills depend on.

## Authentication

All requests require an API key passed as a query parameter:

```
https://server.smartlead.ai/api/v1/{endpoint}?api_key={API_KEY}
```

The API key is obtained from **Settings > Profile > Activate API** in the Smartlead app.

**Never hardcode API keys.** Store them in environment variables or a secrets manager.

## Base URL

```
https://server.smartlead.ai/api/v1
```

## Rate Limits

- **10 requests per 2 seconds** per API key
- Reconnect email accounts endpoint: **3 times per 24 hours**
- Pagination defaults: `offset=0`, `limit=100` (max 100)

## Common Response Patterns

**Success:**
```json
{"ok": true, "data": "success"}
```

**Error 400 (Bad Request):**
```json
{"error": "Description of what went wrong."}
```

**Error 404 (Not Found):**
```json
{"error": "Resource not found - Invalid {resource}_id."}
```

## Core Entities

| Entity | Description |
|---|---|
| **Campaign** | An outreach sequence targeting a list of leads with configurable conditions |
| **Lead** | A recipient/contact you are reaching out to |
| **Email Account** | A sending mailbox (SMTP/IMAP) used within campaigns |
| **Sequence** | The ordered steps (emails) within a campaign |
| **Client** | A sub-account for whitelabel/agency setups |
| **Webhook** | An HTTP callback triggered by campaign events |

## Campaign Statuses

```
DRAFTED | START | PAUSED | STOPPED | COMPLETED
```

## Lead Statuses

```
UPLOADED | NOT_STARTED | IN_PROGRESS | COMPLETED | FAILED | BLOCKED | UNSUBSCRIBED | INTERESTED | NOT_INTERESTED
```

## Webhook Event Types

```
EMAIL_SENT | EMAIL_OPENED | EMAIL_CLICKED | EMAIL_REPLIED | EMAIL_BOUNCED | LEAD_UNSUBSCRIBED | LEAD_CATEGORY_UPDATED
```

## Pagination

Most list endpoints accept `offset` and `limit` query parameters:

```
?offset=0&limit=100&api_key={API_KEY}
```

## Common Pitfalls

- **Missing api_key**: Every request must include `?api_key=` as a query parameter, not a header
- **Rate limiting**: Batch operations should include delays between requests
- **ID types**: Campaign IDs, lead IDs, and email account IDs are all integers
- **Client scoping**: Many endpoints accept an optional `client_id` to scope operations to a specific client
- **Warmup conflicts**: Do not enable warmup on accounts actively sending campaign emails at high volume

## Output Format

When constructing API calls, always output:

1. **HTTP method and full URL** with placeholder variables
2. **Request body** (if POST/PATCH/PUT) as formatted JSON
3. **Expected response** schema summary
4. **Error handling** notes

## Related Skills

| Skill | Scope |
|---|---|
| [campaign-management](../campaign-management/SKILL.md) | Creating and configuring campaigns |
| [lead-management](../lead-management/SKILL.md) | Adding and managing leads |
| [email-account-management](../email-account-management/SKILL.md) | Email sending infrastructure |
| [campaign-analytics](../campaign-analytics/SKILL.md) | Campaign performance metrics |
| [master-inbox](../master-inbox/SKILL.md) | Reading and replying to leads |
| [webhook-management](../webhook-management/SKILL.md) | Event-driven automation |
