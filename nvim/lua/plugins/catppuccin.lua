return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- Set the flavor to mocha
			background = { -- :h background
				dark = "mocha",
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
