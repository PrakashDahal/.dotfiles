return {
	{
		"ThePrimeagen/harpoon",
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			-- Key mappings
			vim.keymap.set("n", "<leader>ah", mark.add_file, { desc = "Add file to Harpoon" })
			vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Toggle Harpoon menu" })
			vim.keymap.set("n", "<C-n>", function()
				ui.nav_next()
			end, { desc = "Navigate to next Harpoon file" })
		end,
	},
}
