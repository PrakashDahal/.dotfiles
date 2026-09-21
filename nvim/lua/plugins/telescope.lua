return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	cmd = "Telescope",
	keys = {
		{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find added git files" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fuzzy find recent files" },
		{ "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
		{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor" },
		{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
		{ "<leader>p", "<cmd>Telescope neovim-project discover<cr>", desc = "Find project" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				live_grep = {
					-- don't use this. it will only search in the current file
					-- live_grep_args = { "-F" },
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--fixed-strings", -- Treat the pattern as a literal string
					},
				},
			},
		})

		telescope.load_extension("fzf")
	end,
}
