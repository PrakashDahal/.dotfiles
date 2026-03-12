-- lua/ai/keymaps.lua
--
-- All AI keymaps in one place.
-- Avante registers its own default keymaps (AvanteAsk etc).
-- This file adds: model picker, context system, status, aider terminal.
--
-- Full keymap reference:
--
--   Avante built-in (set by avante itself, behaviour.auto_set_keymaps = true):
--     <leader>aa   → AvanteAsk      (open sidebar and ask)
--     <leader>ae   → AvanteEdit     (edit selected code inline)
--     <leader>ar   → AvanteRefresh  (refresh last response)
--     <leader>at   → AvanteToggle   (toggle sidebar)
--
--   Model & status (this file):
--     <leader>am   → Pick AI model
--     <leader>as   → Show AI status (model + context)
--
--   Context system (this file):
--     <leader>ap   → Pick project from ~/.ai/
--     <leader>ax   → Pick contexts within active project
--     <leader>ai   → Inject context → open avante with context in clipboard
--     <leader>ay   → Yank context to clipboard (for web AIs)
--
--   Aider terminal (this file):
--     <leader>ac   → Toggle aider terminal (right panel)

local M = {}

-- ── Aider terminal (replaces the old codecompanion terminal) ─────────────────

local _aider_term = nil  -- stores { win_id, buf_id }

local function toggle_aider()
  -- If window is open and valid, close it
  if _aider_term and vim.api.nvim_win_is_valid(_aider_term.win_id) then
    vim.api.nvim_win_close(_aider_term.win_id, true)
    _aider_term = nil
    return
  end

  -- Ask which model to use for aider
  local ai = require("ai")
  local model_flag = ""

  if ai.state.provider == "openai" then
    model_flag = "--model openai/" .. ai.state.model
  elseif ai.state.provider == "ollama" then
    model_flag = "--model ollama/" .. ai.state.model
  elseif ai.state.provider == "claude" then
    model_flag = "--model " .. ai.state.model
  end

  local cmd = "aider --vim " .. model_flag

  -- Open a right-side vertical split (30% width)
  vim.cmd("rightbelow vsplit")
  local width = math.floor(vim.o.columns * 0.3)
  vim.cmd("vertical resize " .. width)

  local win_id = vim.api.nvim_get_current_win()
  local buf_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win_id, buf_id)
  vim.fn.termopen(cmd)
  vim.cmd("startinsert")

  _aider_term = { win_id = win_id, buf_id = buf_id }

  -- Clean up state when the window is closed
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern  = tostring(win_id),
    once     = true,
    callback = function()
      if _aider_term and vim.api.nvim_buf_is_valid(_aider_term.buf_id) then
        vim.api.nvim_buf_delete(_aider_term.buf_id, { force = true })
      end
      _aider_term = nil
    end,
  })
end

-- ── Setup ─────────────────────────────────────────────────────────────────────

function M.setup()
  -- Model picker
  vim.keymap.set("n", "<leader>am", function()
    require("ai.picker").pick_model()
  end, { desc = "AI: Select Model" })

  -- Status
  vim.keymap.set("n", "<leader>as", function()
    require("ai.context").status()
  end, { desc = "AI: Status" })

  -- Context: pick project
  vim.keymap.set("n", "<leader>ap", function()
    require("ai.context").pick_project()
  end, { desc = "AI: Pick Project" })

  -- Context: pick contexts within active project
  vim.keymap.set("n", "<leader>ax", function()
    require("ai.context").pick_context()
  end, { desc = "AI: Pick Context" })

  -- Context: inject into avante (opens avante + copies to clipboard)
  vim.keymap.set("n", "<leader>ai", function()
    require("ai.context").inject_to_chat()
  end, { desc = "AI: Inject Context" })

  -- Context: copy to clipboard only (for web AIs)
  vim.keymap.set("n", "<leader>ay", function()
    require("ai.context").copy_to_clipboard()
  end, { desc = "AI: Yank Context to Clipboard" })

  -- Aider terminal
  vim.keymap.set("n", "<leader>ac", toggle_aider,
    { desc = "AI: Toggle Aider Terminal" })

  -- ── Which-key group labels ────────────────────────────────────────────────
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({
      { "<leader>a", group = "AI" },
    })
  end
end

return M
