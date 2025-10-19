-- lua/plugins/ai.lua
--
-- Plugin specification for the AI integration.
-- This file defines the necessary plugins (CodeCompanion and its dependencies)
-- and wires them into the refactored AI module.

return {
	-- Core AI plugin for chat and actions
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim",
		},
		config = function()
			-- The main `ai` module handles setup and state.
			-- We just need to set up the keymaps here.
			local ai = require("ai")
			ai.keymaps.setup()
		end,
	},

	-- Optional: Markdown rendering for a better reading experience
	{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" }, opts = {} },
	{ "preservim/vim-markdown", ft = { "markdown" } },
}
