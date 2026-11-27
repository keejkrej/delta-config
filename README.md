# Delta config

Configure the delegation settings and subagent profiles in Delta. Install the personal rules separately.

## Orchestration

The primary agent mirrors OpenCode's `build` agent: it plans, delegates, and verifies without editing files or running shell commands. It delegates implementation to `worker`, research to `scout`, and independent review to `reviewer`.

`scout`'s read-only limit is a prompt restriction, not a sandbox: `scout` has terminal access, but its profile prompt and delegated tasks forbid creating, editing, or deleting files, side-effecting shell commands, tests, builds, and formatters, and limit the terminal to read-only inspection and read-only Git commands.

Set **Settings → Subagents → Delegation** to **Max** so Delta does not require an explicit request before delegating. Keep **Settings → Subagents → Allow Model Overrides** off so a parent turn's per-spawn model choice does not replace the configured profile models; that switch covers the per-spawn case only.

The Vercel AI Gateway defaults are DeepSeek V4.1 Flash for `worker` and `scout` and Kimi K3.1 Pro for `reviewer`, matching `opencode-config`. Provider-specific model choices are preserved and take precedence over those defaults, so an existing ChatGPT Subscription override keeps its own model and not every profile necessarily runs on its gateway default.

Isolated subthreads require an explicit merge into the parent, so [`AGENTS.md`](AGENTS.md) makes the orchestrator pull worker changes before reviewing them.

## Agent prompt

[`AGENTS.md`](AGENTS.md) carries the same Ambient memory instructions as the sibling configs and the orchestration workflow. Install it to make Delta load it in local desktop turns across projects:

- macOS or Linux: `sh ./install.sh`
- Windows PowerShell: `.\install.ps1`

The installers use the stable Delta rules directory, or `DELTA_CONFIG_DIR` if set. For a dev build, point `DELTA_CONFIG_DIR` at the folder Delta lists in **Settings → Thread → Rules → Personal AGENTS.md** before running the installer. If you already have rules from this repository installed, merge the updated orchestration block into that file. Otherwise, merge the prompt into any existing rules rather than replacing them. Keep **Personal AGENTS.md** enabled and check that Delta shows the expected file path. The Ambient tools also need the [MCP connection](#mcp) below.

## Vercel AI Gateway

1. In **Settings → LLM Providers**, open **Vercel AI Gateway** if it already exists. Otherwise choose **Add Provider → OpenAI-compatible**.
2. Use the name and base API URL in [`vercel-ai-gateway.json`](vercel-ai-gateway.json). Set the API mode to **Chat Completions**. The JSON is a reference for the provider fields, not a file to copy into Delta's settings directory.
3. Enter a [Vercel AI Gateway API key](https://vercel.com/docs/ai-gateway/authentication-and-byok/api-keys) in Delta's **API key** field.
4. Add the models from the JSON if they aren't already listed. Check each model's ID, context window, and maximum output tokens against the file. Use the Gateway IDs as written, without OpenCode's `vercel/` prefix.
5. Save, pick a model in the composer, and send a test prompt. To mirror the OpenCode model choices, use Kimi K3.1 Pro for primary work and reviews, and DeepSeek V4.1 Flash for worker tasks.

## MCP

[`mcp.json`](mcp.json) mirrors all four entries from `opencode-config`: Paper, Ambient, Mobbin, and Browse. It keeps the original commands, endpoint, and options.

Delta does not load this file today. Its [current MCP support](https://delta.dev/docs/agents/mcp) is limited to remote HTTPS servers. If Delta adds local MCP support, use the saved values here; the file format may still need to be adapted to what Delta accepts.
