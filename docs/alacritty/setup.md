# Alacritty Setup Guide

This document provides instructions for setting up your Alacritty terminal emulator configuration.

## Prerequisites

Before you begin, ensure you have the following installed:

*   **Alacritty:** You can find installation instructions on the [Alacritty GitHub page](https://github.com/alacritty/alacritty#installation).
*   **Font:** A Nerd Font is recommended for proper display of icons and glyphs, especially if you use tools like Neovim with `nvim-web-devicons`.

## Installation Steps

1.  **Clone the dotfiles repository:**

    ```bash
    git clone https://github.com/prakashdahal/dotfiles.git ~/.dotfiles
    ```

2.  **Backup your existing Alacritty configuration (optional but recommended):**

    ```bash
    mv ~/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml_backup
    ```

3.  **Create a symlink to your Alacritty configuration:**

    ```bash
    ln -s ~/.dotfiles/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
    ```

4.  **Restart Alacritty:**

    Close and reopen Alacritty for the changes to take effect.

## Configuration Details

Your Alacritty configuration is located at `~/.config/alacritty/alacritty.toml`. This file defines various aspects of your terminal, including:

*   **Font settings:** `font.normal`, `font.bold`, `font.italic`, `font.bold_italic`, `size`.
*   **Window settings:** `opacity`.
*   **Colors:** `colors.primary`, `colors.cursor`, `colors.normal`, `colors.bright`.

Refer to the `alacritty.toml` file for specific values and comments.
