# Theory of Mind Principles

Use this reference when the audience is mixed, the artifact is sensitive, the context is messy, or a first draft still feels subtly wrong.

## Core Model

Treat communication as an information-asymmetry problem. The model, sender, recipient, and downstream reader do not possess the same context. Track these separately:

| Perspective | Question |
| --- | --- |
| Model | What context did I receive that the recipient may never see? |
| Sender | What does the sender want to accomplish? |
| Recipient | What does this person know, care about, and need next? |
| Downstream reader | Could someone arriving later understand the durable artifact? |

Do not print this table into the artifact. Use it as private reasoning.

## Common Failure Modes

### Transcript leakage

The output mirrors the drafting conversation instead of serving its recipient.

Examples:

- A PR description says `add X and remove Y` after `Y` was only an abandoned intermediate change.
- A one-pager says what the user hopes to convince someone of.
- A revised artifact says `XYZ, not ABC` because the user corrected an earlier draft.
- A demo artifact contains QA notes, sample-data disclaimers, or implementation caveats that only mattered during creation.

Rewrite from the final state. Retain a caveat only when it changes a real decision, interpretation, or risk.

### Assumed common ground

The output relies on context the recipient does not have.

Before cold outreach or a context handoff, privately check:

1. Does the recipient know the sender?
2. Do they know the named people?
3. Do they know the company, customer, project, or thread?
4. Do they know why the sender is contacting them?
5. Do they know why the request is relevant to them?
6. What is the shortest context bridge that makes the ask make sense?

Default to a short context handoff unless the recipient is already in the shared thread.

### Over-compression

The output is brief but illegible. It uses unexplained acronyms, internal nicknames, artifact labels, or new phrases as though they were shared vocabulary.

Replace shorthand with the reader-facing concept. Name artifacts after what they mean, not after the path used to generate them.

### Over-inclusion

The output includes facts because they are available, not because they are useful.

Rank details by whether they change understanding, decision, action, or trust. Omit the rest. Links are evidence, not accomplishments.

Treat schedule changes, personal circumstances, and incidental explanations with extra care. Omit them entirely when they do not affect the recipient's plan, decision, or ask. If a delayed meeting materially changes the work, state that the meeting moved and update the plan. Do not include the private reason unless the recipient needs it to act or the user explicitly wants to share it.

### Social implication blindness

The words are factually reasonable but imply something unintended.

Check for:

- pushiness in a cold request
- exclusivity in a public-channel phrase such as `our conversation`
- accidental criticism, blame, or defensiveness
- unnecessary negative facts
- excessive urgency borrowed from internal context
- commitments the sender did not make

### Synthetic voice

The output is polished in a way the sender would not naturally write.

When examples exist, inspect recent sender-authored messages in the same medium and relationship type. Match their level of formality, sentence length, greeting style, use of bullets, and directness. Do not overfit quirks or copy irrelevant phrases.

## Artifact-Specific Passes

### Slack, email, and outreach

Include:

- a natural opener
- the minimum context bridge
- the reason for contacting this recipient
- a lightweight, concrete ask
- an off-ramp when appropriate

For a public thread, rely on visible preceding context when reasonable, but add a few words of orientation for skimmers and people who arrive later.

### Summaries and updates

Privately identify:

1. context
2. action or change
3. why the recipient should care
4. result, blocker, or next step

Rank by importance. Combine related details. Omit weak items rather than padding. Keep each bullet to one coherent point, but allow enough explanation to make it natural and standalone.

State schedule changes only when they affect the reader. Prefer the operational consequence over an incidental or personal explanation.

### PR descriptions, docs, and generated artifacts

Write for a reader walking up later with no knowledge of model runs, review churn, Slack discussion, or intermediate versions.

Include:

- the durable result
- the user-facing or engineering rationale when supported
- important verification or risk information

Exclude:

- creation narrative
- discarded approaches unless they matter to the decision
- instructions given to the model
- irrelevant caveats
- internal QA residue

### Explanations and analysis

Distinguish:

- observed evidence
- supported inference
- unknown rationale

Do not inspect the current state of a codebase and invent a historical reason. State the inference or uncertainty clearly.

### Delegation to another agent

Treat the agent as a recipient with limited context. Pass:

- objective
- relevant background
- constraints and non-goals
- source locations
- required output form
- completion criteria

Do not dump the entire transcript. Do not assume the agent knows local shorthand.

### Product and UI decisions

Model:

- who the user is
- what they are trying to accomplish
- what they already understand
- where they may hesitate or fail
- what they will do repeatedly

Use this to decide interface hierarchy, visible copy, defaults, empty states, and error handling.

## Final Audit

Before returning an artifact, ask privately:

1. What does the recipient need to know first?
2. What context is missing for a fresh reader?
3. What can be removed without loss?
4. What might be misread or imply the wrong thing?
5. Does the output sound like the sender?
6. Is the durable final state clear?
7. Could the recipient act without reading the source transcript?

If any answer is weak, revise the artifact rather than narrating the weakness.
