return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  config = function()
    vim.g.tmux_navigator_no_mappings = 1 -- Disable default mappings to define our own

    local keymap = vim.keymap

    -- Remap C-h, C-j, C-k, C-l to Tmux navigation
    keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>")
    keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>")
    keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>")
    keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>")
    keymap.set("n", "<C->", ":TmuxNavigatePrevious<CR>")
  end,
}
