return {
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		event = "InsertEnter", -- Load Codeium when entering insert mode
		config = function()
			require("codeium").setup({
				enable_cmp_source = true,
				virtual_text = {
					enable = true,
				},
				-- Optional: Customize Codeium settings here
				-- workspace_root = {
				--   use_lsp = true,
				--   paths = { ".git", "package.json" },
				-- },
			})
		end,
	},
}
