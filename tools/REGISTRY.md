# Tool Registry

## API Integration

| Tool | Type | Description |
|---|---|---|
| Smartlead API v1 | REST API | Primary API at `https://server.smartlead.ai/api/v1` |

## Authentication

- **Method**: Query parameter `?api_key={API_KEY}`
- **Obtain**: Settings > Profile > Activate API in Smartlead app
- **Scope**: Full account access (do not share)

## Rate Limits

| Endpoint | Limit |
|---|---|
| General | 10 requests / 2 seconds |
| Reconnect email accounts | 3 requests / 24 hours |
| Pagination max | 100 items per page |

## Common Integrations

| Platform | Integration Method |
|---|---|
| Zapier | Webhooks (see webhook-management skill) |
| Make (Integromat) | Webhooks + HTTP module |
| Clay | Native Smartlead integration |
| n8n | HTTP Request node with API key |
| Custom | Direct REST API calls |

## Error Codes

| Code | Meaning |
|---|---|
| 200 | Success |
| 400 | Bad Request (check parameters) |
| 404 | Not Found (invalid ID) |
| 406 | Not Acceptable (rate limit on specific endpoints) |
| 429 | Too Many Requests (general rate limit) |
