local M = {}

-- State to track active AI
M.active_ai = "copilot" -- Default to Copilot

-- Function to enable Copilot and disable Codeium
function M.enable_copilot()
	vim.g.copilot_enabled = 1
	local ok, err = pcall(function()
		require("codeium").setup({
			enable = false,
			enable_cmp_source = false,
			virtual_text = { enable = false },
		})
	end)
	if not ok then
		vim.notify("Failed to disable Codeium: " .. tostring(err), vim.log.levels.ERROR)
	end
	M.active_ai = "copilot"
	vim.notify("Copilot enabled, Codeium disabled", vim.log.levels.INFO)
end

-- Function to enable Codeium and disable Copilot
function M.enable_codeium()
	vim.g.copilot_enabled = 0
	local ok, err = pcall(function()
		require("codeium") -- Ensure plugin is loaded
		require("codeium").setup({
			enable = true,
			enable_cmp_source = true,
			virtual_text = { enable = true },
		})
	end)
	if not ok then
		vim.notify("Failed to enable Codeium: " .. tostring(err), vim.log.levels.ERROR)
		M.enable_copilot() -- Fallback to Copilot
		return
	end
	M.active_ai = "codeium"
	vim.notify("Codeium enabled, Copilot disabled", vim.log.levels.INFO)
end

-- Toggle between Copilot and Codeium
function M.toggle_ai()
	if M.active_ai == "copilot" then
		M.enable_codeium()
	else
		M.enable_copilot()
	end
end

-- Open chat for the active AI
function M.open_chat()
	if M.active_ai == "copilot" then
		local ok, copilot_chat = pcall(require, "CopilotChat")
		if not ok then
			vim.notify("CopilotChat plugin not loaded: " .. tostring(copilot_chat), vim.log.levels.ERROR)
			return
		end
		if copilot_chat.config.name == nil then
			vim.notify("CopilotChat config missing 'name' field", vim.log.levels.ERROR)
			return
		end
		local status_ok, err = pcall(vim.cmd, "CopilotChat")
		if not status_ok then
			vim.notify("Failed to open CopilotChat: " .. tostring(err), vim.log.levels.ERROR)
		end
	elseif M.active_ai == "codeium" then
		local ok, err = pcall(vim.cmd, "Codeium Chat")
		if not ok then
			vim.notify("Failed to open Codeium Chat: " .. tostring(err), vim.log.levels.ERROR)
		end
	end
end

return M
