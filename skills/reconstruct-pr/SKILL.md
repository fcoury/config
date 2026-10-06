---
name: reconstruct-pr
description: Reconstruct an authored GitHub pull request on a fresh worktree as a dependency-ordered sequence of conceptual, approval-gated patches, optionally replacing the existing PR branch after a verified backup. Use for guided PR understanding or deliberate simplification, not ordinary review, rebasing, or automatic cherry-picking.
---

# Reconstruct PR

Rebuild a PR change by change so the user can understand, question, simplify, or omit each conceptual step. The source PR is evidence, not blanket permission to copy or publish it.

Read [references/state-and-output.md](references/state-and-output.md) before starting. It defines the durable manifest and the required compact response forms.

## Non-negotiable invariants

- Pin the PR URL/number, actual head repository and ref, source base SHA, source head SHA, target base SHA, fidelity mode, reconstruction worktree, and temporary branch before changing files.
- Inspect applicable repository instructions and the complete pinned source diff before proposing a plan.
- Keep walkthrough state outside the repository and outside temporary directories. Chat history is not the source of truth.
- Never put a complete diff inline by default. Write the exact proposal to a `.patch`, write its reasoning to a companion Markdown file, and link both.
- Approval applies to one patch SHA-256 and one recorded target HEAD. Never silently regenerate an approved patch.
- `Apply and next` authorizes the current exact patch and preparation of the next preview; it does not authorize the next patch.
- Do not push, replace a PR branch, remove a worktree, or delete a branch without the separate authorization required for that phase.
- Preserve the original checkout, user work, durable artifacts, and verified backup.

## 1. Pin the source and choose fidelity

Resolve live PR metadata and Git refs. Distinguish the PR's actual head repository/ref from the local `origin`; author PRs may come from a fork or another remote. Record full SHAs, not abbreviations.

Use one explicit fidelity mode:

- **Source-faithful:** conceptual reordering and context-porting are allowed. Behavioral rewrites or omissions require separate approval.
- **Review-led:** classify source changes as keep, simplify, rewrite, or skip. Every deviation remains explicit and is reconciled at the end.

If the request does not establish the mode, ask before planning. Do not conflate code review with permission to rewrite.

Inventory all worktrees and branches before creating anything. Refuse to reuse a dirty or ambiguous target. Create a fresh temporary branch/worktree from the pinned target base only after the user approves the initial setup when their request has not already authorized it.

Create the durable run directory described in the reference. Initialize `manifest.json`, `state.md`, `source.patch`, and `plan.md`. Never add these artifacts to the repository.

## 2. Propose the conceptual plan

Inspect the entire `source_base_sha..source_head_sha` diff, including generated files, tests, snapshots, build/config changes, and stacked-PR dependencies. Split it by buildable dependency and reviewer-facing concept rather than by file count or original commits.

For every proposed step state:

- purpose and dependency boundary;
- source scope;
- fidelity classification;
- likely keep/simplify/rewrite/skip recommendation;
- expected churn and generated artifacts;
- focused existing validation;
- prerequisites and downstream impact.

Secure approval for the ordered plan before applying step one. Plan approval does not approve any patch.

## 3. Run the approval-gated step loop

For the current step:

1. Generate the exact patch against the current recorded target HEAD.
2. Write `proposed.patch` and `review.md` under the durable step directory.
3. Record the target HEAD, patch SHA-256, touched paths, fidelity classification, and status `awaiting_review` in the manifest.
4. Run read-only checks, including `git apply --check --whitespace=error`, without modifying the target.
5. Present the compact proposal form from the reference and pause.

Answer questions without applying the patch. If the user requests a revision, invalidate the old proposal, preserve it for traceability, generate a new version with a new hash, and request approval again. If the user skips a step, record the approved omission and its source scope.

Immediately before applying an approved patch, recheck:

- the target worktree is the recorded worktree and is clean;
- its branch and HEAD equal the manifest;
- the source remains pinned, or the user has approved repinning;
- the patch hash equals the approved hash;
- `git apply --check --whitespace=error` still succeeds.

Any mismatch invalidates approval. Stop, explain what became stale, and prepare a new preview.

After application:

- inspect the resulting diff for unrelated churn;
- run the planned existing checks, formatting, lint, and generated-file updates appropriate to the slice;
- never hide blocked or static-only validation;
- commit only the approved slice;
- write `completion.md` and update the manifest with the commit and validation evidence;
- prepare the next preview but leave it unapplied.

## 4. Reconcile the source

Before calling reconstruction complete, account for every source path and hunk as:

- applied faithfully;
- context-ported;
- deliberately rewritten;
- explicitly omitted;
- superseded or no longer applicable.

Write `reconciliation.md`, verify the reconstructed branch is clean, and record its full head SHA. For stacked PRs, also record parent and dependent PRs, their base/head refs, and whether replacing this branch changes their effective diffs. Do not proceed through an unreviewed downstream impact.

## 5. Make the explicit final decision

Present exactly three choices after reconciliation:

1. **Replace the existing PR branch (recommended)**
2. Keep the rebuilt branch separate
3. Stop without publishing

The recommendation is not implicit approval. Only a direct choice of replacement authorizes the replacement phase.

Before replacement, inspect every worktree using the original PR branch. A dirty original checkout blocks replacement; never reset, stash, clean, switch, or remove it. A clean but separately checked-out original branch requires explicit acknowledgement that it will be left untouched and locally stale. Preserve it in all cases.

If dependent stacked PRs exist, require an approved impact plan and normally rebuild/replace bottom-to-top.

## 6. Guarded replacement and cleanup

Use `scripts/finalize_pr_reconstruction.py` for deterministic finalization. Run its read-only `verify` action first. The manifest must record the explicit `replace` decision and all required acknowledgements.

Replacement must:

1. Re-read the actual remote head and PR head and require both to equal the recorded original SHA.
2. Create a distinct remote backup ref pointing to the original SHA.
3. Verify the backup ref remotely at that exact SHA.
4. Recheck the remote and PR heads for concurrent movement.
5. Push the rebuilt SHA to the same PR head ref using an exact expected-SHA force-with-lease.
6. Verify both the remote head and GitHub PR head equal the rebuilt SHA.
7. Persist every recovery checkpoint and stop conservatively on partial failure.

Never use plain `--force`, an implicit lease, a guessed remote/ref, or a locally cached expectation.

Cleanup is a separate explicitly confirmed helper action. It is unavailable until backup, remote-head, and PR-head verification all succeeded. Cleanup may remove only the clean temporary reconstruction worktree and its exact local temporary branch. It must retain the original checkout, remote backup, and durable walkthrough directory.

On any failure, keep all recoverable state and report the exact phase, observed SHAs, and safe resume action. Re-running replacement is allowed only through the helper's idempotent checkpoint logic.

## 7. Completion

Report:

- PR and final remote head;
- backup ref and preserved original SHA;
- reconstructed commits and approved deviations;
- validation performed and limitations;
- cleanup performed or deliberately retained;
- durable state directory for later recovery.
