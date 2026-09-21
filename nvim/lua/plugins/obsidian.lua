return {
	"epwalsh/obsidian.nvim",
	version = "3.7.10",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "notes",
				path = "~/Documents/notes",
			},
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
	},
	config = function(_, opts)
		require("obsidian").setup(opts)
		vim.keymap.set("n", "gd", "<cmd>ObsidianFollowLink<CR>", { desc = "Follow obsidian link" })
		vim.keymap.set("n", "gO", "<cmd>ObsidianBacklinks<CR>", { desc = "Show backlinks" })
		vim.keymap.set("n", "go", "<cmd>ObsidianOutline<CR>", { desc = "Show outline" })
	end,
}
