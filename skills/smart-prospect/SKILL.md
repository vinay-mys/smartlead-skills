---
name: smart-prospect
description: >-
  When the user wants to search for and find new contacts or prospects using Smartlead's
  built-in prospecting tool. Also use when the user mentions "find contacts," "prospect,"
  "search leads," "contact search," "find emails," "company search," "lead enrichment."
  For adding found contacts to campaigns, see lead-management.
metadata:
  version: 1.0.0
---

# Smart Prospect

Role: Expert in Smartlead prospecting. Goal: help users find, search, and enrich contact data using the Smart Prospect API.

Context Check: Read smartlead-context first.

## Initial Assessment

Before proceeding, determine the user's needs:

1. **Search criteria** - Industry, location, company name, job title, department
2. **Company size/revenue filters** - Head count ranges, annual revenue brackets
3. **Contact level/seniority** - C-suite, VP, Director, Manager, Individual Contributor
4. **Saved search needs** - One-time search or recurring prospecting workflow
5. **Email finding requirements** - Do they need verified email addresses for outreach

## Authentication

All endpoints require the `api_key` query parameter:

```
?api_key={SMARTLEAD_API_KEY}
```

Base URL: `https://server.smartlead.ai/api/v1`

## Core Endpoints

### Filter Options (GET)

Use these to populate valid filter values before building a search.

| Endpoint | Description |
|---|---|
| `GET /prospect/departments` | Available departments (Sales, Marketing, Engineering, etc.) |
| `GET /prospect/cities` | Available cities for location filtering |
| `GET /prospect/countries` | Available countries |
| `GET /prospect/states` | Available states/provinces |
| `GET /prospect/industries` | Top-level industry categories |
| `GET /prospect/sub-industries` | Sub-industry breakdowns within each industry |
| `GET /prospect/head-counts` | Company size ranges (1-10, 11-50, 51-200, etc.) |
| `GET /prospect/levels` | Seniority levels (C-Suite, VP, Director, Manager, etc.) |
| `GET /prospect/revenue-options` | Annual revenue range options |
| `GET /prospect/companies` | Searchable company database |
| `GET /prospect/domains` | Searchable domain database |
| `GET /prospect/job-titles` | Available job title values |
| `GET /prospect/keywords` | Keyword options for refined searches |

### Search & Fetch (POST)

Primary endpoints for finding and retrieving contact data.

| Endpoint | Method | Description |
|---|---|---|
| `/prospect/search` | POST | Search contacts using assembled filter criteria |
| `/prospect/fetch` | POST | Fetch full contact details for selected prospects |
| `/prospect/contacts` | POST | Retrieve contacts from previous searches |
| `/prospect/review` | PATCH | Mark contacts as reviewed/approved |
| `/prospect/find-emails` | POST | Find and verify email addresses for contacts |

### Saved Searches

Manage reusable search configurations.

| Endpoint | Method | Description |
|---|---|---|
| `/prospect/saved-searches` | GET | List all saved searches |
| `/prospect/recent-searches` | GET | Get recently executed searches |
| `/prospect/fetched-searches` | GET | Get searches where contacts were fetched |
| `/prospect/save-search` | POST | Save current search criteria for reuse |
| `/prospect/saved-search/{id}` | PUT | Update an existing saved search |
| `/prospect/fetched-lead/{id}` | PUT | Update a previously fetched lead record |

### Analytics

Track prospecting performance.

| Endpoint | Method | Description |
|---|---|---|
| `/prospect/search-analytics` | GET | Metrics on search volume, result counts, filter usage |
| `/prospect/reply-analytics` | GET | Response rates from prospected contacts |

## Prospecting Workflow

Follow this sequence for best results:

### Step 1: Fetch Available Filter Options

Always start by retrieving valid filter values. Do not guess or hardcode values.

```
GET /prospect/industries?api_key={key}
GET /prospect/levels?api_key={key}
GET /prospect/countries?api_key={key}
GET /prospect/head-counts?api_key={key}
```

### Step 2: Build Search Criteria

Assemble filters based on user requirements. Combine multiple filters for precision.

```json
{
  "industries": ["Technology", "SaaS"],
  "levels": ["C-Suite", "VP"],
  "countries": ["United States"],
  "head_counts": ["51-200", "201-500"],
  "departments": ["Sales", "Marketing"]
}
```

### Step 3: Search Contacts

Execute the search with assembled criteria.

```
POST /prospect/search?api_key={key}
```

### Step 4: Review Promising Contacts

Review results and mark contacts of interest.

```
PATCH /prospect/review?api_key={key}
```

### Step 5: Fetch Full Contact Details

Retrieve complete profiles for approved contacts.

```
POST /prospect/fetch?api_key={key}
```

### Step 6: Find Email Addresses

Discover and verify email addresses for fetched contacts.

```
POST /prospect/find-emails?api_key={key}
```

### Step 7: Save Search for Reuse

If the search criteria produced good results, save it.

```
POST /prospect/save-search?api_key={key}
```

### Step 8: Add to Campaigns

Hand off enriched contacts to campaign workflows (via lead-management skill).

## Common Mistakes

- **Not fetching available filter options before searching** - Leads to invalid filter values and failed searches. Always call the GET filter endpoints first.
- **Using overly broad search criteria** - Produces slow queries and low-quality results. Use at least 2-3 filters to narrow scope.
- **Not saving successful searches for reuse** - Wastes time rebuilding criteria. Save any search that produces good results.
- **Forgetting to find emails before adding to campaigns** - Contacts without verified emails will fail in outreach sequences.
- **Not reviewing contacts before bulk fetching** - Fetching consumes credits. Review first to avoid wasting quota on irrelevant contacts.
- **Ignoring sub-industry filters** - Top-level industries are often too broad. Sub-industries dramatically improve targeting.
- **Skipping analytics review** - Search and reply analytics reveal which filters and criteria produce the best outcomes over time.

## Tips for Better Prospecting

1. **Start narrow, expand later** - Begin with specific criteria and broaden if results are insufficient.
2. **Layer filters strategically** - Combine industry + level + head count for high-precision targeting.
3. **Use saved searches for ongoing campaigns** - Save and iterate on searches that produce good engagement.
4. **Check recent searches first** - Avoid duplicating work by reviewing what has already been searched.
5. **Monitor reply analytics** - Use reply analytics to refine future search criteria based on what actually converts.

## Related Skills

| Skill | When to Use |
|---|---|
| `smartlead-context` | Read first for API setup, authentication, and global context |
| `lead-management` | Adding found prospects to campaigns, managing lead lists |
| `campaign-management` | Creating and configuring outreach campaigns |
| `email-account-management` | Managing sender accounts for outreach |
| `campaign-analytics` | Tracking campaign performance after prospects are contacted |
| `global-analytics` | Workspace-wide analytics across all prospecting and campaign activity |
