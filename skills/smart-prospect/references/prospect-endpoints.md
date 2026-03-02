# Smart Prospect API Endpoints Reference

Base URL: `https://server.smartlead.ai/api/v1`

Authentication: All endpoints require `?api_key={SMARTLEAD_API_KEY}` as a query parameter.

---

## Category 1: Filter Options (GET Endpoints)

These endpoints return the valid values you can use when building search criteria. Always call these before constructing a search to ensure you use valid filter values.

---

### 1. GET /prospect/departments

Retrieve all available department filter values.

**Request:**

```
GET /prospect/departments?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "dept_001",
      "name": "Sales"
    },
    {
      "id": "dept_002",
      "name": "Marketing"
    },
    {
      "id": "dept_003",
      "name": "Engineering"
    }
  ]
}
```

**Use Case:** Populate department filters in a prospect search. Use the returned `id` or `name` values when building search criteria.

---

### 2. GET /prospect/cities

Retrieve available city values for geographic filtering.

**Request:**

```
GET /prospect/cities?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `country` | string | No | Filter cities by country name |
| `state` | string | No | Filter cities by state/province |
| `search` | string | No | Partial text match on city name |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "city_001",
      "name": "San Francisco",
      "state": "California",
      "country": "United States"
    }
  ]
}
```

**Use Case:** Narrow prospecting to specific cities. Combine with country/state filters for precision.

---

### 3. GET /prospect/countries

Retrieve available country values.

**Request:**

```
GET /prospect/countries?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `search` | string | No | Partial text match on country name |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "country_001",
      "name": "United States",
      "code": "US"
    },
    {
      "id": "country_002",
      "name": "United Kingdom",
      "code": "GB"
    }
  ]
}
```

**Use Case:** Set geographic boundaries for prospecting. Use as a prerequisite filter before narrowing to states and cities.

---

### 4. GET /prospect/states

Retrieve available state/province values.

**Request:**

```
GET /prospect/states?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `country` | string | No | Filter states by country name |
| `search` | string | No | Partial text match on state name |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "state_001",
      "name": "California",
      "country": "United States"
    }
  ]
}
```

**Use Case:** Filter prospects by state or province. Useful for region-specific outreach campaigns.

---

### 5. GET /prospect/industries

Retrieve top-level industry categories.

**Request:**

```
GET /prospect/industries?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `search` | string | No | Partial text match on industry name |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "ind_001",
      "name": "Technology",
      "sub_industry_count": 15
    },
    {
      "id": "ind_002",
      "name": "Healthcare",
      "sub_industry_count": 12
    }
  ]
}
```

**Use Case:** Primary filter for targeting prospects by business sector. Pair with sub-industries for precision.

---

### 6. GET /prospect/sub-industries

Retrieve sub-industry breakdowns within parent industries.

**Request:**

```
GET /prospect/sub-industries?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `industry_id` | string | No | Filter by parent industry ID |
| `search` | string | No | Partial text match on sub-industry name |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "subind_001",
      "name": "SaaS",
      "parent_industry": "Technology"
    },
    {
      "id": "subind_002",
      "name": "Cybersecurity",
      "parent_industry": "Technology"
    }
  ]
}
```

**Use Case:** Refine industry targeting beyond broad categories. Significantly improves prospect quality.

---

### 7. GET /prospect/head-counts

Retrieve available company size (employee count) ranges.

**Request:**

```
GET /prospect/head-counts?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "hc_001",
      "label": "1-10",
      "min": 1,
      "max": 10
    },
    {
      "id": "hc_002",
      "label": "11-50",
      "min": 11,
      "max": 50
    },
    {
      "id": "hc_003",
      "label": "51-200",
      "min": 51,
      "max": 200
    },
    {
      "id": "hc_004",
      "label": "201-500",
      "min": 201,
      "max": 500
    },
    {
      "id": "hc_005",
      "label": "501-1000",
      "min": 501,
      "max": 1000
    },
    {
      "id": "hc_006",
      "label": "1001-5000",
      "min": 1001,
      "max": 5000
    },
    {
      "id": "hc_007",
      "label": "5001+",
      "min": 5001,
      "max": null
    }
  ]
}
```

**Use Case:** Target prospects at companies of a specific size. Critical for matching ICP (Ideal Customer Profile).

---

### 8. GET /prospect/levels

Retrieve available seniority/contact level values.

**Request:**

```
GET /prospect/levels?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "level_001",
      "name": "C-Suite"
    },
    {
      "id": "level_002",
      "name": "VP"
    },
    {
      "id": "level_003",
      "name": "Director"
    },
    {
      "id": "level_004",
      "name": "Manager"
    },
    {
      "id": "level_005",
      "name": "Individual Contributor"
    }
  ]
}
```

**Use Case:** Filter prospects by decision-making authority. Essential for targeting the right seniority in outreach.

---

### 9. GET /prospect/revenue-options

Retrieve available annual revenue range options.

**Request:**

```
GET /prospect/revenue-options?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "rev_001",
      "label": "$0 - $1M",
      "min": 0,
      "max": 1000000
    },
    {
      "id": "rev_002",
      "label": "$1M - $10M",
      "min": 1000000,
      "max": 10000000
    },
    {
      "id": "rev_003",
      "label": "$10M - $50M",
      "min": 10000000,
      "max": 50000000
    },
    {
      "id": "rev_004",
      "label": "$50M - $100M",
      "min": 50000000,
      "max": 100000000
    },
    {
      "id": "rev_005",
      "label": "$100M+",
      "min": 100000000,
      "max": null
    }
  ]
}
```

**Use Case:** Target prospects at companies within specific revenue brackets. Helps align prospecting with deal size expectations.

---

### 10. GET /prospect/companies

Search the company database.

**Request:**

```
GET /prospect/companies?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `search` | string | No | Partial match on company name |
| `industry_id` | string | No | Filter by industry |
| `country` | string | No | Filter by country |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "comp_001",
      "name": "Acme Corp",
      "domain": "acme.com",
      "industry": "Technology",
      "head_count": "201-500",
      "country": "United States"
    }
  ]
}
```

**Use Case:** Look up specific companies or browse companies matching certain criteria before searching for individual contacts within them.

---

### 11. GET /prospect/domains

Search the domain database.

**Request:**

```
GET /prospect/domains?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `search` | string | No | Partial match on domain name |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "dom_001",
      "domain": "acme.com",
      "company_name": "Acme Corp"
    }
  ]
}
```

**Use Case:** Find company domains for domain-based prospecting. Useful when you know the company website but not the exact company name in the database.

---

### 12. GET /prospect/job-titles

Retrieve available job title values.

**Request:**

```
GET /prospect/job-titles?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `search` | string | No | Partial text match on job title |
| `department` | string | No | Filter by department |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "jt_001",
      "title": "Chief Executive Officer",
      "department": "Executive",
      "level": "C-Suite"
    },
    {
      "id": "jt_002",
      "title": "VP of Sales",
      "department": "Sales",
      "level": "VP"
    }
  ]
}
```

**Use Case:** Target prospects by specific job title. More precise than level-only filtering. Use the search parameter to find title variations.

---

### 13. GET /prospect/keywords

Retrieve keyword options for refined searches.

**Request:**

```
GET /prospect/keywords?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `search` | string | No | Partial text match on keyword |

**Response:**

```json
{
  "ok": true,
  "data": [
    {
      "id": "kw_001",
      "keyword": "artificial intelligence"
    },
    {
      "id": "kw_002",
      "keyword": "machine learning"
    }
  ]
}
```

**Use Case:** Add keyword-based filtering to searches. Keywords match against prospect profiles, bios, and company descriptions for thematic targeting.

---

## Category 2: Search & Fetch (POST/PATCH Endpoints)

These endpoints execute searches, retrieve contact data, and manage the review workflow.

---

### 14. POST /prospect/search

Execute a prospect search using assembled filter criteria.

**Request:**

```
POST /prospect/search?api_key={api_key}
Content-Type: application/json
```

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `industries` | array[string] | No | Industry names or IDs to filter by |
| `sub_industries` | array[string] | No | Sub-industry names or IDs |
| `departments` | array[string] | No | Department names or IDs |
| `levels` | array[string] | No | Seniority level names or IDs |
| `job_titles` | array[string] | No | Specific job titles |
| `countries` | array[string] | No | Country names or codes |
| `states` | array[string] | No | State/province names |
| `cities` | array[string] | No | City names |
| `head_counts` | array[string] | No | Company size range labels or IDs |
| `revenue_ranges` | array[string] | No | Revenue range labels or IDs |
| `companies` | array[string] | No | Specific company names or IDs |
| `domains` | array[string] | No | Specific domain names |
| `keywords` | array[string] | No | Keywords for thematic matching |
| `exclude_companies` | array[string] | No | Companies to exclude from results |
| `exclude_domains` | array[string] | No | Domains to exclude from results |
| `page` | integer | No | Page number for pagination (default: 1) |
| `per_page` | integer | No | Results per page (default: 25, max: 100) |

**Example Request Body:**

```json
{
  "industries": ["Technology"],
  "sub_industries": ["SaaS"],
  "levels": ["C-Suite", "VP"],
  "countries": ["United States"],
  "head_counts": ["51-200", "201-500"],
  "departments": ["Sales", "Marketing"],
  "page": 1,
  "per_page": 25
}
```

**Response:**

```json
{
  "ok": true,
  "data": {
    "total_results": 1250,
    "page": 1,
    "per_page": 25,
    "contacts": [
      {
        "id": "contact_001",
        "first_name": "Jane",
        "last_name": "Smith",
        "job_title": "VP of Sales",
        "level": "VP",
        "department": "Sales",
        "company": "Acme SaaS Inc.",
        "industry": "Technology",
        "sub_industry": "SaaS",
        "country": "United States",
        "state": "California",
        "city": "San Francisco",
        "head_count": "201-500",
        "has_email": true,
        "status": "new"
      }
    ]
  }
}
```

**Use Case:** Primary search endpoint. Combine multiple filters for targeted results. Always fetch filter options first to ensure valid values. Use pagination for large result sets.

**Notes:**
- At least one filter field should be provided. Searches with no filters will be rejected.
- Results are sorted by relevance by default.
- The `has_email` flag indicates whether an email is available for finding.

---

### 15. POST /prospect/fetch

Fetch full contact details for selected prospects.

**Request:**

```
POST /prospect/fetch?api_key={api_key}
Content-Type: application/json
```

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `contact_ids` | array[string] | Yes | List of contact IDs to fetch full details for |
| `include_social` | boolean | No | Include social media profiles (default: false) |
| `include_company_details` | boolean | No | Include full company info (default: false) |

**Example Request Body:**

```json
{
  "contact_ids": ["contact_001", "contact_002", "contact_003"],
  "include_social": true,
  "include_company_details": true
}
```

**Response:**

```json
{
  "ok": true,
  "data": {
    "contacts": [
      {
        "id": "contact_001",
        "first_name": "Jane",
        "last_name": "Smith",
        "job_title": "VP of Sales",
        "level": "VP",
        "department": "Sales",
        "email": null,
        "phone": "+1-555-0100",
        "linkedin_url": "https://linkedin.com/in/janesmith",
        "company": {
          "name": "Acme SaaS Inc.",
          "domain": "acmesaas.com",
          "industry": "Technology",
          "sub_industry": "SaaS",
          "head_count": "201-500",
          "revenue": "$10M - $50M",
          "country": "United States",
          "state": "California",
          "city": "San Francisco",
          "description": "B2B SaaS platform for sales automation"
        },
        "social_profiles": {
          "linkedin": "https://linkedin.com/in/janesmith",
          "twitter": "https://twitter.com/janesmith"
        },
        "fetched_at": "2025-01-15T10:30:00Z"
      }
    ],
    "credits_used": 3
  }
}
```

**Use Case:** Retrieve complete profiles after identifying promising contacts via search. Fetching consumes credits, so review contacts before bulk fetching.

**Notes:**
- Fetching a contact that has already been fetched does not consume additional credits.
- Email addresses are not included by default; use `/prospect/find-emails` separately.
- `credits_used` shows how many new credits were consumed in this request.

---

### 16. POST /prospect/contacts

Get contacts from previous searches or fetch operations.

**Request:**

```
POST /prospect/contacts?api_key={api_key}
Content-Type: application/json
```

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `search_id` | string | No | Retrieve contacts from a specific search |
| `status` | string | No | Filter by status: `new`, `reviewed`, `fetched`, `emailed` |
| `page` | integer | No | Page number (default: 1) |
| `per_page` | integer | No | Results per page (default: 25, max: 100) |

**Example Request Body:**

```json
{
  "search_id": "search_abc123",
  "status": "fetched",
  "page": 1,
  "per_page": 50
}
```

**Response:**

```json
{
  "ok": true,
  "data": {
    "total_results": 45,
    "page": 1,
    "per_page": 50,
    "contacts": [
      {
        "id": "contact_001",
        "first_name": "Jane",
        "last_name": "Smith",
        "job_title": "VP of Sales",
        "company": "Acme SaaS Inc.",
        "status": "fetched",
        "email": "jane.smith@acmesaas.com",
        "fetched_at": "2025-01-15T10:30:00Z"
      }
    ]
  }
}
```

**Use Case:** Retrieve contacts you have already interacted with. Use the `status` filter to track contacts through the prospecting pipeline.

---

### 17. PATCH /prospect/review

Mark contacts as reviewed or update their review status.

**Request:**

```
PATCH /prospect/review?api_key={api_key}
Content-Type: application/json
```

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `contact_ids` | array[string] | Yes | List of contact IDs to review |
| `action` | string | Yes | Review action: `approve`, `reject`, `bookmark` |
| `notes` | string | No | Optional notes about the review decision |

**Example Request Body:**

```json
{
  "contact_ids": ["contact_001", "contact_002"],
  "action": "approve",
  "notes": "Good fit for Q1 SaaS outreach campaign"
}
```

**Response:**

```json
{
  "ok": true,
  "data": {
    "updated_count": 2,
    "contacts": [
      {
        "id": "contact_001",
        "status": "reviewed",
        "review_action": "approve"
      },
      {
        "id": "contact_002",
        "status": "reviewed",
        "review_action": "approve"
      }
    ]
  }
}
```

**Use Case:** Quality control step between searching and fetching. Review contacts to approve, reject, or bookmark them before committing credits to full fetches.

---

### 18. POST /prospect/find-emails

Find and verify email addresses for contacts.

**Request:**

```
POST /prospect/find-emails?api_key={api_key}
Content-Type: application/json
```

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `contact_ids` | array[string] | Yes | List of contact IDs to find emails for |
| `verify` | boolean | No | Run email verification after finding (default: true) |

**Example Request Body:**

```json
{
  "contact_ids": ["contact_001", "contact_002", "contact_003"],
  "verify": true
}
```

**Response:**

```json
{
  "ok": true,
  "data": {
    "results": [
      {
        "contact_id": "contact_001",
        "email": "jane.smith@acmesaas.com",
        "verification_status": "valid",
        "confidence": 95,
        "source": "pattern_match"
      },
      {
        "contact_id": "contact_002",
        "email": "john.doe@techcorp.io",
        "verification_status": "valid",
        "confidence": 88,
        "source": "database"
      },
      {
        "contact_id": "contact_003",
        "email": null,
        "verification_status": "not_found",
        "confidence": 0,
        "source": null
      }
    ],
    "found_count": 2,
    "not_found_count": 1,
    "credits_used": 3
  }
}
```

**Use Case:** Essential step before adding contacts to outreach campaigns. Contacts without verified emails should not be added to email sequences.

**Notes:**
- Email finding consumes credits regardless of whether an email is found.
- Setting `verify` to `true` adds a verification step that checks deliverability.
- The `confidence` score (0-100) indicates how reliable the email address is.
- `source` can be `pattern_match`, `database`, `catch_all`, or `guess`.

---

## Category 3: Saved Searches (GET/POST/PUT Endpoints)

Manage reusable search configurations to streamline recurring prospecting workflows.

---

### 19. GET /prospect/saved-searches

List all saved searches for the account.

**Request:**

```
GET /prospect/saved-searches?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `page` | integer | No | Page number (default: 1) |
| `per_page` | integer | No | Results per page (default: 25) |

**Response:**

```json
{
  "ok": true,
  "data": {
    "total": 8,
    "saved_searches": [
      {
        "id": "ss_001",
        "name": "SaaS VPs in California",
        "filters": {
          "industries": ["Technology"],
          "sub_industries": ["SaaS"],
          "levels": ["VP"],
          "states": ["California"]
        },
        "result_count": 1250,
        "created_at": "2025-01-10T09:00:00Z",
        "last_run_at": "2025-01-15T14:00:00Z"
      }
    ]
  }
}
```

**Use Case:** View all saved search configurations. Use to quickly re-run proven searches without rebuilding criteria.

---

### 20. GET /prospect/recent-searches

Get recently executed searches.

**Request:**

```
GET /prospect/recent-searches?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `limit` | integer | No | Number of recent searches to return (default: 10, max: 50) |

**Response:**

```json
{
  "ok": true,
  "data": {
    "searches": [
      {
        "id": "search_abc123",
        "filters": {
          "industries": ["Technology"],
          "levels": ["C-Suite"],
          "countries": ["United States"]
        },
        "result_count": 3420,
        "executed_at": "2025-01-15T14:30:00Z",
        "is_saved": false
      }
    ]
  }
}
```

**Use Case:** Review recent search activity. Identify searches worth saving. Avoid duplicating recent work.

---

### 21. GET /prospect/fetched-searches

Get searches where contacts have been fetched (credits consumed).

**Request:**

```
GET /prospect/fetched-searches?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `page` | integer | No | Page number (default: 1) |
| `per_page` | integer | No | Results per page (default: 25) |

**Response:**

```json
{
  "ok": true,
  "data": {
    "total": 5,
    "searches": [
      {
        "id": "search_abc123",
        "filters": {
          "industries": ["Technology"],
          "levels": ["VP"]
        },
        "result_count": 1250,
        "fetched_count": 75,
        "credits_used": 75,
        "executed_at": "2025-01-15T14:30:00Z"
      }
    ]
  }
}
```

**Use Case:** Track which searches led to actual contact fetches. Monitor credit usage across searches. Audit prospecting spend.

---

### 22. POST /prospect/save-search

Save current search criteria for future reuse.

**Request:**

```
POST /prospect/save-search?api_key={api_key}
Content-Type: application/json
```

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | Yes | Descriptive name for the saved search |
| `filters` | object | Yes | The search filter criteria to save |
| `description` | string | No | Optional description of the search purpose |

**Example Request Body:**

```json
{
  "name": "SaaS VPs in California",
  "description": "VP-level sales and marketing contacts at mid-size SaaS companies in CA",
  "filters": {
    "industries": ["Technology"],
    "sub_industries": ["SaaS"],
    "levels": ["VP"],
    "departments": ["Sales", "Marketing"],
    "states": ["California"],
    "head_counts": ["51-200", "201-500"]
  }
}
```

**Response:**

```json
{
  "ok": true,
  "data": {
    "id": "ss_002",
    "name": "SaaS VPs in California",
    "description": "VP-level sales and marketing contacts at mid-size SaaS companies in CA",
    "filters": {
      "industries": ["Technology"],
      "sub_industries": ["SaaS"],
      "levels": ["VP"],
      "departments": ["Sales", "Marketing"],
      "states": ["California"],
      "head_counts": ["51-200", "201-500"]
    },
    "created_at": "2025-01-15T15:00:00Z"
  }
}
```

**Use Case:** Preserve successful search criteria for recurring prospecting. Name searches descriptively so they are easy to identify later.

---

### 23. PUT /prospect/saved-search/{id}

Update an existing saved search.

**Request:**

```
PUT /prospect/saved-search/{id}?api_key={api_key}
Content-Type: application/json
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `id` | string | Yes | The saved search ID to update |

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | No | Updated name |
| `filters` | object | No | Updated filter criteria |
| `description` | string | No | Updated description |

**Example Request Body:**

```json
{
  "name": "SaaS VPs & Directors in California",
  "filters": {
    "industries": ["Technology"],
    "sub_industries": ["SaaS"],
    "levels": ["VP", "Director"],
    "departments": ["Sales", "Marketing"],
    "states": ["California"],
    "head_counts": ["51-200", "201-500"]
  }
}
```

**Response:**

```json
{
  "ok": true,
  "data": {
    "id": "ss_002",
    "name": "SaaS VPs & Directors in California",
    "filters": {
      "industries": ["Technology"],
      "sub_industries": ["SaaS"],
      "levels": ["VP", "Director"],
      "departments": ["Sales", "Marketing"],
      "states": ["California"],
      "head_counts": ["51-200", "201-500"]
    },
    "updated_at": "2025-01-16T09:00:00Z"
  }
}
```

**Use Case:** Refine saved searches over time. Expand or narrow criteria based on campaign results and reply analytics.

---

### 24. PUT /prospect/fetched-lead/{id}

Update a previously fetched lead record.

**Request:**

```
PUT /prospect/fetched-lead/{id}?api_key={api_key}
Content-Type: application/json
```

**Path Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `id` | string | Yes | The fetched lead/contact ID to update |

**Request Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `status` | string | No | Updated status: `active`, `archived`, `do_not_contact` |
| `tags` | array[string] | No | Tags to apply to the lead |
| `notes` | string | No | Updated notes about the lead |
| `custom_fields` | object | No | Custom field key-value pairs |

**Example Request Body:**

```json
{
  "status": "active",
  "tags": ["high-priority", "q1-campaign"],
  "notes": "Responded positively on LinkedIn. Schedule follow-up.",
  "custom_fields": {
    "campaign_id": "camp_001",
    "lead_source": "smart_prospect"
  }
}
```

**Response:**

```json
{
  "ok": true,
  "data": {
    "id": "contact_001",
    "status": "active",
    "tags": ["high-priority", "q1-campaign"],
    "notes": "Responded positively on LinkedIn. Schedule follow-up.",
    "custom_fields": {
      "campaign_id": "camp_001",
      "lead_source": "smart_prospect"
    },
    "updated_at": "2025-01-16T10:00:00Z"
  }
}
```

**Use Case:** Manage fetched leads with tags, status changes, and notes. Useful for organizing leads before adding them to campaigns via the lead-management skill.

---

## Category 4: Analytics (GET Endpoints)

Track prospecting performance to optimize future searches.

---

### 25. GET /prospect/search-analytics

Get analytics on search activity and performance.

**Request:**

```
GET /prospect/search-analytics?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `start_date` | string | No | Start date in ISO 8601 format (e.g., `2025-01-01`) |
| `end_date` | string | No | End date in ISO 8601 format (e.g., `2025-01-31`) |
| `group_by` | string | No | Group results by: `day`, `week`, `month` (default: `day`) |

**Response:**

```json
{
  "ok": true,
  "data": {
    "summary": {
      "total_searches": 45,
      "total_results_found": 56000,
      "total_contacts_fetched": 320,
      "total_emails_found": 280,
      "total_credits_used": 600,
      "average_results_per_search": 1244
    },
    "top_filters": {
      "industries": [
        { "name": "Technology", "usage_count": 30 }
      ],
      "levels": [
        { "name": "VP", "usage_count": 25 }
      ],
      "countries": [
        { "name": "United States", "usage_count": 40 }
      ]
    },
    "timeline": [
      {
        "date": "2025-01-15",
        "searches": 5,
        "results_found": 6200,
        "contacts_fetched": 40,
        "credits_used": 40
      }
    ]
  }
}
```

**Use Case:** Monitor search volume, credit consumption, and filter effectiveness. Identify which filters produce the most results. Track prospecting activity trends over time.

---

### 26. GET /prospect/reply-analytics

Get analytics on responses from prospected contacts.

**Request:**

```
GET /prospect/reply-analytics?api_key={api_key}
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `api_key` | string | Yes | Your Smartlead API key |
| `start_date` | string | No | Start date in ISO 8601 format |
| `end_date` | string | No | End date in ISO 8601 format |
| `group_by` | string | No | Group results by: `day`, `week`, `month` (default: `day`) |
| `search_id` | string | No | Filter by specific search ID |

**Response:**

```json
{
  "ok": true,
  "data": {
    "summary": {
      "total_contacted": 280,
      "total_replies": 42,
      "reply_rate": 15.0,
      "positive_replies": 28,
      "negative_replies": 8,
      "neutral_replies": 6,
      "positive_reply_rate": 10.0
    },
    "by_search": [
      {
        "search_id": "ss_001",
        "search_name": "SaaS VPs in California",
        "contacted": 75,
        "replies": 15,
        "reply_rate": 20.0,
        "positive_replies": 12,
        "positive_reply_rate": 16.0
      }
    ],
    "by_filter": {
      "by_industry": [
        {
          "industry": "Technology",
          "contacted": 180,
          "replies": 30,
          "reply_rate": 16.7
        }
      ],
      "by_level": [
        {
          "level": "VP",
          "contacted": 100,
          "replies": 20,
          "reply_rate": 20.0
        }
      ]
    },
    "timeline": [
      {
        "date": "2025-01-15",
        "contacted": 15,
        "replies": 3,
        "positive_replies": 2
      }
    ]
  }
}
```

**Use Case:** Measure which prospecting criteria lead to the best engagement. Compare reply rates across different searches, industries, and seniority levels. Use these insights to refine future searches and prioritize high-performing segments.

**Notes:**
- Reply analytics depend on contacts being added to campaigns via the lead-management skill.
- The `by_filter` breakdown shows how individual filter dimensions correlate with reply rates.
- Use `search_id` to analyze the performance of a specific saved search.
