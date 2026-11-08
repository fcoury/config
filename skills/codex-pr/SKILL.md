---
name: codex-pr
description: Review and publish an existing Codex change, then babysit its PR or complete stack until current-head CI is green and the review bot approves. Use for delivery through a ready-for-review PR, not description-only updates.
metadata:
  tested-with: "codex gpt-6.1-terra:low"
  tested-on: "2026-11-08"
---

# Codex PR

Preserve the original problem, intended behavior and scope through review, publication, evidence and monitoring. A description-only request does not start this workflow.

## Review and fix

Identify the intended change from the request, branch, commits and complete correct-base diff, including intended uncommitted work. State scope and success criteria before edits.

Use multiple independent, read-only subagents with complementary assignments covering correctness, boundaries and regressions. Give them the actual diff and scope; request evidence, priority, paths and lines. Independently verify and deduplicate their findings.

Apply the same triage to local and published bot findings:

- Fix verified, introduced or materially worsened in-scope problems needed for safe delivery. P0/P1 findings and material correctness, security, compatibility, data-loss or user-facing regressions at any priority are significant; inconvenience does not excuse an in-scope P1.
- Judge P2s by concrete user impact and remedy size/complexity. Fix material, proportionate issues; defer low-impact findings whose remedy would bloat or broaden the PR, explaining why.
- Reject pre-existing problems, unsupported claims and speculative cleanup with a short reason. Keep accepted fixes surgical and run the narrowest meaningful verification.

After new significant findings, review the updated full diff and changed risks with independent read-only subagents again. Repeat until no previously unseen significant finding remains, without recycling rejected or addressed reports. Repeated bot failures in one area call for reassessing the design and a simpler sound in-scope solution; ask before expanding scope.

## Publish and prove

Verify destination repository, base and head. Commit/push intended work only, preserving unrelated edits and repository conventions. Update an existing PR instead of creating a duplicate. Use `gh pr create` or `gh pr edit` with `--title` and a temporary `--body-file` for multiline Markdown.

Write concise problem-first title/notes describing the net change against the actual base. Preserve required templates, attachments and useful context; include a supported issue when available. Omit abandoned approaches and a test-plan/testing-strategy section. Mark ready with `gh pr ready` when needed and verify the state.

Capture Squatch video whenever it can demonstrate relevant behavior. Small changes, refactors and passing tests do not justify skipping it; screenshots only supplement video. Explain a concrete no-visible-benefit exception. Useful video blocked by tools/access/safety is a blocker.

Use the installed `dev-6adb9577b1ac8191ac727ae60c94621f:squatch`, `dev-6adb9577b1ac8191ac727ae60c94621f:edit-squatch-video` and `dev-6adb9577b1ac8191ac727ae60c94621f:format-squatch-evidence` skills for recording, every recording's editing, and PR evidence formatting. Follow their exact-head build, disposable-credential, recording and cleanup requirements. Before any evidence upload/publication, verify the actual destination is private/internal; public or unverifiable visibility blocks required evidence.

For macOS, prefer a suitable local exact-head build; use CI when none exists or it cannot exercise the behavior. Publish polished truthful evidence only to the authorized PR surface. Use before/after only with a meaningful baseline, otherwise after-only. Refresh affected evidence when a later head change invalidates the demonstrated behavior.

## Monitor to the gate

Invoke `$babysit-pr` for each PR, including every stack layer. Own the live monitoring loops and resume immediately after fixes/pushes. Follow its CI diagnosis, flaky-retry limits, Git safety and thread/mutation rules. This workflow authorizes marking ready; other unrelated GitHub mutations and automatic human replies remain unauthorized.

Finish only after a fresh check of every open PR's current head confirms both:

1. All CI is green, with none pending or failing.
2. An actual Codex bot thumbs-up, associated with that head, with no outstanding actionable bot findings.

Inspect reaction data directly and verify bot identity and current-head association using review context. Human approval/reactions, older-head reactions and a quiet watcher do not satisfy this gate. Pushes, rebases and stack updates invalidate affected CI/bot confirmations; require fresh ones.

This gate overrides babysit-pr's normal watch-until-closed rule. Stop each merged/closed PR while continuing the remaining stack. Pending CI/bot review means continue, including before the final handoff. Stop early only for explicit user cancellation or a genuine permission, infrastructure, evidence-safety or scope blocker requiring help; identify which PRs remain incomplete. If the bot withholds approval solely for a reasonably deferred finding, report that scope blocker instead of expanding the PR to earn approval.

Report each PR's URL, final head SHA, CI result, bot-reaction status, and material evidence or deferred findings once the gate is verified.
