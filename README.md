# Smartlead API Skills

Agent skills for the [Smartlead](https://smartlead.ai) cold email outreach platform API. These skills enable AI agents to manage campaigns, leads, email accounts, analytics, and more through the Smartlead API.

## Installation

Clone this repository and point your agent to the skills directory:

```bash
git clone https://github.com/your-org/smartlead-skills.git
```

## Skills

### Core Operations

| Skill | Description |
|---|---|
| **smartlead-context** | Shared authentication, base URL, rate limits, and schemas |
| **campaign-management** | Create, configure, schedule, and manage outreach campaigns |
| **lead-management** | Add, update, pause, resume, delete, and organize leads |
| **email-account-management** | Set up email accounts, configure warmup, manage sending infrastructure |

### Communication

| Skill | Description |
|---|---|
| **master-inbox** | Read and respond to lead conversations, manage tasks and notes |
| **webhook-management** | Set up event-driven webhooks for campaign automation |

### Analytics

| Skill | Description |
|---|---|
| **campaign-analytics** | Per-campaign performance metrics and statistics |
| **global-analytics** | Account-wide reporting, health metrics, and dashboards |

### Infrastructure

| Skill | Description |
|---|---|
| **smart-delivery** | Email deliverability testing, spam checks, authentication monitoring |
| **smart-senders** | Domain purchasing and mailbox auto-generation |

### Administration

| Skill | Description |
|---|---|
| **client-management** | Manage whitelabel clients and sub-accounts |
| **smart-prospect** | Contact search, enrichment, and lead prospecting |

## Architecture

```
                         [smartlead-context]              <- Hub: auth, base URL, rate limits
                        /    |    |    |    \
                       /     |    |    |     \
    [campaign-mgmt] [lead-mgmt] [email-accts] [master-inbox] [campaign-analytics]
            |                                                        |
    [webhook-mgmt]                                            [global-analytics]
    [client-mgmt]      [smart-delivery]   [smart-prospect]  [smart-senders]
```

The `smartlead-context` skill is the hub that provides shared configuration to all other skills.

## Quick Start

1. Get your API key from [Smartlead Settings](https://app.smartlead.ai/app/settings/profile)
2. Set `SMARTLEAD_API_KEY` environment variable
3. Start with `smartlead-context` to understand authentication
4. Use the specific skill for your task

## API Reference

- **Base URL**: `https://server.smartlead.ai/api/v1`
- **Auth**: `?api_key={API_KEY}` query parameter
- **Rate Limit**: 10 requests per 2 seconds
- **Official Docs**: [Smartlead API Reference](https://api.smartlead.ai/reference)

## Validation

Run the validation script to check all skills:

```bash
chmod +x validate-skills.sh
./validate-skills.sh
```

## License

MIT
