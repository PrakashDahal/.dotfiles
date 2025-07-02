-- return {
-- 	{
-- 		"Exafunction/codeium.nvim",
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 			"hrsh7th/nvim-cmp",
-- 		},
-- 		event = "InsertEnter", -- Load Codeium when entering insert mode
-- 		config = function()
-- 			require("lua.plugins.ai").setup({
-- 				enable_cmp_source = true,
-- 				virtual_text = {
-- 					enable = true,
-- 				},
-- 				-- Optional: Customize Codeium settings here
-- 				-- workspace_root = {
-- 				--   use_lsp = true,
-- 				--   paths = { ".git", "package.json" },
-- 				-- },
-- 			})
-- 		end,
-- 	},
-- }

return {
	-- GitHub Copilot
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			-- Enable Copilot by default
			vim.g.copilot_enabled = 1
			vim.g.copilot_filetypes = {
				["*"] = true,
				["markdown"] = true,
				["yaml"] = true,
			}
		end,
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			window = {
				layout = "buffer",
				relative = "editor",
				width = 0.8,
				height = 0.8,
				row = 0.1,
				col = 0.1,
			},
			mappings = {
				close = { normal = "q", insert = "<C-c>" },
				reset = { normal = "<C-r>", insert = "<C-r>" },
				submit_prompt = { normal = "<CR>", insert = "<C-s>" },
			},
		},
	},

	-- Codeium
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		event = "InsertEnter",
		config = function()
			require("codeium").setup({
				enable_cmp_source = false, -- Disabled by default
				virtual_text = {
					enable = false,
				},
			})
		end,
	},

	-- Toggle Keybindings
	{
		"nvim-lua/plenary.nvim", -- Ensure plenary is available
		config = function()
			local ai = require("ai")
			-- Toggle between Copilot and Codeium
			vim.keymap.set("n", "<Leader>ai", ai.toggle_ai, { desc = "Toggle Copilot/Codeium" })
			-- Open chat for active AI
			vim.keymap.set("n", "<Leader>cc", ai.open_chat, { desc = "Open AI Chat" })

			vim.keymap.set("n", "<Leader>as", function()
				vim.notify("Active AI: " .. ai.active_ai, vim.log.levels.INFO)
			end, { desc = "Check Active AI" })
		end,
	},
}
