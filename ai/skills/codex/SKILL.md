---
name: codex
description: "Second opinion from Codex model. Use when reviewing plans, double-checking approaches, debugging hard problems, or finding edge cases."
---

# Codex Subagent

Run the Codex CLI (gpt-5.3-codex) non-interactively from Claude Code. Extends Claude Code with a different model family as a tool.

## Why

- **Spread token usage** across two services — avoids hitting Claude Code limits faster
- **Different training = different blind spots** — increases chance of catching issues Claude misses
- **Model comparison** — helps user track state-of-the-art and relative strengths across model families
- **Source of randomness** — different perspectives on the same problem, not just confirmation

## When to Use

- User explicitly asks for a second opinion or alternative approach
- Architecture/design decisions where model diversity reduces blind spots
- Code review from a different perspective (complement, not replace, own review)
- Debugging when stuck after multiple attempts — different model may spot different patterns
- User expresses uncertainty about an approach ("I'm not sure about this")
  Do NOT use for: trivial tasks, tasks requiring file writes, or when the user hasn't indicated they want model diversity.

## Command

```sh
codex exec -s read-only -o "/tmp/codex-$$.md" "<prompt>" > "/tmp/codex-$$-log.md" 2>&1
```

- `exec` — non-interactive, no TUI
- `-s read-only` — can read files but not write (avoids two agents fighting over the codebase)
- `-o` — writes only the final answer to file. `$$` (shell PID) ensures unique filenames for concurrent runs
- `-m <model>` — override model (default from config: `gpt-5.3-codex`)
- `-c model_reasoning_effort="<level>"` — reasoning effort:
- `medium` — simple questions, quick lookups
- `high` — default, use most of the time (~80%)
- `extra_high` — rare, complex architectural decisions (~5%)
- `-C <dir>` — working directory (defaults to cwd, explicit when needed)
- `> ... 2>&1` — redirects all CLI noise (headers, thinking, tool calls) to log file

## Execution

1. Run via Bash with `run_in_background: true`
2. Wait for completion via `TaskOutput`
3. Read `/tmp/codex-<pid>.md` for the final answer
4. Quiet mode means the user sees nothing — share or summarize the answer when relevant. Judgment call.
5. `/tmp/codex-<pid>-log.md` available for debugging if needed

## Context

- AGENTS.md is auto-loaded by Codex from the project root — project rules apply
- `.agents/ -> .claude/` symlink gives Codex access to skill files
- The project is `trusted` in Codex config — it can read all project files

## Prompt Tips

- Be specific about what you want: "Review this approach and suggest alternatives" not "What do you think?"
- Include relevant file paths so Codex reads the right code
- State constraints and context upfront — Codex has no memory of our conversation
- Ask for structured output (numbered list, pros/cons) for easier parsing

## Maintenance

- **Update CLI**: `bun install -g @openai/codex`
- **Models last checked**: 2026-02-12. Default: `gpt-5.3-codex` (ChatGPT account). Auth is ChatGPT-based, not API key — some models (o3, o4-mini) are unavailable.
