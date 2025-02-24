local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("vim-config")
require("lazy").setup({ { import = "plugins" }, { import = "plugins.lsp" } }, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	ui = {
		border = "single",
		position = "top",
		size = { width = 0.7, height = 0.7 },
		open_at_top = false,
		winblend = 0,
		highlight = {
			fg = "#FFFFFF",
		},
	},
})

require("tabnine").setup({
	max_lines = 1000,
	max_filesize = 5000,
	disable_auto_comment = true,
	accept_keymap = "<Tab>",
	dismiss_keymap = "<C-]>",
	debounce_ms = 800,
	suggestion_color = { gui = "#F5C2E7", cterm = 13 },
	exclude_filetypes = { "TelescopePrompt", "NvimTree" },
	log_file_path = nil, -- absolute path to Tabnine log file
	ignore_certificate_errors = false,
	max_number_results = 20,
})

-- Zathura PDF reader
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*.pdf" },
	callback = function()
		local pdf_file = vim.fn.expand("%:p")
		-- Open the PDF with Zathura detached from the terminal
		vim.fn.jobstart({ "zathura", pdf_file }, { detach = true })
		-- Close the current buffer
		vim.cmd("bd!")
	end,
})
