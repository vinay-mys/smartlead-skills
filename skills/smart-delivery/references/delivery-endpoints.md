# Smart Delivery API Endpoints Reference

Complete reference for all 28 Smartlead Smart Delivery endpoints.

Base URL: `https://server.smartlead.ai/api/v1`

Authentication: All requests require `?api_key={api_key}` as a query parameter.

---

## Test Management

### 1. Create Manual Placement Test

```
POST /smart-delivery/manual-test
```

Creates a one-time email placement test to check inbox vs spam delivery across providers.

**Request Body:**
```json
{
  "name": "string (required) - Test name",
  "sender_account_id": "number (required) - ID of the sender email account",
  "provider_ids": "array[number] (required) - List of provider IDs to test against",
  "subject": "string (required) - Email subject line",
  "body": "string (required) - Email body in HTML format",
  "folder_id": "number (optional) - Folder ID to organize the test"
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "id": "number - Test ID",
    "name": "string - Test name",
    "status": "string - Test status (PENDING, IN_PROGRESS, COMPLETED)",
    "created_at": "string - ISO timestamp"
  }
}
```

**Notes:**
- Verify DKIM and SPF records before running a test for accurate results.
- Provider IDs can be retrieved from the GET /smart-delivery/providers endpoint.
- The test runs immediately upon creation.

---

### 2. Create Automated Recurring Test

```
POST /smart-delivery/automated-test
```

Creates a recurring placement test that runs on a schedule for ongoing monitoring.

**Request Body:**
```json
{
  "name": "string (required) - Test name",
  "sender_account_id": "number (required) - ID of the sender email account",
  "provider_ids": "array[number] (required) - List of provider IDs to test against",
  "subject": "string (required) - Email subject line",
  "body": "string (required) - Email body in HTML format",
  "frequency": "string (required) - Schedule frequency (DAILY, WEEKLY, MONTHLY)",
  "folder_id": "number (optional) - Folder ID to organize the test",
  "start_date": "string (optional) - ISO date for when to start the schedule",
  "time_of_day": "string (optional) - Time in HH:MM format (24h) for test execution"
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "id": "number - Test ID",
    "name": "string - Test name",
    "status": "string - ACTIVE",
    "frequency": "string - Schedule frequency",
    "next_run": "string - ISO timestamp of next scheduled run",
    "created_at": "string - ISO timestamp"
  }
}
```

**Notes:**
- Use the stop endpoint to pause automated tests rather than deleting them.
- Automated tests allow trend analysis across multiple runs.
- Each run generates its own set of reports.

---

### 3. Get Test Details

```
GET /smart-delivery/test/{id}
```

Retrieves full details and results for a specific placement test.

**Path Parameters:**
- `id` (required) - The test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "id": "number - Test ID",
    "name": "string - Test name",
    "status": "string - PENDING | IN_PROGRESS | COMPLETED | FAILED | ACTIVE | STOPPED",
    "type": "string - MANUAL | AUTOMATED",
    "sender_account_id": "number",
    "provider_ids": "array[number]",
    "subject": "string",
    "inbox_count": "number - Emails landed in inbox",
    "spam_count": "number - Emails landed in spam",
    "missing_count": "number - Emails not delivered",
    "inbox_rate": "number - Percentage delivered to inbox",
    "spam_rate": "number - Percentage delivered to spam",
    "created_at": "string - ISO timestamp",
    "completed_at": "string - ISO timestamp or null"
  }
}
```

---

### 4. Stop Automated Test

```
PUT /smart-delivery/test/{id}/stop
```

Stops a running automated recurring test. The test can be referenced later for historical data.

**Path Parameters:**
- `id` (required) - The automated test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "id": "number",
    "status": "string - STOPPED",
    "stopped_at": "string - ISO timestamp"
  }
}
```

**Notes:**
- Stopping preserves all historical run data. Deleting removes it permanently.
- Only automated tests can be stopped. Manual tests complete on their own.

---

### 5. Delete Tests in Bulk

```
POST /smart-delivery/tests/delete
```

Deletes one or more tests permanently. This action cannot be undone.

**Request Body:**
```json
{
  "test_ids": "array[number] (required) - List of test IDs to delete"
}
```

**Response:**
```json
{
  "ok": true,
  "message": "string - Confirmation message",
  "deleted_count": "number - Number of tests deleted"
}
```

**Notes:**
- This permanently removes all associated reports and run history.
- Stop automated tests first if you want to preserve data.
- Cannot be undone.

---

### 6. List All Tests

```
POST /smart-delivery/tests
```

Retrieves a paginated list of all placement tests.

**Request Body:**
```json
{
  "page": "number (optional, default: 1) - Page number",
  "limit": "number (optional, default: 20) - Results per page",
  "folder_id": "number (optional) - Filter by folder",
  "status": "string (optional) - Filter by status (PENDING, IN_PROGRESS, COMPLETED, ACTIVE, STOPPED, FAILED)",
  "type": "string (optional) - Filter by type (MANUAL, AUTOMATED)",
  "search": "string (optional) - Search by test name"
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "tests": [
      {
        "id": "number",
        "name": "string",
        "type": "string",
        "status": "string",
        "inbox_rate": "number",
        "spam_rate": "number",
        "created_at": "string",
        "folder_id": "number or null"
      }
    ],
    "total": "number - Total test count",
    "page": "number",
    "limit": "number"
  }
}
```

---

## Reports

### 7. Provider-Wise Report

```
POST /smart-delivery/report/provider
```

Returns placement results broken down by email provider (Gmail, Outlook, Yahoo, etc.).

**Request Body:**
```json
{
  "test_id": "number (required) - The test ID",
  "run_id": "number (optional) - Specific run ID for automated tests. Defaults to latest run."
}
```

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "provider": "string - Provider name (e.g., Gmail, Outlook, Yahoo)",
      "provider_id": "number",
      "inbox_count": "number",
      "spam_count": "number",
      "missing_count": "number",
      "inbox_rate": "number - Percentage",
      "total_seeds": "number - Total seed accounts tested"
    }
  ]
}
```

**Notes:**
- Essential for identifying which providers are flagging your emails.
- Use alongside the geo report for a complete picture.

---

### 8. Geo-Wise Report

```
POST /smart-delivery/report/geo
```

Returns placement results broken down by geographic region.

**Request Body:**
```json
{
  "test_id": "number (required) - The test ID",
  "run_id": "number (optional) - Specific run ID for automated tests"
}
```

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "region": "string - Region name (e.g., US, EU, APAC)",
      "inbox_count": "number",
      "spam_count": "number",
      "missing_count": "number",
      "inbox_rate": "number - Percentage",
      "total_seeds": "number"
    }
  ]
}
```

**Notes:**
- Different regions may have different filtering rules.
- Useful for global outreach campaigns to identify regional issues.

---

### 9. Sender Account Report

```
GET /smart-delivery/report/sender
```

Returns deliverability metrics aggregated by sender account across all tests.

**Query Parameters:**
- `sender_account_id` (optional) - Filter to a specific sender account.
- `date_from` (optional) - Start date in YYYY-MM-DD format.
- `date_to` (optional) - End date in YYYY-MM-DD format.

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "sender_account_id": "number",
      "email": "string - Sender email address",
      "total_tests": "number",
      "avg_inbox_rate": "number - Average inbox placement percentage",
      "avg_spam_rate": "number",
      "last_test_date": "string - ISO date",
      "trend": "string - IMPROVING | STABLE | DECLINING"
    }
  ]
}
```

**Notes:**
- Use this to compare deliverability across your sender accounts.
- The trend field shows whether deliverability is getting better or worse.

---

### 10. Spam Filter Report

```
GET /smart-delivery/report/spam-filter
```

Returns details about which spam filters flagged your test emails.

**Query Parameters:**
- `test_id` (required) - The test ID to get spam filter data for.
- `run_id` (optional) - Specific run ID for automated tests.

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "filter_name": "string - Spam filter name",
      "filter_type": "string - CONTENT | REPUTATION | AUTHENTICATION | BEHAVIORAL",
      "flagged": "boolean - Whether the filter flagged the email",
      "details": "string - Description of why the filter triggered",
      "severity": "string - LOW | MEDIUM | HIGH"
    }
  ]
}
```

**Notes:**
- Critical for understanding why emails land in spam.
- Address HIGH severity filters first for the biggest deliverability improvements.

---

## Authentication

### 11. DKIM Details

```
GET /smart-delivery/dkim/{id}
```

Retrieves DKIM (DomainKeys Identified Mail) authentication details for a test.

**Path Parameters:**
- `id` (required) - The test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "test_id": "number",
    "dkim_status": "string - PASS | FAIL | MISSING",
    "selector": "string - DKIM selector used",
    "domain": "string - Signing domain",
    "key_length": "number - Key length in bits (1024, 2048)",
    "alignment": "string - STRICT | RELAXED",
    "details": "string - Additional information or error details",
    "checked_at": "string - ISO timestamp"
  }
}
```

**Notes:**
- DKIM PASS is essential for good deliverability. Fix FAIL status before running placement tests.
- 2048-bit keys are recommended over 1024-bit.

---

### 12. SPF Details

```
GET /smart-delivery/spf/{id}
```

Retrieves SPF (Sender Policy Framework) authentication details for a test.

**Path Parameters:**
- `id` (required) - The test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "test_id": "number",
    "spf_status": "string - PASS | FAIL | SOFTFAIL | NEUTRAL | NONE | PERMERROR | TEMPERROR",
    "spf_record": "string - The SPF TXT record found",
    "sending_ip": "string - IP address used to send",
    "authorized": "boolean - Whether the IP is authorized by the SPF record",
    "lookup_count": "number - DNS lookups performed (max 10 allowed)",
    "details": "string - Additional information",
    "checked_at": "string - ISO timestamp"
  }
}
```

**Notes:**
- SPF records have a 10 DNS lookup limit. Exceeding this causes PERMERROR.
- SOFTFAIL means the IP is not explicitly authorized but is not rejected.
- Ensure your sending IP is included in the SPF record.

---

### 13. rDNS Report

```
GET /smart-delivery/rdns/{id}
```

Retrieves reverse DNS (rDNS) details for a test.

**Path Parameters:**
- `id` (required) - The test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "test_id": "number",
    "rdns_status": "string - PASS | FAIL | MISSING",
    "sending_ip": "string - IP address checked",
    "hostname": "string - Resolved hostname or null",
    "forward_confirmed": "boolean - Whether forward DNS matches reverse DNS",
    "details": "string - Additional information",
    "checked_at": "string - ISO timestamp"
  }
}
```

**Notes:**
- Forward-confirmed rDNS (FCrDNS) means the hostname resolves back to the same IP. This is important for reputation.
- MISSING rDNS can cause deliverability issues with some providers.

---

## Blacklists

### 14. IP Blacklists

```
GET /smart-delivery/blacklists
```

Checks sending IPs against known IP blacklists (DNSBLs).

**Query Parameters:**
- `ip` (optional) - Specific IP address to check. If omitted, checks all sending IPs.

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "ip": "string - IP address",
      "listed": "boolean - Whether the IP is on any blacklist",
      "blacklists": [
        {
          "name": "string - Blacklist name (e.g., Spamhaus, Barracuda)",
          "listed": "boolean",
          "listing_reason": "string - Reason for listing or null",
          "delist_url": "string - URL to request delisting or null"
        }
      ],
      "total_listed": "number - Total number of blacklists the IP appears on",
      "checked_at": "string - ISO timestamp"
    }
  ]
}
```

**Notes:**
- Being on one or two minor blacklists is common and may not severely impact deliverability.
- Spamhaus and Barracuda listings are the most impactful and should be addressed immediately.
- Use the delist_url to begin the delisting process.

---

### 15. Domain Blacklist

```
GET /smart-delivery/domain-blacklist
```

Checks sending domains against known domain blacklists (URIBLs).

**Query Parameters:**
- `domain` (optional) - Specific domain to check. If omitted, checks all sending domains.

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "domain": "string - Domain name",
      "listed": "boolean - Whether the domain is on any blacklist",
      "blacklists": [
        {
          "name": "string - Blacklist name",
          "listed": "boolean",
          "listing_reason": "string or null",
          "delist_url": "string or null"
        }
      ],
      "total_listed": "number",
      "checked_at": "string - ISO timestamp"
    }
  ]
}
```

**Notes:**
- Domain blacklists check both sending domains and domains found in email content (links).
- Ensure links in email bodies do not point to blacklisted domains.

---

### 16. IP Blacklist Count for Test

```
GET /smart-delivery/test/{id}/ip-blacklist
```

Returns the IP blacklist count associated with a specific test.

**Path Parameters:**
- `id` (required) - The test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "test_id": "number",
    "ip": "string - Sending IP used in the test",
    "blacklist_count": "number - Number of blacklists the IP is on",
    "blacklist_names": "array[string] - Names of blacklists",
    "checked_at": "string - ISO timestamp"
  }
}
```

---

## Infrastructure

### 17. Region-Wise Provider IDs

```
GET /smart-delivery/providers
```

Returns the list of email providers and their IDs, organized by geographic region.

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "region": "string - Region name (e.g., US, EU, UK, APAC)",
      "providers": [
        {
          "id": "number - Provider ID",
          "name": "string - Provider name (e.g., Gmail, Outlook, Yahoo)",
          "type": "string - BUSINESS | CONSUMER"
        }
      ]
    }
  ]
}
```

**Notes:**
- Use the provider IDs from this endpoint when creating manual or automated tests.
- Different regions have different provider options.
- Select providers that match your target audience's geography.

---

### 18. Sender Account List

```
GET /smart-delivery/sender-accounts
```

Returns the list of sender email accounts available for placement testing.

**Query Parameters:**
- `page` (optional, default: 1) - Page number.
- `limit` (optional, default: 50) - Results per page.
- `search` (optional) - Search by email address.

**Response:**
```json
{
  "ok": true,
  "data": {
    "accounts": [
      {
        "id": "number - Sender account ID",
        "email": "string - Email address",
        "provider": "string - Email provider (e.g., Google, Microsoft)",
        "warmup_status": "string - ACTIVE | COMPLETED | NOT_STARTED",
        "daily_limit": "number - Daily sending limit",
        "health_score": "number - Account health score (0-100)"
      }
    ],
    "total": "number",
    "page": "number",
    "limit": "number"
  }
}
```

**Notes:**
- Only use accounts with a COMPLETED warmup status for accurate placement tests.
- The health_score indicates overall account reputation.

---

### 19. Mailbox Summary

```
GET /smart-delivery/mailbox-summary
```

Returns a summary overview of all mailboxes connected for smart delivery.

**Response:**
```json
{
  "ok": true,
  "data": {
    "total_mailboxes": "number",
    "active_mailboxes": "number",
    "inactive_mailboxes": "number",
    "avg_health_score": "number - Average health score across all mailboxes",
    "providers_breakdown": [
      {
        "provider": "string",
        "count": "number"
      }
    ]
  }
}
```

---

### 20. Mailbox Count

```
GET /smart-delivery/mailbox-count
```

Returns the total count of mailboxes available for smart delivery testing.

**Response:**
```json
{
  "ok": true,
  "data": {
    "count": "number - Total mailbox count"
  }
}
```

---

## Folders

### 21. List Folders

```
GET /smart-delivery/folders
```

Returns all folders used to organize placement tests.

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "id": "number - Folder ID",
      "name": "string - Folder name",
      "test_count": "number - Number of tests in the folder",
      "created_at": "string - ISO timestamp"
    }
  ]
}
```

---

### 22. Create Folder

```
POST /smart-delivery/folders
```

Creates a new folder for organizing placement tests.

**Request Body:**
```json
{
  "name": "string (required) - Folder name"
}
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "id": "number - New folder ID",
    "name": "string - Folder name",
    "created_at": "string - ISO timestamp"
  }
}
```

---

### 23. Get Folder

```
GET /smart-delivery/folders/{id}
```

Retrieves details for a specific folder including its tests.

**Path Parameters:**
- `id` (required) - The folder ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "id": "number",
    "name": "string",
    "tests": [
      {
        "id": "number",
        "name": "string",
        "type": "string",
        "status": "string",
        "inbox_rate": "number",
        "created_at": "string"
      }
    ],
    "test_count": "number",
    "created_at": "string"
  }
}
```

---

### 24. Delete Folder

```
DELETE /smart-delivery/folders/{id}
```

Deletes a folder. Tests inside the folder are not deleted, they become unorganized.

**Path Parameters:**
- `id` (required) - The folder ID.

**Response:**
```json
{
  "ok": true,
  "message": "string - Confirmation message"
}
```

**Notes:**
- Deleting a folder does not delete the tests inside it.
- Tests previously in the folder will have their folder_id set to null.

---

## Other

### 25. Email Content

```
GET /smart-delivery/test/{id}/content
```

Retrieves the email subject and body content used in a specific test.

**Path Parameters:**
- `id` (required) - The test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "test_id": "number",
    "subject": "string - Email subject line",
    "body": "string - Email body in HTML format",
    "plain_text": "string - Plain text version if available"
  }
}
```

---

### 26. Reply Headers

```
GET /smart-delivery/test/{id}/reply-headers
```

Retrieves the email reply headers captured during a placement test.

**Path Parameters:**
- `id` (required) - The test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "test_id": "number",
    "headers": [
      {
        "seed_email": "string - Seed account that received the email",
        "provider": "string - Email provider",
        "received_headers": "array[string] - Full received header chain",
        "authentication_results": "string - Authentication-Results header value",
        "dkim_signature": "string - DKIM-Signature header value",
        "return_path": "string - Return-Path header value",
        "message_id": "string - Message-ID header value"
      }
    ]
  }
}
```

**Notes:**
- Reply headers are essential for diagnosing routing and authentication issues.
- The received header chain shows the path the email took through mail servers.
- Authentication-Results contains the pass/fail status as evaluated by the receiving server.

---

### 27. Schedule History

```
GET /smart-delivery/test/{id}/schedule-history
```

Retrieves the run history for an automated recurring test.

**Path Parameters:**
- `id` (required) - The automated test ID.

**Query Parameters:**
- `page` (optional, default: 1) - Page number.
- `limit` (optional, default: 20) - Results per page.

**Response:**
```json
{
  "ok": true,
  "data": {
    "test_id": "number",
    "runs": [
      {
        "run_id": "number",
        "status": "string - COMPLETED | FAILED | IN_PROGRESS",
        "inbox_rate": "number",
        "spam_rate": "number",
        "inbox_count": "number",
        "spam_count": "number",
        "missing_count": "number",
        "started_at": "string - ISO timestamp",
        "completed_at": "string - ISO timestamp or null"
      }
    ],
    "total_runs": "number",
    "page": "number",
    "limit": "number"
  }
}
```

**Notes:**
- Only available for automated tests. Manual tests have a single run.
- Use the run_id in report endpoints to get detailed breakdowns for a specific run.
- Useful for tracking deliverability trends over time.

---

### 28. IP Details

```
GET /smart-delivery/test/{id}/ip-details
```

Retrieves detailed IP information associated with a specific test.

**Path Parameters:**
- `id` (required) - The test ID.

**Response:**
```json
{
  "ok": true,
  "data": {
    "test_id": "number",
    "sending_ip": "string - IP address used to send the test",
    "ip_type": "string - SHARED | DEDICATED",
    "hostname": "string - Hostname associated with the IP",
    "isp": "string - Internet Service Provider",
    "location": "string - Geographic location of the IP",
    "reputation_score": "number - IP reputation score (0-100)",
    "blacklist_count": "number - Number of blacklists the IP appears on",
    "rdns_configured": "boolean - Whether rDNS is configured",
    "rdns_hostname": "string - rDNS hostname or null"
  }
}
```

**Notes:**
- Dedicated IPs give you full control over sender reputation.
- Shared IPs can be affected by other senders using the same IP.
- A low reputation_score suggests the IP may need warming or has deliverability issues.
