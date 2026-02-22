# PRD Template Reference

Use this template when generating PRDs in Create mode. Replace all `<placeholders>` with actual content. Remove any sections that don't apply, but keep the numbering consistent.

---

# PRD: <Feature Name>

**Author:** AI-generated via `/prd` skill
**Date:** <YYYY-MM-DD>
**Status:** Draft

---

## 1. Problem Statement & Business Impact

<2-3 sentences describing the problem this feature solves. Be specific about who is affected and what the cost of not solving it is.>

**Business impact:** <Quantify if possible: time saved, revenue impact, user retention, etc.>

---

## 2. Goals & Success Metrics

| Goal | Metric | Target | How to Measure |
|------|--------|--------|----------------|
| <Goal 1> | <Metric> | <Specific target> | <Measurement method> |
| <Goal 2> | <Metric> | <Specific target> | <Measurement method> |

All metrics must be SMART: Specific, Measurable, Achievable, Relevant, Time-bound.

---

## 3. User Stories

Each story is atomic — one requirement only. Format:

### US-001: <Title>

**As a** <user type>, **I want** <action>, **so that** <benefit>.

**Acceptance Criteria:**
- [ ] <Testable criterion 1 — binary pass/fail>
- [ ] <Testable criterion 2>

**Priority:** <1-5, where 1 is highest>
**Complexity:** <S | M | L | XL>

---

### US-002: <Title>

**As a** <user type>, **I want** <action>, **so that** <benefit>.

**Acceptance Criteria:**
- [ ] <Criterion>

**Priority:** <1-5>
**Complexity:** <S | M | L | XL>

<!-- Repeat for each user story. Keep stories atomic. -->

---

## 4. Functional Requirements

Numbered requirements that map to user stories.

| ID | Requirement | Maps to |
|----|-------------|---------|
| FR-1 | <Specific functional requirement> | US-001 |
| FR-2 | <Specific functional requirement> | US-002 |
| FR-3 | <Specific functional requirement> | US-001, US-003 |

---

## 5. Non-Goals / Out of Scope

Explicitly state what this feature does NOT do. This prevents scope creep during agent execution.

- <Thing that might seem in scope but isn't>
- <Thing that's a future enhancement, not part of this PRD>
- <Thing that's handled by a different system>

---

## 6. Technical Considerations

### Architecture

<How this fits into the existing system. Reference specific files, modules, or services.>

### API Changes

<New endpoints, modified endpoints, or "No API changes required.">

### Data Model

<New tables/columns, schema changes, or "No data model changes required.">

### Dependencies

<External libraries, services, or systems this depends on.>

---

## 7. Boundaries

### Always Do
<Things the agent must always do during implementation.>
- <e.g., "Write tests for all new public functions">
- <e.g., "Follow existing naming conventions in src/models/">

### Ask First
<Things the agent should check with the user before doing.>
- <e.g., "Before modifying the database schema">
- <e.g., "Before adding new dependencies">

### Never Change
<Files, modules, or patterns that must not be modified.>
- <e.g., "Do not modify src/auth/oauth.rs — it's stable and audited">
- <e.g., "Do not change the public API contract for /api/v1/*">

---

## 8. Task Breakdown Hints

Suggested implementation order. The agent should follow this sequence unless there's a good reason to deviate.

| Order | Task | Depends On | Complexity | Notes |
|-------|------|------------|------------|-------|
| 1 | <First task to implement> | — | S | <Any notes> |
| 2 | <Second task> | Task 1 | M | <Any notes> |
| 3 | <Third task> | Task 1 | L | <Any notes> |

---

## 9. Open Questions

Unresolved items that need human input before or during implementation.

- [ ] <Question 1>
- [ ] <Question 2>

---

*This PRD pairs with `prd.json` for machine-readable agent execution. The PRD is the "what", `CLAUDE.md` is the "how".*
