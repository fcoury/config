# X API Guardrails

Read the current official policy pages before actions whose permissibility may have changed:

- Developer guidelines: `https://docs.x.com/developer-guidelines`
- Developer policy: `https://docs.x.com/developer-terms/policy`
- Restricted use cases: `https://docs.x.com/developer-terms/restricted-use-cases`
- Automation rules: `https://help.x.com/en/rules-and-policies/x-automation`

## Operation Checks

| Activity | Requirement |
| --- | --- |
| Search and public reads | Use official API, observe rate and redistribution limits. |
| Post creation | Require explicit user request; avoid unsolicited mentions and duplicate spam. |
| Replies or DMs | Require explicit user request and current-policy check for automation or AI generation. |
| Likes, follows, reposts, list changes | Require explicit user request; do not bulk automate or manipulate engagement. |
| Data export or storage | Check attribution, removal, redistribution, consent, and retention obligations. |
| Analysis | Do not infer sensitive attributes, perform surveillance, benchmark competitors with X data, or train prohibited models. |

## Default Decision

If a request may violate current X policy or would create uncontrolled ongoing interactions, stop before calling a mutating tool and explain the policy risk. Do not work around policy by scraping or browser automation.

