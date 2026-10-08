---
name: simplify-code
description: Review code changes for simpler implementation, smaller diffs, fewer added lines, leaner tests, and reduced code churn. Use when Codex is asked to simplify code, reduce churn, shrink a diff, do a simplification pass, trim redundant tests, review overall branch or PR changes for unnecessary complexity, or clean up an implementation while preserving behavior. By default, operate on the current branch or current PR if one exists; users may override the scope to unstaged, staged, uncommitted, or another explicit diff range.
---

# Simplify Code

Use this skill to find the smallest complete solution and diff while preserving behavior.

## Resolve Scope

Choose the review scope in this order:

1. If the user specifies `unstaged`, inspect only `git diff`.
2. If the user specifies `staged`, inspect only `git diff --cached`.
3. If the user specifies `uncommitted`, inspect `git diff HEAD`.
4. If the user gives an explicit commit, branch, PR, or diff range, use that.
5. Otherwise, inspect the current branch or current PR:
   - Prefer the current PR when `gh pr view` can identify one.
   - Use the PR base branch as the comparison base.
   - If no PR exists, compare the current branch to its upstream or the repository's default branch.

Always run `git status --short` before editing. Treat unrelated worktree changes as user-owned; do not revert them. If default branch or PR scope is selected and uncommitted changes exist, avoid folding them into the review unless they overlap files you must inspect for safety.

## Build Context

Start broad, then zoom in:

- Inspect `git diff --stat` and `git diff --name-status` for the chosen scope.
- Read the actual diff and nearby code for changed files.
- Look for new APIs, renamed types, moved files, shared helpers, generated files, and tests touched by the change.
- Understand the intended behavior before proposing simplifications.

## Simplification Priorities

Use this decision order:

1. **Subtract.** Remove dead code, redundant validation, unused paths, obsolete compatibility layers, and speculative machinery before adding anything.
2. **Reuse.** Prefer an existing project pattern or helper over a new convention or abstraction.
3. **Add.** Introduce only the smallest local change required by observed behavior and the stated requirements.

Optimize for the smallest complete solution and the smallest relevant diff, not abstract elegance:

- Prefer deletion. Cut to the minimum before polishing or generalizing.
- Design for observed usage. Do not add validators, parsers, configuration, guards, or edge-case handling that the task does not require.
- Minimize added lines and touched surface area. Avoid unrelated renames, formatting, reordering, or file moves.
- Flatten paths that are expensive to trace. Inline one-caller helpers, pass-through wrappers, adapters with no second implementation, and layers that do not change the abstraction.
- Reduce state a reader must hold. Prefer pure functions and returned values over mutation, locals over fields, and derived values over synchronized copies.
- Consolidate repeated decisions behind one source of truth, but deduplicate only when the result is easier to read.
- Narrow broad API changes when a local change solves the problem. Preserve public interfaces unless changing them is the task.
- Keep tests focused on changed behavior. Remove redundant, over-specified, implementation-detail, or no-op tests, snapshots, and fixture churn.

Be skeptical of cleanup that grows the diff, hides intent, adds coordination costs, or couples unrelated concerns. A useful final check is whether a new reader can quickly answer where a value comes from and what can change it.

## Act

If the user asks for implementation, or the request naturally calls for cleanup, make clear low-risk simplifications directly. Keep edits minimal and focused on the chosen scope.

If a simplification is risky, depends on product intent, or would require a larger redesign, report it instead of applying it. Explain the tradeoff and point to the relevant files.

After edits, run the narrowest relevant formatter or tests for the changed area when practical. In the final response, summarize what was simplified, what was intentionally left alone, and any validation performed.
