# Neovim Keybindings

This document outlines the keybindings configured in your Neovim setup.

## General Keybindings (from `vim-config.lua`)

| Keybinding   | Description                                     |
| ------------ | ----------------------------------------------- |
| `K` (visual) | Move selected lines up                          |
| `J` (visual) | Move selected lines down                        |
| `<C-d>`      | Scroll half page down, keeping cursor in middle |
| `<C-u>`      | Scroll half page up, keeping cursor in middle   |
| `<leader>y`  | Yank to system clipboard (normal mode)          |
| `<leader>y`  | Yank to system clipboard (visual mode)          |
| `<leader>Y`  | Yank current line to system clipboard           |
| `<C-S-<>`    | Go back in file history                         |
| `<C-S->>`    | Go forward in file history                      |
| `<leader>sv` | Split window vertically                         |
| `<leader>sh` | Split window horizontally                       |
| `<leader>se` | Make splits equal size                          |
| `<leader>sx` | Close current split window                      |
| `<C-h>`      | Move to left split                              |
| `<C-j>`      | Move to below split                             |
| `<C-k>`      | Move to above split                             |
| `<C-l>`      | Move to right split                             |
| `<leader>o`  | Add a new line below the current line           |
| `<leader>O`  | Add a new line above the current line           |
| `<leader>lz` | Open Lazy.nvim dashboard                        |

## Plugin-Specific Keybindings

### AI (from `ai.lua`)

| Keybinding   | Description            |
| ------------ | ---------------------- |
| `<Leader>ai` | Toggle Copilot/Codeium |
| `<Leader>cc` | Open AI Chat           |
| `<Leader>as` | Check Active AI        |

### Alpha (from `alpha.lua`)

These keybindings are available on the Alpha dashboard (startup screen).

| Keybinding | Description                             |
| ---------- | --------------------------------------- |
| `SPC wr`   | Restore Session For Current Directory   |
| `SPC ee`   | Toggle file explorer (`NvimTreeToggle`) |
| `SPC ff`   | Find File (`Telescope find_files`)      |
| `SPC fs`   | Find Word (`Telescope live_grep`)       |
| `SPC l`    | See Lazy dashboard (`Lazy`)             |
| `q`        | Quit NVIM                               |

### Auto Session (from `auto-session.lua`)

| Keybinding   | Description                                   |
| ------------ | --------------------------------------------- |
| `<leader>wr` | Restore session for current working directory |
| `<leader>ws` | Save session for auto session root directory  |

### Completions (from `completions.lua`)

| Keybinding  | Description                                        |
| ----------- | -------------------------------------------------- |
| `<C-k>`     | Select previous completion suggestion              |
| `<C-j>`     | Select next completion suggestion                  |
| `<C-f>`     | Scroll documentation up                            |
| `<C-d>`     | Scroll documentation down                          |
| `<C-Space>` | Show completion suggestions                        |
| `<C-e>`     | Close completion window                            |
| `<CR>`      | Confirm selected completion                        |
| `<Tab>`     | Confirm completion or expand/jump snippet          |
| `<S-Tab>`   | Select previous completion or jump back in snippet |

### Formatter (from `formatter.lua`)

| Keybinding   | Description                           |
| ------------ | ------------------------------------- |
| `<leader>mp` | Format file or range (in visual mode) |

### Gitsigns (from `gitsigns.lua`)

| Keybinding             | Description          |
| ---------------------- | -------------------- |
| `]z`                   | Next Hunk            |
| `[z`                   | Previous Hunk        |
| `<leader>zs`           | Stage hunk           |
| `<leader>zr`           | Reset hunk           |
| `<leader>zS`           | Stage buffer         |
| `<leader>zR`           | Reset buffer         |
| `<leader>zu`           | Undo stage hunk      |
| `<leader>zp`           | Preview hunk         |
| `<leader>zb`           | Blame line           |
| `<leader>zB`           | Toggle line blame    |
| `<leader>zd`           | Diff this            |
| `<leader>zD`           | Diff this ~          |
| `iz` (operator/visual) | Gitsigns select hunk |

### Harpoon (from `harpoon.lua`)

| Keybinding   | Description                   |
| ------------ | ----------------------------- |
| `<leader>ah` | Add file to Harpoon           |
| `<leader>h`  | Toggle Harpoon menu           |
| `<C-n>`      | Navigate to next Harpoon file |

### LazyGit (from `lazygit.lua`)

| Keybinding   | Description   |
| ------------ | ------------- |
| `<leader>lg` | Open lazy git |

### Linting (from `linting.lua`)

| Keybinding   | Description                      |
| ------------ | -------------------------------- |
| `<leader>lt` | Trigger linting for current file |

### NvimTree (from `nvim-tree.lua`)

| Keybinding   | Description                          |
| ------------ | ------------------------------------ |
| `<leader>ee` | Toggle file explorer                 |
| `<leader>ef` | Toggle file explorer on current file |
| `<leader>ec` | Collapse file explorer               |
| `<leader>er` | Refresh file explorer                |

### Substitute (from `substitute.lua`)

| Keybinding | Description                          |
| ---------- | ------------------------------------ |
| `s`        | Substitute with motion (normal mode) |
| `ss`       | Substitute line                      |
| `S`        | Substitute to end of line            |
| `s`        | Substitute in visual mode            |

### Telescope (from `telescope.lua`)

| Keybinding   | Description                                           |
| ------------ | ----------------------------------------------------- |
| `<leader>fg` | Find added git files                                  |
| `<leader>ff` | Fuzzy find files in current working directory         |
| `<leader>fr` | Fuzzy find recent files                               |
| `<leader>fs` | Find string in current working directory              |
| `<leader>fc` | Find string under cursor in current working directory |
| `<leader>ft` | Find todos                                            |
| `<leader>p`  | Discover Neovim projects                              |

### Todo Comments (from `todo-comments.lua`)

| Keybinding | Description           |
| ---------- | --------------------- |
| `]t`       | Next todo comment     |
| `[t`       | Previous todo comment |

### Treesitter (from `treesitter.lua`)

| Keybinding  | Description                      |
| ----------- | -------------------------------- |
| `<C-space>` | Initialize incremental selection |
| `<C-space>` | Incrementally select node        |
| `<bs>`      | Decrement selection              |

### Trouble (from `trouble.lua`)

| Keybinding   | Description                        |
| ------------ | ---------------------------------- |
| `<leader>xw` | Open trouble workspace diagnostics |
| `<leader>xd` | Open trouble document diagnostics  |
| `<leader>xq` | Open trouble quickfix list         |
| `<leader>xl` | Open trouble location list         |
| `<leader>xt` | Open todos in trouble              |

### Undotree (from `undotree.lua`)

| Keybinding  | Description            |
| ----------- | ---------------------- |
| `<leader>u` | Show undo tree on left |

### Vim Maximizer (from `vim-maximizer.lua`)

| Keybinding   | Description               |
| ------------ | ------------------------- |
| `<leader>sm` | Maximize/minimize a split |

### LSP (from `lspconfig.lua`)

| Keybinding   | Description                                 |
| ------------ | ------------------------------------------- |
| `gR`         | Show LSP references                         |
| `gD`         | Go to declaration                           |
| `gd`         | Show LSP definitions                        |
| `gi`         | Show LSP implementations                    |
| `gt`         | Show LSP type definitions                   |
| `<leader>ca` | See available code actions                  |
| `<leader>rn` | Smart rename                                |
| `<leader>D`  | Show buffer diagnostics                     |
| `<leader>d`  | Show line diagnostics                       |
| `[d`         | Go to previous diagnostic                   |
| `]d`         | Go to next diagnostic                       |
| `K`          | Show documentation for what is under cursor |
| `<leader>rs` | Restart LSP                                 |
