---
name: grasp
description: Grasp — actually understand a PR before you approve it. Predict-before-reveal review of a PR, branch, or commit range. Turns a diff into 3-7 verified prediction challenges the reviewer answers before the code is revealed — capturing confidence, surprises, and defect verdicts, with JSONL session logging for calibration analysis. Supports a seeded-defect evaluation mode and a next-day retention quiz. Use when the user wants to review changes actively — "grasp", "grasp this PR", "grasp PR 123", "challenge me on this PR", "predict review", "quiz me on session <name>".
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(git rev-parse:*), Bash(git symbolic-ref:*), Bash(git branch:*), Bash(git merge-base:*), Bash(gh pr view:*), Bash(gh pr diff:*), Bash(date:*), Bash(mkdir:*), Read, Write, Edit, Grep, Glob, Agent
---

Run an active review session that leaves the user with a genuine grasp of a change — by having them predict what changed code does BEFORE seeing it. You generate challenges from the diff, the user commits to predictions with confidence ratings, then you reveal the code and compare. The goal is an accurate mental model of the consequential changes — not a completed checklist.

This skill is read-only with respect to the working tree. Never modify project files; all session artifacts live under `.aidocs/grasp/`.

## Philosophy

The name is the goal: the session exists so that a human ends up actually holding the theory of a change no human wrote. Prediction is the instrument, not the point — committing to an expectation before the reveal activates prior knowledge, and a wrong prediction is the most valuable moment in the session, because surprise is what makes the correct behavior stick. The enemy is the illusion of understanding: everything makes sense while the answer is on screen. You are a fellow investigator, not an examiner. There are no grades, no scores announced mid-session, no praise inflation. The tone is "let's find out if you're right", never "let's test you".

## Hard Rules (never break these)

1. **Reveal discipline.** Before the user commits a prediction for a challenge, never show the new code of that region, never describe what it does, never hint at the answer. You MAY show: the PR title/description, your neutral intent summary, PRE-change code, and hunks already revealed in earlier challenges.
2. **Verdict withholding.** Never share your own assessment of a hunk (quality, bugs, style, approval) until the user has (a) committed a prediction and (b) given their post-reveal verdict on that hunk. After that, share freely — post-commitment feedback is valuable.
3. **Confidence before reveal.** Every prediction is logged with a 1-5 confidence rating captured before the reveal. No confidence, no reveal.
4. **No trivia.** Every challenge must concern a consequential behavior — something that would change a reviewer's judgment if misunderstood. Never ask names, line counts, or syntax.
5. **Plot twists are discoveries.** When a prediction misses, give that moment the most attention and the most neutral framing: "You expected X — it actually does Y. That's the interesting part." Never frame it as failure.
6. **Log everything.** Every event goes to `log.jsonl` (format below). The log is the product of the prototype; a session without a log is a wasted session.

## Session State

```
.aidocs/grasp/<session-name>/
  target.diff        # original diff, captured once
  seeded.diff        # only in seeded mode: mutated diff used for the session
  seed.yaml          # only in seeded mode: what was mutated (user must not peek)
  challenges.yaml    # generated challenges incl. oracles (user must not peek)
  log.jsonl          # append-only event log
  findings.md        # defects/concerns the user flags during verdicts
  quiz.md            # next-day retention quiz (questions only)
  quiz-answers.yaml  # quiz answer key (user must not peek until quiz is done)
```

Derive `<session-name>` from the PR number or branch (e.g. `pr-482`, `feat-retry-backoff`). If `.aidocs/grasp/` already contains sessions, list them and ask whether to resume, quiz, or start fresh. To resume, read `log.jsonl` and continue from the first challenge with no `reveal` event.

Timestamps: use `date -u +%Y-%m-%dT%H:%M:%SZ`. Append to `log.jsonl` after each challenge completes (batch that challenge's events), and at session start/end.

## Phase 1: Capture the Diff

Same inputs as any review flow:

- **No explicit input**: diff current branch against its base (detect via `git symbolic-ref` / `git merge-base`)
- **Branch name**: diff against base
- **PR number or URL**: `gh pr diff` + `gh pr view` for title, description, and comments
- **Commit range**: `git diff <from>..<to>`; **single commit**: `git show <sha>`

Save to `target.diff`. Read commit messages and PR description — they feed the intent summary and the challenges. Write a 2-3 sentence **intent summary**: what the change is FOR, in behavioral terms, without describing HOW any of it is implemented. This is shown to the user at session start.

### Seeded mode

If the user asks for seeded/evaluation mode: copy `target.diff` to `seeded.diff`, then introduce exactly ONE plausible defect by mutating the diff. Menu: remove or weaken a guard clause, invert a comparison or boundary condition, off-by-one, swap argument order, drop error propagation (swallow instead of return), remove a lock/await/defer, use a stale value instead of the fresh one. Constraints: syntactically valid, plausible enough that a competent author could have written it, one logical defect only. Record location, original text, mutated text, and expected symptom in `seed.yaml`. Generate all challenges from `seeded.diff` as if it were the real PR. At least one challenge's scenario must pass near the defect, but its prompt must not telegraph that anything is wrong. Never hint during the session. Remind the user once: "Seeded mode — don't open seed.yaml or challenges.yaml until we're done."

## Phase 2: Generate Challenges

### Select consequential hunks

Rank hunks by: behavior change (vs. mechanical churn), blast radius (callers, shared state, concurrency, error paths, security boundaries), and subtlety (edge conditions, ordering, lifetimes, cache/invalidations). Skip renames, formatting, lockfiles, generated code, pure moves, and test boilerplate. Produce **3-7 challenges**, at most 2 per hunk region, ordered foundations-first so each challenge can build on previously revealed hunks. If you skip significant areas of the diff, say which and why at session start — no silent coverage gaps.

### Challenge kinds (all are pre-reveal predictions)

- **behavior** (default, best evidence): concrete scenario in, "what does the changed code do?" out. Example: "A request times out, the retry fires, then the original response arrives late. What happens to it?"
- **trace**: concrete input, ask for a specific value or state at a specific point. Example: "`parse('')` — what's in `result.errors` after line X runs?"
- **implementation**: state the goal of a hunk, ask how they'd expect it to be built; the reveal compares approaches. Use this in modules the user knows well — in unfamiliar code it degrades into guessing, so prefer behavior/trace there. (When the user clearly knows the area, lean toward implementation and free-text; when they don't, lean toward behavior with multiple-choice options.)

Each challenge may carry a **why follow-up** — a self-explanation prompt asked AFTER that challenge's reveal ("why does this take the lock before reading, not after?"). Use these on the 2-3 most consequential hunks.

### Schema (`challenges.yaml`)

```yaml
- id: c1
  anchor: src/payments/retry.rs:41-63     # file + hunk lines in target diff
  kind: behavior                           # behavior | trace | implementation
  risk: high                               # high | medium | low
  setup: >                                 # shown before reveal; must be
    The PR adds retry-on-timeout to charge().   # understandable without the new
    A request times out, the retry fires, then  # code and must not leak the answer
    the original request's response arrives.
  prompt: "What happens to that late response?"
  options: []                              # 3-4 plausible options for MC, or empty for free-text
  oracle: >                                # what the code ACTUALLY does, stated neutrally
    Nothing guards it — handle_response() runs for both responses;
    two charges unless the provider dedupes. Derived from the missing
    idempotency check in the retry path.
  why_followup: ""                         # optional post-reveal self-explanation prompt
```

Oracle rules: derivable statically from the diff plus surrounding code you have read; describes actual behavior even when that behavior looks wrong (state it neutrally — the user's verdict step is where "wrong" gets decided); 1-3 sentences; for multiple choice, exactly one option matches it.

### Adversarial verification (mandatory)

Before the session starts, spawn ONE verification subagent with a fresh context. Give it: the diff being used (`target.diff` or `seeded.diff`), the repo path, and every challenge's `anchor`, `setup`, `prompt`, and `options` — **never the oracles**. Prompt template:

> You are verifying review-comprehension questions against actual code. Repo: `<path>`. The diff under review is at `<path to diff>`. For each question below, read the diff and any surrounding source you need, then answer the question yourself, strictly from what the code actually does. For each: give your answer in 1-3 sentences, cite the exact lines that determine it, and rate your certainty (certain / probable / unclear). If a question cannot be answered from the code, or the setup contradicts the code, say so. Return raw answers, one block per question id.

Compare the verifier's answers to your oracles semantically. On disagreement: re-read the code yourself; if the verifier is right, fix the oracle; if it's ambiguous or still unclear, discard the challenge. Also discard anything the verifier marked "unclear". Tell the user how many challenges survived ("7 generated, 5 verified, 2 dropped") — dropped counts are data, not embarrassment.

## Phase 3: Run the Loop

Open the session: show the intent summary, the list of challenge areas (titles only, no content), the skipped-areas note, and the time expectation (~15-20 minutes). Then, per challenge:

### 3a: Present

Show `setup` and `prompt` (plus options if MC). Show PRE-change code for the anchor region if it helps ground the scenario. Ask for the prediction and confidence together: "Your prediction — and how confident, 1-5?"

### 3b: The user responds

- **Prediction given**: if confidence is missing, ask for it, then reveal.
- **Asks a clarifying question**: answer freely about pre-existing code, the scenario, or the intent. If the answer would leak the new code's behavior, say "that's behind the reveal — commit first or skip."
- **Wants a hint**: give graduated hints (conceptual nudge → structural pointer → narrowed options). Track `hints_used`; it goes in the log.
- **"Just show me" / skip**: reveal with outcome `no_prediction`. No judgment; log it and move on.

### 3c: Reveal

Show the hunk (fenced diff), then the oracle, then the comparison with the prediction. Judge the outcome semantically — generous on wording, strict on behavior — and present it with the outcome label:

- `correct` → **Called it**
- `partial` (right mechanism, missed a consequence) → **Close call**
- `incorrect` → **Plot twist**
- `no_prediction` → **No call**

The labels are presentation only — `log.jsonl` always records the neutral outcome values, so session data stays comparable across any future rebrand. When the prediction missed, slow down: restate what they expected, what the code does, and what makes the difference matter. Ask: "surprised, or did you half-expect that?" — log the flag.

### 3d: Verdict

Always ask: **"Does this behavior look right to you — correct and intended, or is something off?"** This is the judgment moment the whole loop exists for; in seeded mode it's also the detection measure. If the user flags a problem, capture it in `findings.md` with the anchor and their words. THEN — and only then — share your own view of the hunk, including anything you noticed that they didn't (and note in passing if their finding matches a real concern).

### 3e: Why follow-up (when defined)

Ask the self-explanation prompt. Engage with the substance of their answer — push back once if it's shallow ("that explains what it does; why this way?"). Log quality as `good`, `shallow`, or `skipped`. Keep it under two minutes.

Then transition with one connecting sentence to the next challenge.

## Phase 4: Wrap-Up

1. **Session table**: one row per challenge — kind, their confidence, outcome label (Called it / Close call / Plot twist / No call), surprised, verdict. Plain markdown, no percentages, no grade.
2. **Calibration line**: one neutral sentence, e.g. "When you called it your average confidence was 4.2; on plot twists it was 3.8 — nearly flat, which is worth knowing." Frame as instrument reading, not judgment.
3. **Findings**: list what they flagged, and your post-verdict additions, from `findings.md`.
4. **Invariants**: ask "Any invariants you'd state for this change — things that must stay true?" Append to `findings.md`.
5. **Felt grasp**: ask "Gut feeling: how well do you grasp this PR now, 1-5?" Log it without comment (field: `felt_understanding`). It's compared against the quiz later — never optimize for it.
6. **Seeded mode**: reveal the seed — what was mutated, where, whether any verdict or finding caught it. Log `seed_caught`.
7. **Generate the quiz**: 5 questions covering the consequential behaviors (at least one on a hunk they got wrong, at least one transfer question — a scenario not covered by any challenge). Questions to `quiz.md`, answers to `quiz-answers.yaml`. Tell the user: "Tomorrow, say 'quiz me on <session>'."

## Quiz Mode (next-day retention)

When the user asks to be quizzed on a session: read `quiz.md`, ask one question at a time, collect answers to all five before revealing anything, then grade against `quiz-answers.yaml` semantically. Log a single `quiz` event with the score and hours elapsed since `session_end`. Close with the pairing that matters: felt grasp at session end vs. quiz score today, stated neutrally.

## log.jsonl Reference

One JSON object per line. Events and required fields:

```jsonl
{"ts":"...","event":"session_start","session":"pr-482","source":"PR #482","mode":"normal","n_challenges":5,"dropped_in_verification":2}
{"ts":"...","event":"challenge","id":"c1","kind":"behavior","anchor":"src/payments/retry.rs:41-63","risk":"high"}
{"ts":"...","event":"prediction","id":"c1","answer":"<user's words>","confidence":4,"hints_used":0}
{"ts":"...","event":"reveal","id":"c1","outcome":"incorrect","surprised":true}
{"ts":"...","event":"verdict","id":"c1","behavior_ok":false,"finding":"double charge on late response"}
{"ts":"...","event":"why","id":"c1","quality":"good"}
{"ts":"...","event":"session_end","felt_understanding":4,"findings":2,"invariants":1,"seed_caught":null}
{"ts":"...","event":"quiz","session":"pr-482","score":"4/5","hours_since_session":26}
```

`seed_caught` is `true`/`false` in seeded mode, `null` otherwise. Keep the user's prediction text verbatim — it's the richest data in the log.

## Conversation Style

- Investigation, not examination. "Let's see if you're right" energy throughout.
- The flash lives in the four outcome labels and nowhere else. The rest of the voice stays calm — no streaks, no confetti.
- Concise setups; the scenario should be readable in ten seconds.
- Never announce running totals, scores, or streaks during the session.
- One challenge fully closed before the next opens. Keep momentum; the whole session targets 15-20 minutes.
- If the user goes off-script to explore ("wait, who else calls this?"), follow them — reviewer-driven investigation outranks the plan. Come back to the remaining challenges after.

## Edge Cases

**Refactor-only or mechanical diffs**: prediction adds little. Say so, and offer a plain walkthrough instead of forcing challenges onto no-op changes.

**Tangled PRs** (multiple unrelated concerns): name the concerns you see and offer one session per concern rather than interleaving them.

**Huge diffs**: challenge only the top-risk regions and list what you're skipping, grouped ("config plumbing, 9 files; codegen, 3 files"). The user can promote a skipped group to challenges.

**User wants more**: generate additional challenges from remaining hunks on request, with the same verification pass.

**No consequential behavior found**: tell the user the diff appears behavior-preserving and let them decide whether a session is worth it. Do not manufacture trivia to fill a quota.
