-- lua/ai/keymaps.lua
--
-- All AI keymaps in one place.
-- Avante registers its own default keymaps (AvanteAsk etc).
-- This file adds: model picker, context system, status, opencode terminal.
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
--   OpenCode terminal (this file):
--     <leader>ac   → Toggle opencode terminal (right panel)

local M = {}

-- ── OpenCode terminal ───────────────────────────────────────
local _opencode_term = nil

local function toggle_opencode()
	if _opencode_term and vim.api.nvim_win_is_valid(_opencode_term.win_id) then
		vim.api.nvim_win_close(_opencode_term.win_id, true)
		_opencode_term = nil
		return
	end

	-- Get current project directory
	local cwd = vim.fn.getcwd()

	-- Build opencode command
	-- OpenCode auto-reads AGENTS.md from the project root
	local cmd = "cd " .. cwd .. " && opencode"

	vim.cmd("rightbelow vsplit")
	local width = math.floor(vim.o.columns * 0.4)
	vim.cmd("vertical resize " .. width)

	local win_id = vim.api.nvim_get_current_win()
	local buf_id = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(win_id, buf_id)
	vim.fn.termopen(cmd)
	vim.cmd("startinsert")

	_opencode_term = { win_id = win_id, buf_id = buf_id }

	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win_id),
		once = true,
		callback = function()
			if _opencode_term and vim.api.nvim_buf_is_valid(_opencode_term.buf_id) then
				vim.api.nvim_buf_delete(_opencode_term.buf_id, { force = true })
			end
			_opencode_term = nil
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

	-- opencode terminal
	vim.keymap.set("n", "<leader>ao", toggle_opencode, { desc = "AI: Toggle OpenCode Terminal" })

	-- ── Which-key group labels ────────────────────────────────────────────────
	local ok, wk = pcall(require, "which-key")
	if ok then
		wk.add({
			{ "<leader>a", group = "AI" },
		})
	end
end

return M
