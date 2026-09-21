return {
	{
		"3rd/image.nvim",
		build = false, -- avoid the luarocks "magick" rock; use the magick CLI instead
		opts = {
			backend = "ueberzug",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki" },
				},
			},
			max_width_window_percentage = 80,
			max_height_window_percentage = 80,
			window_overlap_clear_enabled = true,
			editor_only_render_when_focused = true,
		},
		config = function(_, opts)
			require("image").setup(opts)

			-- SVGs are readable source, so don't hijack them by default (unlike
			-- raster formats). <leader>iv toggles the current buffer in place
			-- between rendered image and source, same as image.nvim does for
			-- raster files.
			local function toggle_svg_view()
				local buf = vim.api.nvim_get_current_buf()
				local win = vim.api.nvim_get_current_win()

				if vim.b.svg_image_mode then
					for _, img in ipairs(require("image").get_images({ buffer = buf })) do
						img:clear()
					end

					local lines = vim.fn.readfile(vim.api.nvim_buf_get_name(buf))
					vim.bo[buf].modifiable = true
					vim.bo[buf].buftype = ""
					vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
					vim.bo[buf].filetype = vim.b.svg_orig_filetype or "xml"
					vim.bo[buf].modified = false

					local prev = vim.b.svg_orig_winopts or {}
					vim.wo[win].number = prev.number
					vim.wo[win].cursorline = prev.cursorline
					vim.wo[win].signcolumn = prev.signcolumn
					vim.wo[win].colorcolumn = prev.colorcolumn

					vim.b.svg_image_mode = false
					return
				end

				local path = vim.api.nvim_buf_get_name(buf)
				if not path:match("%.svg$") then
					vim.notify("Not an SVG buffer", vim.log.levels.WARN)
					return
				end

				vim.b.svg_orig_filetype = vim.bo[buf].filetype
				vim.b.svg_orig_winopts = {
					number = vim.wo[win].number,
					cursorline = vim.wo[win].cursorline,
					signcolumn = vim.wo[win].signcolumn,
					colorcolumn = vim.wo[win].colorcolumn,
				}

				require("image").hijack_buffer(path, win, buf)
				vim.b.svg_image_mode = true
			end

			vim.keymap.set("n", "<leader>iv", toggle_svg_view, { desc = "Toggle SVG image/source view" })
		end,
	},
}
