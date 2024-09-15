return {
	"codota/tabnine-nvim",
	event = "InsertEnter",
	build = "./dl_binaries.sh",
}

-- In your lazy.lua or init.lua file
--
--

-- local function load_codeium_token()
-- 	-- Update package path to include custom Lua scripts
-- 	package.path = package.path .. ";~/.config/nvim/lua/?.lua"
--
-- 	-- Require the JSON library (ensure dkjson is installed)
-- 	local json = require("cjson")
-- 	local file_path = os.getenv("HOME") .. "/Documents/dotfiles/codeium_config.json" -- Path to your JSON file
--
-- 	-- Open the JSON file for reading
-- 	local file = io.open(file_path, "r")
-- 	if file then
-- 		local content = file:read("*a") -- Read the entire file content
-- 		file:close() -- Close the file
--
-- Decode the JSON content
-- 		local config, pos, err = json.decode(content, 1, nil)
-- 		if err then
-- 			print("Error decoding JSON: " .. err)
-- 			return
-- 		end
--
-- 		-- Check if API token is available
-- 		if config and config.api_token then
-- 			vim.g.codeium_api_token = config.api_token -- Set the API token for Codeium
-- 		else
-- 			print("API token not found in the configuration file.")
-- 		end
-- 	else
-- 		print("Codeium config file not found at: " .. file_path)
-- 	end
-- end
--
-- load_codeium_token() -- Load the API token at startup

-- return {
-- 	"Exafunction/codeium.nvim",
-- 	dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
-- 	config = function()
-- 		require("codeium").setup({
-- 			enable_chat = true, -- Enable chat functionality
-- 		})
-- 	end,
-- }
