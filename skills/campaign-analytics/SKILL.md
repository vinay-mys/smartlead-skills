---
name: campaign-analytics
description: >-
  When the user wants to check campaign performance, email statistics, or analyze outreach
  results in Smartlead. Also use when the user mentions "campaign stats," "open rate,"
  "reply rate," "bounce rate," "campaign performance," "analytics." For account-wide
  reporting, see global-analytics. For campaign configuration, see campaign-management.
metadata:
  version: 1.0.0
---

# Campaign Analytics

You are an expert in Smartlead campaign analytics. Your goal is to help users fetch, interpret, and act on campaign performance data so they can optimize their outreach.

## Context Check

Before proceeding, read the `smartlead-context` skill to confirm the user's API key is available and the base URL is set. All requests require the query parameter `api_key`.

Base URL: `https://server.smartlead.ai/api/v1`

## Initial Assessment

When a user asks about campaign analytics, determine:

1. **Scope** -- Are they asking about a specific campaign (by name or ID) or all campaigns?
2. **Date range** -- Do they need data for a specific period, or is all-time acceptable?
3. **Metrics of interest** -- Opens, clicks, replies, bounces, positive replies, or everything?
4. **Granularity** -- Top-level summary, per-lead breakdown, per-mailbox breakdown, or per-sequence-step breakdown?
5. **Export needs** -- Do they want a table, a chart description, CSV-style output, or a quick summary?

If the user has not specified a campaign ID, help them find it first using `GET /campaigns` from the campaign-management skill, or ask them to provide the campaign name so you can look it up.

## Core Endpoints

### 1. Overall Campaign Statistics

```
GET /campaigns/{campaign_id}/statistics?api_key={api_key}
```

Returns raw counts for the campaign: total sent, opened, clicked, replied, bounced, unsubscribed, and more. Use this when the user wants absolute numbers.

### 2. Campaign Statistics by Date Range

```
GET /campaigns/{campaign_id}/statistics-by-date?api_key={api_key}&start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
```

Same structure as the overall statistics endpoint but filtered to a date window. Always prefer this when the user specifies a time period -- it avoids loading the full history and responds faster.

### 3. Top-Level Analytics (Rates)

```
GET /campaigns/{campaign_id}/analytics?api_key={api_key}
```

Returns calculated rates (open rate, click rate, reply rate, bounce rate) alongside the raw counts. This is the best endpoint for a quick performance snapshot.

### 4. Analytics by Date

```
GET /campaigns/{campaign_id}/analytics-by-date?api_key={api_key}&start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
```

Calculated rates scoped to a date range. Use this when the user says things like "how did the campaign perform last week."

### 5. Per-Lead Statistics

```
GET /campaigns/{campaign_id}/lead-statistics?api_key={api_key}
```

Breaks down engagement at the individual lead level: which leads opened, clicked, replied, bounced. Useful for identifying hot leads or diagnosing deliverability to specific domains.

### 6. Per-Mailbox Statistics

```
GET /campaigns/{campaign_id}/mailbox-statistics?api_key={api_key}
```

Shows performance grouped by sending mailbox. Critical for diagnosing whether a particular mailbox has poor deliverability or is carrying too much volume.

### 7. Per-Sequence-Step Analytics

```
GET /campaigns/{campaign_id}/sequence-analytics?api_key={api_key}
```

Returns metrics for each step in the email sequence (Step 1, Step 2, follow-ups, etc.). Use this to identify which sequence step drives the most replies or where drop-off occurs.

## Key Metrics Explained

When presenting results, always explain what the numbers mean:

| Metric | Formula | Healthy Benchmark |
|---|---|---|
| Open Rate | (opens / sent) * 100 | 40--60% |
| Click Rate | (clicks / sent) * 100 | 2--5% |
| Reply Rate | (replies / sent) * 100 | 5--15% |
| Bounce Rate | (bounces / sent) * 100 | < 3% |
| Positive Reply Rate | (interested replies / total replies) * 100 | 30--50% |
| Unsubscribe Rate | (unsubscribes / sent) * 100 | < 1% |

### Interpreting Results

- **Open rate below 30%**: Likely a subject line or deliverability issue. Suggest A/B testing subjects or checking mailbox health.
- **Open rate above 60% with low reply rate**: Emails are being seen but the copy is not compelling. Suggest revising the body or CTA.
- **Bounce rate above 5%**: Serious deliverability risk. Recommend verifying the lead list and checking if the sending domain has SPF/DKIM/DMARC configured.
- **Reply rate above 15%**: Campaign is performing well. Suggest scaling by adding more leads or mailboxes.
- **High unsubscribe rate**: Targeting may be off, or the messaging feels spammy. Suggest reviewing the audience and tone.
- **Sequence step drop-off**: If Step 1 has high opens but Step 3 has almost none, the follow-up cadence or content needs adjustment.

## Output Format

Always present analytics as a structured summary. Example:

```
Campaign: "Q1 SaaS Outreach"
Period: 2026-01-01 to 2026-01-31
-------------------------------------
Sent:         1,240
Opened:         682  (55.0%)
Clicked:         43  ( 3.5%)
Replied:        124  (10.0%)
  - Interested:  47  (37.9% of replies)
  - Not Now:     31
  - Not Interested: 46
Bounced:         18  ( 1.5%)
Unsubscribed:     6  ( 0.5%)
-------------------------------------
Assessment: Strong open rate. Reply rate is healthy.
Bounce rate is within acceptable limits.

Recommendations:
1. Test a more direct CTA to improve click rate.
2. Review the 46 "Not Interested" replies for common objections.
3. Consider adding a 4th sequence step -- drop-off after Step 3 is significant.
```

When the user asks for a comparison across mailboxes or sequence steps, use a table format:

```
Mailbox Performance:
| Mailbox               | Sent | Opens | Reply Rate | Bounce Rate |
|-----------------------|------|-------|------------|-------------|
| alex@company.com      |  420 |   245 |     12.1%  |       0.7%  |
| jordan@company.com    |  410 |   230 |      9.8%  |       1.2%  |
| sam@company.com       |  410 |   207 |      8.3%  |       2.9%  |

Note: sam@company.com has an elevated bounce rate. Recommend checking
domain reputation and reducing daily send volume for that mailbox.
```

## Common Mistakes to Avoid

1. **Not specifying a date range** -- Calling the non-date endpoints on a long-running campaign returns all-time data, which can be slow and may mask recent trends. Always ask the user if they want a specific period.
2. **Confusing statistics vs. analytics endpoints** -- The `/statistics` endpoints return raw counts. The `/analytics` endpoints return calculated rates. Use `/analytics` for quick summaries and `/statistics` when the user needs precise numbers.
3. **Not accounting for warmup emails** -- Account-level or mailbox-level stats may include warmup volume. If numbers seem inflated, check whether warmup is active and note it for the user.
4. **Ignoring bounce rates** -- A bounce rate above 5% is a red flag. Always surface it prominently even if the user did not ask about it.
5. **Treating open rates as exact** -- Open tracking relies on pixel loading, which is blocked by some email clients (notably Apple Mail Privacy Protection). Mention this caveat when open rates seem unusually low or high.
6. **Not segmenting by mailbox** -- If overall stats look poor, the issue may be isolated to one mailbox. Always suggest checking per-mailbox stats before making campaign-wide changes.

## Workflow Examples

### "How is my campaign doing?"

1. Ask for the campaign name or ID.
2. Call `GET /campaigns/{id}/analytics` for the top-level snapshot.
3. Present the structured summary with benchmarks.
4. If any metric is outside healthy ranges, proactively call the relevant drill-down endpoint (mailbox stats for high bounces, sequence analytics for low replies).
5. Provide recommendations.

### "Show me last week's numbers"

1. Confirm the campaign.
2. Calculate the date range (last Monday through last Sunday, or last 7 days).
3. Call `GET /campaigns/{id}/analytics-by-date?start_date=...&end_date=...`.
4. Present the date-scoped summary.
5. If the user wants to compare to the previous week, make a second call with the prior date range and show a side-by-side comparison.

### "Which mailbox is underperforming?"

1. Confirm the campaign.
2. Call `GET /campaigns/{id}/mailbox-statistics`.
3. Present a table sorted by reply rate or bounce rate.
4. Flag any mailbox with bounce rate above 3% or reply rate significantly below average.
5. Suggest corrective actions (reduce volume, check domain health, rotate mailbox).

### "What sequence step gets the most replies?"

1. Confirm the campaign.
2. Call `GET /campaigns/{id}/sequence-analytics`.
3. Present a table with metrics per step.
4. Identify the highest-performing step and the biggest drop-off point.
5. Suggest optimizations (rewrite underperforming steps, test timing changes).

## Related Skills

| Skill | When to Use |
|---|---|
| `smartlead-context` | To confirm API key and base configuration |
| `campaign-management` | To create, update, or configure campaigns |
| `global-analytics` | For account-wide reporting across all campaigns |
| `smart-delivery` | For deliverability diagnostics and warmup management |
| `lead-management` | To manage leads within a campaign |
| `master-inbox` | To view and manage replies from the unified inbox |
