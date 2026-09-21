return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		local colors = require("catppuccin.palettes").get_palette()
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				globalstatus = true,
			},
			sections = {
				lualine_c = {
					{
						"filename",
						fg = colors.mauve,
						bg = colors.surface1,
						bold = true,
					},
				},
			},
			winbar = {
				lualine_c = {
					{
						"filename",
						fg = colors.lavender,
						bg = colors.surface1,
						bold = true,
					},
				},
			},
			inactive_winbar = {
				lualine_c = {
					{
						"filename",
						fg = colors.lavender,
						bg = colors.surface1,
						bold = true,
					},
				},
			},
		})
	end,
}
