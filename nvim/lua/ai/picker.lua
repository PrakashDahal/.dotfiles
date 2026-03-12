-- lua/ai/picker.lua
--
-- Model picker for avante.
-- Replaces the old codecompanion-based picker.
--
-- Shows all models from ai.model_menu plus any locally
-- installed Ollama models discovered at runtime.
-- Selecting a model updates M.state and reconfigures avante.

local M = {}

--- Fetches locally installed Ollama model names.
-- Runs `ollama list` and parses output.
-- Returns empty table if ollama is not installed or running.
local function get_ollama_models()
  local models = {}
  local ok, result = pcall(vim.fn.system, "ollama list 2>/dev/null | awk 'NR>1 {print $1}'")
  if not ok or result == "" then return models end

  for _, line in ipairs(vim.split(result, "\n")) do
    local name = vim.trim(line)
    if name ~= "" then
      table.insert(models, name)
    end
  end
  table.sort(models)
  return models
end

--- Shows the model picker using vim.ui.select (styled by dressing.nvim).
-- On selection: updates ai.state, reconfigures avante, notifies user.
function M.pick_model()
  local ai = require("ai")

  -- Start with the curated menu
  local labels      = {}
  local label_to_cfg = {}

  -- Sort menu labels for consistent display
  local sorted_labels = vim.tbl_keys(ai.model_menu)
  table.sort(sorted_labels)

  for _, label in ipairs(sorted_labels) do
    table.insert(labels, label)
    label_to_cfg[label] = ai.model_menu[label]
  end

  -- Append any Ollama models not already in the menu
  local ollama_models = get_ollama_models()
  for _, model_name in ipairs(ollama_models) do
    -- Check it's not already listed
    local already_listed = false
    for _, cfg in pairs(ai.model_menu) do
      if cfg.provider == "ollama" and cfg.model == model_name then
        already_listed = true
        break
      end
    end
    if not already_listed then
      local label = string.format("%-35s (Local • Auto-discovered)", model_name)
      table.insert(labels, label)
      label_to_cfg[label] = { provider = "ollama", model = model_name }
    end
  end

  if #labels == 0 then
    vim.notify("No models available.", vim.log.levels.WARN, { title = "AI" })
    return
  end

  -- Mark the currently active model in the list
  local active_label = nil
  for _, label in ipairs(labels) do
    local cfg = label_to_cfg[label]
    if cfg.provider == ai.state.provider and cfg.model == ai.state.model then
      active_label = label
      break
    end
  end

  vim.ui.select(labels, {
    prompt = "Select AI Model:",
    format_item = function(item)
      -- Put a ● marker next to the currently active model
      local prefix = (item == active_label) and "● " or "  "
      return prefix .. item
    end,
  }, function(choice)
    if not choice then return end

    local cfg = label_to_cfg[choice]
    if not cfg then return end

    -- Update global state
    ai.state.provider = cfg.provider
    ai.state.model    = cfg.model

    -- Reconfigure avante with new state
    ai.reconfigure()

    vim.notify(
      string.format("Model → %s  (%s)", cfg.model, cfg.provider),
      vim.log.levels.INFO,
      { title = "AI" }
    )
  end)
end

return M
