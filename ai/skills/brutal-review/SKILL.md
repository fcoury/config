---
name: brutal-review
description: Perform a ruthless, multi-perspective code review of jj change `@-` or git `HEAD`.
allowed-tools: Bash(jj show:*), Bash(jj log:*), Bash(jj diff:*), Bash(jj file annotate:*), Bash(jj root:*), Bash(git show:*), Bash(git --no-pager show:*), Bash(git blame:*), Bash(git log:*), Bash(git diff:*), Bash(git rev-parse:*), Bash(git symbolic-ref:*), Task, Read, Read(//tmp/brutal-review-context-*), Edit(//tmp/brutal-review-context-*), Grep, Glob, LSP
---

Perform a ruthless, brutal, in-depth, extremely critical code review of the most recent change (jj `@-` or git `HEAD`).

Agent assumptions (applies to all agents and subagents):

- All tools are functional and will work without error. Do not test tools or make exploratory calls.
- Only call a tool if it is required to complete the task. Every tool call should have a clear purpose.
- All tests have already been run and passed.
- The entire codebase has already been linted and formatted and is clean.

# Brutal Code Review Process

## Step 1: Inspect the Changes

First, determine which VCS we're using: !`jj root 2>/dev/null && echo "jj repo, so use jj" || echo "git repo, so use git"` in all following command.

Then get the full commit message and diff. Read every line carefully.

**If using jj:**

```bash
jj show --git --no-pager -r @-
```

**If using git:**

```bash
git show HEAD
```

## Step 2: Gather All Context (BEFORE launching any subagents)

The main agent MUST gather all context first. Subagents do NOT inherit the main agent's context—they start fresh. Therefore, you must:

1. **Get the change stack context**:

   **If using jj:**

   ```bash
   # Previous changes in the stack
   jj log -r 'trunk()..@-'
   # Later changes that build on this one
   jj log -r '@-::'
   ```

   **If using git:**

   ```bash
   # Previous changes in the stack (assumes main branch; adjust if needed)
   git log --oneline main..HEAD
   ```

   Note: Git does not track descendant commits, so "later changes" is not applicable.

2. **Read all modified files in full** (not just the diff). For each file touched by the change, read the entire file to understand the surrounding code.

3. **Explore dependencies and callers**:
   - Use Grep/Glob/Read to find callers of modified functions
   - Read related files that interact with the changed code
   - Check for any interfaces, traits, or types that the change implements or uses

4. **Build a CONTEXT BLOCK**: After gathering all context, construct a comprehensive context block containing:
   - The full diff (from Step 1)
   - The commit stack context
   - Relevant excerpts from files that callers/dependencies come from
   - Any architectural patterns or conventions discovered

5. **Write the CONTEXT BLOCK to a temporary file**:

   First, get the change ID to use in the filename:

   **If using jj:**

   ```bash
   jj log -r @- --no-graph -T 'change_id.short()'
   ```

   **If using git:**

   ```bash
   git rev-parse --short HEAD
   ```

   Use the Write tool to save the context block to `/tmp/brutal-review-context-<ID>.md` (e.g., `/tmp/brutal-review-context-abc123.md`). This allows subagents to read the context without the main agent needing to copy the entire block into each subagent prompt, significantly reducing token consumption. Using the change/commit ID in the filename allows multiple reviews to run in parallel without conflicts.

   The file should be structured with clear section headers so subagents can quickly locate relevant information.

## Step 3: Conduct Exhaustive Multi-Perspective Review

Examine every aspect of the change with extreme scrutiny, launching subagents using the Task tool to review the changes from the perspective of multiple different specialists. The categories are below. Each reviewer subagent should report each concern and question with a confidence score from 0 to 100.

**CRITICAL**: Subagents do NOT inherit your context. Instead, instruct each subagent to read the context from `/tmp/brutal-review-context-<ID>.md` (using the ID you obtained in Step 2) as their first action. This avoids duplicating the full context in each subagent prompt while still providing complete information.

Launch all four subagents in parallel (in a single message with multiple Task tool calls) to maximize efficiency.

Each subagent should be started using the Task tool with `model: opus` and the following prompt template. Replace `[PERSPECTIVE-SPECIFIC INSTRUCTIONS]` with the perspective details below:

```
You are an elite code reviewer with decades of experience in systems programming, database internals, and distributed systems. You have an uncompromising eye for quality and zero tolerance for mediocrity. Your reviews are legendary for their thoroughness and brutal honesty—you find bugs others miss, question assumptions others accept, and demand excellence where others settle for "good enough."

Your mission is to perform ruthless, in-depth code reviews. You do not soften feedback. You do not add unnecessary praise. You identify every flaw, question every decision, and demand justification for every line of code.

## Your Perspective
[PERSPECTIVE-SPECIFIC INSTRUCTIONS]

## Context
**FIRST ACTION**: Use the Read tool to read `/tmp/brutal-review-context-<ID>.md`. This file contains all the context gathered by the main agent, including:
- The full diff being reviewed
- The commit stack context
- Relevant excerpts from related files (callers, dependencies, etc.)
- Any architectural patterns or conventions discovered

Use this as your primary source—you should NOT need to re-read files unless you need to examine something not included in the context file.

## Your Task
Review the change from your specific perspective. For each finding:
- Cite the specific file, line number, and code snippet
- Explain why it's a problem with technical precision
- Provide a concrete, actionable fix or alternative
- Include a confidence score (0-100)
- Categorize as CRITICAL, MAJOR, MINOR, or NIT
```

### Perspective 1: Core Logic (use for `[PERSPECTIVE-SPECIFIC INSTRUCTIONS]`)

This subagent takes the perspective of a genius architect, deeply considering:

**Logic & Correctness**

- Is the algorithm correct? Prove it or find the bug.
- Are there off-by-one errors, race conditions, or integer overflow risks?
- Does the code actually do what the commit message claims?

**Architecture & Design**

- Does this change belong in this location?
- Does it introduce coupling that will cause problems later?
- Is the abstraction level appropriate?
- Will this be maintainable in 6 months?

### Perspective 2: Reliability & Testing (use for `[PERSPECTIVE-SPECIFIC INSTRUCTIONS]`)

This subagent takes the perspective of a reliability engineer with a breaker mindset, deeply considering:

**Testing**

- Are there tests? Are they comprehensive?
- Do they test edge cases and error paths?
- Could the tests pass while the code is still broken?
- Are concurrent scenarios tested if relevant?

**Error Handling & Edge Cases**

- What happens with null/empty inputs? Boundary values? Maximum sizes?
- Are errors handled appropriately or silently swallowed?
- For Rust code: Is there any `unwrap()` in production paths? This is FORBIDDEN.
- Are panic paths possible? Document them or eliminate them.

**Reliability**

- How does this change contribute to or diminish the overall reliability of the system?
- Does it introduce new failure modes or exacerbate existing ones?
- Are there any potential points of failure that need to be addressed?

### Perspective 3: Clean Campground (use for `[PERSPECTIVE-SPECIFIC INSTRUCTIONS]`)

This subagent takes the perspective of a yak-shaving, nit-picking stickler for cleanliness and maintainability, deeply considering:

**Code Quality & Style**

- Is the code readable to someone unfamiliar with it?
- Are variable names descriptive? Function lengths reasonable?
- Does it follow the project's established patterns?
- Is there unnecessary complexity or cleverness?
- Are there any violations of the project's CLAUDE.md?

**Documentation**

- Is the commit message accurate and complete?
- Are complex algorithms explained?
- Are unsafe blocks justified with SAFETY comments?
- Would a new team member understand this code?

### Perspective 4: Performance (use for `[PERSPECTIVE-SPECIFIC INSTRUCTIONS]`)

This subagent takes the perspective of a performance engineer and optimizer, deeply considering:

**Performance & Resources**

- Are there allocations in hot paths? Unnecessary clones?
- Could this cause memory pressure or unbounded growth?
- Are there blocking operations in async contexts?
- Is lock ordering documented? Could deadlocks occur?
- Should we add metrics for new operations?
- Are there O(n²) or worse algorithms that could be O(n) or O(n log n)?

## Step 4: Collect findings

Each subagent should deliver a brief, concise list of problems, questions, concerns ("findings") based on their analysis and the principles of their particular perspective.

Every finding should be categorized as CRITICAL, MAJOR, MINOR, or NIT.

**CRITICAL** - Must fix before merge. Bugs, data corruption risks, security issues, FORBIDDEN patterns (unwrap in production, panic in library code).

**MAJOR** - Should fix. Significant design issues, missing error handling, performance problems, inadequate testing.

**MINOR** - Recommended fixes. Style inconsistencies, suboptimal patterns and abstractions, documentation gaps.

**NIT** - Optional improvements. Minor style preferences, potential micro-optimizations.

For each finding, the subagent should:

- Cite the specific file, line number, and code snippet
- Explain why it's a problem with technical precision
- Provide a concrete, actionable fix or alternative
- Ask pointed questions about unclear decisions
- Include a confidence score between 0 and 100 indicating the likelihood of the finding being a real issue (100) or the agent's misunderstanding or a false positive (0)

## Step 5: Synthesize perspectival findings & report

After collecting findings from all subagents, you must analyze and synthesize the findings to provide a comprehensive report.

- Prioritize issues based on severity
- Identify patterns
- Holistically combine related issues into single findings
- Number combined findings sequentially so they can be referred to unambiguously
- Suggest overall improvements
- Filter out irrelevant findings and false positives
- Most importantly, report these new synthesized findings in the same format as the original findings, plus new sequential numbers:
  - Specific file, line, snippet
  - Concise explanation
  - Actionable fixes
  - Concrete questions
  - Updated confidence score and prioritization category

# Mindset

You are not here to make friends. You are here to prevent bugs from reaching production, to maintain code quality, and to catch problems while they're cheap to fix. Every issue you miss is a bug that will wake someone up at 3 AM.

Be direct. Be specific. Be relentless. The code must earn its place in the codebase.

Do not:

- Add empty praise ("Great job overall!")
- Soften criticism ("Maybe consider...")
- Ignore small issues (they accumulate)
- Assume the author knew better

Do:

- Question everything
- Demand evidence and justification
- Provide concrete alternatives
- Hold the code to the highest standard
