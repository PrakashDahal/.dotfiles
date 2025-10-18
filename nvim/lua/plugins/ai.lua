return {
	-- Niceties
	{ "nvim-lua/plenary.nvim" },
	{ "MunifTanjim/nui.nvim" },
	{ "stevearc/dressing.nvim", opts = {} },

	-- Primary chat/edit: CodeCompanion (OpenAI + Gemini via adapters.http)
	{
		"olimorris/codecompanion.nvim",
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionToggle" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim",
		},
		opts = function()
			-- Get config from our central ai module
			local ai_config = require("ai")
			return ai_config.get_codecompanion_config()
		end,
	},

	-- Fallback inline completion + chat: Codeium (free tier)
	{
		"jcdickinson/codeium.nvim",
		event = "InsertEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("codeium").setup({
				enable = true, -- keep inline suggestions on by default
				enable_cmp_source = false, -- if you use cmp source, set true
				virtual_text = { enable = true },
			})
		end,
	},

	-- Optional: markdown ergonomics (SRS in .md)
	{ "MeanderingProgrammer/render-markdown.nvim", opts = {} }, -- live MD render in the buffer
	{ "preservim/vim-markdown", ft = { "markdown" } },
	{ "dhruvasagar/vim-table-mode", ft = { "markdown" } },
	{ "numToStr/Comment.nvim", opts = {} }, -- better comments
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- Bindings to our controller (see next section)
	{
		"nvim-lua/plenary.nvim",
		config = function()
			local ai = require("ai")
			-- Chat / Edit
			vim.keymap.set("n", "<leader>cc", ai.chat_openai, { desc = "AI Chat (OpenAI, right)" })
			vim.keymap.set("n", "<leader>cg", ai.chat_gemini, { desc = "AI Chat (Gemini, left)" })
			vim.keymap.set({ "n", "v" }, "<leader>ce", ai.edit, { desc = "AI Edit/Actions (CodeCompanion)" })

			-- Model swap (OpenAI <-> Gemini) within CodeCompanion

			-- Inline suggestions on/off (Codeium)
			vim.keymap.set("n", "<leader>ci", ai.toggle_codeium, { desc = "Toggle Codeium Inline" })

			-- Status ping
			vim.keymap.set("n", "<leader>as", ai.status, { desc = "AI Status" })
		end,
	},
}