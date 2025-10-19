-- lua/ai/terminals.lua
--
-- Provides functions to toggle terminals for development tools.
-- This module implements helpers for opening `aider` and a general-purpose
-- code shell in a right-side docked panel.

local M = {}

-- Use a table to store state for multiple terminals, keyed by command
local terminals = {}

--- Creates and manages a terminal window on the right side.
-- @param cmd string The command to run in the terminal, used as a key.
local function toggle_right_term(cmd)
	local term_state = terminals[cmd]

	if term_state and vim.api.nvim_win_is_valid(term_state.win_id) then
		vim.api.nvim_win_close(term_state.win_id, true)
		terminals[cmd] = nil
	else
		vim.cmd("rightbelow vsplit")
		local width = math.floor(vim.o.columns * 0.3)
		vim.cmd("vertical resize " .. width)

		local win_id = vim.api.nvim_get_current_win()
		local buf_id = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_win_set_buf(win_id, buf_id)

		vim.fn.termopen(cmd)
		vim.cmd("startinsert")

		-- Store state for this specific terminal
		terminals[cmd] = { win_id = win_id, buf_id = buf_id }

		-- Autocmd to clean up when the terminal buffer is closed
		vim.api.nvim_create_autocmd("WinClosed", {
			pattern = tostring(win_id),
			once = true,
			callback = function()
				local state = terminals[cmd]
				if state and state.buf_id and vim.api.nvim_buf_is_valid(state.buf_id) then
					vim.api.nvim_buf_delete(state.buf_id, { force = true })
				end
				terminals[cmd] = nil
			end,
		})
	end
end

--- Toggles a terminal on the right running `aider`.
function M.toggle_aider()
	local picker = require("ai.picker")
	picker.pick_model(function(selection)
		if selection then
			local cmd = "aider --vim --model " .. selection.model
			if selection.adapter == "openai" then
				cmd = cmd .. " --no-stream"
			end
			toggle_right_term(cmd)
		end
	end)
end

--- Toggles a terminal on the right with a shell.
function M.toggle_code_terminal()
	local shell = os.getenv("SHELL") or "bash"
	toggle_right_term(shell)
end

return M

