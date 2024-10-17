return {
	"coffebar/neovim-project",
	opts = {
		projects = {
			"~/Documents/projects/prakashdahal.github.io/", -- Define your project roots
			"~/Documents/projects/tailwind-paid-components/",
			"~/Documents/HDD/myFiles/",
			"~/Documents/dotfiles/*",
			"~/Documents/HDD/TechEverest/*",
			"~/Documents/techEverest/Tech/*",

			-- "~/.config/*",
		},
		datapath = vim.fn.stdpath("data"), -- Path to store history and sessions
		last_session_on_startup = true, -- Load the most recent session on startup
		dashboard_mode = true, -- Disable dashboard mode
		filetype_autocmd_timeout = 100, -- Timeout for FileType autocmd after session load
		session_manager_opts = {
			autosave_ignore_dirs = { vim.fn.expand("~"), "/tmp" }, -- Directories to ignore for autosave
			autosave_ignore_filetypes = { "ccc-ui", "gitcommit", "gitrebase", "qf", "toggleterm" }, -- Filetypes to ignore
		},
	},
	init = function()
		vim.opt.sessionoptions:append("globals") -- Enable saving the state of plugins in the session
	end,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim", tag = "0.1.4" },
		{ "Shatur/neovim-session-manager" },
	},
	lazy = false,
	priority = 100,
}
