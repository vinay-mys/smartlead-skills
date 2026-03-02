---
name: global-analytics
description: >-
  When the user wants account-wide reporting, cross-campaign analytics, or health metrics
  in Smartlead. Also use when the user mentions "overall stats," "account analytics,"
  "domain health," "provider performance," "team board," "reporting dashboard."
  For single-campaign metrics, see campaign-analytics.
metadata:
  version: 1.0.0
---

# Global Analytics

Role: Expert in Smartlead account-wide analytics. Goal: help users access cross-campaign reporting, health metrics, and performance dashboards.

Context Check: Read smartlead-context first.

## Initial Assessment

Before calling any endpoint, determine:

1. **Reporting scope** - overall account, campaign-level aggregate, client-level, or mailbox-level
2. **Time period** - day-wise breakdown, specific date range, or all-time totals
3. **Focus area** - performance metrics, health/deliverability, team board, or lead analytics
4. **Client filtering needs** - agency accounts must filter by client_id where applicable
5. **Export/automation requirements** - one-time pull vs. recurring dashboard data

## Core Endpoints by Category

### Overview

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/analytics/overall-stats` | Account-wide aggregate stats (sent, opened, clicked, replied, bounced) |
| GET | `/api/v1/analytics/day-wise-stats` | Day-by-day breakdown of all key metrics |
| GET | `/api/v1/analytics/day-wise-stats-sent-time` | Stats segmented by the hour emails were sent |

### Campaign Level

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/analytics/campaigns` | List campaigns available for analytics filtering |
| GET | `/api/v1/analytics/campaign-stats` | Aggregate stats across selected campaigns |
| GET | `/api/v1/analytics/campaign-response` | Response breakdown (positive, negative, neutral, OOO) per campaign |
| GET | `/api/v1/analytics/campaign-status` | Campaign status distribution (active, paused, completed, draft) |

### Client Level

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/analytics/clients` | List clients available for analytics filtering |
| GET | `/api/v1/analytics/client-count` | Month-wise count of active clients |
| GET | `/api/v1/analytics/client-stats` | Aggregate stats filtered by client |

### Lead Analytics

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/analytics/lead-stats` | Lead-level aggregate stats (total, contacted, replied, interested) |
| GET | `/api/v1/analytics/lead-category-response` | Responses broken down by lead category |
| GET | `/api/v1/analytics/first-reply-time` | Distribution of time-to-first-reply |
| GET | `/api/v1/analytics/follow-up-reply-rate` | Reply rate per follow-up sequence step |
| GET | `/api/v1/analytics/lead-reply-time` | Average lead-to-reply time metrics |

### Reply Analytics

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/analytics/positive-reply-stats` | Day-wise positive reply counts and rates |
| GET | `/api/v1/analytics/positive-reply-stats-sent-time` | Positive replies segmented by original send time |

### Health & Deliverability

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/analytics/email-health` | Per-email-account health scores and metrics |
| GET | `/api/v1/analytics/domain-health` | Per-domain deliverability health metrics |
| GET | `/api/v1/analytics/provider-performance` | Performance breakdown by email provider (Google, Outlook, etc.) |
| GET | `/api/v1/analytics/mailbox-stats` | Per-mailbox sending and deliverability stats |

### Team

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/v1/analytics/team-board` | Team member performance leaderboard and stats |

## Workflow Patterns

### Pattern 1: Executive Dashboard

```
1. GET /analytics/overall-stats          -> top-line numbers
2. GET /analytics/day-wise-stats         -> trend over last 7/30 days
3. GET /analytics/positive-reply-stats   -> positive reply trend
4. GET /analytics/domain-health          -> deliverability summary
```

### Pattern 2: Deliverability Audit

```
1. GET /analytics/email-health           -> identify unhealthy accounts
2. GET /analytics/domain-health          -> flag problem domains
3. GET /analytics/provider-performance   -> compare provider delivery rates
4. GET /analytics/mailbox-stats          -> drill into specific mailboxes
```

### Pattern 3: Agency Client Review

```
1. GET /analytics/clients                -> list all clients
2. GET /analytics/client-stats           -> per-client performance
3. GET /analytics/client-count           -> client growth trend
4. GET /analytics/campaign-stats         -> campaign performance by client
```

### Pattern 4: Lead Funnel Analysis

```
1. GET /analytics/lead-stats             -> top-of-funnel numbers
2. GET /analytics/lead-category-response -> response quality breakdown
3. GET /analytics/first-reply-time       -> speed-to-engage metric
4. GET /analytics/follow-up-reply-rate   -> sequence effectiveness
```

### Pattern 5: Team Performance Review

```
1. GET /analytics/team-board             -> member-by-member stats
2. GET /analytics/campaign-stats         -> campaign attribution
3. GET /analytics/positive-reply-stats   -> positive outcome trends
```

## Output Format

Present results as an executive summary with:

- **Key metrics** in a clear table (sent, opened, clicked, replied, bounced with rates)
- **Trend indicators** showing direction (improving, stable, declining) over the selected period
- **Benchmarks** comparing against typical Smartlead performance ranges
- **Actionable insights** calling out anomalies, risks, or opportunities
- **Health warnings** if any domain/email/provider metrics are in danger zones

Example output structure:

```
## Account Overview (Last 30 Days)

| Metric       | Count  | Rate   | Trend      |
|--------------|--------|--------|------------|
| Sent         | 45,230 | -      | stable     |
| Opened       | 22,115 | 48.9%  | improving  |
| Clicked      | 3,612  | 8.0%   | stable     |
| Replied      | 2,487  | 5.5%   | improving  |
| Bounced      | 905    | 2.0%   | stable     |

### Insights
- Open rate above 45% benchmark - strong subject lines
- Reply rate trending up 0.8% week-over-week
- 2 domains showing declining health - recommend warmup review

### Action Items
1. Review domain health for example.com (score dropped below 70)
2. Follow-up step 3 has 40% lower reply rate - consider revision
```

## Common Mistakes

1. **Using global analytics for single-campaign questions** - redirect to campaign-analytics skill for individual campaign deep-dives
2. **Not filtering by client_id for agency accounts** - agency users must scope queries to the relevant client or results will aggregate across all clients
3. **Ignoring domain/email health metrics** - health scores are leading indicators of deliverability problems; check them proactively, not just when bounce rates spike
4. **Not tracking day-wise trends** - a single snapshot can be misleading; always pull day-wise data to spot declining performance before it becomes critical
5. **Comparing raw counts without rates** - always present percentage rates alongside absolute numbers for meaningful comparison
6. **Missing sent-time optimization** - the sent-time variants of stats endpoints reveal optimal sending windows that many users overlook

## Parameter Reference (Quick)

Most analytics endpoints accept these common query parameters:

| Parameter | Type | Description |
|-----------|------|-------------|
| `api_key` | string | **Required.** Your Smartlead API key |
| `start_date` | string | Start of date range (YYYY-MM-DD) |
| `end_date` | string | End of date range (YYYY-MM-DD) |
| `client_id` | integer | Filter by client (agency accounts) |
| `campaign_id` | integer | Filter by specific campaign |
| `offset` | integer | Pagination offset (default 0) |
| `limit` | integer | Results per page (default 25, max 100) |

See `references/global-analytics-endpoints.md` for full parameter and response details per endpoint.

## Related Skills

- **smartlead-context** - Account configuration and API key setup
- **campaign-analytics** - Single-campaign deep-dive metrics
- **smart-delivery** - Deliverability optimization and warmup
- **email-account-management** - Email account configuration and health
- **client-management** - Client CRUD and assignment
- **campaign-management** - Campaign creation and lifecycle
