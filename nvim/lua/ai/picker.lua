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
	local ok, result = pcall(vim.fn.system, "ollama list --format json")

	if not ok or result == "" then
		vim.notify("Failed to run 'ollama list'. Is it installed and in your PATH?", vim.log.levels.WARN)
		return {}
	end

	local json_ok, parsed = pcall(vim.json.decode, result)
	if not json_ok or not parsed or not parsed.models then
		-- This can happen if the command runs but returns an error message instead of JSON
		-- No notification here as the previous one is likely sufficient
		return {}
	end

	local model_names = {}
	for _, item in ipairs(parsed.models) do
		-- Strip tags like ":latest" for a cleaner name
		local short_name = item.name:match("([^:]+)")
		if short_name then
			model_names[short_name] = true
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
				require("codecompanion").setup(ai.setup_codecompanion())

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
