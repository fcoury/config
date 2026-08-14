# XMCP Setup

Use this reference when `x_api` is unavailable, the user wants local installation, or authentication/server startup needs diagnosis.

## Components

- Docs MCP: `https://docs.x.com/mcp`; hosted documentation lookup, no X account login needed.
- XMCP: official server from `https://github.com/xdevplatform/xmcp`; local operations endpoint at `http://127.0.0.1:8000/mcp`.
- Launcher: `scripts/xmcp.py`; pins the verified official checkout, keeps credentials outside the repository, and selects read or write tools.

XMCP excludes stream and webhook endpoints. Use official SDK guidance from Docs MCP for applications that need persistent streams or webhooks.

## Install

Run from the discovered skill path:

```bash
python3 ~/.codex/skills/x-api/scripts/xmcp.py install
```

Defaults:

| Item | Path |
| --- | --- |
| XMCP checkout | `~/.local/share/x-api/xmcp` |
| Credentials | `~/.config/x-api/xmcp.env` |
| MCP endpoint | `http://127.0.0.1:8000/mcp` |

Override runtime locations only when needed with `X_API_XMCP_HOME` and `X_API_XMCP_ENV`.

## Configure Credentials

The installer creates the credential file with mode `0600` if it does not exist. Populate it locally from the X Developer Console; do not ask for values in chat or put them in tracked files.

Required variables:

```dotenv
X_OAUTH_CONSUMER_KEY=
X_OAUTH_CONSUMER_SECRET=
X_BEARER_TOKEN=
```

Register this callback URL in the X Developer App unless the external credential file overrides its host, port, or path:

```text
http://127.0.0.1:8976/oauth/callback
```

## Start The Server

For lookup, search, and analysis work, launch read mode:

```bash
python3 ~/.codex/skills/x-api/scripts/xmcp.py serve --profile read
```

For one explicitly requested account mutation session, launch write mode:

```bash
python3 ~/.codex/skills/x-api/scripts/xmcp.py serve --profile write
```

Startup opens the browser for OAuth consent. Leave the server running while using its tools; tokens remain in that process only. Enable the configured `x_api` MCP server for the relevant Codex session after launching XMCP.

## Diagnose

```bash
python3 ~/.codex/skills/x-api/scripts/xmcp.py doctor
python3 ~/.codex/skills/x-api/scripts/xmcp.py serve --profile read --dry-run
```

`doctor` checks installation, the pinned upstream revision, credential presence and permission bits, and reserved configuration safety without printing values. The launcher refuses an XMCP checkout containing `.env`, because the official server would load it after launcher safeguards.

## Official Sources

- Agent resources: `https://docs.x.com/tools/ai`
- MCP server guide: `https://docs.x.com/tools/mcp`
- XMCP source: `https://github.com/xdevplatform/xmcp`
- Authentication: `https://docs.x.com/fundamentals/authentication/overview`

