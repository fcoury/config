---
name: documentation-pass
description: >-
  Non-functional documentation pass over an existing code change: write PR-level narrative,
  add/clarify module/type/function docs (especially Rust rustdoc), surface implicit
  contracts/invariants, and call out design risks without changing runtime behavior. Use
  when asked for “DOCUMENTATION PASS mode”, “doc pass”, “rustdoc pass”, “comment pass”,
  “make this change legible to reviewers”, or when a PR needs a clearer description
  + in-code documentation but must not alter behavior.
---

# Documentation Pass

Apply a non-functional pass over an existing change to make intent, contracts, and operational understanding explicit to humans while keeping behavior identical.

This skill is for reviewability and long-term maintainability: it turns “the code seems to do X” into explicit prose that explains what X is, why it exists, and what it promises.

## Guardrails

- Do not change runtime behavior.
- Do not refactor logic, reformat broadly, or rename public APIs.
- Do not delete code.
- Prefer documentation comments and small clarifying tests only when they explain intent (usually add none).
- If clarity requires a code change, call it out explicitly but do not implement it.

## Workflow

Follow this sequence; keep edits tightly scoped to docs/comments and PR text.

1. Establish the change boundary.
   Determine what “the existing change” is (PR diff, a branch, a set of files, or a patch). If the boundary is unclear, ask for it before editing.

2. Write the PR-level narrative first.
   Use the template below. Do not walk the diff line-by-line; describe the system and why it changed.

3. Infer intent, then judge implementation against it.
   State the intended design in your own words, then list where the code matches, where it leaks, and what minimal documentation would remove ambiguity.

4. Add or update module-level documentation.
   For each non-trivial module, add a header doc comment that explains the problem, core concepts/terms, responsibilities vs non-responsibilities, lifecycle/state machine (if any), and where invariants are enforced.

5. Add type-level documentation.
   For each public struct/enum/trait/type alias in scope, document role, conceptual meaning, invariants, construction/mutation authority, and concurrency/ownership assumptions.

6. Add function-level documentation.
   For each public function/method in scope, document why it exists, when to use it, assumptions, guarantees, what errors mean, and one realistic misuse case and the bug it would cause.

7. Make implicit contracts explicit.
   List the real contracts introduced or relied upon, and categorize them as: enforced by types, enforced by tests, or only social/tribal knowledge. Recommend where each should be documented (doc comments, module docs, READMEs, runbooks).

8. Write a debug path.
   Describe which components maintain which invariants, where state is cached/synchronized, and what logs/flags/entry points matter for tracing behavior.

9. Propose commit-story improvements (if applicable).
   Rewrite or propose commit messages so each answers: what changed in system behavior, why, and what it enables next. Avoid “refactor/cleanup/minor”.

## Output Templates

### PR Description Template

Produce a PR description that contains these sections with narrative prose:

- Problem
- Mental model
- Non-goals
- Tradeoffs
- Architecture
- Observability
- Tests

### Final Deliverables Checklist

Produce all of the following:

1. Updated PR description (ready to paste).
2. Documentation-only patches (module/type/function docs, with minimal inline comments).
3. A short, blunt list of design inconsistencies or risks discovered.

## Rust Documentation Rules (Apply When Editing Rust)

- The first paragraph of every doc comment is a single-sentence summary.
- Follow with narrative paragraphs; do not invent headings like “Overview” or “Postcondition”.
- Use `# Errors`, `# Panics`, or `# Safety` only when Rustdoc conventions genuinely require them.
- Move architectural/design/invariant commentary into doc comments, not inline comments.
- Keep inline comments local: explain why a branch exists or why a calculation is shaped that way, not system-level truth.

When documenting misuse, write it as a natural warning in prose (not a standalone “Misuse” section) and tie it to a plausible bug a caller would actually hit.
