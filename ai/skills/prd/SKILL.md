---
name: prd
description: Generate structured PRDs optimized for AI coding agents, with machine-readable prd.json output. Supports creating new PRDs and importing existing ones.
---

# PRD Skill

Generate Product Requirements Documents optimized for autonomous AI agent execution. Produces both a human-readable markdown PRD and a machine-readable `prd.json` for agent loops.

## Modes

This skill operates in two modes based on `$ARGUMENTS`:

- **Create Mode** (default): `/prd <feature-name>` — build a new PRD from scratch
- **Import Mode**: `/prd import <path>` — convert an existing markdown PRD into `prd.json`

---

## Create Mode

### Phase 1: Discovery

Before writing anything, ask 4-6 targeted discovery questions to understand scope. Use lettered options for quick answers.

**Required questions (adapt wording to context):**

1. **Who is the primary user?**
   - a) End users / customers
   - b) Internal team / admins
   - c) API consumers / developers
   - d) Other (describe)

2. **What problem does this solve?** (open-ended, 1-2 sentences)

3. **What does success look like?**
   - a) Specific metric improvement (describe)
   - b) New capability that doesn't exist yet
   - c) Replace/improve existing workflow
   - d) Other (describe)

4. **What's the scope?**
   - a) Small — single component, < 1 day
   - b) Medium — multiple components, 1-3 days
   - c) Large — cross-cutting, 3-7 days
   - d) XL — multi-system, 1-2 weeks

5. **Are there areas of the codebase that must NOT be changed?** (open-ended)

6. **Any technical constraints or preferences?** (open-ended, optional)

Wait for answers before proceeding.

### Phase 2: Research

After discovery answers are received:

1. Read the project's `CLAUDE.md` (if it exists) to understand coding conventions
2. Scan the relevant parts of the codebase to understand existing architecture
3. Check for existing PRDs or docs in `tasks/` directory
4. Note any patterns, frameworks, or conventions that the PRD must respect

### Phase 3: Generate PRD

Read the template from `~/.claude/skills/prd/references/prd-template.md` and generate the PRD markdown file.

**Output location:** `tasks/prd-<feature-name>.md`

Rules for generating the PRD:
- Every user story must be **atomic** — one requirement per story, never bundled
- Acceptance criteria must be **testable** — discrete checks an agent can verify programmatically
- Use the three-tier boundary system: "Always do" / "Ask first" / "Never change"
- Include complexity estimates (S/M/L/XL) for each user story
- Number functional requirements as FR-1, FR-2, etc.
- Keep language precise and unambiguous — agents cannot ask clarifying questions mid-task

### Phase 4: Generate prd.json

Read the schema from `~/.claude/skills/prd/references/prd-json-schema.md` and generate a valid `prd.json` file in the project root.

Extract user stories from the markdown PRD and structure them per the schema. Each user story becomes an entry in the `userStories` array with:
- Unique ID (US-001, US-002, ...)
- Priority derived from the PRD ordering (1 = highest)
- `passes: false` initially for all stories
- Complexity matching the PRD estimates

### Phase 5: Validation

Run through this checklist before presenting results:

- [ ] Every user story has at least one acceptance criterion
- [ ] No user story bundles multiple requirements
- [ ] Acceptance criteria are binary (pass/fail), not subjective
- [ ] "DO NOT CHANGE" boundaries are explicitly listed
- [ ] Functional requirements are numbered sequentially
- [ ] prd.json is valid JSON and matches the schema
- [ ] prd.json user stories match the markdown PRD exactly
- [ ] Success metrics are measurable (not vague like "improve UX")
- [ ] Open questions are captured (not silently ignored)

Report the validation results to the user.

---

## Import Mode

When invoked as `/prd import <path>`:

### Step 1: Read

Read the file at the given path. If the file doesn't exist, report the error and stop.

### Step 2: Extract

Parse the existing PRD and extract:
- Project/feature name (from title or first heading)
- Description (from intro or problem statement)
- User stories (look for "As a..." patterns, numbered requirements, or bullet lists describing functionality)
- Acceptance criteria (look for checkboxes, "should" statements, or criteria lists)
- Priority (from ordering, explicit priority labels, or MoSCoW notation)
- Complexity estimates (if present, otherwise default to "M")

### Step 3: Generate prd.json

Create `prd.json` using the extracted data, following the schema in `~/.claude/skills/prd/references/prd-json-schema.md`.

### Step 4: Gap Report

Report to the user:
- How many user stories were extracted
- Any stories that lack acceptance criteria (flag these)
- Any ambiguous requirements that couldn't be cleanly mapped
- Suggestions for improving the source PRD for agent consumption

---

## Output Summary

After either mode completes, present a summary:

```
PRD Generated:
  Markdown: tasks/prd-<feature>.md (Create mode only)
  JSON:     prd.json
  Stories:  <N> user stories extracted
  Gaps:     <N> stories missing acceptance criteria

Next steps:
  1. Review the PRD and prd.json for accuracy
  2. Run your agent loop against prd.json
  3. Stories are ordered by priority — work top to bottom
```
