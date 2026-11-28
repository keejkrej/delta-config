# Delta config

Configure the delegation settings and subagent profiles in Delta. Install the personal rules separately.

## Orchestration

The primary agent mirrors OpenCode's `build` agent: it plans, delegates, and verifies without editing files or running shell commands. It delegates implementation to `worker`, research to `scout`, and independent review to `reviewer`.

`scout`'s read-only limit is a prompt restriction, not a sandbox: `scout` has terminal access, but its profile prompt and delegated tasks forbid creating, editing, or deleting files, side-effecting shell commands, tests, builds, and formatters, and limit the terminal to read-only inspection and read-only Git commands.

Set **Settings → Subagents → Delegation** to **Max** so Delta does not require an explicit request before delegating. Keep **Settings → Subagents → Allow Model Overrides** off so a parent turn's per-spawn model choice does not replace the configured profile models; that switch covers the per-spawn case only.

When moving to another machine with the same Delta account, check the subagent profiles first: profile settings normally sync. If you're using another Delta account or the overrides are missing, sign in to ChatGPT Subscription in Delta and open **Settings → Subagents → Provider Overrides**, then **LLM Providers → ChatGPT Subscription → Model Preferences**. Set `worker` and `scout` to GPT-6.2-Sol and `reviewer` to GPT-6.2-Astra, all with **Medium** thinking.

Alternatively, ask the Delta desktop agent to use `delta_settings` to apply only the three ChatGPT Subscription overrides in [`subagent-overrides.json`](subagent-overrides.json), leaving other profile fields and providers unchanged. The JSON is a reference, not a file to copy into Delta's settings directory.

Isolated subthreads require an explicit merge into the parent, so [`AGENTS.md`](AGENTS.md) makes the orchestrator pull worker changes before reviewing them.

## Agent prompt

[`AGENTS.md`](AGENTS.md) carries the same Ambient memory instructions as the sibling configs and the orchestration workflow. Install it to make Delta load it in local desktop turns across projects:

- macOS or Linux: `sh ./install.sh`
- Windows PowerShell: `.\install.ps1`

The installers use the stable Delta rules directory, or `DELTA_CONFIG_DIR` if set. For a dev build, point `DELTA_CONFIG_DIR` at the folder Delta lists in **Settings → Thread → Rules → Personal AGENTS.md** before running the installer. If you already have rules from this repository installed, merge the updated orchestration block into that file. Otherwise, merge the prompt into any existing rules rather than replacing them. Keep **Personal AGENTS.md** enabled and check that Delta shows the expected file path. The Ambient tools also need the [MCP connection](#mcp) below.

## Vercel AI Gateway

[`vercel-ai-gateway.json`](vercel-ai-gateway.json) is a reference for the provider fields. It is not an installer input or a file to copy into Delta's settings directory, and it does not change default models or subagent profiles.

1. In Delta desktop's **Settings → LLM Providers**, open **Vercel AI Gateway** if it already exists. Otherwise choose **Add Provider** to configure a [compatible endpoint](https://delta.dev/docs/agents/models-and-providers#connect-a-compatible-endpoint).
2. Use the name and base API URL in the JSON. Set **API mode** to [**OpenAI Chat Completions**](https://vercel.com/docs/ai-gateway/sdks-and-apis/openai-chat-completions).
3. Enter a [Vercel AI Gateway API key](https://vercel.com/docs/ai-gateway/authentication-and-byok/api-keys) in Delta's **API key** field only; never put it in this repository or the reference JSON.
4. Add the models from the JSON if they aren't already listed. Check each model's **ID**, **Maximum tokens** (context window), and **Maximum output tokens** against the file. Use the Gateway IDs as written, without OpenCode's `vercel/` prefix.
5. Save the provider, select a model in the composer, and send a test prompt. The historical OpenCode choices were Kimi K3.1 Pro for primary work and reviews, and DeepSeek V4.1 Flash for worker and scout tasks; these are not Delta defaults.

## Z.ai Coding Plan

[`zai-coding-plan.json`](zai-coding-plan.json) is a reference for the provider fields, mirroring the live Delta configuration. It is not an installer input or a file to copy into Delta's settings directory, and it does not change default models or subagent profiles.

Z.ai limits Coding Plan use to [officially supported tools](https://docs.z.ai/devpack/tool/others), and Delta is not listed. Confirm that Z.ai permits use with Delta before entering a plan API key or sending a test prompt. Authenticated compatibility is untested; this reference does not establish official support.

1. In **Settings → LLM Providers**, open **Z.ai Coding Plan** if it already exists. Otherwise choose **Add Provider → OpenAI-compatible**.
2. Use the name and base API URL in the JSON. Set the API mode to **Chat Completions** (OpenAI Chat Completions), not Responses or Anthropic Messages.
3. Follow the [Z.ai Coding Plan quick start](https://docs.z.ai/devpack/quick-start) to obtain the matching Coding Plan API key: **Plan Overview** for a personal plan, or **My Plan** for a team plan. Enter the key in Delta's **API key** field only; never put it in this repository or the reference JSON.
4. Add the models from the JSON if they aren't already listed. Check each model's ID, context window, and maximum output tokens against the file and the [Models.dev Z.ai Coding Plan listing](https://models.dev/providers/zai-coding-plan/). No reasoning-effort values are specified, matching the live configuration.

## MCP

[`mcp.json`](mcp.json) mirrors all four entries from `opencode-config`: Paper, Ambient, Mobbin, and Browse. It keeps the original commands, endpoint, and options.

Delta does not load this file today. Its [current MCP support](https://delta.dev/docs/agents/mcp) is limited to remote HTTPS servers. If Delta adds local MCP support, use the saved values here; the file format may still need to be adapted to what Delta accepts.
