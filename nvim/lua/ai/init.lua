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
	["GPT-4.1                 (OpenAI • Best)"] = { provider = "openai", model = "gpt-4.1" },
	["GPT-5-mini            (OpenAI • Fast)"] = { provider = "openai", model = "gpt-5-mini" },
	["GPT-5-nano            (OpenAI • SuperFast)"] = { provider = "openai", model = "gpt-5-nano" },

	["Gemma 2b               (Local • Fast Small Model)"] = { provider = "ollama", model = "gemma:2b" },
	["Deepseek Coder 1.3b    (Local • Coding)"] = { provider = "ollama", model = "deepseek-coder:1.3b" },

	["Qwen3 Coder 480B    (OpenRouter • Free)"] = { provider = "openrouter", model = "qwen/qwen3-coder-480b-a35b:free" },
	["DeepSeek R1         (OpenRouter • Free)"] = { provider = "openrouter", model = "deepseek/deepseek-r1:free" },
	["Llama 3.3 70B       (OpenRouter • Free)"] = {
		provider = "openrouter",
		model = "meta-llama/llama-3.3-70b-instruct:free",
	},
	["Auto (Best Free)    (OpenRouter • Free)"] = { provider = "openrouter", model = "openrouter/auto" },

	-- ["Llama 3.3 70b          (Groq • Free + Fast)"] = { provider = "groq", model = "llama-3.3-70b-versatile" },
	-- ["Mixtral 8x7b           (Groq • Free)"] = { provider = "groq", model = "mixtral-8x7b-32768" },
	["Gemini 2.5 Flash    (Google • Free)"] = { provider = "gemini", model = "gemini-2.5-flash" },
	["Gemini 2.5 Pro      (Google • Free)"] = { provider = "gemini", model = "gemini-2.5-pro" },

	["Claude Haiku 4.5       (Anthropic • Fast)"] = { provider = "claude", model = "claude-haiku-4-5-20251001" },
	["Claude Sonnet 4.5      (Anthropic • Reasoning)"] = { provider = "claude", model = "claude-sonnet-4-5-20251001" },
}

-- ── Global state ──────────────────────────────────────────────────────────────
M.state = {
	provider = "openai",
	model = "gpt-5-nano",
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

			openrouter = {
				__inherited_from = "openai",
				endpoint = "https://openrouter.ai/api/v1",
				model = (state.provider == "openrouter") and state.model or "qwen/qwen3-coder-480b-a35b:free",
				timeout = 60000,
				api_key_name = "OPENROUTER_API_KEY",
				extra_request_body = {
					temperature = 0,
					max_tokens = 4096,
				},
			},

			groq = {
				__inherited_from = "openai",
				endpoint = "https://api.groq.com/openai/v1",
				model = (state.provider == "groq") and state.model or "llama-3.3-70b-versatile",
				timeout = 30000,
				api_key_name = "GROQ_API_KEY",
				extra_request_body = {
					temperature = 0,
					max_tokens = 32768,
				},
			},

			gemini = {
				__inherited_from = "openai",
				endpoint = "https://generativelanguage.googleapis.com/v1beta/openai/",
				model = (state.provider == "gemini") and state.model or "gemini-2.5-flash",
				timeout = 60000,
				api_key_name = "GEMINI_API_KEY",
				extra_request_body = {
					temperature = 0,
					max_tokens = 8192,
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
