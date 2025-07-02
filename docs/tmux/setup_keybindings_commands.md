# Tmux Setup, Keybindings, and Commands

This document details the specific Tmux configuration in your dotfiles, including installation, custom keybindings, and useful commands.

## Tmux Configuration File

Your Tmux configuration is located at `~/.tmux.conf`.

## Installation and Setup

1.  **Install Tmux:** If you don't have Tmux installed, refer to your operating system's package manager (e.g., `sudo apt install tmux` on Debian/Ubuntu, `sudo pacman -S tmux` on Arch Linux, `brew install tmux` on macOS).

2.  **Clone the dotfiles repository:**

    ```bash
    git clone https://github.com/prakashdahal/dotfiles.git ~/.dotfiles
    ```

3.  **Backup your existing Tmux configuration (optional but recommended):**

    ```bash
    mv ~/.tmux.conf ~/.tmux.conf_backup
    ```

4.  **Create a symlink to your Tmux configuration:**

    ```bash
    ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
    ```

5.  **Install Tmux Plugin Manager (TPM):**

    TPM is used to manage Tmux plugins, including the Catppuccin theme. If you don't have it, install it by running:

    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

6.  **Install Tmux Plugins:**

    *   Start a new Tmux session (or `tmux kill-server` and restart Tmux).
    *   Inside Tmux, press your prefix key (`Ctrl+a`) followed by `I` (capital `i`, as in Install) to fetch and install the plugins defined in your `.tmux.conf`.

7.  **Configure `vim-tmux-navigator` in Neovim:**

    For seamless pane switching between Tmux and Neovim, ensure you have `christoomey/vim-tmux-navigator` (or a similar plugin) installed and configured in your Neovim setup. This plugin works in conjunction with the Tmux configuration to allow `Ctrl+h/j/k/l` to navigate between Neovim splits and Tmux panes.

## Keybindings

Your Tmux configuration uses `Ctrl+a` as the prefix key. All custom keybindings are pressed *after* the prefix key.

| Keybinding      | Description                                                                 |
| --------------- | --------------------------------------------------------------------------- |
| `Ctrl+a` then `r` | Reload the Tmux configuration file (`~/.tmux.conf`). Useful after making changes. |
| `Ctrl+a` then `C-h` | Move to the pane on the left (smartly navigates into/out of Neovim).        |
| `Ctrl+a` then `C-j` | Move to the pane below (smartly navigates into/out of Neovim).              |
| `Ctrl+a` then `C-k` | Move to the pane above (smartly navigates into/out of Neovim).              |
| `Ctrl+a` then `C-l` | Move to the pane on the right (smartly navigates into/out of Neovim).       |
| `Ctrl+a` then `C-\` | Select the last active pane (smartly navigates into/out of Neovim).         |

### Default Tmux Keybindings (still active)

Many standard Tmux keybindings remain active. Here are some common ones:

| Keybinding      | Description                                 |
| --------------- | ------------------------------------------- |
| `Ctrl+a` then `c` | Create a new window                         |
| `Ctrl+a` then `n` | Move to the next window                     |
| `Ctrl+a` then `p` | Move to the previous window                 |
| `Ctrl+a` then `<number>` | Go to window by number (e.g., `Ctrl+a 0`) |
| `Ctrl+a` then `%` | Split pane vertically                       |
| `Ctrl+a` then `"` | Split pane horizontally                     |
| `Ctrl+a` then `z` | Maximize/unmaximize current pane            |
| `Ctrl+a` then `x` | Close current pane (prompts for confirmation) |
| `Ctrl+a` then `d` | Detach from the current session             |
| `Ctrl+a` then `[` | Enter copy mode (use `vi` keys for navigation) |
| `Ctrl+a` then `]` | Paste from Tmux buffer                      |

## Commands

You can execute Tmux commands directly from your shell or within a Tmux session by pressing `Ctrl+a` then `:` (colon) to enter the Tmux command prompt.

*   `tmux new -s <session-name>`: Create a new named session.
*   `tmux attach -t <session-name>`: Attach to a named session.
*   `tmux ls`: List all active Tmux sessions.
*   `tmux kill-session -t <session-name>`: Kill a specific session.
*   `tmux kill-server`: Kill all Tmux sessions and the Tmux server.

## Theme

Your Tmux configuration uses the **Catppuccin (Mocha)** theme, applied via the `catppuccin/tmux` plugin. This provides a consistent and aesthetically pleasing color scheme across your terminal environment.

## Mouse Support

Mouse support is enabled, allowing you to use your mouse to:

*   Select panes.
*   Resize panes.
*   Scroll through pane history.

## Copy Mode

Copy mode is set to use `vi` keybindings (`set-window-option -g mode-keys vi`). To enter copy mode, press `Ctrl+a` then `[`. You can then use `vi` navigation keys (e.g., `h`, `j`, `k`, `l`, `w`, `b`) to move around, `v` to start a selection, and `y` to yank (copy) the selection. Press `q` to exit copy mode.
