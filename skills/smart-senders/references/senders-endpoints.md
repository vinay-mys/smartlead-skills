# Smart Senders API Endpoints Reference

Complete reference for all Smart Senders endpoints in the Smartlead API.

---

## 1. Search Domain Availability

Search for available domains based on a keyword query.

### Request

```
GET /smart-senders/search-domain
```

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your Smartlead API key |
| `keyword` | string | Yes | The keyword or phrase to search for domain availability |
| `tlds` | string | No | Comma-separated list of TLDs to search (e.g., `com,io,co`). Defaults to common TLDs if omitted |

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/smart-senders/search-domain?api_key=YOUR_API_KEY&keyword=acmesales&tlds=com,io,co"
```

### Example Response

```json
{
  "ok": true,
  "data": [
    {
      "domain": "acmesales.com",
      "available": true,
      "price": 12.99,
      "currency": "USD",
      "tld": "com"
    },
    {
      "domain": "acmesales.io",
      "available": true,
      "price": 34.99,
      "currency": "USD",
      "tld": "io"
    },
    {
      "domain": "acmesales.co",
      "available": false,
      "tld": "co"
    }
  ]
}
```

### Key Notes

- Only domains with `"available": true` can be ordered.
- Prices are per year and reflect the initial registration cost. Renewal pricing may differ.
- Search results are not reserved. Availability can change between search and order.
- Use specific, unique keywords to get more useful results. Generic terms often have low availability.

---

## 2. Get Available Vendors

Retrieve the list of domain vendors (registrars) available for purchasing domains.

### Request

```
GET /smart-senders/vendors
```

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your Smartlead API key |

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/smart-senders/vendors?api_key=YOUR_API_KEY"
```

### Example Response

```json
{
  "ok": true,
  "data": [
    {
      "vendor_id": 1,
      "name": "Smartlead Default",
      "supported_tlds": ["com", "net", "org", "io", "co"],
      "avg_provisioning_time": "10 minutes",
      "pricing_tier": "standard"
    },
    {
      "vendor_id": 2,
      "name": "Premium Registrar",
      "supported_tlds": ["com", "net", "org", "io", "co", "ai", "dev"],
      "avg_provisioning_time": "30 minutes",
      "pricing_tier": "premium"
    }
  ]
}
```

### Key Notes

- Different vendors support different TLDs. Verify TLD support before placing an order.
- Provisioning time varies by vendor. Factor this in if the user needs domains urgently.
- Pricing tiers affect both initial registration and renewal costs.
- The vendor ID is required when placing an order.

---

## 3. Place Domain Order

Purchase one or more domains through a selected vendor.

### Request

```
POST /smart-senders/order
```

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your Smartlead API key |

### Request Body

```json
{
  "vendor_id": 1,
  "domains": [
    {
      "domain": "acmesales.com",
      "tld": "com"
    },
    {
      "domain": "acmeoutreach.io",
      "tld": "io"
    }
  ],
  "auto_renew": true,
  "registration_years": 1
}
```

### Body Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `vendor_id` | integer | Yes | ID of the vendor to purchase from (from the vendors endpoint) |
| `domains` | array | Yes | Array of domain objects to purchase |
| `domains[].domain` | string | Yes | Full domain name including TLD |
| `domains[].tld` | string | Yes | Top-level domain (e.g., `com`, `io`) |
| `auto_renew` | boolean | No | Enable automatic renewal. Defaults to `true` |
| `registration_years` | integer | No | Number of years to register. Defaults to `1` |

### Example Request

```bash
curl -X POST "https://server.smartlead.ai/api/v1/smart-senders/order?api_key=YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "vendor_id": 1,
    "domains": [
      {"domain": "acmesales.com", "tld": "com"},
      {"domain": "acmeoutreach.io", "tld": "io"}
    ],
    "auto_renew": true,
    "registration_years": 1
  }'
```

### Example Response

```json
{
  "ok": true,
  "data": {
    "order_id": "ord_abc123def456",
    "status": "pending",
    "total_cost": 47.98,
    "currency": "USD",
    "domains": [
      {
        "domain": "acmesales.com",
        "status": "pending",
        "price": 12.99
      },
      {
        "domain": "acmeoutreach.io",
        "status": "pending",
        "price": 34.99
      }
    ],
    "created_at": "2026-03-02T10:30:00Z"
  }
}
```

### Key Notes

- Always search for domain availability before ordering. Ordering an unavailable domain will result in a failed order.
- The `order_id` is used to track the order via the order details endpoint.
- Orders start in `pending` status and transition through `in_progress` to `completed` or `failed`.
- Multi-domain orders may have individual domains complete at different times.
- Verify the total cost with the user before submitting the order.

---

## 4. List Purchased Domains

Retrieve all domains purchased through Smart Senders in the account.

### Request

```
GET /smart-senders/domains
```

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your Smartlead API key |
| `status` | string | No | Filter by domain status: `active`, `pending`, `expired`. Defaults to all |
| `offset` | integer | No | Pagination offset. Defaults to `0` |
| `limit` | integer | No | Number of results per page. Defaults to `25`, max `100` |

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/smart-senders/domains?api_key=YOUR_API_KEY&status=active&limit=10"
```

### Example Response

```json
{
  "ok": true,
  "data": {
    "total_count": 8,
    "domains": [
      {
        "domain_id": "dom_001",
        "domain": "acmesales.com",
        "status": "active",
        "vendor": "Smartlead Default",
        "registered_at": "2026-02-15T08:00:00Z",
        "expires_at": "2027-02-15T08:00:00Z",
        "auto_renew": true,
        "mailbox_count": 4,
        "dns_configured": true
      },
      {
        "domain_id": "dom_002",
        "domain": "acmeoutreach.io",
        "status": "active",
        "vendor": "Smartlead Default",
        "registered_at": "2026-02-15T08:05:00Z",
        "expires_at": "2027-02-15T08:05:00Z",
        "auto_renew": true,
        "mailbox_count": 3,
        "dns_configured": true
      }
    ]
  }
}
```

### Key Notes

- The `mailbox_count` field shows how many mailboxes have been generated on each domain.
- `dns_configured` indicates whether DNS records (SPF, DKIM, DMARC) are properly set up.
- Only domains with `status: active` and `dns_configured: true` should be used for mailbox generation.
- Use the `domain_id` when referencing domains in other operations.

---

## 5. Get Order Details

Check the status and details of a specific domain order.

### Request

```
GET /smart-senders/orders/{id}
```

### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | string | Yes | The order ID returned when the order was placed |

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your Smartlead API key |

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/smart-senders/orders/ord_abc123def456?api_key=YOUR_API_KEY"
```

### Example Response

```json
{
  "ok": true,
  "data": {
    "order_id": "ord_abc123def456",
    "status": "completed",
    "vendor_id": 1,
    "vendor_name": "Smartlead Default",
    "total_cost": 47.98,
    "currency": "USD",
    "auto_renew": true,
    "registration_years": 1,
    "domains": [
      {
        "domain": "acmesales.com",
        "tld": "com",
        "status": "completed",
        "domain_id": "dom_001",
        "price": 12.99,
        "registered_at": "2026-02-15T08:00:00Z"
      },
      {
        "domain": "acmeoutreach.io",
        "tld": "io",
        "status": "completed",
        "domain_id": "dom_002",
        "price": 34.99,
        "registered_at": "2026-02-15T08:05:00Z"
      }
    ],
    "created_at": "2026-02-15T07:55:00Z",
    "completed_at": "2026-02-15T08:05:00Z"
  }
}
```

### Order Statuses

| Status | Description |
|--------|-------------|
| `pending` | Order has been received and is queued for processing |
| `in_progress` | Domain registration is underway with the vendor |
| `completed` | All domains have been successfully registered |
| `partially_completed` | Some domains registered, others failed |
| `failed` | Order failed entirely. Check individual domain errors |

### Individual Domain Statuses

| Status | Description |
|--------|-------------|
| `pending` | Domain registration not yet started |
| `in_progress` | Registration underway |
| `completed` | Domain registered and DNS being configured |
| `failed` | Registration failed. Check `error` field for reason |

### Key Notes

- Poll this endpoint to track order progress. Typical completion time ranges from 5 minutes to a few hours.
- When the overall order status is `completed`, all domains are ready for mailbox generation.
- For `partially_completed` orders, check each domain's individual status and error fields.
- Failed domains may be retried by placing a new order.
- The `domain_id` values in completed domains can be used with the auto-generate endpoint.

---

## 6. Auto-Generate Mailboxes

Automatically generate mailboxes on one or more purchased domains.

### Request

```
POST /smart-senders/auto-generate
```

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your Smartlead API key |

### Request Body

```json
{
  "domain_ids": ["dom_001", "dom_002"],
  "mailboxes_per_domain": 4,
  "naming_pattern": "first_last",
  "first_names": ["James", "Sarah", "Michael", "Emily"],
  "last_names": ["Wilson", "Chen", "Rivera", "Thompson"],
  "enable_warmup": true,
  "admin_mailbox": true
}
```

### Body Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `domain_ids` | array | Yes | Array of domain IDs to generate mailboxes on |
| `mailboxes_per_domain` | integer | Yes | Number of mailboxes to create per domain (recommended: 3-5) |
| `naming_pattern` | string | No | Pattern for mailbox names. Options: `first_last` (james.wilson@), `first` (james@), `first_initial_last` (jwilson@), `random`. Defaults to `first_last` |
| `first_names` | array | No | Custom first names for mailbox generation. If omitted, names are auto-generated |
| `last_names` | array | No | Custom last names for mailbox generation. If omitted, names are auto-generated |
| `enable_warmup` | boolean | No | Automatically start warmup on generated mailboxes. Defaults to `false` |
| `admin_mailbox` | boolean | No | Create an admin mailbox (admin@domain) for domain management. Defaults to `false` |

### Example Request

```bash
curl -X POST "https://server.smartlead.ai/api/v1/smart-senders/auto-generate?api_key=YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "domain_ids": ["dom_001", "dom_002"],
    "mailboxes_per_domain": 4,
    "naming_pattern": "first_last",
    "enable_warmup": true,
    "admin_mailbox": true
  }'
```

### Example Response

```json
{
  "ok": true,
  "data": {
    "total_mailboxes_created": 10,
    "domains": [
      {
        "domain_id": "dom_001",
        "domain": "acmesales.com",
        "mailboxes": [
          {
            "mailbox_id": "mb_101",
            "email": "admin@acmesales.com",
            "type": "admin",
            "warmup_status": "active",
            "requires_otp": true
          },
          {
            "mailbox_id": "mb_102",
            "email": "james.wilson@acmesales.com",
            "type": "sending",
            "warmup_status": "active",
            "requires_otp": false
          },
          {
            "mailbox_id": "mb_103",
            "email": "sarah.chen@acmesales.com",
            "type": "sending",
            "warmup_status": "active",
            "requires_otp": false
          },
          {
            "mailbox_id": "mb_104",
            "email": "michael.rivera@acmesales.com",
            "type": "sending",
            "warmup_status": "active",
            "requires_otp": false
          },
          {
            "mailbox_id": "mb_105",
            "email": "emily.thompson@acmesales.com",
            "type": "sending",
            "warmup_status": "active",
            "requires_otp": false
          }
        ]
      },
      {
        "domain_id": "dom_002",
        "domain": "acmeoutreach.io",
        "mailboxes": [
          {
            "mailbox_id": "mb_201",
            "email": "admin@acmeoutreach.io",
            "type": "admin",
            "warmup_status": "active",
            "requires_otp": true
          },
          {
            "mailbox_id": "mb_202",
            "email": "james.wilson@acmeoutreach.io",
            "type": "sending",
            "warmup_status": "active",
            "requires_otp": false
          },
          {
            "mailbox_id": "mb_203",
            "email": "sarah.chen@acmeoutreach.io",
            "type": "sending",
            "warmup_status": "active",
            "requires_otp": false
          },
          {
            "mailbox_id": "mb_204",
            "email": "michael.rivera@acmeoutreach.io",
            "type": "sending",
            "warmup_status": "active",
            "requires_otp": false
          },
          {
            "mailbox_id": "mb_205",
            "email": "emily.thompson@acmeoutreach.io",
            "type": "sending",
            "warmup_status": "active",
            "requires_otp": false
          }
        ]
      }
    ]
  }
}
```

### Key Notes

- Domains must have `status: active` and `dns_configured: true` before generating mailboxes.
- The recommended range is 3 to 5 mailboxes per domain. Exceeding this can harm domain reputation.
- If custom names are provided, the count should match or exceed `mailboxes_per_domain`. If fewer names are provided, the system will auto-generate the remaining ones.
- Setting `enable_warmup: true` is strongly recommended. It begins the warmup process immediately so mailboxes build reputation before campaign use.
- Admin mailboxes (`admin@domain`) are used for domain management and may require OTP verification. Use the OTP endpoint to retrieve the code.
- The `mailbox_id` values can be used with the email-account-management skill for further configuration.

---

## 7. Get OTP for Admin Mailbox

Retrieve the one-time password (OTP) for verifying an admin mailbox.

### Request

```
GET /smart-senders/otp/{mailbox_id}
```

### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `mailbox_id` | string | Yes | The ID of the admin mailbox requiring OTP verification |

### Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `api_key` | string | Yes | Your Smartlead API key |

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/smart-senders/otp/mb_101?api_key=YOUR_API_KEY"
```

### Example Response

```json
{
  "ok": true,
  "data": {
    "mailbox_id": "mb_101",
    "email": "admin@acmesales.com",
    "otp": "847291",
    "expires_at": "2026-03-02T10:45:00Z",
    "expires_in_seconds": 300
  }
}
```

### Key Notes

- OTP codes are only generated for admin mailboxes (those with `type: admin` and `requires_otp: true`).
- Codes expire after a short window (typically 5 minutes). Retrieve and use them promptly.
- If the OTP has expired, call this endpoint again to generate a new one.
- Attempting to get an OTP for a non-admin or non-existent mailbox will return an error.
- OTP verification is a one-time step. Once the admin mailbox is verified, subsequent OTP requests are unnecessary.

### Error Response Example

```json
{
  "ok": false,
  "error": "OTP expired or mailbox not found",
  "code": "OTP_EXPIRED"
}
```

### Common Error Codes

| Code | Description |
|------|-------------|
| `OTP_EXPIRED` | The OTP has expired. Request a new one |
| `MAILBOX_NOT_FOUND` | The mailbox ID does not exist |
| `NOT_ADMIN_MAILBOX` | OTP is only available for admin-type mailboxes |
| `ALREADY_VERIFIED` | The admin mailbox has already been verified |

---

## Error Handling

All endpoints follow a consistent error response format:

```json
{
  "ok": false,
  "error": "Human-readable error message",
  "code": "ERROR_CODE"
}
```

### Common Error Codes Across All Endpoints

| HTTP Status | Code | Description |
|-------------|------|-------------|
| 401 | `INVALID_API_KEY` | The provided API key is invalid or expired |
| 403 | `INSUFFICIENT_PERMISSIONS` | The API key does not have permission for this operation |
| 404 | `NOT_FOUND` | The requested resource (domain, order, mailbox) was not found |
| 422 | `VALIDATION_ERROR` | Request body or parameters failed validation |
| 429 | `RATE_LIMIT_EXCEEDED` | Too many requests. Wait and retry |
| 500 | `INTERNAL_ERROR` | Server-side error. Contact support if persistent |

### Rate Limits

- Domain search: 30 requests per minute
- Order placement: 10 requests per minute
- Auto-generate: 5 requests per minute
- All other endpoints: 60 requests per minute

When rate limited, the response includes a `Retry-After` header indicating how many seconds to wait before retrying.
