#!/bin/bash
# Validate all skills in the repository

set -e

SKILLS_DIR="skills"
ERRORS=0
WARNINGS=0

echo "=== Smartlead Skills Validator ==="
echo ""

# Check each skill directory
for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    echo "Checking: $skill_name"

    # Check SKILL.md exists
    if [ ! -f "$skill_file" ]; then
        echo "  ERROR: SKILL.md not found"
        ERRORS=$((ERRORS + 1))
        continue
    fi

    # Check YAML frontmatter exists
    if ! head -1 "$skill_file" | grep -q "^---"; then
        echo "  ERROR: Missing YAML frontmatter"
        ERRORS=$((ERRORS + 1))
    fi

    # Check name field in frontmatter
    if ! grep -q "^name:" "$skill_file"; then
        echo "  ERROR: Missing 'name' in frontmatter"
        ERRORS=$((ERRORS + 1))
    else
        # Validate name matches directory
        yaml_name=$(grep "^name:" "$skill_file" | head -1 | sed 's/name: *//')
        if [ "$yaml_name" != "$skill_name" ]; then
            echo "  ERROR: Frontmatter name '$yaml_name' does not match directory '$skill_name'"
            ERRORS=$((ERRORS + 1))
        fi
    fi

    # Check description field
    if ! grep -q "^description:" "$skill_file"; then
        echo "  ERROR: Missing 'description' in frontmatter"
        ERRORS=$((ERRORS + 1))
    fi

    # Check version field
    if ! grep -q "version:" "$skill_file"; then
        echo "  ERROR: Missing 'version' in frontmatter"
        ERRORS=$((ERRORS + 1))
    fi

    # Check line count
    line_count=$(wc -l < "$skill_file")
    if [ "$line_count" -gt 500 ]; then
        echo "  ERROR: SKILL.md is $line_count lines (max 500)"
        ERRORS=$((ERRORS + 1))
    elif [ "$line_count" -gt 450 ]; then
        echo "  WARNING: SKILL.md is $line_count lines (approaching 500 limit)"
        WARNINGS=$((WARNINGS + 1))
    fi

    # Check naming conventions (lowercase, hyphens, no leading/trailing/consecutive hyphens)
    if ! echo "$skill_name" | grep -qE '^[a-z][a-z0-9]*(-[a-z0-9]+)*$'; then
        echo "  ERROR: Invalid skill name format (must be lowercase a-z, numbers, hyphens)"
        ERRORS=$((ERRORS + 1))
    fi

    # Check for H1 title
    if ! grep -q "^# " "$skill_file"; then
        echo "  WARNING: No H1 title found"
        WARNINGS=$((WARNINGS + 1))
    fi

    # Check references directory
    if [ -d "$skill_dir/references" ]; then
        ref_count=$(find "$skill_dir/references" -name "*.md" | wc -l)
        echo "  OK: $line_count lines, $ref_count reference file(s)"
    else
        echo "  OK: $line_count lines, no references/"
    fi
done

echo ""
echo "=== Validation Complete ==="
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
    echo "FAILED: Fix errors above before publishing."
    exit 1
else
    echo "PASSED: All skills valid."
    exit 0
fi
