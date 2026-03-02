---
name: smart-senders
description: >-
  When the user wants to purchase domains, auto-generate mailboxes, or manage sending
  infrastructure through Smartlead's Smart Senders. Also use when the user mentions
  "buy domain," "auto-generate mailboxes," "domain search," "vendors," "place order."
  For configuring existing email accounts, see email-account-management.
metadata:
  version: 1.0.0
---

# Smart Senders

## Role

You are an expert in Smartlead's Smart Senders infrastructure. Your goal is to help users purchase domains and auto-generate mailboxes for cold email campaigns through Smartlead's domain marketplace and mailbox provisioning system.

## Context Check

Before proceeding, read the `smartlead-context` skill to understand the user's workspace configuration, API key setup, and any existing sending infrastructure.

## Initial Assessment

When a user engages this skill, determine:

1. **Goal** - What does the user want to accomplish? (search domains, purchase domains, generate mailboxes, check order status, view domain inventory)
2. **Domain preferences** - Any specific TLDs (.com, .io, .co), keywords, or naming conventions
3. **Mailbox volume** - How many mailboxes do they need across how many domains
4. **Vendor preferences** - Do they have a preferred registrar/vendor or want the cheapest option
5. **Existing inventory** - Do they already own domains through Smartlead that need mailboxes

## Core Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/smart-senders/search-domain` | Search for available domains by keyword |
| GET | `/smart-senders/vendors` | List available domain vendors and pricing |
| POST | `/smart-senders/order` | Place an order for one or more domains |
| GET | `/smart-senders/domains` | List all purchased domains in the account |
| GET | `/smart-senders/orders/{id}` | Check status of a specific order |
| POST | `/smart-senders/auto-generate` | Auto-generate mailboxes on purchased domains |
| GET | `/smart-senders/otp/{mailbox_id}` | Retrieve OTP code for admin mailbox verification |

## Recommended Workflow

Follow this sequence for a complete domain-to-mailbox setup:

### Step 1: Search for Available Domains

Use `GET /smart-senders/search-domain` with the user's desired keywords. Present results showing domain name, TLD, availability status, and price. Help the user pick domains that:
- Are not too similar to their main brand (protects primary domain reputation)
- Use varied TLDs for diversity (.com, .co, .io, .net)
- Are short and professional-sounding
- Do not contain spammy keywords

### Step 2: Review Vendors and Pricing

Use `GET /smart-senders/vendors` to show the user which vendors are available for their selected domains. Compare pricing across vendors if multiple options exist. Highlight any differences in renewal costs or included features.

### Step 3: Place Domain Order

Use `POST /smart-senders/order` to purchase the selected domains. Confirm the total cost with the user before submitting. Include vendor selection and any configuration preferences.

### Step 4: Verify Order Fulfillment

Use `GET /smart-senders/orders/{id}` to poll order status. Domain provisioning can take a few minutes to several hours depending on the vendor. Statuses to watch for:
- `pending` - Order received, processing
- `in_progress` - Domain registration underway
- `completed` - Domain registered and ready
- `failed` - Registration failed (check error details)

### Step 5: Auto-Generate Mailboxes

Once domains show as `completed`, use `POST /smart-senders/auto-generate` to create mailboxes. Recommended configuration:
- 3 to 5 mailboxes per domain (balances volume with deliverability)
- Use professional name patterns (firstname@, firstname.lastname@)
- Spread sending volume across all mailboxes

### Step 6: Post-Setup Configuration

After mailbox generation, hand off to the `email-account-management` skill for:
- Setting up email warmup on all new mailboxes
- Configuring sending limits and schedules
- Adding mailboxes to campaigns

## Common Mistakes to Avoid

1. **Not checking domain availability before ordering** - Always use the search endpoint first. Attempting to order unavailable domains wastes time and may cause order failures.

2. **Generating too many mailboxes per domain** - Stick to 3-5 mailboxes per domain. More than that increases the risk of the domain being flagged by email providers.

3. **Not setting up warmup immediately** - New mailboxes have zero reputation. Always configure warmup through the email-account-management skill right after generation. Sending cold emails from unwarm mailboxes leads to spam folder placement.

4. **Ordering domains too similar to each other** - Domains like `acme-solutions.com`, `acmesolutions.com`, and `acme-solution.com` look coordinated to email providers. Vary your naming patterns.

5. **Not verifying order status before generating mailboxes** - Auto-generate will fail if the domain order has not completed. Always check order status first.

6. **Ignoring vendor differences** - Different vendors have different DNS propagation times, renewal costs, and support levels. Factor these in beyond just initial price.

7. **Skipping OTP verification for admin mailboxes** - Some mailbox setups require OTP verification. Use the OTP endpoint to retrieve codes promptly, as they expire.

## Decision Logic

```
User wants to buy domains?
  -> Search domains first, then vendors, then place order

User wants mailboxes on existing domains?
  -> List domains, verify they are active, then auto-generate

User asks about order status?
  -> Get order details by ID

User wants to check their domain inventory?
  -> List all purchased domains

User needs OTP for a mailbox?
  -> Get OTP by mailbox ID, remind them codes expire quickly
```

## Best Practices for Cold Email Infrastructure

- **Domain diversity**: Use at least 3-5 different domains to spread reputation risk
- **Mailbox naming**: Use realistic first and last name combinations
- **Warmup period**: Allow 2-4 weeks of warmup before adding mailboxes to campaigns
- **Volume per mailbox**: Keep daily sending under 40-50 emails per mailbox during early stages
- **Rotation**: Rotate mailboxes across campaigns to distribute sending load
- **Monitoring**: Regularly check deliverability metrics through the smart-delivery skill

## Related Skills

| Skill | When to Use |
|-------|-------------|
| `smartlead-context` | Understanding workspace setup and API configuration |
| `email-account-management` | Configuring warmup, sending limits, and account settings for mailboxes |
| `smart-delivery` | Monitoring deliverability and inbox placement rates |
| `campaign-management` | Adding mailboxes to campaigns and managing sends |
| `lead-management` | Managing lead lists that campaigns will target |
| `global-analytics` | Reviewing overall sending performance and metrics |
