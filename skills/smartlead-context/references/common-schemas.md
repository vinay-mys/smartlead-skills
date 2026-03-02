# Common Smartlead API Schemas

## Campaign Schema

```json
{
  "id": 3023,
  "name": "Test email campaign",
  "created_at": "2022-11-07T16:23:24.025929+00:00",
  "status": "DRAFTED",
  "client_id": null
}
```

## Lead Schema

```json
{
  "id": 627657,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "created_at": "2022-08-29T06:15:31.513Z",
  "phone_number": "1234567890",
  "company_name": "Acme Corp",
  "website": "www.acme.com",
  "location": "New York",
  "custom_fields": {"Title": "CEO", "Industry": "Tech"},
  "linkedin_profile": "https://linkedin.com/in/johndoe",
  "company_url": "acme.com",
  "is_unsubscribed": false
}
```

## Lead Input Schema

Used when adding or updating leads:

```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "phone_number": "1234567890",
  "company_name": "Acme Corp",
  "website": "acme.com",
  "location": "New York",
  "custom_fields": {"Title": "CEO"},
  "linkedin_profile": "https://linkedin.com/in/johndoe",
  "company_url": "acme.com"
}
```

**Note:** `custom_fields` supports a maximum of 20 key-value pairs.

## Email Account Schema

```json
{
  "id": 2849,
  "from_name": "John Doe",
  "from_email": "john@example.com",
  "user_name": "john@example.com",
  "smtp_host": "smtp.gmail.com",
  "smtp_port": 465,
  "imap_host": "imap.gmail.com",
  "imap_port": 993,
  "max_email_per_day": 100,
  "custom_tracking_url": "",
  "bcc": "",
  "signature": "",
  "warmup_enabled": false,
  "total_warmup_per_day": null,
  "daily_rampup": null,
  "reply_rate_percentage": null,
  "client_id": null
}
```

## Campaign Webhook Schema

```json
{
  "id": 456,
  "campaign_id": 3023,
  "webhook_url": "https://hooks.example.com/smartlead",
  "event_type": "EMAIL_REPLIED",
  "is_active": true
}
```

## Webhook Event Types

| Event | Trigger |
|---|---|
| `EMAIL_SENT` | Email sent to a lead |
| `EMAIL_OPENED` | Lead opened the email |
| `EMAIL_CLICKED` | Lead clicked a link |
| `EMAIL_REPLIED` | Lead replied to the email |
| `EMAIL_BOUNCED` | Email bounced |
| `LEAD_UNSUBSCRIBED` | Lead unsubscribed |
| `LEAD_CATEGORY_UPDATED` | Lead category changed |

## Client Schema

```json
{
  "ok": true,
  "clientId": 299,
  "name": "Client Name",
  "email": "client@example.com",
  "password": "ClientPass123!"
}
```

## Client Permissions

```
"permission": ["reply_master_inbox"]
"permission": ["full_access"]
```

## Campaign Statistics Schema

```json
{
  "id": 3023,
  "name": "Campaign Name",
  "sent_count": 500,
  "open_count": 250,
  "click_count": 50,
  "reply_count": 30,
  "bounce_count": 5,
  "unsubscribe_count": 2
}
```

## Export CSV Fields

```
id, campaign_lead_map_id, status, created_at, first_name, last_name,
email, phone_number, company_name, website, location, custom_fields,
linkedin_profile, company_url, is_unsubscribed, last_email_sequence_sent,
is_interested, open_count, click_count, reply_count
```

## Standard Success Response

```json
{"ok": true}
```

## Standard Error Responses

```json
// 400 Bad Request
{"error": "Email account id - 297 not allowed. Permission Error."}

// 404 Not Found
{"error": "Campaign not found - Invalid campaign_id."}

// 406 Not Acceptable (rate limit on reconnect)
{"error": "Rate limit exceeded. Try again after 24 hours."}
```
