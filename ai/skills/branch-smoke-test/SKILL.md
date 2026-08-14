---
name: branch-smoke-test
description: Design and execute focused manual smoke tests for a local branch or GitHub PR, using a retained tmux session and a sanitized evidence bundle. Use when Codex should validate a feature/fix branch, exercise its happy path and a relevant edge or regression case, preserve observable results for a later walkthrough, or provide instructions only when execution is explicitly excluded.
---

# Branch Smoke Test

## Overview

Produce a concise, executable manual smoke-test plan for the branch in front of you, then run it automatically in a named tmux session and retain reviewable evidence. Ground each scenario in the actual diff and PR context. Cover the shortest realistic happy path and at least one meaningful non-happy path unless the user requests a narrower scope.

Execution and evidence retention are the default, not a separate follow-up request. If the user asks for instructions only, a plan only, static review, or explicitly says not to run tests, stop after producing the requested plan and do not execute anything.

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

5. Prefer interactive, observable product behavior over automated test commands. Run only the setup/build commands needed to exercise the app or tool. Do not substitute cargo/npm/pytest test suites for the smoke test unless the user explicitly asks for automated validation.

6. Unless execution is explicitly excluded, verify prerequisites, execute the planned scenarios in tmux, and preserve the session and evidence as described below. Continue through recoverable setup and execution failures when doing so is within the user's authorization; clearly report any remaining blocker.

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

## Execute in tmux

1. Confirm `tmux` is available. Choose a descriptive, collision-free session name based on the PR number or branch, such as `pr4170-cd-smoke`. Preserve any existing session; never replace or kill someone else's tmux session.

2. Create a durable, repository-local evidence directory that is ignored by Git or otherwise explicitly approved. Prefer the repository's established evidence location, such as `target/manual-smoke/<run-id>/` or `personal/smoke-evidence/<run-id>/`. Use the PR/branch, date, and short commit SHA in the run ID. Verify generated evidence does not unexpectedly dirty tracked files. Temporary directories can hold sensitive raw logs but are not the retained evidence location.

3. Start the relevant app, service, CLI, or TUI in named tmux windows. Keep useful processes and the tmux session available after the smoke run so the user can attach and inspect them later. When a browser or native UI is required, use available authorized UI tooling for the interaction and retain its supporting app/log session in tmux.

4. For newer-model Codex CLI/TUI smoke tests, build both binaries from `codex-rs` before launch:

   ```fish
   cargo build -p codex-cli --bin codex
   cargo build -p codex-code-mode-host --bin codex-code-mode-host
   test -x target/debug/codex
   test -x target/debug/codex-code-mode-host
   ```

   `just c`, `just codex`, and `cargo run --bin codex` do not build the companion host automatically. If a rusty_v8 archive returns HTTP 404, use `scripts/codex_package/v8.py` to obtain checksum-verified Codex release artifacts and set `RUSTY_V8_ARCHIVE` and `RUSTY_V8_SRC_BINDING_PATH`. Never silently substitute an older direct-tool model when validating newer-model behavior.

5. Run the happy path and requested edge/regression scenarios against the actual checked-out commit. Wait for the shell or UI to become ready before sending input. For interactive TUIs, send text and Enter separately, waiting until the draft is visibly rendered before submitting. Capture the observable result after each meaningful action.

6. If required access, feature flags, accounts, platform hardware, UI tooling, or user-only interactions are unavailable, preserve the setup attempts and explain exactly which scenarios could not run. Never describe an unexecuted scenario as passed, and never replace the requested behavior with an unrelated test suite.

7. Clean up only disposable fixtures and state that would interfere with subsequent work. Preserve the tmux session, named windows, useful running processes, and finalized evidence bundle unless the user requests otherwise.

## Preserve walkthrough evidence

Retain enough sanitized material that the user can inspect each result later without rerunning the scenario:

- `EVIDENCE.md`: a walkthrough index containing branch/PR, exact commit, comparison base, environment assumptions, session name, attach command, scenarios, expected versus observed results, pass/fail/blocked status, and links to captures.
- `plan.md`: the concrete human-readable smoke-test steps.
- `metadata.json` or equivalent: timestamp, repository/worktree, branch, PR URL when available, exact HEAD, comparison base, tmux session/windows, and relevant binary/model versions.
- Sanitized pane captures, command/output transcripts, screenshots when relevant, and verifier output or a concise results table.
- `SHA256SUMS` for the frozen retained artifacts. Exclude the checksum file itself, then verify the manifest with `shasum -a 256 -c SHA256SUMS` or the platform's equivalent.

Capture tmux panes after each meaningful scenario and preserve their descriptive filenames. Redact credentials, API tokens, cookies, authorization headers, private prompts, and unrelated user data before writing retained files; keep any necessary sensitive raw traces in private temporary storage only. Freeze retained artifacts before generating checksums, and send continuing live logs elsewhere so later writes do not invalidate the manifest.

Before reporting completion, confirm the tmux session still exists, `EVIDENCE.md` is readable, the reported scenario results match observable captures, and all retained checksums verify. If a prerequisite prevents execution, return the plan, any evidence already collected, and the concrete blocker instead of claiming a successful smoke run.

## Output Format

For the retained `plan.md`, or for the final response when the user explicitly requests instructions only, use this structure:

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

- <reset disposable state or seed data; preserve the smoke tmux session and useful running services>

**Notes / Risks**

- <assumptions, missing context, or extra scenario worth testing if time allows>
```

After an executed run, keep the final answer focused on the actual outcome:

```markdown
**Smoke test:** <passed/failed/blocked; scenario counts>
**Branch/PR:** <branch and PR URL if available>
**Commit:** <exact tested SHA>
**tmux:** `tmux attach -t <session-name>`
**Evidence:** `<absolute path to EVIDENCE.md>`

- <happy-path observed result>
- <edge/regression observed result or explicit blocker>
```

Do not include a broad code review unless the user also asks for one.
