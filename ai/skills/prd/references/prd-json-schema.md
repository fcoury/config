# prd.json Schema Reference

The `prd.json` file is the machine-readable companion to the markdown PRD. It enables autonomous agent loops to track progress through user stories.

## Schema

```json
{
  "project": "feature-name",
  "branch": "feature/feature-name",
  "description": "One-line summary of the feature",
  "createdAt": "2025-01-15T10:00:00Z",
  "sourceDocument": "tasks/prd-feature-name.md",
  "userStories": [
    {
      "id": "US-001",
      "title": "Short descriptive title",
      "description": "As a <user>, I want <action>, so that <benefit>.",
      "acceptanceCriteria": [
        "Criterion 1 — binary pass/fail statement",
        "Criterion 2 — another testable condition"
      ],
      "priority": 1,
      "passes": false,
      "complexity": "M",
      "notes": "",
      "dependsOn": []
    }
  ]
}
```

## Field Definitions

### Top-level fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `project` | string | yes | Kebab-case feature name (e.g., `"user-auth"`) |
| `branch` | string | yes | Suggested git branch name (`"feature/<project>"`) |
| `description` | string | yes | One-line summary, max 120 chars |
| `createdAt` | string | yes | ISO 8601 timestamp of generation |
| `sourceDocument` | string | yes | Path to the markdown PRD file |
| `userStories` | array | yes | Array of user story objects |

### User story fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | yes | Unique ID in format `US-NNN` (zero-padded to 3 digits) |
| `title` | string | yes | Short title, max 80 chars |
| `description` | string | yes | Full "As a... I want... so that..." statement |
| `acceptanceCriteria` | string[] | yes | Array of testable criteria (min 1) |
| `priority` | number | yes | 1-5 where 1 is highest priority |
| `passes` | boolean | yes | Whether the story's criteria are met. Always `false` initially |
| `complexity` | string | yes | One of: `"S"`, `"M"`, `"L"`, `"XL"` |
| `notes` | string | no | Implementation notes, empty string if none |
| `dependsOn` | string[] | no | Array of US-IDs this story depends on |

## Rules

1. **IDs are sequential**: US-001, US-002, US-003... no gaps
2. **Priority matches PRD**: Stories listed first in the PRD get lower priority numbers (higher priority)
3. **All stories start with `passes: false`**: The agent loop flips these to `true` as criteria are met
4. **Acceptance criteria are plain strings**: No markdown, no checkboxes — just the text of each criterion
5. **One story per requirement**: Never combine multiple requirements into one story
6. **dependsOn is optional**: Only include if there's a genuine implementation dependency

## Example

```json
{
  "project": "search-filters",
  "branch": "feature/search-filters",
  "description": "Add advanced filtering to the product search page",
  "createdAt": "2025-01-15T10:30:00Z",
  "sourceDocument": "tasks/prd-search-filters.md",
  "userStories": [
    {
      "id": "US-001",
      "title": "Filter by price range",
      "description": "As a shopper, I want to filter products by price range, so that I only see items within my budget.",
      "acceptanceCriteria": [
        "A price range slider appears in the filter sidebar",
        "Setting min/max values updates the product list without page reload",
        "The URL updates with price query params for shareable links",
        "Clearing the filter restores the full product list"
      ],
      "priority": 1,
      "passes": false,
      "complexity": "M",
      "notes": "Use existing RangeSlider component from src/components/ui/",
      "dependsOn": []
    },
    {
      "id": "US-002",
      "title": "Filter by category",
      "description": "As a shopper, I want to filter products by category, so that I can narrow results to relevant items.",
      "acceptanceCriteria": [
        "Category checkboxes appear in the filter sidebar",
        "Multiple categories can be selected simultaneously",
        "Selected categories persist across page navigation",
        "Category counts show number of matching products"
      ],
      "priority": 2,
      "passes": false,
      "complexity": "S",
      "notes": "",
      "dependsOn": []
    },
    {
      "id": "US-003",
      "title": "Combine multiple filters",
      "description": "As a shopper, I want to apply multiple filters at once, so that I can narrow results precisely.",
      "acceptanceCriteria": [
        "Price and category filters can be active simultaneously",
        "An active filter summary shows all applied filters",
        "A 'Clear all filters' button resets everything",
        "Filter combinations that yield zero results show an empty state message"
      ],
      "priority": 3,
      "passes": false,
      "complexity": "M",
      "notes": "Depends on both filter types being implemented first",
      "dependsOn": ["US-001", "US-002"]
    }
  ]
}
```

## Agent Loop Integration

An agent consuming `prd.json` should:

1. Read the file and sort stories by `priority`
2. Check `dependsOn` — skip stories whose dependencies haven't passed yet
3. Pick the highest-priority story where `passes` is `false`
4. Implement the story, verifying each acceptance criterion
5. Set `passes: true` and write the file back
6. Repeat until all stories pass
