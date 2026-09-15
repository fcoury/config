## Email Safety

- Except for the self-email exception below, never send an email without the
  user's explicit, immediate confirmation for that specific message. Present
  the exact recipients, subject, body, and attachments, then wait for
  confirmation to send. If recipients or content (including attachments)
  materially change after approval, obtain renewed confirmation.
- Self-email exception: when the user explicitly asks to send an email to
  themselves (for example, "email me the report" or "send it to me again"),
  that request authorizes preparing and sending the requested message without
  a separate preview or confirmation. This exception applies only when every
  recipient in To, Cc, Bcc, and the actual delivery envelope is one of these
  user-owned addresses:
  - `felipe.coury@gmail.com`
  - `felipe@coury.com.br`
  - `felipe@gistia.com`
  - `felipe.coury@gistia.com`
  - `felipe@galera.com`
  - `felipe.coury@galera.com`
- Match actual email addresses, not display names. An unlisted recipient or a
  mix of self and other recipients requires the normal confirmation above.
- A broad instruction such as "execute the plan" or "handle this end to end"
  authorizes preparing an email draft only; it does not authorize sending it.
  An affirmative reply (including "do it") directly approving the exact
  recipients, subject, body, and attachments just presented authorizes sending
  that specific message.
- Creating or updating a draft alone does not authorize sending it. The
  self-email exception still requires an explicit request to send.

## Engineering Approach

- Complete the requested scope with the simplest clear, correct solution.
  Avoid speculative features, abstractions, configuration, and unrelated
  cleanup. Optimize for maintainability, not minimum line count.
- Inspect the affected flow and relevant callers before editing. Fix the
  cause at the responsible layer; keep investigation and changes proportional
  to the task and expand only when evidence warrants it.
- Reuse suitable project code, standard-library functionality, native features,
  and existing dependencies. Prefer maintained libraries over substantial
  custom implementations when they reduce complexity or risk. Use supported
  extension points before forking or rebuilding.
- For unfamiliar or changed external API usage, verify official guidance
  against the project's installed version. Avoid unrelated dependency upgrades.
- Use existing test conventions. Add focused coverage for changed behavior
  and realistic regressions, proportional to risk. Avoid redundant tests and
  tests that merely repeat implementation details. Run required project checks;
  add further validation when a concrete risk justifies it.
- Preserve security, data integrity, accessibility, and explicit requirements.
  Report the result, relevant validation, and remaining limitations concisely.

## Worktrees / Worktrunk

- Prefer `wt` over raw `git worktree` when isolation benefits the task.
  Reuse a suitable existing worktree; preserve unrelated work.
- Inspect worktrees with `wt list`. Create one with
  `wt switch --create BRANCH --base BASE`; choose the base deliberately.
  Use `wt switch pr:NUMBER` for PR checkout.
- Set subsequent commands' working directory explicitly to the selected
  worktree. Do not assume a shell directory change persists across tool calls.
- Use `wt remove` for authorized cleanup. Use `wt merge` only when local
  integration is intended and consistent with the repository's PR workflow.
  Inspect pending changes and command options before merging.
- Consult `wt COMMAND --help` for details. Fall back to native Git commands
  if Worktrunk is unavailable or unsuitable.

<!-- codealmanac:start -->
## CodeAlmanac

When a repository contains `almanac/`, use its maintained wiki for project
context. Consult it for unfamiliar subsystems, integrations, architectural
choices, cross-cutting behavior, invariants, and history. Skip it for typos,
small styling changes, and mechanical edits in code you already understand.

### Find and read knowledge

Start with `almanac/README.md` when present. Search from the repository root:

- `codealmanac search "concept"`
- `codealmanac search --mentions path/to/source`
- `codealmanac search --topic TOPIC`
- `codealmanac show PAGE`

Use `codealmanac list` to find registered wikis and `--wiki NAME` to select
another wiki. Use command-specific `--help` for additional options. Read
commands refresh the derived index automatically; no separate indexing is needed.
If the CLI is unavailable, read the Markdown directly. If no relevant knowledge
exists, continue with the code; do not invent project history.

### Evidence and citations

Use current code as evidence of existing behavior. Prefer Almanac over ordinary
repository documentation for architectural context. When implementation conflicts
with a documented requirement or invariant, investigate and report the discrepancy
rather than assuming the implementation is correct.

When Almanac contributes to an answer, cite the supporting committed Markdown
page inline, immediately after the claim, using its repository-relative path:
`[Page title](almanac/path/to/page.md)`.

### Maintenance boundary

Treat the wiki as read-only during ordinary coding work. Do not edit its pages,
sources, links, topics, or structure. Wiki maintenance belongs to explicitly
requested CodeAlmanac Init, Ingest, Garden, and Sync workflows.
<!-- codealmanac:end -->
