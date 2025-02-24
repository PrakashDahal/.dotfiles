return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local colors = require("catppuccin.palettes").get_palette() -- Get Catppuccin colors
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				globalstatus = true,
			},
			sections = {
				lualine_c = {
					{
						"filename",
						color = { fg = colors.mauve, bg = colors.surface1, gui = "bold" }, -- Highlight filename
					},
				},
			},
			tabline = {
				lualine_x = {
					{
						"filename",
						color = { fg = colors.lavender, bg = colors.surface1, gui = "bold" }, -- Top right filename highlight
					},
				},
			},
		})
	end,
}
