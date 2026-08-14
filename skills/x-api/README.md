# X API Skill for Codex

This skill gives Codex access to official X Developer Platform documentation and,
when explicitly enabled, live X API operations through the official
[XMCP](https://github.com/xdevplatform/xmcp) server.

It is intended for:

- Reading posts, users, timelines, lists, spaces, trends, news, bookmarks, and analytics.
- Answering X API integration questions from current official documentation.
- Performing specifically requested account actions, such as posting or replying, in a guarded write session.

It does not use browser scraping to retrieve X content.

## Architecture

| Component | Purpose | Endpoint or path |
| --- | --- | --- |
| `x_docs` MCP | Current official X API documentation | `https://docs.x.com/mcp` |
| XMCP | Official local server for live X API tools | `http://127.0.0.1:8000/mcp` |
| `scripts/xmcp.py` | Installs, validates, and starts XMCP with guarded profiles | This skill directory |
| Credential file | Keeps X secrets outside the repo | `~/.config/x-api/xmcp.env` |
| XMCP checkout | Pinned upstream runtime installation | `~/.local/share/x-api/xmcp` |

The launcher pins XMCP to a reviewed upstream revision, prevents token/header
debug output, refuses checkout-local `.env` overrides, and provides separate
read and write tool profiles.

## Prerequisites

- A Codex installation that supports MCP servers and skills.
- An X Developer Platform account with access to the
  [Developer Console](https://console.x.com/).
- Python 3 and Git available locally.

## Install The Skill

When working from this skill directory, link it into the Codex skills folder:

```bash
mkdir -p ~/.codex/skills
ln -sfn "$PWD" ~/.codex/skills/x-api
```

Register the documentation and local live-operation MCP servers in
`~/.codex/config.toml`:

```toml
[mcp_servers.x_docs]
url = "https://docs.x.com/mcp"

[mcp_servers.x_api]
url = "http://127.0.0.1:8000/mcp"
enabled = false
```

`x_api` is intentionally disabled by default. Leave it disabled until XMCP is
running locally, so ordinary Codex sessions do not attempt to connect to a
server that is not active.

## Install XMCP

Run the guarded installer:

```bash
python3 ~/.codex/skills/x-api/scripts/xmcp.py install
```

The installer:

1. Clones the official XMCP repository into `~/.local/share/x-api/xmcp`.
2. Pins it to the revision expected by this skill.
3. Creates an isolated virtual environment and installs its dependencies.
4. Creates `~/.config/x-api/xmcp.env` with permission mode `0600`.

The credential file initially contains placeholders:

```dotenv
X_OAUTH_CONSUMER_KEY=
X_OAUTH_CONSUMER_SECRET=
X_BEARER_TOKEN=
```

Do not put these values in the skill directory, a tracked repository, chat, or
shell history.

## Create A Dedicated X App

Use a dedicated app for Codex/XMCP rather than reusing credentials from another
integration.

1. Open the [X Developer Console](https://console.x.com/) and go to **Apps**.
2. Click **Create App**.
3. Choose the **Development** environment.
4. Give the app an identifiable name, for example `Codex XMCP`.
5. Create the app.
6. On the one-time credential screen, securely store these values in
   `~/.config/x-api/xmcp.env`:

```dotenv
X_OAUTH_CONSUMER_KEY=<Consumer Key>
X_OAUTH_CONSUMER_SECRET=<Secret Key>
X_BEARER_TOKEN=<Bearer Token>
```

X displays the initial credentials only once. Keep the credential file private:

```bash
chmod 600 ~/.config/x-api/xmcp.env
```

## Configure User Authentication

XMCP uses OAuth 1.0a user authorization when it starts. Configure the dedicated
app before launching XMCP:

1. Open the newly created app in the Developer Console.
2. Under **User authentication settings**, click **Set up**.
3. Select **Read and write** for app permissions.
4. Do not enable Direct Messages unless a specific use case requires it.
5. Select **Web App, Automated App or Bot** as the app type.
6. Set the callback URI exactly to:

```text
http://127.0.0.1:8976/oauth/callback
```

7. Set the website URL to an appropriate identifier for the integration, for
   example:

```text
https://github.com/xdevplatform/xmcp
```

8. Save changes.

The console may display OAuth 2.0 client credentials after saving this form.
XMCP uses the OAuth 1.0 consumer key, consumer secret, and bearer token stored
earlier; no OAuth 2.0 client values are required for this skill.

## Validate Setup

Run the safe diagnostic command:

```bash
python3 ~/.codex/skills/x-api/scripts/xmcp.py doctor
```

Expected output confirms:

- The official XMCP checkout is installed at the pinned revision.
- The credential file has mode `0600`.
- All required credential variables are configured.

The command never prints credential values.

Complete the live smoke test after starting the read-profile server below:
invoke `$x-api` in Codex to retrieve a known public post URL. This verifies
OAuth and live API access without placing bearer-token material in a terminal
command.

## Start A Read Session

Read mode is the default for post lookup, search, and analysis:

```bash
python3 ~/.codex/skills/x-api/scripts/xmcp.py serve --profile read
```

XMCP will open X in a browser for OAuth authorization at startup. Approve access
for the dedicated app, then keep the server process running while Codex uses X
tools.

Once XMCP is running, enable `x_api` for the Codex session by changing the
configured MCP entry to:

```toml
[mcp_servers.x_api]
url = "http://127.0.0.1:8000/mcp"
enabled = true
```

Restart or reload the Codex session as needed for MCP configuration changes to
take effect. Disable `x_api` again when no XMCP process is running.

The read profile exposes only lookup and search operations. It is the correct
default even if the app itself has read/write authorization.

## Start A Write Session

Use write mode only for a user-requested account mutation such as creating a
post, replying, liking, reposting, following, messaging, or deleting:

```bash
python3 ~/.codex/skills/x-api/scripts/xmcp.py serve --profile write
```

Write capability in the X app does not authorize autonomous action. Each
mutation still requires explicit current user intent identifying the action
and its target or content.

## Troubleshooting

### `doctor` reports missing credentials

Populate all three required variables in `~/.config/x-api/xmcp.env`. Do not
paste them into a chat prompt or store them in repository files.

### `doctor` reports unsafe permissions

Repair the local credential file mode:

```bash
chmod 600 ~/.config/x-api/xmcp.env
```

### OAuth callback fails

Confirm the X app callback matches exactly:

```text
http://127.0.0.1:8976/oauth/callback
```

Also confirm that another local process is not already occupying the callback
or MCP ports.

### Codex cannot connect to `x_api`

Confirm that:

1. `python3 ~/.codex/skills/x-api/scripts/xmcp.py serve --profile read` is still running.
2. `x_api` is enabled in the active Codex configuration.
3. The MCP endpoint remains `http://127.0.0.1:8000/mcp`.

### Only documentation is needed

Use `x_docs` without starting XMCP or enabling `x_api`. Documentation queries
do not require X account authorization.

## Security And Policy

- Never print, disclose, commit, or paste credential values into chat.
- Prefer `--profile read`; enable `--profile write` only for an explicitly requested action.
- Use the official API for X content, not browser automation or scraping.
- Re-check current X policy before automated posting, replies, DMs, bulk collection, or stored redistribution.
- Preserve attribution and comply with deletion and retention obligations when storing X data.

## Files In This Skill

| File | Purpose |
| --- | --- |
| `SKILL.md` | Operational instructions Codex follows when the skill is invoked |
| `scripts/xmcp.py` | Pinned installation, safety checks, and guarded XMCP startup |
| `references/setup.md` | Concise setup reference used during operation |
| `references/policy.md` | Mutation, automation, and data-handling guardrails |
| `agents/openai.yaml` | Skill UI metadata and MCP dependency declarations |

## Official References

- [X Developer Documentation](https://docs.x.com/)
- [X authentication overview](https://docs.x.com/fundamentals/authentication/overview)
- [X MCP guide](https://docs.x.com/tools/mcp)
- [X AI tools resources](https://docs.x.com/tools/ai)
- [Official XMCP repository](https://github.com/xdevplatform/xmcp)
- [X developer guidelines](https://docs.x.com/developer-guidelines)
