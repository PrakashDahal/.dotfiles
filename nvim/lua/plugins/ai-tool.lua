-- return {
-- 	"codota/tabnine-nvim",
-- 	event = "InsertEnter",
-- 	build = "./dl_binaries.sh",
-- }

-- In your lazy.lua or init.lua file

local function load_codeium_token()
	package.path = package.path .. ";~/.config/nvim/lua/?.lua"
	local json = require("dkjson") -- Ensure you have a JSON library like dkjson
	local file_path = os.getenv("HOME") .. "/Documents/dotfiles/codeium_config.json" -- Path to your JSON file
	local file = io.open(file_path, "r") -- Open the JSON file for reading
	if file then
		local content = file:read("*a") -- Read the entire file content
		file:close() -- Close the file
		local config = json.decode(content) -- Decode the JSON content
		if config and config.api_token then
			vim.g.codeium_api_token = config.api_token -- Set the API token for Codeium
		else
			print("API token not found in the configuration file.")
		end
	else
		print("Codeium config file not found at: " .. file_path)
	end
end

load_codeium_token() -- Load the API token at startup

return {
	{
		"Exafunction/codeium.nvim", -- Codeium plugin
		cmd = "Codeium",
		build = ":Codeium Auth", -- Build command for Codeium
		opts = {},
		config = function()
			local codeium = require("codeium") -- Require the Codeium module

			-- Setup Codeium with desired options
			codeium.setup({
				auto_complete = {
					enabled = true, -- Enable auto-completion
					delay = 100, -- Delay in milliseconds before triggering auto-completion
				},
				suggest_next_line = {
					enabled = true, -- Enable suggesting the next line of code
					max_length = 100, -- Maximum length of the suggested line
				},
				tab_complete = {
					enabled = true, -- Enable tab completion
					behavior = "replace_current", -- Behavior when tab completing
				},
			})

			-- Keybindings for Codeium
			vim.keymap.set("i", "<C-j>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })

			vim.keymap.set("i", "<C-;>", function()
				return vim.fn["codeium#Complete"]()
			end, { expr = true })

			vim.keymap.set("n", "<C-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true })

			-- Function to open Codeium Chat in a vertical split on the right side
			local function open_codeium_chat()
				vim.cmd("vsplit") -- Create a new vertical split
				local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
				vim.api.nvim_win_set_buf(0, buf) -- Set the new buffer to the current window

				-- Set buffer options
				vim.api.nvim_buf_set_option(buf, "buftype", "nofile") -- Make buffer non-file
				vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe") -- Wipe buffer when hidden
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Loading Codeium Chat..." }) -- Placeholder text

				-- Start the Codeium Chat in the buffer
				vim.fn.system("codeium chat") -- Adjust this command if necessary

				-- Optionally, set the window size
				local width = math.floor(vim.o.columns * 0.4) -- Set width to 40% of the window
				vim.cmd(string.format("vertical resize %d", width)) -- Resize the split window
			end

			-- Keybinding to open Codeium Chat
			vim.keymap.set("n", "<leader>cc", open_codeium_chat, { desc = "Open Codeium Chat" })
		end,
	},
}
