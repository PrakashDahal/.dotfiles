-- lua/ai/keymaps.lua
--
-- Centralized keymap configuration for all AI features.
-- This module defines and sets all keybindings related to the AI integration,
-- ensuring they are simple, discoverable, and don't pollute other files.

local M = {}

--- Sets up all AI-related keymaps.
-- This function should be called from the plugin configuration.
function M.setup()
	local ai = require("ai")

	-- Chat
	vim.keymap.set("n", "<leader>cc", ai.chat, { desc = "AI Chat" })

	-- Model Picker
	vim.keymap.set("n", "<leader>am", function()
		require("ai.picker").pick_model()
	end, { desc = "AI: Select Model" })

	-- Actions (Edit/Explain/Refactor)
	vim.keymap.set({ "n", "v" }, "<leader>ce", function()
		require("codecompanion").setup(ai.setup_codecompanion())
		vim.cmd("CodeCompanionActions")
	end, { desc = "AI Edit/Actions" })

	-- Terminals
	vim.keymap.set("n", "<leader>ca", ai.terminals.toggle_aider, { desc = "AI Toggle Aider" })
	-- vim.keymap.set("n", "<leader>ct", ai.terminals.toggle_code_terminal, { desc = "AI Toggle Code Terminal" })

	-- Status
	vim.keymap.set("n", "<leader>as", function()
		vim.notify(string.format("AI Status: %s • %s", ai.state.adapter, ai.state.model))
	end, { desc = "AI Status" })
end

return M
