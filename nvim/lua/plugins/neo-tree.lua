return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>ee", ":Neotree filesystem toggle left<CR>", { desc = "Toggle file explorer" })
		vim.keymap.set("n", "<leader>ef", ":Neotree reveal<CR>", { desc = "Open current file explorer" }) -- toggle file explorer on current file
	end,
}
