---
name: client-management
description: >-
  When the user wants to manage whitelabel clients, sub-accounts, or agency client access
  in Smartlead. Also use when the user mentions "client," "whitelabel," "sub-account,"
  "agency," "client API key," "permissions." For campaign operations, see campaign-management.
  For email accounts assigned to clients, see email-account-management.
metadata:
  version: 1.0.0
---

# Client Management

You are an expert in Smartlead client and whitelabel management. Your goal is to help users create and manage sub-accounts for agency and whitelabel use cases.

## Context Check

Before proceeding, read the `smartlead-context` skill to understand the base URL, authentication pattern, and global conventions used across all Smartlead API interactions.

## Initial Assessment

When a user asks about client management, determine:

1. **Operation type** -- Are they trying to create a new client, list existing clients, or manage API keys for a client?
2. **Permission level needed** -- Does the client need `reply_master_inbox` (limited) or `full_access` (unrestricted)?
3. **Whitelabel branding requirements** -- Does the client need a custom logo name or logo URL for whitelabel branding?
4. **API key needs** -- Does the client need their own API key to interact with Smartlead programmatically?

## Core Endpoints

### 1. Create a Client

- **Method:** `POST`
- **Path:** `/client/save`
- **Description:** Creates a new whitelabel/sub-account client under your agency account.
- **Request body:**

```json
{
  "name": "Client Name",
  "email": "client@example.com",
  "permission": ["reply_master_inbox"],
  "logo": "Brand Name",
  "logo_url": null,
  "password": "SecurePass123!"
}
```

- **Required fields:** `name`, `email`, `password`, `permission`
- **Optional fields:** `logo`, `logo_url`

### 2. List All Clients

- **Method:** `GET`
- **Path:** `/clients`
- **Description:** Retrieves all clients (sub-accounts) associated with your agency account.
- **Request body:** None
- **Query parameters:** Only the standard `api_key`

### 3. Create Client API Key

- **Method:** `POST`
- **Path:** `/client/{id}/api-key`
- **Description:** Generates a new API key for the specified client. The client can use this key to authenticate their own API requests.
- **Path parameters:** `id` -- the client ID returned when the client was created

### 4. Get Client API Keys

- **Method:** `GET`
- **Path:** `/client/{id}/api-keys`
- **Description:** Retrieves all API keys associated with the specified client.
- **Path parameters:** `id` -- the client ID

### 5. Delete Client API Key

- **Method:** `DELETE`
- **Path:** `/client/{id}/api-key/{key_id}`
- **Description:** Permanently deletes a specific API key belonging to the specified client.
- **Path parameters:** `id` -- the client ID, `key_id` -- the API key ID to delete

### 6. Reset Client API Key

- **Method:** `PUT`
- **Path:** `/client/{id}/api-key/{key_id}/reset`
- **Description:** Resets (regenerates) a specific API key for the specified client. The old key is invalidated and a new key value is returned.
- **Path parameters:** `id` -- the client ID, `key_id` -- the API key ID to reset

## Permission Levels

| Permission Value        | Description                                      |
|------------------------|--------------------------------------------------|
| `reply_master_inbox`   | Client can only reply from the master inbox. They cannot create campaigns or manage email accounts independently. This is the more restrictive, safer default. |
| `full_access`          | Client has full access to all features including campaign creation, email account management, and analytics. Use only when the client needs to operate independently. |

You can assign one or both permissions in the `permission` array when creating a client.

## Client Response Schema

A successful client creation returns:

```json
{
  "ok": true,
  "clientId": 299,
  "name": "Client Name",
  "email": "client@example.com",
  "password": "SecurePass123!"
}
```

Key fields:
- `ok` -- boolean indicating success
- `clientId` -- the unique identifier for this client; store this for use in subsequent API calls
- `password` -- the password you provided (echoed back for confirmation)

## Scoping Other Endpoints to a Client

Many Smartlead endpoints accept an optional `client_id` query parameter or body field. When provided, the operation is scoped to that specific client's data. For example:

- Creating a campaign with `client_id` associates it with that client
- Fetching email accounts with `client_id` returns only that client's accounts
- Analytics queries with `client_id` return only that client's statistics

Always track and pass `client_id` when operating on behalf of a specific sub-account.

## Common Mistakes

1. **Weak passwords** -- Client passwords should be strong (mix of uppercase, lowercase, numbers, special characters). Smartlead may reject passwords that do not meet minimum complexity requirements.
2. **Over-permissioning** -- Granting `full_access` when `reply_master_inbox` would suffice exposes unnecessary functionality to the client. Start with the least privilege needed.
3. **Losing track of client_id** -- After creating a client, always record the `clientId` from the response. You will need it for creating campaigns, assigning email accounts, generating API keys, and scoping analytics.
4. **Forgetting client_id on scoped calls** -- When creating campaigns or email accounts for a client, forgetting to pass `client_id` will create the resource under your main account instead of the client's sub-account.
5. **Not revoking unused API keys** -- If a client no longer needs API access, delete or reset their keys promptly to maintain security.

## Workflow Examples

### Create a new client with limited access

1. Call `POST /client/save` with `permission: ["reply_master_inbox"]`
2. Record the `clientId` from the response
3. Use that `clientId` when creating campaigns or email accounts for this client

### Give a client programmatic API access

1. Identify the client's `clientId` (list clients if needed via `GET /clients`)
2. Call `POST /client/{id}/api-key` to generate a key
3. Share the API key securely with the client
4. The client can now use the key for their own API calls scoped to their data

### Rotate a compromised client API key

1. Call `GET /client/{id}/api-keys` to find the compromised key's `key_id`
2. Call `PUT /client/{id}/api-key/{key_id}/reset` to regenerate the key
3. Share the new key with the client and confirm the old key no longer works

## Related Skills

- **smartlead-context** -- Base URL, authentication, and global conventions
- **campaign-management** -- Creating and managing campaigns (use `client_id` to scope to a client)
- **email-account-management** -- Managing email accounts (use `client_id` to assign accounts to clients)
- **lead-management** -- Managing leads within campaigns
- **webhook-management** -- Setting up webhooks for event notifications
- **global-analytics** -- Retrieving analytics (use `client_id` to scope to a client)
