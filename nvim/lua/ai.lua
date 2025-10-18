local M = {}

local function _dock_chat(side)
	-- run after CodeCompanion creates its window
	vim.schedule(function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.bo[buf].filetype
			if ft == "codecompanion" then
				vim.api.nvim_set_current_win(win)
				-- put at far right or far left
				if side == "right" then
					vim.cmd("wincmd L")
				else
					vim.cmd("wincmd H")
				end
				break
			end
		end
	end)
end

-- ===== Config knobs you can change =====
local OPENAI_MODEL = "gpt-4o-mini" -- set your preferred OpenAI model here
local GEMINI_MODEL = "gemini-2.5-pro" -- set your preferred Gemini model here
-- ======================================

-- Default to OpenAI; you can switch with M.switch_model()
M.active_adapter = "openai"

-- Centralized CodeCompanion adapters (new http.* syntax)
M.adapters = {
	http = {
		-- OpenAI (reads the key from env var named below)
		openai = function()
			return require("codecompanion.adapters").extend("openai", {
				env = {
					-- IMPORTANT: this is the *name* of your env var; CodeCompanion will read $OPEN_API_KEY
					api_key = "OPEN_API_KEY",
					-- If you use a custom base, uncomment and set the env var name (not the value):
					-- base = "OPENAI_BASE",
				},
				schema = {
					model = { default = OPENAI_MODEL },
				},
				opts = {
					stream = true,
					-- Ensure /v1/chat/completions to get a response with `choices`
					endpoint = "/v1/chat/completions",
				},
			})
		end,

		-- Gemini (reads the key from env var named below)
		gemini = function()
			return require("codecompanion.adapters").extend("gemini", {
				env = {
					api_key = "GEMINI_API_KEY",
				},
				schema = {
					model = { default = GEMINI_MODEL },
				},
				opts = { stream = true },
			})
		end,

		-- Global HTTP opts
		opts = {
			timeout = 30000,
			show_model_choices = false,
		},
	},
}

-- Make <CR> send in chat, <S-CR> newline
M.strategies_overrides = {
	chat = {
		keymaps = {
			send = { modes = { n = "<CR>", i = "<CR>" } },
			new_line = { modes = { i = "<S-CR>" } },
			close = { modes = { n = "q", i = "<C-c>" } },
		},
	},
}

-- Build CodeCompanion config using current adapter
function M.get_codecompanion_config(position)
	local overrides = vim.deepcopy(M.strategies_overrides)
	overrides.chat.view = {
		title = M.active_adapter == "openai" and "---- OPEN API -----" or "----- GEMINI -----",
		position = position,
	}
	return {
		strategies = {
			chat = { adapter = M.active_adapter },
			inline = { adapter = M.active_adapter }, -- enable if you want inline edits
		},
		adapters = M.adapters,
		strategies_overrides = overrides,
	}
end
-- Chat with OpenAI (right)
function M.chat_openai()
	M.active_adapter = "openai"
	require("codecompanion").setup(M.get_codecompanion_config("right"))
	vim.notify("Opening Chat with OpenAI on the right") -- Added notification
	vim.cmd("CodeCompanionChat")
	_dock_chat("right")
end

-- Chat with Gemini (left)
function M.chat_gemini()
	M.active_adapter = "gemini"
	require("codecompanion").setup(M.get_codecompanion_config("left"))
	vim.notify("Opening Chat with Gemini on the left") -- Added notification
	vim.cmd("CodeCompanionChat")
	_dock_chat("left")
end

-- Edit/Explain/Refactor (actions work on buffer/visual selection)
function M.edit()
	require("codecompanion").setup(M.get_codecompanion_config())
	vim.cmd("CodeCompanionActions")
end

-- Codeium inline toggle (fallback/free)
function M.toggle_codeium()
	vim.cmd("CodeiumToggle")
end

function M.status()
	local inline_status = "Off"
	local ok, codeium = pcall(require, "codeium")
	if ok and codeium.is_enabled() then
		inline_status = "Codeium"
	end
	vim.notify(string.format("Chat/Edit: %s • Inline: %s", M.active_adapter, inline_status), vim.log.levels.INFO)
end

return M
