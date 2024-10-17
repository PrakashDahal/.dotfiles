return {
	"epwalsh/obsidian.nvim",
	version = "3.7.10", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			-- {
			-- 	name = "personal",
			-- 	path = "~/Documents/notes/personal",
			-- },
			-- {
			-- 	name = "business",
			-- 	path = "~/Documents/notes/business",
			-- },
			{
				name = "all",
				path = "~/Documents/notes",
			},
		},

		completion = {
			-- Set to false to disable completion.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},
	},
}
