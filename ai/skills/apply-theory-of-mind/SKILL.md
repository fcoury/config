---
name: apply-theory-of-mind
description: "Apply a private Theory of Mind audit before reasoning, drafting, editing, delegating, or producing an artifact. Use when an output will be read, interpreted, acted on, or experienced by someone with different context: Slack messages, emails, cold outreach, public or external posts, summaries, updates, briefs, PR descriptions, docs, UI copy, explanations, recommendations, reviews, and agent prompts. Especially useful when the source context is messy, the audience is unfamiliar, the artifact has gone through revisions, or the user asks for something clear, natural, concise, standalone, or in their voice."
---

# Apply Theory of Mind

## Purpose

Model the reader, user, or downstream agent before producing the output. Keep the audit private unless the user asks for it. Optimize for the downstream outcome: the recipient should understand the right thing, with the right emphasis, and know what to do next.

## Workflow

### 1. Identify the real outcome

Determine what the output must help the recipient understand, decide, feel, or do. Distinguish the user's drafting instructions from information the recipient actually needs.

### 2. Build a private recipient model

Before drafting, answer privately:

- Who will receive or use this?
- What is their relationship to the sender or product?
- What do they likely know already?
- What do they likely not know?
- What do they care about?
- What action or reaction is desired?
- What channel, sensitivity, and time constraints matter?

Separate known facts from assumptions. Ask one concise clarifying question only when a consequential unknown cannot be resolved from available context.

### 3. Select the minimum sufficient context

Start from the recipient's likely baseline, not from the conversation transcript.

- Introduce unfamiliar people, organizations, projects, and links with the smallest useful explanation.
- Explain why the message or artifact is landing with this recipient.
- Translate internal shorthand, jargon, and coined phrases into plain language.
- Include why a fact matters when the connection is not obvious.
- Keep one coherent thought per bullet, but do not turn bullets into fragments.
- Omit details that do not change the recipient's understanding, decision, or action.

### 4. Rewrite from the final state

Treat intermediate drafts, corrections, and investigation notes as scratch work. Produce a clean artifact for a reader arriving now.

- Remove rejected alternatives, revision history, prompt instructions, debugging residue, and private motivations.
- Do not leak user feedback as phrases such as `X, not Y` unless the contrast matters to the recipient.
- Do not preserve negative facts, caveats, or disclaimers merely because they appeared during creation.
- Omit off-path scheduling changes, personal circumstances, and incidental reasons for delays unless they materially affect the recipient's plan, decision, or ask. When a delay matters, state the relevant effect, not the private cause.
- For PRs and summaries, describe the durable result and rationale, not the sequence of edits.

### 5. Calibrate tone and implications

Match the sender's actual voice and the recipient relationship. Prefer natural, direct, friendly, practical language over polished-but-generic corporate phrasing.

Privately check what the wording may imply:

- Does it accidentally assume familiarity?
- Does it sound pushy, exclusive, defensive, or overly negative?
- Does it create an unintended commitment?
- Does it imply blame or criticism?
- Does it overstate confidence or invent a rationale?

### 6. Run a fresh-reader audit

Hide the transcript mentally and inspect the final output:

- Can the intended recipient understand it without private context?
- Is the purpose or ask clear?
- Is any detail present only because the model saw it?
- Is any necessary connective tissue missing?
- Are the most important points emphasized?
- Would a link-free skim still convey the core meaning?

Revise before returning the output.

## Output Guidance

- For messages and emails, establish only the needed context, then make a lightweight ask with an appropriate off-ramp.
- For public or external posts, protect skimmers: make the topic and relevance legible without repeating an entire preceding thread.
- For summaries and status updates, rank signals, explain why they matter, and omit weak items rather than padding.
- For PR descriptions and documents, write the finished artifact as a standalone object, not a changelog unless a changelog was requested.
- For explanations, distinguish observed evidence from inference. Do not invent intent from the current state of code or documents.
- For agent prompts, assume the receiving agent lacks the current thread. Pass the task, relevant context, constraints, evidence locations, and output criteria explicitly.
- For product and UI work, model the end user's knowledge, goals, repeated workflows, and likely failure points before deciding what to build or say.

## References

Read [references/principles.md](references/principles.md) for nuanced cases, failure modes, and artifact-specific checks.
