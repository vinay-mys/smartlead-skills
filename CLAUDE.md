# Smartlead Skills for Claude

This repository contains agent skills for the Smartlead cold email outreach API.

## Quick Start

1. All API calls use base URL: `https://server.smartlead.ai/api/v1`
2. Authentication: `?api_key={API_KEY}` query parameter on every request
3. Rate limit: 10 requests per 2 seconds

## Skill Architecture

The `smartlead-context` skill is the hub. Always read it first for shared auth, schemas, and patterns. Then use the specific task skill.

## Conventions

- All skill names use lowercase-kebab-case
- Each SKILL.md is under 500 lines
- Detailed endpoint docs live in `references/` subdirectories
- Semantic versioning for all skills (MAJOR.MINOR.PATCH)

## Key Patterns

- POST for create/update operations
- GET for fetch/list operations
- DELETE for removal operations
- Most list endpoints support `?offset=0&limit=100` pagination
- Many endpoints accept optional `client_id` for agency/whitelabel scoping
- Standard success: `{"ok": true}`
- Standard error: `{"error": "description"}`
