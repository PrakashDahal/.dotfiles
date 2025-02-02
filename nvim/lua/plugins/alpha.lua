return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("SPC wr", "󰁯 > Restore Session For Current Directory", ":SessionRestore<CR>"),
			dashboard.button("SPC ee", " > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC ff", "󰱼 > Find File", ":Telescope find_files<CR>"),
			dashboard.button("SPC fs", " > Find Word", ":Telescope live_grep<CR>"),
			dashboard.button("SPC l", " > See Lazy dashboard", ":Lazy<CR>"),
			dashboard.button("q", " > Quit NVIM", ":qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

		-- Fix potential redraw issue on resize
		vim.api.nvim_create_autocmd("VimResized", {
			pattern = "*",
			callback = function()
				if vim.api.nvim_buf_is_valid(1) and vim.bo[1].filetype == "alpha" then
					alpha.redraw()
				end
			end,
		})

		vim.g.alpha_redraw_on_resize = false
	end,
}
