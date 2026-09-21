-- return {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	build = ":TSUpdate",
-- 	config = function()
-- 		local config = require("nvim-treesitter.configs")
-- 		config.setup({
-- 			auto_install = true,
-- 			ensure_installed = { "lua", "javascript", "typescript", "c", "python", "java" },
-- 			highlight = { enable = true },
-- 			indent = { enable = true },
-- 		})
-- 	end,
-- }

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      },
      indent = { enable = true },
      autotag = { enable = true },
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "python",
        "go",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
