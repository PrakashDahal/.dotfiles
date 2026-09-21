-- Live markdown preview: <leader>mv toggles a glow-rendered preview in a
-- vertical split to the right of the source buffer. The preview refreshes
-- (debounced) as you edit and when the window is resized, reading unsaved buffer content via a scratch
-- tempfile, and its scroll position is kept proportionally in sync with the
-- source buffer's scroll (glow's rendered line count never matches the
-- source's, so this is done by percentage-through-the-buffer, not raw line
-- number binding).
return {
	dir = vim.fn.stdpath("config"),
	name = "markdown-preview-local",
	ft = "markdown",
	config = function()
		local uv = vim.uv or vim.loop
		local state = {} -- [src_buf] = { win, src_win, buf, tmpfile, timer, augroup, width }

		-- The terminal's pty is sized to the window's text area, so any
		-- number/sign/fold columns shrink it. glow must render to exactly that
		-- width, otherwise every full-width line (table borders especially)
		-- gets hard-wrapped by the terminal and the layout falls apart.
		local function setup_preview_win(win)
			local wo = vim.wo[win]
			wo.number = false
			wo.relativenumber = false
			wo.signcolumn = "no"
			wo.foldcolumn = "0"
			wo.statuscolumn = ""
			wo.spell = false
			wo.list = false
			wo.wrap = false
		end

		local function text_width(win)
			local info = vim.fn.getwininfo(win)[1]
			return math.max(20, vim.api.nvim_win_get_width(win) - (info and info.textoff or 0))
		end

		local render, schedule_refresh, close_preview, open_preview, toggle_preview, sync_scroll

		sync_scroll = function(src_buf)
			local s = state[src_buf]
			if not s or not s.buf or not vim.api.nvim_buf_is_valid(s.buf) then
				return
			end
			if not vim.api.nvim_win_is_valid(s.src_win) or not vim.api.nvim_win_is_valid(s.win) then
				return
			end

			local src_total = vim.api.nvim_buf_line_count(src_buf)
			local preview_total = vim.api.nvim_buf_line_count(s.buf)
			if src_total <= 1 or preview_total <= 1 then
				return
			end

			local src_top = vim.fn.line("w0", s.src_win)
			local pct = (src_top - 1) / (src_total - 1)
			local target = math.floor(pct * (preview_total - 1)) + 1
			target = math.max(1, math.min(target, preview_total))

			-- winrestview() has no effect on terminal buffers; a cursor jump +
			-- zt is what actually moves the view here.
			vim.api.nvim_win_call(s.win, function()
				vim.api.nvim_win_set_cursor(s.win, { target, 0 })
				vim.cmd("normal! zt")
			end)
		end

		render = function(src_buf)
			local s = state[src_buf]
			if not s then
				return
			end

			local lines = vim.api.nvim_buf_get_lines(src_buf, 0, -1, false)
			vim.fn.writefile(lines, s.tmpfile)

			if not vim.api.nvim_win_is_valid(s.win) then
				return
			end

			local old_buf = s.buf
			setup_preview_win(s.win)
			local width = text_width(s.win)
			s.width = width
			local cur_win = vim.api.nvim_get_current_win()
			local src_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(src_buf), ":t")
			if src_name == "" then
				src_name = "[No Name]"
			end

			-- termopen() always targets the current window/buffer, so we have
			-- to focus the preview window for it, then restore editing focus.
			local buf = vim.api.nvim_create_buf(false, true)
			vim.bo[buf].bufhidden = "wipe"
			vim.api.nvim_set_current_win(s.win)
			vim.api.nvim_win_set_buf(s.win, buf)
			vim.fn.termopen({ "glow", "--style", "dark", "-w", tostring(width), s.tmpfile }, {
				-- glow renders asynchronously; the buffer is still empty right
				-- after termopen() returns, so scroll sync has to wait for the
				-- job to actually finish writing its output.
				on_exit = function()
					vim.schedule(function()
						sync_scroll(src_buf)
					end)
				end,
			})
			s.buf = buf
			-- Terminal buffers can re-enable window options via TermOpen
			-- autocmds; enforce them again after the job has started.
			setup_preview_win(s.win)
			-- termopen() names the buffer after the job command (e.g. "glow [-]");
			-- override it to read like "Readme.md (Preview)" instead. Names must
			-- be unique across buffers, so ignore a collision if one occurs.
			pcall(vim.api.nvim_buf_set_name, buf, src_name .. " (Preview)")

			if vim.api.nvim_win_is_valid(cur_win) then
				vim.api.nvim_set_current_win(cur_win)
			end

			if old_buf and vim.api.nvim_buf_is_valid(old_buf) then
				vim.api.nvim_buf_delete(old_buf, { force = true })
			end
		end

		schedule_refresh = function(src_buf)
			local s = state[src_buf]
			if not s then
				return
			end
			s.timer:start(300, 0, vim.schedule_wrap(function()
				render(src_buf)
			end))
		end

		close_preview = function(src_buf)
			local s = state[src_buf]
			if not s then
				return
			end
			-- Clear state and the augroup before closing the window so the
			-- WinClosed autocmd this triggers can't re-enter this function.
			state[src_buf] = nil
			if s.augroup then
				pcall(vim.api.nvim_del_augroup_by_id, s.augroup)
			end

			s.timer:stop()
			s.timer:close()
			if vim.api.nvim_win_is_valid(s.win) then
				vim.api.nvim_win_close(s.win, true)
			end
			vim.fn.delete(s.tmpfile)
		end

		open_preview = function(src_buf)
			if state[src_buf] then
				return
			end

			local src_win = vim.api.nvim_get_current_win()
			vim.cmd("rightbelow vsplit") -- always open to the right, regardless of 'splitright'
			local win = vim.api.nvim_get_current_win()
			vim.api.nvim_set_current_win(src_win) -- keep editing focus on the source buffer
			local tmpfile = vim.fn.tempname() .. ".md"
			local augroup = vim.api.nvim_create_augroup("MarkdownPreview" .. src_buf, { clear = true })

			state[src_buf] = {
				win = win,
				src_win = src_win,
				tmpfile = tmpfile,
				timer = uv.new_timer(),
				augroup = augroup,
			}

			vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
				group = augroup,
				buffer = src_buf,
				callback = function()
					schedule_refresh(src_buf)
				end,
			})

			vim.api.nvim_create_autocmd("WinScrolled", {
				group = augroup,
				pattern = tostring(src_win),
				callback = function()
					sync_scroll(src_buf)
				end,
			})

			-- Re-render at the new width when the preview window (or the whole
			-- editor) is resized, so text and tables re-wrap to fit.
			vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
				group = augroup,
				callback = function()
					local s = state[src_buf]
					if s and vim.api.nvim_win_is_valid(s.win) and text_width(s.win) ~= s.width then
						schedule_refresh(src_buf)
					end
				end,
			})

			vim.api.nvim_create_autocmd("WinClosed", {
				group = augroup,
				callback = function(args)
					local s = state[src_buf]
					if s and tostring(s.win) == args.match then
						close_preview(src_buf)
					end
				end,
			})

			-- Close the preview once the source window switches to another file
			-- (:e, Telescope, Harpoon, ...), so it never shows a stale buffer.
			vim.api.nvim_create_autocmd("BufWinEnter", {
				group = augroup,
				callback = function()
					vim.schedule(function()
						local s = state[src_buf]
						if s and vim.api.nvim_win_is_valid(s.src_win) and vim.api.nvim_win_get_buf(s.src_win) ~= src_buf then
							close_preview(src_buf)
						end
					end)
				end,
			})

			vim.api.nvim_create_autocmd("BufWipeout", {
				group = augroup,
				buffer = src_buf,
				callback = function()
					close_preview(src_buf)
				end,
			})

			render(src_buf)
		end

		toggle_preview = function()
			local src_buf = vim.api.nvim_get_current_buf()
			if state[src_buf] then
				close_preview(src_buf)
			else
				open_preview(src_buf)
			end
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(args)
				vim.keymap.set("n", "<leader>mv", toggle_preview, { buffer = args.buf, desc = "Toggle markdown preview" })
			end,
		})
	end,
}
