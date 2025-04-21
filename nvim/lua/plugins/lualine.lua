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
			-- Add winbar for each window (split)
			winbar = {
				lualine_x = {
					{
						"filename",
						color = { fg = colors.lavender, bg = colors.surface1, gui = "bold" },
					},
				},
			},
			-- Optional: also show the winbar for inactive windows
			inactive_winbar = {
				lualine_x = {
					{
						"filename",
						color = { fg = colors.lavender, bg = colors.surface1, gui = "bold" },
					},
				},
			},
		})
	end,
}
