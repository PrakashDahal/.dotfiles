-- lua/ai/picker.lua
--
-- Implements the model picker UI.
-- This module discovers available models from Ollama, combines them with
-- the default OpenAI model, and presents them in a `vim.ui.select` menu.
-- Selecting a model updates the global AI state.

local M = {}

--- Fetches a list of locally installed Ollama models.
-- Runs `ollama list` and parses the JSON output.
-- @return table A sorted list of unique model names, or an empty table on error.
function M.get_ollama_models()
	local models = {}
	-- Use pcall for robust error handling in case `ollama` is not installed
	local ok, result = pcall(vim.fn.system, "ollama list | awk 'NR>1 {print $1}'")

	if not ok or result == "" then
		vim.notify("Failed to run 'ollama list'. Is it installed and in your PATH?", vim.log.levels.WARN)
		return {}
	end

	local lines = vim.split(result, "\n")
	local model_names = {}
	for _, line in ipairs(lines) do
		if line ~= "" then
			local short_name = line:match("([^\t]+)")
			if short_name then
				model_names[short_name] = true
			end
		end
	end
	for name in pairs(model_names) do
		table.insert(models, name)
	end
	table.sort(models)

	return models
end

--- Gathers all available models (OpenAI + local) for the picker.
-- @return table A list of formatted strings for `vim.ui.select`.
-- @return table A corresponding list of {adapter, model} tables.
function M.available_models()
	local ai = require("ai")
	local choices = {}
	local choice_data = {}

	-- Add the default OpenAI model
	table.insert(choices, string.format("OpenAI • %s", ai.defaults.openai_model))
	table.insert(choice_data, { adapter = "openai", model = ai.defaults.openai_model })

	-- Add local Ollama models
	local local_models = M.get_ollama_models()
	for _, model_name in ipairs(local_models) do
		table.insert(choices, string.format("Local • %s", model_name))
		table.insert(choice_data, { adapter = "local", model = model_name })
	end

	return choices, choice_data
end

--- Shows the model picker UI and updates the state on selection.
function M.pick_model(callback)
	local choices, choice_data = M.available_models()

	if #choices == 0 then
		vim.notify("No models available to pick.", vim.log.levels.WARN)
		return
	end

	vim.ui.select(choices, {
		prompt = "Select an AI Model:",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		if not choice then
			if callback then
				callback(nil)
			end
			return
		end

		for i, item_text in ipairs(choices) do
			if item_text == choice then
				local ai = require("ai")
				local selection = choice_data[i]
				ai.state.adapter = selection.adapter
				ai.state.model = selection.model

				-- Re-setup CodeCompanion immediately to apply the change
				local success, err = pcall(function()
					require("codecompanion").setup(ai.setup_codecompanion())
				end)

				if not success then
					local errmsg = tostring(err)
					-- If the failure indicates an invalid model ID from OpenAI's API,
					-- attempt a safe fallback to a commonly-available model and retry once.
					if errmsg:lower():match("invalid model") or errmsg:lower():match("invalid model id") then
						vim.notify("CodeCompanion: invalid model detected. Falling back to gpt and retrying.", vim.log.levels.WARN)
						ai.defaults.openai_model = "gpt-5-nano"
						local ok2, err2 = pcall(function()
							require("codecompanion").setup(ai.setup_codecompanion())
						end)
						if not ok2 then
							vim.notify("Retry failed: " .. tostring(err2), vim.log.levels.ERROR)
							return
						end
					else
						vim.notify("Error setting up CodeCompanion: " .. errmsg, vim.log.levels.ERROR)
						return
					end
				end

				vim.notify(string.format("AI model set to: %s • %s", ai.state.adapter, ai.state.model))

				if callback then
					callback(selection)
				end
				break
			end
		end
	end)
end

return M
