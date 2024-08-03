local opt = vim.opt
local keymap = vim.keymap

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
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 10
opt.signcolumn = "yes"

opt.updatetime = 50
opt.colorcolumn = "80"

opt.conceallevel = 1

vim.g.mapleader = " "
keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Execute Explore command. Takes back in repo" })

-- move selected (visual) up and down with J and K (note: Not j and k)
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Keep your cursor in middle of the screen
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Yank outside the vim with <leader>y
-- opt.clipboard:append("unnamedplus")
keymap.set("n", "<leader>y", '"+y')
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>Y", '"+Y')

-- Go back and forth in files
keymap.set("n", "<C-S-<>", "<C-o>", { noremap = true, silent = true })
keymap.set("n", "<C-S->>", "<C-i>", { noremap = true, silent = true })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })     -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
