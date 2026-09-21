-- lua/plugins/ai.lua
--
-- AI plugin stack. CodeCompanion removed. Avante is the core.
--
-- Plugins:
--   avante.nvim          → sidebar chat, inline edit, diff view
--   render-markdown.nvim → renders markdown in avante chat buffer
--   img-clip.nvim        → paste images into avante chat (optional)

return {

  -- ── Core: Avante ──────────────────────────────────────────────────────────
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,   -- always latest commit (avante moves fast)
    build = "make",    -- required: builds the rust binary for diff rendering

    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "stevearc/dressing.nvim",          -- already in your config
      "nvim-telescope/telescope.nvim",   -- already in your config
      "nvim-tree/nvim-web-devicons",     -- already in your config
      "MeanderingProgrammer/render-markdown.nvim", -- markdown rendering
    },

    config = function()
      -- Bootstrap: load the ai module which sets up avante
      local ai = require("ai")
      ai.setup()
    end,
  },

  -- ── Markdown rendering (avante chat + obsidian) ───────────────────────────
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    event = "BufReadPost",
    opts = {
      file_types = { "markdown", "Avante" },
      headings = {
        icon = "󰎕 ",
        icons = { "󰎕 ", "󰎖 ", "󰎗 ", "󰎘 ", "󰎙 ", "󰎚 " },
      },
      dash = {
        leading_symbol = "—",
        highlight = "RenderMarkdownDash",
      },
      bullet = {
        icons = { "●", "○", "◐", "◉" },
      },
      code = {
        width = "full",
        highlight = "RenderMarkdownCode",
        text = "IndentBlanklineChar",
      },
      indent = {
        skip = "comments",
      },
      render = {
        virtual_lines = "current",
        width = "block",
        padding = { left = 1, right = 1 },
      },
      treesitter = {
        language = "markdown",
      },
    },
  },

  -- ── Image paste support (paste screenshots into avante chat) ─────────────
  -- Optional but very useful: copy a screenshot, paste it into avante chat
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name  = false,
        drag_and_drop = {
          insert_mode = true,
        },
        use_absolute_path = true,
      },
    },
  },

}
