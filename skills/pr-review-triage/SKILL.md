---
name: pr-review-triage
description: Critically triage automated AI PR review feedback (CodeRabbit, Codex, Copilot, etc.). This skill should be used when the user pastes a GitHub PR review link and wants each suggestion evaluated for whether to apply as-is, apply with modifications, or skip, with clear rationale. Triggers on phrases like "review PR feedback", "triage this review", or any GitHub PR review URL.
---

# PR Review Triage

Critically evaluate automated AI PR review feedback, separating signal from noise. For each suggestion, determine whether to apply as-is, apply with modifications, or skip — with clear rationale grounded in the actual codebase.

## Workflow

### Step 1: Fetch the Review

Parse the GitHub PR review URL from the user's message. Extract the owner, repo, PR number, and review ID.

Fetch the review data using `gh`:

```bash
# Get the review comments (the individual file-level comments)
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews/{review_id}/comments

# Get the review body (top-level summary)
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews/{review_id}

# Get the PR diff for context
gh api repos/{owner}/{repo}/pulls/{pr_number} --jq '.diff_url' | xargs curl -sL
```

If the review ID is not in the URL, list all reviews and let the user pick:

```bash
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --jq '.[] | "\(.id) \(.user.login) \(.state) \(.submitted_at)"'
```

### Step 2: Read the Affected Code

For each comment, read the actual source file at the relevant lines to understand context. Do not evaluate suggestions without seeing the real code. Use the PR diff and local files to understand what changed and why.

### Step 3: Classify Comments by Type

Group comments into categories based on the review tool's own structure:

- **CodeRabbit**: Actionable Comments, Nitpicks, Comments Outside Diff Range
- **Codex**: P1 (Critical), P2 (Major), P3 (Minor), P4 (Suggestion)
- **Copilot**: Flat list (classify by severity yourself: Critical, Major, Minor, Nitpick)
- **Other tools**: Infer categories from the comment structure, or use a flat list grouped by inferred severity

When the tool does not provide explicit categories, infer them:
- **Critical**: Security vulnerabilities, data loss, crashes, incorrect logic
- **Major**: Performance issues, missing error handling on external boundaries, correctness concerns
- **Minor**: Code style improvements that affect readability, small refactors
- **Nitpick**: Purely stylistic, naming preferences, comment suggestions, whitespace

### Step 4: Evaluate Each Comment

For every comment, apply critical thinking:

1. **Read the actual code** — not just the diff snippet in the comment
2. **Check if the concern is valid** — does the problem actually exist, or is the reviewer hallucinating context?
3. **Check if the fix is correct** — even valid concerns can have wrong suggested fixes
4. **Assess proportionality** — is the suggested change worth the churn? Does it improve the code meaningfully?
5. **Consider the project context** — does the suggestion align with existing patterns in the codebase?

Common AI reviewer blind spots to watch for:
- Suggesting nil/null checks where the type system or control flow already guarantees safety
- Recommending extraction of small inline code into methods/functions when the code is only used once
- Flagging "missing error handling" for infallible operations
- Suggesting overly defensive patterns that add complexity without real safety benefit
- Recommending changes outside the PR's scope that would bloat the diff
- Pattern-matching on superficial code similarity without understanding semantic intent
- Suggesting additions of comments or docstrings that merely restate the code

### Step 5: Assign a Verdict

For each comment, assign one of:

- **Apply as-is** — The suggestion is correct, proportionate, and improves the code
- **Apply with changes** — The concern is valid but the suggested fix needs adjustment. Describe the modified approach
- **Skip** — The suggestion is incorrect, disproportionate, or not worth the churn. Explain why clearly

### Step 6: Present the Triage Report

Present findings as a narrative with bullet points, organized as follows:

#### Report Structure

Start with a one-line summary: how many comments total, how many to apply, how many to skip.

Then present comments grouped by type (matching the tool's own categories from Step 3). Within each type, order by **triage priority** — a composite of:
- **Stated priority** (from the tool, if available)
- **Ease of implementation** (quick wins bubble up)
- **Impact** (higher impact ranks higher)

For each comment:

- **Summary**: One-line description of what the reviewer flagged
- **Stated priority**: The tool's own severity label (if any)
- **Triage priority**: Your assessed priority (Critical / High / Medium / Low)
- **Verdict**: Apply as-is | Apply with changes | Skip
- **Rationale**: 1-3 sentences explaining why. For "Apply with changes," describe the modification. For "Skip," explain what the reviewer got wrong
- **File and line**: `path/to/file.rs:42` format for easy navigation

#### Example Output

> **Triage summary**: 8 comments total — 3 apply as-is, 2 apply with changes, 3 skip.
>
> ---
>
> **Actionable Comments** (CodeRabbit)
>
> - **Missing bounds check on user input parsing**
>   Stated: Critical | Triage: Critical | **Apply as-is**
>   The `parse_input` function does not validate the length before slicing. The suggested bounds check is correct and minimal.
>   `src/parser.rs:127`
>
> - **Extract repeated database query into a shared function**
>   Stated: Major | Triage: Low | **Skip**
>   The two queries look similar but operate on different tables with different join conditions. Extracting them would require a generic abstraction that adds complexity for no real deduplication benefit. The current approach is clear and each query is independently maintainable.
>   `src/db/queries.rs:45`
>
> **Nitpicks** (CodeRabbit)
>
> - **Rename `tmp` variable to `formatted_output`**
>   Stated: Nitpick | Triage: Low | **Apply with changes**
>   The variable does deserve a better name, but `formatted_output` is too long for a 3-line scope. Use `output` instead.
>   `src/formatter.rs:89`

### Step 7: Offer to Apply

After presenting the report, ask the user:

> Would you like me to apply the accepted changes? I can apply them all at once, or you can pick specific items.

If the user agrees:
- Apply "Apply as-is" items directly using the reviewer's suggested code
- Apply "Apply with changes" items using the modified approach described in the rationale
- Skip all "Skip" items
- After applying, present a short summary of what was changed

## URL Parsing Reference

GitHub PR review URLs follow these patterns:

```
# Review with specific review ID
https://github.com/{owner}/{repo}/pull/{pr_number}#pullrequestreview-{review_id}

# PR page (no specific review — list available reviews)
https://github.com/{owner}/{repo}/pull/{pr_number}

# Individual comment
https://github.com/{owner}/{repo}/pull/{pr_number}#discussion_r{comment_id}
```

Extract components with pattern matching. For the review ID, strip the `pullrequestreview-` prefix.
