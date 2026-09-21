return {
	{
		"ThePrimeagen/harpoon",
		keys = {
			{ "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Add file to Harpoon" },
			{ "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle Harpoon menu" },
			{ "<C-n>", function() require("harpoon.ui").nav_next() end, desc = "Navigate to next Harpoon file" },
		},
	},
}
