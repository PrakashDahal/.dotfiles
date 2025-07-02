# Neovim Setup Guide

This document provides instructions for setting up your Neovim configuration.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Neovim (v0.9.0 or later recommended):** You can download it from the [Neovim GitHub releases page](https://github.com/neovim/neovim/releases).
- **Terminal Emulator:** A terminal emulator that supports true color and ligatures (e.g., Alacritty, Kitty, WezTerm) is recommended for optimal experience.
- **Git:** For cloning the dotfiles repository and managing plugins.
- **Node.js and npm/yarn:** Required for some LSP servers and formatters (e.g., `eslint_d`, `prettier`).
- **Python and pip:** Required for some LSP servers and linters (e.g., `pylint`, `pyright`).
- **`ripgrep` (rg):** Used by Telescope for fast searching.
- **`fd`:** Used by Telescope for fast file finding.
- **`fzf`:** Used by Telescope for fuzzy finding.
- **`lazygit`:** A simple terminal UI for git.
- **`make`:** Required for building some plugins (e.g., `telescope-fzf-native.nvim`).

## Installation Steps

1.  **Clone the dotfiles repository:**

    ```bash
    git clone https://github.com/prakashdahal/.dotfiles.git ~/.dotfiles
    ```

2.  **Backup your existing Neovim configuration (optional but recommended):**

    ```bash
    mv ~/.config/nvim ~/.config/nvim_backup
    mv ~/.local/share/nvim ~/.local/share/nvim_backup
    mv ~/.cache/nvim ~/.cache/nvim_backup
    ```

3.  **Create a symlink to your Neovim configuration:**

    ```bash
    ln -s ~/.dotfiles/nvim ~/.config/nvim
    ```

4.  **Open Neovim:**

    Upon the first launch, `lazy.nvim` (your plugin manager) will automatically install all the defined plugins. This might take some time depending on your internet connection.

    ```bash
    nvim
    ```

5.  **Install LSP Servers and Formatters (if prompted or needed):**

    Many language servers and formatters are managed by `mason.nvim` (a dependency of `nvim-lspconfig`). When you open a file type for the first time, Mason might prompt you to install the relevant LSP server. You can also manually install them using the `:Mason` command in Neovim.

    For example, to install `pyright` (Python LSP) and `black` (Python formatter):

    ```
    :MasonInstall pyright black
    ```

    Refer to the `mason.nvim` documentation for a full list of available servers and tools.

## Post-Installation

- **Font:** Ensure you have a [Nerd Font](https://www.nerdfonts.com/) installed and configured in your terminal emulator for proper display of icons and glyphs.
- **Terminal Emulator:** For optimal experience, use a terminal emulator that supports true color and ligatures (e.g., Alacritty, Kitty, WezTerm).

Your Neovim setup should now be ready to use! Refer to `how_to_run.md` for basic usage and `keybindings.md` for a comprehensive list of keybindings.
