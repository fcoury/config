---
name: branch-smoke-test
description: Run focused manual smoke tests for a local branch or PR, retain a tmux session and sanitized evidence, and report observed results. Use for feature or regression validation and for smoke-test plans when the user excludes execution.
metadata:
  tested-with: "codex gpt-6.1-terra:low"
  tested-on: "2026-11-08"
---

# Branch smoke test

Execute the smoke and retain its evidence unless the user requests a plan, instructions, static review, or no tests. For those requests, inspect sources and return the concrete plan with no builds, app launches or scenario execution. Use Fish syntax for generated shell code.

1. Check the working tree, branch and HEAD. Use `gh pr view` for PR context and its base. Otherwise use the upstream default branch and state any limitation. Inspect the base-to-head diff and relevant source, tests, docs and user-facing copy.
2. Write a short plan grounded in the changed behavior; save it as `plan.md` for an executed run. Give the prerequisites, exact entry point, commands or interactions, expected result after each action, disposable-state reset, and assumptions. Cover a realistic happy path and a change-specific edge or regression unless the user narrows scope. Include visible copy for UI changes, request/response shapes for APIs, and keys/output for CLIs or TUIs.
3. Verify prerequisites, then run the actual checked-out commit. Prefer observable product behavior over test suites. Build or configure only what the smoke needs. Use automated suites when the user explicitly asks for them. Continue through recoverable setup failures; retain attempts and report any scenarios blocked by access, flags, accounts, hardware, tooling or user-only interactions.
4. Use a unique named tmux session and descriptive windows. Preserve existing sessions. Keep the smoke session, useful processes and windows available for inspection. For browsers or native UIs, use available authorized UI tools and retain the supporting log/app session in tmux. When `CPR_PR` and `CPR_WORKTREE` are set, read [CPR ownership](references/cpr.md) before creating resources. For Codex model smokes, read [Codex launch requirements](references/codex.md).
5. Wait until the shell or UI is ready before input. For interactive TUIs, send text and Enter separately and confirm that the draft renders before submitting. Capture the observable result after each meaningful action.
6. Retain a Git-ignored repository-local evidence directory, or one explicitly approved by the user. Use the repository's established location and identify the PR/branch, date and short SHA. Ensure evidence leaves tracked source intact. Keep sensitive raw data in private temporary storage. Redact credentials, tokens, cookies, authorization headers, private prompts and unrelated user data before writing retained artifacts.
7. Freeze the evidence, then create `SHA256SUMS` covering it with relative paths, excluding the manifest itself. Verify it. Send continuing live logs elsewhere so they cannot invalidate checksums. Clean disposable state that interferes with later work while retaining the smoke session, useful processes and evidence unless the user requests teardown.

The retained bundle must contain `EVIDENCE.md`, `plan.md`, metadata and sanitized captures/transcripts. Record repository/worktree, PR when available, branch, tested HEAD, comparison base, timestamp, environment assumptions, binary/model versions, tmux session/windows and attach command. Generate identifiers and versions from commands and verify recorded HEADs against the tested SHA. For each scenario, link its expected and observed result and mark it passed, failed or blocked.

Before reporting completion, verify the session still exists, the walkthrough is readable, the reported outcomes match the captures and the checksums pass. Lead with the actual outcome and scenario counts, branch/PR, tested commit, attach command and absolute evidence path. Mark prerequisite-blocked scenarios blocked; claim passed only for scenarios whose observed results meet expectations. Include a code review only when requested.
