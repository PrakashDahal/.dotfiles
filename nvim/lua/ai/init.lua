-- lua/ai/init.lua
--
-- Main AI module. Avante replaces CodeCompanion.
--
-- Responsibilities:
--   - Holds global state: active provider + model
--   - Builds avante config using the NEW providers.* structure
--   - Exposes setup(), reconfigure() for model switching
--   - Wires together: context, keymaps sub-modules

local M = {}

-- ── Curated model menu ────────────────────────────────────────────────────────
-- Edit this table to add/remove models.
-- Format: display_label = { provider = "...", model = "..." }
M.model_menu = {
	["GPT-4o                 (OpenAI • Best)"] = { provider = "openai", model = "gpt-4o" },
	["GPT-4o-mini            (OpenAI • Fast)"] = { provider = "openai", model = "gpt-4o-mini" },
	["Claude Sonnet 4.5      (Anthropic • Reasoning)"] = { provider = "claude", model = "claude-sonnet-4-5-20251001" },
	["Claude Haiku 4.5       (Anthropic • Fast)"] = { provider = "claude", model = "claude-haiku-4-5-20251001" },
	["Deepseek Coder 6.7b    (Local • Coding)"] = { provider = "ollama", model = "deepseek-coder:6.7b" },
	["Llama 3.2 3b           (Local • Fast Chat)"] = { provider = "ollama", model = "llama3.2:3b" },
}

-- ── Global state ──────────────────────────────────────────────────────────────
M.state = {
	provider = "openai",
	model = "gpt-4o",
}

-- ── Sub-modules ───────────────────────────────────────────────────────────────
M.context = require("ai.context")
M.keymaps = require("ai.keymaps")

-- ── Build avante config from current M.state ─────────────────────────────────
--
-- Uses the NEW avante providers.* structure (post-migration).
-- All providers go under `providers`, all request body fields
-- (temperature, max_tokens) go under `providers.<n>.extra_request_body`.
function M.build_avante_config()
	local state = M.state

	return {
		-- ── Active provider ────────────────────────────────────────────────────
		provider = state.provider,

		-- ── All providers under providers.* (new structure) ───────────────────
		providers = {

			openai = {
				endpoint = "https://api.openai.com/v1",
				model = (state.provider == "openai") and state.model or "gpt-4o",
				timeout = 30000,
				extra_request_body = {
					temperature = 0,
					max_tokens = 4096,
				},
			},

			claude = {
				endpoint = "https://api.anthropic.com",
				model = (state.provider == "claude") and state.model or "claude-sonnet-4-5-20251001",
				timeout = 30000,
				extra_request_body = {
					temperature = 0,
					max_tokens = 4096,
				},
			},

			-- Ollama runs locally — no API key needed.
			-- api_key_name points to a dummy env var; avante requires the field
			-- but ollama itself ignores it.
			ollama = {
				__inherited_from = "openai",
				endpoint = "http://127.0.0.1:11434/v1",
				model = (state.provider == "ollama") and state.model or "deepseek-coder:6.7b",
				timeout = 60000,
				api_key_name = "OLLAMA_API_KEY",
				extra_request_body = {
					temperature = 0,
					max_tokens = 2048,
				},
			},
		},

		-- ── Behaviour ──────────────────────────────────────────────────────────
		behaviour = {
			auto_suggestions = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = true,
			support_paste_from_clipboard = true,
			minimize_diff = true,
		},

		-- ── Sidebar window ─────────────────────────────────────────────────────
		windows = {
			position = "right",
			wrap = true,
			width = 38,
			sidebar_header = {
				enabled = true,
				align = "center",
				rounded = true,
			},
			input = {
				prefix = "> ",
			},
			edit = {
				border = "rounded",
				start_insert = true,
			},
			ask = {
				floating = false,
				start_insert = true,
				border = "rounded",
				focus_on_apply = "theirs",
			},
		},

		-- ── Diff view ──────────────────────────────────────────────────────────
		diff = {
			autojump = true,
			list_opener = "copen",
			override_timeoutlen = 500,
		},
	}
end

-- ── Setup (called once from plugins/ai.lua) ───────────────────────────────────
function M.setup()
	require("avante").setup(M.build_avante_config())
	M.keymaps.setup()
end

-- ── Reconfigure avante at runtime (called after model switch) ─────────────────
function M.reconfigure()
	local ok, err = pcall(function()
		require("avante").setup(M.build_avante_config())
	end)
	if not ok then
		vim.notify("Failed to switch model: " .. tostring(err), vim.log.levels.ERROR, { title = "AI" })
	end
end

return M
