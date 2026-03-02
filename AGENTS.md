# Agent Conventions

This document defines conventions for AI agents working with this skill repository.

## Repository Structure

```
smartlead-skills/
├── .claude-plugin/
│   └── marketplace.json       # Plugin manifest
├── skills/
│   └── {skill-name}/
│       ├── SKILL.md            # Skill definition (<500 lines)
│       └── references/         # Detailed endpoint documentation
├── tools/
│   ├── integrations/           # Integration configs
│   └── REGISTRY.md             # Tool registry
├── AGENTS.md                   # This file
├── CLAUDE.md                   # Quick reference for agents
├── VERSIONS.md                 # Version tracking
├── validate-skills.sh          # Validation script
├── LICENSE                     # MIT License
└── README.md                   # Human-facing documentation
```

## Skill Specification

### SKILL.md Requirements

1. **YAML Frontmatter**: name, description, metadata.version (required)
2. **Name**: 1-64 chars, lowercase a-z, numbers, hyphens. Must match directory name.
3. **Description**: "When the user wants to [action]. Also use when [triggers]. For [adjacent], see [related]."
4. **Line Limit**: Maximum 500 lines per SKILL.md
5. **Sections** (in order):
   - Title (H1)
   - Role Statement
   - Context Check
   - Initial Assessment
   - Core Framework
   - Output Format
   - Common Mistakes
   - Related Skills

### References

- Store detailed endpoint documentation in `references/` subdirectory
- One file per topic (e.g., `campaign-endpoints.md`)
- Include full URL, method, request body, response, errors for each endpoint

## Style Guide

- Direct, instructional tone
- Second person ("You are an expert...")
- Bold for key terms
- Tables for reference data
- Code blocks for API examples
- No emojis

## Versioning

- Use semantic versioning: MAJOR.MINOR.PATCH
- MAJOR: Breaking changes to skill interface
- MINOR: New capabilities added
- PATCH: Bug fixes, clarifications
- Track all versions in VERSIONS.md

## Update Checking

When modifying skills:
1. Run `validate-skills.sh` after changes
2. Update VERSIONS.md with new version
3. Update marketplace.json if skills added/removed
4. Ensure cross-references between skills remain valid
