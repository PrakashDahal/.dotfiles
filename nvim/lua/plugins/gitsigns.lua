return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- Navigation
			map("n", "]z", gs.next_hunk, "Next Hunk")
			map("n", "[z", gs.prev_hunk, "Prev Hunk")

			-- Actions
			map("n", "<leader>zs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>zr", gs.reset_hunk, "Reset hunk")
			map("v", "<leader>zs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage hunk")
			map("v", "<leader>zr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset hunk")

			map("n", "<leader>zS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>zR", gs.reset_buffer, "Reset buffer")

			map("n", "<leader>zu", gs.undo_stage_hunk, "Undo stage hunk")

			map("n", "<leader>zp", gs.preview_hunk, "Preview hunk")

			map("n", "<leader>zb", function()
				gs.blame_line({ full = true })
			end, "Blame line")
			map("n", "<leader>zB", gs.toggle_current_line_blame, "Toggle line blame")

			map("n", "<leader>zd", gs.diffthis, "Diff this")
			map("n", "<leader>zD", function()
				gs.diffthis("~")
			end, "Diff this ~")

			-- Text object
			map({ "o", "x" }, "iz", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
		end,
	},
}
