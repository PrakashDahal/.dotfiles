return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find all files" })
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find added git files" }) -- note: this is dublicated with fg. But I want to keep it this way. You can remove
      vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find added git files" })
      vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Search in all files" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
