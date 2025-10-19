-- lua/ai/adapters.lua
--
-- Manages adapter configurations for CodeCompanion.
-- This module is responsible for building the adapter tables for both
-- the default OpenAI provider and a local, OpenAI-compatible provider
-- (like Ollama). It reads environment variables for API keys and base URLs.

local M = {}

local cc_adapters = require("codecompanion.adapters")

-- Holds the configured adapter tables
local configured_adapters = {}

--- Builds the OpenAI adapter configuration.
-- @param model string The model name to use (e.g., "gpt-5-mini").
-- @return table The CodeCompanion adapter definition.
function M.get_openai_adapter(model)
	local use_stream = require("ai").defaults.openai_stream
	return cc_adapters.extend("openai", {
		env = {
			api_key = "OPENAI_API_KEY", -- Name of the environment variable
		},
		schema = {
			model = { default = model },
		},
		opts = {
			stream = use_stream,
			endpoint = "/v1/chat/completions", -- Required for chat-style models
		},
	})
end

--- Builds the local (Ollama) adapter configuration.
-- @param model string The model name to use (e.g., "deepseek-coder").
-- @return table The CodeCompanion adapter definition.
function M.get_local_adapter(model)
	return cc_adapters.extend("openai", { -- Use "openai" base for compatibility
		env = {
			api_key = "OLLAMA_DUMMY_KEY", -- Dummy key, as Ollama doesn't require one
			base = "OLLAMA_BASE", -- Env var for the base URL (e.g., http://localhost:11434)
		},
		schema = {
			model = { default = model },
		},
		opts = {
			stream = true,
			endpoint = "/v1/chat/completions",
		},
	})
end

--- Sets up and stores both OpenAI and local adapters.
-- This function is called before setting up CodeCompanion to ensure
-- the adapters are configured with the correct models from the current state.
-- @param openai_model string The current OpenAI model.
-- @param local_model string The current local model.
function M.setup_adapters(openai_model, local_model)
	configured_adapters = {
		http = {
			openai = M.get_openai_adapter(openai_model),
			["local"] = M.get_local_adapter(local_model),
			opts = {
				timeout = 30000,
				show_model_choices = false,
			},
		},
	}
end

--- Returns the fully constructed adapter table for CodeCompanion.
-- @return table The adapters table for CodeCompanion's setup function.
function M.get_all_adapters()
	return configured_adapters
end

return M
