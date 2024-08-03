return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 700
  end,
  opts = {
    -- leave it empty to use the default settings
  },
}
