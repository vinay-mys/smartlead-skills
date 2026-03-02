# Client Management API Endpoints Reference

This document provides detailed reference information for all six client management endpoints in the Smartlead API. Each endpoint includes the full request format, all parameters, example requests using cURL, and example responses.

All endpoints require your API key passed as a query parameter: `?api_key=YOUR_API_KEY`

Base URL: `https://server.smartlead.ai/api/v1`

---

## 1. Create a Client

Creates a new whitelabel or sub-account client under your agency account.

### Request

- **Method:** `POST`
- **URL:** `https://server.smartlead.ai/api/v1/client/save?api_key=YOUR_API_KEY`
- **Content-Type:** `application/json`

### Request Body Parameters

| Parameter    | Type     | Required | Description                                                                 |
|-------------|----------|----------|-----------------------------------------------------------------------------|
| `name`      | string   | Yes      | Display name for the client account                                         |
| `email`     | string   | Yes      | Email address for the client. Must be unique across all clients.            |
| `password`  | string   | Yes      | Password for the client's login. Should meet complexity requirements.       |
| `permission`| string[] | Yes      | Array of permission strings. Values: `"reply_master_inbox"`, `"full_access"`|
| `logo`      | string   | No       | Brand name displayed in the whitelabel interface. Defaults to null.         |
| `logo_url`  | string   | No       | URL to a logo image for whitelabel branding. Defaults to null.              |

### Example Request

```bash
curl -X POST "https://server.smartlead.ai/api/v1/client/save?api_key=YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Acme Corp",
    "email": "admin@acmecorp.com",
    "permission": ["reply_master_inbox"],
    "logo": "Acme Corp",
    "logo_url": "https://acmecorp.com/logo.png",
    "password": "Str0ng!Pass#2024"
  }'
```

### Example Response (201 Created)

```json
{
  "ok": true,
  "clientId": 299,
  "name": "Acme Corp",
  "email": "admin@acmecorp.com",
  "password": "Str0ng!Pass#2024"
}
```

### Example Request -- Full Access Client

```bash
curl -X POST "https://server.smartlead.ai/api/v1/client/save?api_key=YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Beta Agency",
    "email": "ops@betaagency.io",
    "permission": ["full_access"],
    "logo": null,
    "logo_url": null,
    "password": "B3ta@gency!Secure"
  }'
```

### Example Response (201 Created)

```json
{
  "ok": true,
  "clientId": 300,
  "name": "Beta Agency",
  "email": "ops@betaagency.io",
  "password": "B3ta@gency!Secure"
}
```

### Error Responses

| Status | Condition                        | Example Response                                            |
|--------|----------------------------------|-------------------------------------------------------------|
| 400    | Missing required fields          | `{"ok": false, "error": "name is required"}`                |
| 400    | Invalid email format             | `{"ok": false, "error": "Invalid email address"}`           |
| 409    | Email already exists             | `{"ok": false, "error": "Client with this email already exists"}` |
| 401    | Invalid or missing API key       | `{"ok": false, "error": "Unauthorized"}`                    |

### Notes

- The `permission` field is an array. You can pass `["reply_master_inbox"]`, `["full_access"]`, or both `["reply_master_inbox", "full_access"]`.
- The `clientId` in the response is the unique identifier you should store and use for all subsequent client-scoped operations.
- The password is echoed back in the response for confirmation but is stored securely on the server.

---

## 2. Fetch All Clients

Retrieves a list of all clients (sub-accounts) associated with your agency account.

### Request

- **Method:** `GET`
- **URL:** `https://server.smartlead.ai/api/v1/clients?api_key=YOUR_API_KEY`

### Query Parameters

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/clients?api_key=YOUR_API_KEY"
```

### Example Response (200 OK)

```json
[
  {
    "id": 299,
    "name": "Acme Corp",
    "email": "admin@acmecorp.com",
    "permission": ["reply_master_inbox"],
    "logo": "Acme Corp",
    "logo_url": "https://acmecorp.com/logo.png",
    "created_at": "2024-11-15T08:30:00Z"
  },
  {
    "id": 300,
    "name": "Beta Agency",
    "email": "ops@betaagency.io",
    "permission": ["full_access"],
    "logo": null,
    "logo_url": null,
    "created_at": "2024-11-16T14:22:00Z"
  },
  {
    "id": 301,
    "name": "Gamma Solutions",
    "email": "team@gammasolutions.com",
    "permission": ["reply_master_inbox", "full_access"],
    "logo": "Gamma",
    "logo_url": null,
    "created_at": "2024-12-01T09:00:00Z"
  }
]
```

### Error Responses

| Status | Condition                  | Example Response                              |
|--------|----------------------------|-----------------------------------------------|
| 401    | Invalid or missing API key | `{"ok": false, "error": "Unauthorized"}`      |

### Notes

- Returns an array of client objects. An empty array `[]` is returned if no clients exist.
- Each client object includes `id`, `name`, `email`, `permission`, `logo`, `logo_url`, and `created_at`.
- Use the `id` field from these results as the `{id}` path parameter in other client endpoints.

---

## 3. Create Client API Key

Generates a new API key for a specific client. The client can use this key to authenticate their own Smartlead API requests, scoped to their sub-account data.

### Request

- **Method:** `POST`
- **URL:** `https://server.smartlead.ai/api/v1/client/{id}/api-key?api_key=YOUR_API_KEY`
- **Content-Type:** `application/json`

### Path Parameters

| Parameter | Type    | Required | Description                                  |
|-----------|---------|----------|----------------------------------------------|
| `id`      | integer | Yes      | The client ID returned from client creation   |

### Query Parameters

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

### Example Request

```bash
curl -X POST "https://server.smartlead.ai/api/v1/client/299/api-key?api_key=YOUR_API_KEY" \
  -H "Content-Type: application/json"
```

### Example Response (201 Created)

```json
{
  "ok": true,
  "id": 1042,
  "api_key": "sl_client_abc123def456ghi789jkl012mno345pqr678",
  "client_id": 299,
  "created_at": "2024-11-15T10:00:00Z"
}
```

### Error Responses

| Status | Condition                  | Example Response                                        |
|--------|----------------------------|---------------------------------------------------------|
| 404    | Client not found           | `{"ok": false, "error": "Client not found"}`            |
| 401    | Invalid or missing API key | `{"ok": false, "error": "Unauthorized"}`                |

### Notes

- A client can have multiple API keys. Each call to this endpoint creates an additional key.
- The `id` in the response is the API key's unique identifier (`key_id`), not the client ID.
- Store the `api_key` value securely -- it will not be shown again in full after creation.
- The client uses this key as `?api_key=sl_client_abc123...` in their own API requests.

---

## 4. Get Client API Keys

Retrieves all API keys associated with a specific client.

### Request

- **Method:** `GET`
- **URL:** `https://server.smartlead.ai/api/v1/client/{id}/api-keys?api_key=YOUR_API_KEY`

### Path Parameters

| Parameter | Type    | Required | Description        |
|-----------|---------|----------|--------------------|
| `id`      | integer | Yes      | The client ID      |

### Query Parameters

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

### Example Request

```bash
curl -X GET "https://server.smartlead.ai/api/v1/client/299/api-keys?api_key=YOUR_API_KEY"
```

### Example Response (200 OK)

```json
[
  {
    "id": 1042,
    "api_key": "sl_client_abc123def456ghi789jkl012mno345pqr678",
    "client_id": 299,
    "created_at": "2024-11-15T10:00:00Z",
    "last_used_at": "2024-12-20T16:45:00Z"
  },
  {
    "id": 1098,
    "api_key": "sl_client_zzz999yyy888xxx777www666vvv555uuu444",
    "client_id": 299,
    "created_at": "2024-12-01T12:00:00Z",
    "last_used_at": null
  }
]
```

### Error Responses

| Status | Condition                  | Example Response                                        |
|--------|----------------------------|---------------------------------------------------------|
| 404    | Client not found           | `{"ok": false, "error": "Client not found"}`            |
| 401    | Invalid or missing API key | `{"ok": false, "error": "Unauthorized"}`                |

### Notes

- Returns an array of API key objects. An empty array `[]` means the client has no API keys.
- The `id` field in each object is the `key_id` used for delete and reset operations.
- `last_used_at` may be `null` if the key has never been used.
- Use this endpoint to audit which keys exist before performing delete or reset operations.

---

## 5. Delete Client API Key

Permanently deletes a specific API key belonging to a client. The key is immediately invalidated and can no longer be used for authentication.

### Request

- **Method:** `DELETE`
- **URL:** `https://server.smartlead.ai/api/v1/client/{id}/api-key/{key_id}?api_key=YOUR_API_KEY`

### Path Parameters

| Parameter | Type    | Required | Description                                     |
|-----------|---------|----------|-------------------------------------------------|
| `id`      | integer | Yes      | The client ID                                    |
| `key_id`  | integer | Yes      | The API key ID (from the key's `id` field)       |

### Query Parameters

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

### Example Request

```bash
curl -X DELETE "https://server.smartlead.ai/api/v1/client/299/api-key/1098?api_key=YOUR_API_KEY"
```

### Example Response (200 OK)

```json
{
  "ok": true,
  "message": "API key deleted successfully"
}
```

### Error Responses

| Status | Condition                      | Example Response                                        |
|--------|--------------------------------|---------------------------------------------------------|
| 404    | Client not found               | `{"ok": false, "error": "Client not found"}`            |
| 404    | API key not found              | `{"ok": false, "error": "API key not found"}`           |
| 401    | Invalid or missing API key     | `{"ok": false, "error": "Unauthorized"}`                |

### Notes

- This action is irreversible. Once deleted, the API key cannot be recovered.
- Any integrations or automations using the deleted key will immediately stop working.
- If you want to invalidate a key but issue a replacement, use the reset endpoint instead.
- Always confirm with the client before deleting their API key to avoid disrupting their workflows.

---

## 6. Reset Client API Key

Resets (regenerates) a specific API key for a client. The old key value is invalidated and a new key value is generated. The key retains the same `key_id`.

### Request

- **Method:** `PUT`
- **URL:** `https://server.smartlead.ai/api/v1/client/{id}/api-key/{key_id}/reset?api_key=YOUR_API_KEY`

### Path Parameters

| Parameter | Type    | Required | Description                                     |
|-----------|---------|----------|-------------------------------------------------|
| `id`      | integer | Yes      | The client ID                                    |
| `key_id`  | integer | Yes      | The API key ID (from the key's `id` field)       |

### Query Parameters

| Parameter | Type   | Required | Description            |
|-----------|--------|----------|------------------------|
| `api_key` | string | Yes      | Your Smartlead API key |

### Example Request

```bash
curl -X PUT "https://server.smartlead.ai/api/v1/client/299/api-key/1042/reset?api_key=YOUR_API_KEY"
```

### Example Response (200 OK)

```json
{
  "ok": true,
  "id": 1042,
  "api_key": "sl_client_new111key222value333after444reset555",
  "client_id": 299,
  "created_at": "2024-11-15T10:00:00Z",
  "reset_at": "2024-12-22T09:15:00Z"
}
```

### Error Responses

| Status | Condition                      | Example Response                                        |
|--------|--------------------------------|---------------------------------------------------------|
| 404    | Client not found               | `{"ok": false, "error": "Client not found"}`            |
| 404    | API key not found              | `{"ok": false, "error": "API key not found"}`           |
| 401    | Invalid or missing API key     | `{"ok": false, "error": "Unauthorized"}`                |

### Notes

- The `key_id` remains the same after reset; only the `api_key` value changes.
- The old key is immediately invalidated upon reset.
- Use this endpoint instead of delete + create when you want to rotate a key without changing the key ID in your tracking systems.
- Share the new `api_key` value securely with the client after resetting.
- Common use case: rotating keys on a regular schedule for security, or immediately after a suspected key compromise.

---

## Common Patterns

### Full client onboarding flow

```bash
# Step 1: Create the client
curl -X POST "https://server.smartlead.ai/api/v1/client/save?api_key=YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New Client Inc",
    "email": "hello@newclient.com",
    "permission": ["reply_master_inbox"],
    "logo": "New Client",
    "logo_url": "https://newclient.com/logo.png",
    "password": "W3lcome!N3wClient"
  }'
# Response: {"ok": true, "clientId": 305, ...}

# Step 2: Generate an API key for the client
curl -X POST "https://server.smartlead.ai/api/v1/client/305/api-key?api_key=YOUR_API_KEY" \
  -H "Content-Type: application/json"
# Response: {"ok": true, "id": 1150, "api_key": "sl_client_...", ...}

# Step 3: Verify the key was created
curl -X GET "https://server.smartlead.ai/api/v1/client/305/api-keys?api_key=YOUR_API_KEY"
# Response: [{"id": 1150, "api_key": "sl_client_...", ...}]
```

### Key rotation flow

```bash
# Step 1: List current keys to find the key_id
curl -X GET "https://server.smartlead.ai/api/v1/client/299/api-keys?api_key=YOUR_API_KEY"
# Response: [{"id": 1042, "api_key": "sl_client_old...", ...}]

# Step 2: Reset the key
curl -X PUT "https://server.smartlead.ai/api/v1/client/299/api-key/1042/reset?api_key=YOUR_API_KEY"
# Response: {"ok": true, "id": 1042, "api_key": "sl_client_new...", ...}
```

### Key revocation flow

```bash
# Step 1: List current keys
curl -X GET "https://server.smartlead.ai/api/v1/client/299/api-keys?api_key=YOUR_API_KEY"
# Response: [{"id": 1042, ...}, {"id": 1098, ...}]

# Step 2: Delete the compromised key
curl -X DELETE "https://server.smartlead.ai/api/v1/client/299/api-key/1098?api_key=YOUR_API_KEY"
# Response: {"ok": true, "message": "API key deleted successfully"}
```
