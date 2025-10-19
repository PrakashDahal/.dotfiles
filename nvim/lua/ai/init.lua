-- lua/ai/init.lua
---@diagnostic disable: E5108
--
-- Main AI module for state management and setup.
-- This module initializes the AI state, provides default configurations,
-- and glues together the other modules (adapters, picker, terminals, keymaps).
-- It exposes the public API for interacting with the AI features.

local M = {}

-- Default configuration values.
-- These can be overridden by the user if needed.
M.defaults = {
	openai_model = "gpt-5-mini",
	local_model = "deepseek-coder:1.3b",
	openai_stream = false, -- Set to false to disable streaming for OpenAI
}

-- Global state for the AI module.
-- This table holds the currently active adapter and model.
-- It is updated by the model picker.
M.state = {
	adapter = "openai", -- "openai" or "local"
	model = M.defaults.openai_model,
}

-- Forward-declare modules that will be loaded later.
M.adapters = require("ai.adapters")
M.picker = require("ai.picker")
M.terminals = require("ai.terminals")
M.keymaps = require("ai.keymaps")

--- Docks the CodeCompanion chat window to a specified side.
-- @param side string "left" or "right"
local function _dock_chat(side)
	vim.schedule(function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype == "codecompanion" then
				vim.api.nvim_set_current_win(win)
				vim.cmd(side == "right" and "wincmd L" or "wincmd H")
				break
			end
		end
	end)
end

--- Generates the configuration table for CodeCompanion.
-- This function builds the dynamic configuration based on the current `M.state`.
-- It sets up the correct adapter, model, and view options.
-- @param position string The position for the chat window (e.g., "right").
-- @return table The CodeCompanion configuration table.
function M.setup_codecompanion(position)
	position = position or "right" -- Default to "right" if not provided
	-- Set up adapters based on current state
	M.adapters.setup_adapters(M.state.model, M.state.model)

	local title = string.format("— %s — %s", string.upper(M.state.adapter), M.state.model)

	return {
		-- Use the active adapter for both chat and inline strategies
		strategies = {
			chat = { adapter = M.state.adapter },
			inline = { adapter = M.state.adapter, enabled = true },
		},
		-- Provide the adapter definitions
		adapters = M.adapters.get_all_adapters(),
		-- Override keymaps and view options
		strategies_overrides = {
			chat = {
				keymaps = {
					send = { modes = { n = "<CR>", i = "<CR>" } },
					new_line = { modes = { i = "<S-CR>" } },
					close = { modes = { n = "q", i = "<C-c>" } },
				},
				view = {
					title = title,
					position = position,
				},
			},
		},
	}
end

--- Opens the CodeCompanion chat window.
-- It configures CodeCompanion with the current state and docks the window.
function M.chat()
	require("codecompanion").setup(M.setup_codecompanion("left"))
	vim.cmd("CodeCompanionChat")
	_dock_chat("left")
end

return M
