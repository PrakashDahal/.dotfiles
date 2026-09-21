local opt = vim.opt

local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

opt.mouse = "a"
opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.smartindent = true
opt.wrap = true
opt.swapfile = false
opt.backup = false
opt.undodir = undodir
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 10
opt.signcolumn = "yes"

opt.updatetime = 50
opt.colorcolumn = "80"

opt.conceallevel = 1

local keymap = vim.keymap
vim.g.mapleader = " "
keymap.set("n", "<leader>pv", "<cmd>Ex<CR>", { desc = "Execute Explore command. Takes back in repo" })

keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("n", "<leader>y", '"+y')
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>Y", '"+Y')

keymap.set("n", "<C-S-Left>", "<C-o>", { noremap = true, silent = true })
keymap.set("n", "<C-S-Right>", "<C-i>", { noremap = true, silent = true })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>o", "mzo<Esc>k", { desc = "Add line below" })
keymap.set("n", "<leader>O", "mzo<Esc>j", { desc = "Add line above" })

keymap.set("n", "<leader>lz", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
keymap.set("n", "<leader>no", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Obsidian quick switch" })
keymap.set("n", "<leader>nn", "<cmd>ObsidianNew<CR>", { desc = "Obsidian new note" })
keymap.set("n", "<leader>ns", "<cmd>ObsidianSearch<CR>", { desc = "Obsidian search" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt.conceallevel = 0
    vim.opt.wrap = true
    vim.opt.linebreak = true
    vim.opt.spell = true
  end,
})
