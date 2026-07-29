---
name: branch-smoke-test
description: Create manual smoke-test instructions for a local branch or GitHub PR. Use when Codex is on a feature/fix branch, usually with a PR attached, and the user wants clear steps a human can execute to validate the happy path plus at least one non-happy path or regression scenario for the change.
---

# Branch Smoke Test

## Overview

Produce a concise, executable manual smoke-test plan for the branch in front of you. Ground the plan in the actual diff and PR context, then describe the shortest realistic happy path and at least one meaningful non-happy path.

If generating shell code, tailor it for Fish shell.

## Workflow

1. Identify the branch and working tree state:

   ```bash
   git status --short
   git branch --show-current
   git remote -v
   ```

2. Find the PR when available:

   ```bash
   gh pr view --json number,title,url,baseRefName,headRefName,body
   ```

   If there is no PR or `gh` is unavailable, continue from the local branch. State the limitation.

3. Determine the comparison base:
   - Prefer the PR base branch from `gh pr view`.
   - Otherwise use the upstream default branch, commonly `origin/main`.
   - Inspect the diff with `git diff --stat <base>...HEAD` and targeted `git diff <base>...HEAD -- <paths>`.

4. Read the changed files, tests, docs, and any user-facing copy touched by the branch. Identify:
   - the behavior the branch adds, fixes, removes, or protects;
   - the smallest realistic end-to-end path that exercises that behavior;
   - one or more failure, cancellation, invalid-input, disabled-state, missing-permission, empty-state, or regression paths that the diff could plausibly break.

5. Prefer manual steps over automated test commands. Only include setup commands needed for a human to run the app or tool locally. Do not present cargo/npm/pytest test suites as the smoke test unless the user explicitly asks for automated validation.

## Smoke-Test Design

Make every scenario concrete enough that another person can execute it without rediscovering intent from the diff.

- Include exact commands, URLs, feature flags, config snippets, UI navigation, terminal keystrokes, or sample inputs when the repo reveals them.
- State expected results after each meaningful action, not only at the end.
- Keep the happy path short and representative.
- Choose a non-happy path that is specific to the changed behavior. Avoid generic "try invalid input" unless the diff actually changes invalid-input handling.
- Include cleanup/reset steps when the scenario creates local state, files, database rows, config, or sessions.
- Call out any assumptions or missing information instead of inventing product details.
- If the diff changes user-facing text or UI, include what the human should visibly see.
- If the diff changes API behavior, include request shape, response expectations, and one error/status case.
- If the diff changes CLI/TUI behavior, include exact command, relevant key sequence, visible output, and exit/reset behavior.

## Output Format

Use this structure:

```markdown
**Scope**
Branch/PR: <branch name and PR URL if available>
Base: <base ref or limitation>
Change under test: <one-sentence behavior summary>

**Prerequisites**

- <required local app/tool setup>
- <seed data/account/config/feature flag if needed>

**Happy Path**

1. <action>
   Expected: <observable result>
2. <action>
   Expected: <observable result>

**Non-Happy Path**

1. <action that exercises a realistic failure/edge/regression case>
   Expected: <observable result>
2. <action>
   Expected: <observable result>

**Cleanup**

- <reset local state, revert config, stop servers, delete seed data>

**Notes / Risks**

- <assumptions, missing context, or extra scenario worth testing if time allows>
```

Keep the final answer focused on the smoke-test steps. Do not include a broad code review unless the user also asks for one.
