# Durable state and response forms

## Run directory

Use:

```text
${CODEX_HOME:-$HOME/.codex}/walkthroughs/<host>/<owner>/<repo>/pr-<number>-<source-head-short>/
```

Required layout:

```text
manifest.json
state.md
source.patch
plan.md
reconciliation.md                 # created at final reconciliation
steps/
  01-<slug>/
    proposed.patch
    review.md
    completion.md                 # created only after commit
```

Keep superseded proposals with a numeric suffix rather than overwriting them.

## Manifest

`manifest.json` is the machine-readable source of truth. Keep at least:

```json
{
  "schema_version": 1,
  "run_id": "<stable-id>",
  "pr": {
    "url": "https://github.com/<owner>/<repo>/pull/<number>",
    "number": 123,
    "head_repo": "<owner>/<repo>",
    "head_remote": "<git-remote-name>",
    "head_remote_url": "<exact-remote-url>",
    "head_ref": "<branch-name>",
    "base_ref": "<base-branch>",
    "source_base_sha": "<full-sha>",
    "original_head_sha": "<full-sha>"
  },
  "target": {
    "base_sha": "<full-sha>",
    "worktree": "<absolute-path>",
    "repository_admin_worktree": "<absolute-path-to-a-preserved-worktree>",
    "branch": "<temporary-branch>",
    "rebuilt_sha": null
  },
  "fidelity_mode": "source-faithful | review-led",
  "plan": [],
  "current_step": {
    "id": null,
    "status": null,
    "target_head": null,
    "patch_path": null,
    "patch_sha256": null,
    "approved_patch_sha256": null
  },
  "reconciliation": {
    "complete": false,
    "path": null,
    "deviations": []
  },
  "dependencies": {
    "dependent_prs": [],
    "impact_reviewed": false
  },
  "finalization": {
    "decision": null,
    "original_checkout_acknowledged": false,
    "backup_ref": null,
    "phase": "not_started",
    "backup_verified_sha": null,
    "remote_verified_sha": null,
    "pr_verified_sha": null,
    "last_error": null
  }
}
```

The helper may add timestamped checkpoint fields. Update JSON atomically. `state.md` is the concise human-readable resume point and should identify the pending decision or exact safe next action.

## Initial plan response

```markdown
### Reconstruction plan

- PR: <link>
- Source: `<base-sha>..<head-sha>`
- Target: `<target-base-sha>` -> `<temporary-branch>`
- Fidelity: **Source-faithful | Review-led**
- Durable state: [state.md](/absolute/path/state.md)

1. **<step>** - <purpose and recommendation>
2. **<step>** - <purpose and recommendation>

No source changes have been applied. Approve or revise this sequence.
```

## Per-step proposal

Do not include the complete diff inline.

```markdown
### Step <n>/<total>: <name>

Recommendation: **Keep | Simplify | Rewrite | Skip**

<Short explanation of the conceptual boundary and why this is the recommendation.>

- Fidelity: <faithful port | context port | deliberate rewrite | proposed omission>
- Source scope: <commit/files/change group>
- Proposed churn: <files, +A/-B>
- Target base: `<full-sha>`
- Validation plan: <focused existing checks>
- Intentional deviations: <none or concise list>

[Review the patch](/absolute/path/proposed.patch) - [Read the rationale](/absolute/path/review.md) - [Walkthrough state](/absolute/path/state.md)

**Status: unapplied, awaiting your review.**

Reply with `apply`, `revise: ...`, `skip`, or a question.
```

A tiny excerpt is acceptable only when it materially clarifies one decision. Show the full diff inline only when the user requests it.

## Applied-step response

```markdown
Committed `<sha>` - `<subject>`.

- Churn: <files, +A/-B>
- Validation: <checks and outcomes>
- Limitations: <blocked/static-only checks or none>
- Fidelity outcome: <faithful/context-port/rewrite/omission>

Next: <one-sentence recommendation>.

[Review the next patch](/absolute/path/proposed.patch) - [Rationale](/absolute/path/review.md)

**The next patch is unapplied.**
```

## Final decision response

```markdown
### Finalize the PR

- PR: <link>
- Existing PR head: `<remote>/<head-ref>` at `<original-sha>`
- Rebuilt head: `<rebuilt-sha>`
- Planned backup: `<remote>/<backup-ref>` at `<original-sha>`
- Dependent stacked PRs: <none or list and impact>
- Validation: <summary>
- Durable recovery state: [state.md](/absolute/path/state.md)

**Recommendation: Replace the existing PR branch with the rebuilt history.**

Choose:

1. **Replace PR branch (recommended)**
2. Keep the rebuilt branch separate
3. Stop without publishing
```

Do not execute replacement until the user explicitly selects option 1.
