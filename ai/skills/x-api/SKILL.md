---
name: x-api
description: Use the official X API through X Docs MCP and XMCP to search or retrieve posts, users, lists, spaces, trends, news, DMs, bookmarks, and analytics, or to perform explicitly requested X actions such as posting, replying, liking, reposting, following, messaging, or deleting. Use for X research, account operations, and X API integration questions; never use browser automation or scraping for X content.
---

# X API

Use the official X platform API at `docs.x.com` and `api.x.com`. Do not confuse it with the xAI model API.

## Workflow

1. Classify the request as documentation, read-only retrieval, or account mutation.
2. Use `x_docs` to check current endpoint, authentication, policy, or field details when needed.
3. Use `x_api` for live X API calls only after the corresponding XMCP profile is running.
4. For reads, request only fields needed for the task and paginate deliberately.
5. For mutations, require an explicit request in the current user instruction that names the intended action and target/content. A draft request is not authorization to publish.
6. Report the performed operation and any API error without exposing credentials, authorization headers, or token material.

## XMCP Profiles

XMCP is an official local MCP server. It performs OAuth consent at startup and holds user tokens only in the running process.

- Use read profile by default: `python3 ~/.codex/skills/x-api/scripts/xmcp.py serve --profile read`.
- Use write profile only for an explicitly requested state-changing task: `python3 ~/.codex/skills/x-api/scripts/xmcp.py serve --profile write`.
- If the server is not installed or credentials are not configured, read [references/setup.md](references/setup.md) and guide the user through local setup without requesting secrets in chat.
- If only documentation or integration design is needed, use `x_docs`; no XMCP login is necessary.

## Mutation Guardrails

Treat these as mutations requiring explicit immediate user intent: create/delete posts, replies, DMs, likes, reposts, follows, mutes/blocks, list changes, bookmarks, media uploads, and any account-setting or relationship update.

- Do not perform unsolicited mentions, replies, or DMs.
- Do not automate likes, bulk follows, engagement manipulation, spam, or trend manipulation.
- Do not deploy AI-generated replies or similar automated engagement without checking current X approval requirements.
- Do not use X data for prohibited training, surveillance, sensitive-attribute inference, or unauthorized off-X matching.
- Do not scrape X or automate a browser to access X data; use the API only.

Read [references/policy.md](references/policy.md) before planning automation, bulk retrieval/redistribution, DMs, replies, engagement actions, AI-generated content, or storage of X data.

## Secrets And Output

- Never ask the user to paste X credentials into chat.
- Never read credentials aloud, print `.env` content, enable token/header debugging, or include tokens in commands, logs, patches, or committed files.
- Use the external XMCP credential file described in setup; the launcher blocks token/header print flags and local checkout `.env` overrides.
- Preserve X attribution and deletion/compliance obligations when presenting or storing retrieved content.

## Current Sources

Prefer live official sources because X capabilities and policies can change:

- `https://docs.x.com/tools/ai`
- `https://docs.x.com/tools/mcp`
- `https://docs.x.com/skill.md`
- `https://docs.x.com/fundamentals/authentication/overview`
- `https://docs.x.com/developer-guidelines`

