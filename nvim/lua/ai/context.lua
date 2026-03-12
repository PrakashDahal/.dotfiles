-- lua/ai/context.lua
--
-- Project-aware AI context selector.
-- Reads from ~/.ai/<project>/contexts/ symlink structure.
--
-- Public API:
--   M.pick_project()       → pick project, then immediately pick contexts
--   M.pick_context()       → pick contexts for already-active project
--   M.inject_to_chat()     → inject loaded context into avante sidebar
--   M.copy_to_clipboard()  → copy context to clipboard (for web AIs)
--   M.status()             → notify current project + contexts + model

local M = {}

-- ── State ─────────────────────────────────────────────────────────────────────
M.state = {
  project     = nil,   -- e.g. "nepwalk"
  contexts    = {},    -- e.g. { "backend", "product" }
  loaded_text = nil,   -- combined markdown of all selected contexts
}

local AI_DIR = vim.fn.expand("~/.ai")

-- ── Internal helpers ──────────────────────────────────────────────────────────

--- Returns sorted list of project names (top-level dirs in ~/.ai/)
local function get_projects()
  local projects = {}
  local handle = vim.loop.fs_scandir(AI_DIR)
  if not handle then return projects end
  while true do
    local name, ftype = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if (ftype == "directory" or ftype == "link") and not name:match("^%.") then
      table.insert(projects, name)
    end
  end
  table.sort(projects)
  return projects
end

--- Returns sorted list of context names for a project
local function get_contexts(project)
  local contexts = {}
  local ctx_dir  = AI_DIR .. "/" .. project .. "/contexts"
  local handle   = vim.loop.fs_scandir(ctx_dir)
  if not handle then return contexts end
  while true do
    local name, ftype = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if ftype == "directory" or ftype == "link" then
      table.insert(contexts, name)
    end
  end
  table.sort(contexts)
  return contexts
end

--- Reads all .md files in a context dir and returns combined text
local function read_context_dir(project, ctx_name)
  local ctx_path = AI_DIR .. "/" .. project .. "/contexts/" .. ctx_name
  local result   = "## Context: " .. ctx_name .. "\n\n"
  local files    = vim.fn.globpath(ctx_path, "**/*.md", false, true)
  table.sort(files)

  if #files == 0 then
    return result .. "_No markdown files found._\n\n"
  end

  for _, filepath in ipairs(files) do
    local rel = filepath:gsub(ctx_path .. "/", "")
    result = result .. "### " .. rel .. "\n\n"
    local f = io.open(filepath, "r")
    if f then
      result = result .. f:read("*all") .. "\n\n---\n\n"
      f:close()
    end
  end
  return result
end

--- Reads all prompt .md files for a project
local function read_prompts(project)
  local prompts_dir = AI_DIR .. "/" .. project .. "/prompts"
  local files       = vim.fn.globpath(prompts_dir, "*.md", false, true)
  if #files == 0 then return "" end

  local result = "## System Prompts\n\n"
  table.sort(files)
  for _, filepath in ipairs(files) do
    local f = io.open(filepath, "r")
    if f then
      result = result .. f:read("*all") .. "\n\n---\n\n"
      f:close()
    end
  end
  return result
end

--- Builds the full context text from M.state
local function build_loaded_text()
  if not M.state.project or #M.state.contexts == 0 then return nil end

  local text = "# AI Context\n"
    .. "# Project:  " .. M.state.project .. "\n"
    .. "# Contexts: " .. table.concat(M.state.contexts, ", ") .. "\n"
    .. "# Loaded:   " .. os.date("%Y-%m-%d %H:%M") .. "\n\n"

  text = text .. read_prompts(M.state.project)

  for _, ctx_name in ipairs(M.state.contexts) do
    text = text .. read_context_dir(M.state.project, ctx_name)
  end

  return text
end

-- ── Telescope multi-select picker ─────────────────────────────────────────────

local function telescope_pick_contexts(project, on_done)
  local contexts = get_contexts(project)
  if #contexts == 0 then
    vim.notify(
      "No contexts in ~/.ai/" .. project .. "/contexts/\n"
        .. "Create one with: ln -s ~/your/docs ~/.ai/" .. project .. "/contexts/name",
      vim.log.levels.WARN,
      { title = "AI Context" }
    )
    return
  end

  local ok_p, pickers = pcall(require, "telescope.pickers")
  if not ok_p then
    -- Fallback to vim.ui.select (single select)
    vim.ui.select(contexts, {
      prompt = "Select context [" .. project .. "]:",
    }, function(choice)
      if choice then on_done({ choice }) end
    end)
    return
  end

  local finders   = require("telescope.finders")
  local conf      = require("telescope.config").values
  local actions   = require("telescope.actions")
  local action_st = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "AI Contexts — " .. project .. "   (TAB = multi-select)",
    finder = finders.new_table({
      results = contexts,
      entry_maker = function(entry)
        local target = vim.fn.resolve(
          AI_DIR .. "/" .. project .. "/contexts/" .. entry
        )
        local short = target:gsub(vim.fn.expand("~"), "~")
        local file_count = #vim.fn.globpath(
          AI_DIR .. "/" .. project .. "/contexts/" .. entry,
          "**/*.md", false, true
        )
        return {
          value   = entry,
          display = string.format("%-25s  →  %-40s  (%d files)", entry, short, file_count),
          ordinal = entry,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local picker     = action_st.get_current_picker(prompt_bufnr)
        local selections = {}

        for _, entry in ipairs(picker:get_multi_selection()) do
          table.insert(selections, entry.value)
        end

        if #selections == 0 then
          local entry = action_st.get_selected_entry()
          if entry then table.insert(selections, entry.value) end
        end

        actions.close(prompt_bufnr)
        if #selections > 0 then on_done(selections) end
      end)
      return true
    end,
  }):find()
end

-- ── Public API ────────────────────────────────────────────────────────────────

--- Pick a project, then immediately open the context picker for it.
function M.pick_project()
  local projects = get_projects()

  if #projects == 0 then
    vim.notify(
      "No projects in ~/.ai/\n"
        .. "Create one:\n"
        .. "  mkdir -p ~/.ai/nepwalk/contexts\n"
        .. "  ln -s ~/your/docs ~/.ai/nepwalk/contexts/backend",
      vim.log.levels.WARN,
      { title = "AI Context" }
    )
    return
  end

  vim.ui.select(projects, {
    prompt = "Select AI Project:",
    format_item = function(item)
      local ctx_count = #get_contexts(item)
      local marker    = (item == M.state.project) and "● " or "  "
      return string.format("%s%-20s  (%d contexts)", marker, item, ctx_count)
    end,
  }, function(project)
    if not project then return end
    M.state.project     = project
    M.state.contexts    = {}
    M.state.loaded_text = nil
    M.pick_context()
  end)
end

--- Pick contexts for the currently active project.
function M.pick_context()
  if not M.state.project then
    vim.notify(
      "No project selected.\nUse <leader>ap to pick a project first.",
      vim.log.levels.WARN,
      { title = "AI Context" }
    )
    return
  end

  telescope_pick_contexts(M.state.project, function(selected)
    M.state.contexts    = selected
    M.state.loaded_text = build_loaded_text()

    -- Count total markdown files loaded
    local file_count = 0
    for _, ctx in ipairs(selected) do
      local ctx_path = AI_DIR .. "/" .. M.state.project .. "/contexts/" .. ctx
      file_count = file_count + #vim.fn.globpath(ctx_path, "**/*.md", false, true)
    end

    vim.notify(
      string.format(
        "Loaded: %s → [%s]\n%d files  |  <leader>ai to inject  |  <leader>ay to copy",
        M.state.project,
        table.concat(selected, ", "),
        file_count
      ),
      vim.log.levels.INFO,
      { title = "AI Context" }
    )
  end)
end

--- Inject loaded context into the avante sidebar as the initial message.
-- Opens avante, then writes the context into the input area.
function M.inject_to_chat()
  if not M.state.loaded_text then
    vim.notify(
      "No context loaded.\nUse <leader>ap → <leader>ax first.",
      vim.log.levels.WARN,
      { title = "AI Context" }
    )
    return
  end

  -- Copy context to clipboard so user can paste it into avante input
  -- (avante's input area is an interactive buffer; direct injection
  --  is more reliable via clipboard than buffer manipulation)
  vim.fn.setreg("+", M.state.loaded_text)
  vim.fn.setreg('"', M.state.loaded_text)

  -- Open avante sidebar
  vim.cmd("AvanteAsk")

  vim.notify(
    "Context copied to clipboard.\n"
      .. "Avante is open — press <C-v> or p to paste context,\n"
      .. "then add your question below it.",
    vim.log.levels.INFO,
    { title = "AI Context" }
  )
end

--- Copy loaded context to system clipboard for pasting into web AIs.
function M.copy_to_clipboard()
  if not M.state.loaded_text then
    vim.notify(
      "No context loaded.\nUse <leader>ap → <leader>ax first.",
      vim.log.levels.WARN,
      { title = "AI Context" }
    )
    return
  end

  vim.fn.setreg("+", M.state.loaded_text)
  local bytes = #M.state.loaded_text
  local lines = select(2, M.state.loaded_text:gsub("\n", "\n"))

  vim.notify(
    string.format(
      "Copied to clipboard\n%d lines  |  %d bytes\nPaste into ChatGPT / Claude web",
      lines, bytes
    ),
    vim.log.levels.INFO,
    { title = "AI Context" }
  )
end

--- Show full AI status: model, provider, active project + contexts.
function M.status()
  local ai  = require("ai")
  local ctx = "none"

  if M.state.project and #M.state.contexts > 0 then
    ctx = M.state.project .. " → [" .. table.concat(M.state.contexts, ", ") .. "]"
  elseif M.state.project then
    ctx = M.state.project .. " → (no contexts selected)"
  end

  vim.notify(
    string.format(
      "Provider:  %s\nModel:     %s\nContext:   %s",
      ai.state.provider,
      ai.state.model,
      ctx
    ),
    vim.log.levels.INFO,
    { title = "AI Status" }
  )
end

return M
