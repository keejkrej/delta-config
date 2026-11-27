# Delta config

Apply the provider settings in Delta. Install the personal rules separately.

## Agent prompt

[`AGENTS.md`](AGENTS.md) carries the same Ambient memory instructions as the sibling configs, plus a review-before-done rule that respects Delta's delegation settings. Install it to make Delta load it in local desktop turns across projects:

- macOS or Linux: `sh ./install.sh`
- Windows PowerShell: `.\install.ps1`

The installers use the stable Delta rules directory, or `DELTA_CONFIG_DIR` if set. For a dev build, point `DELTA_CONFIG_DIR` at the folder Delta lists in **Settings → Thread → Rules → Personal AGENTS.md** before running the installer. If you already have a rules file, merge the new instructions into the file Delta shows rather than replacing it. Keep **Personal AGENTS.md** enabled and check that Delta shows the expected file path. The Ambient tools also need the [MCP connection](#mcp) below.

## Vercel AI Gateway

1. In **Settings → LLM Providers**, open **Vercel AI Gateway** if it already exists. Otherwise choose **Add Provider → OpenAI-compatible**.
2. Use the name and base API URL in [`vercel-ai-gateway.json`](vercel-ai-gateway.json). Set the API mode to **Chat Completions**. The JSON is a reference for the provider fields, not a file to copy into Delta's settings directory.
3. Enter a [Vercel AI Gateway API key](https://vercel.com/docs/ai-gateway/authentication-and-byok/api-keys) in Delta's **API key** field.
4. Add the models from the JSON if they aren't already listed. Check each model's ID, context window, and maximum output tokens against the file. Use the Gateway IDs as written, without OpenCode's `vercel/` prefix.
5. Save, pick a model in the composer, and send a test prompt. To mirror the OpenCode model choices, use Kimi K3.1 Pro for primary work and reviews, and DeepSeek V4.1 Flash for worker tasks.

## MCP

[`mcp.json`](mcp.json) mirrors all four entries from `opencode-config`: Paper, Ambient, Mobbin, and Browse. It keeps the original commands, endpoint, and options.

Delta does not load this file today. Its [current MCP support](https://delta.dev/docs/agents/mcp) is limited to remote HTTPS servers. If Delta adds local MCP support, use the saved values here; the file format may still need to be adapted to what Delta accepts.
