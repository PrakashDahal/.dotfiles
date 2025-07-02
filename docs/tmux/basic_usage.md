# Tmux for Beginners: A Basic Usage Guide

Tmux is a terminal multiplexer, which means it allows you to create and manage multiple terminal sessions, windows, and panes within a single terminal window. This is incredibly useful for organizing your workflow, especially when working on multiple tasks or connecting to remote servers.

## Why Use Tmux?

*   **Persistence:** Your Tmux sessions can remain active even if you disconnect from your SSH session or close your terminal emulator. You can reattach to them later and find everything exactly as you left it.
*   **Multitasking:** Easily switch between different programs or tasks without opening multiple terminal windows.
*   **Organization:** Divide your terminal into multiple panes to view different outputs or work on related tasks side-by-side.

## Core Concepts

*   **Session:** A collection of windows and panes. You can have multiple named sessions.
*   **Window:** Similar to tabs in a web browser. Each window can contain multiple panes.
*   **Pane:** A rectangular division within a window, allowing you to run different commands simultaneously.
*   **Prefix Key:** The most important concept in Tmux. All Tmux commands start with a prefix key combination. In your configuration, the prefix key is `Ctrl+a` (meaning hold down `Ctrl` and press `a`). Once you press the prefix key, you release it and then press the command key.

## Getting Started

1.  **Start a new Tmux session:**

    Open your terminal and type:

    ```bash
    tmux
    ```

    This will start a new Tmux session. You'll notice a status bar at the bottom of your terminal, indicating that you are inside a Tmux session.

2.  **Detach from a session:**

    To leave a Tmux session running in the background without closing it, press:

    `Ctrl+a` then `d` (for detach)

    You will be returned to your regular terminal prompt.

3.  **List existing sessions:**

    To see a list of your active Tmux sessions:

    ```bash
    tmux ls
    ```

4.  **Attach to a session:**

    To reattach to the last active session:

    ```bash
    tmux attach
    ```

    If you have multiple sessions, you can attach to a specific one by its name or ID:

    ```bash
    tmux attach -t <session-name-or-id>
    ```

## Working with Windows

*   **Create a new window:**

    `Ctrl+a` then `c` (for create)

*   **Switch to the next window:**

    `Ctrl+a` then `n` (for next)

*   **Switch to the previous window:**

    `Ctrl+a` then `p` (for previous)

*   **Switch to a specific window by number:**

    `Ctrl+a` then `<number>` (e.g., `Ctrl+a 0` for the first window)

*   **Close a window:**

    `Ctrl+a` then `&` (you'll be prompted to confirm)

## Working with Panes

*   **Split pane vertically:**

    `Ctrl+a` then `%`

*   **Split pane horizontally:**

    `Ctrl+a` then `"` (double quote)

*   **Navigate between panes:**

    `Ctrl+a` then `<arrow key>` (e.g., `Ctrl+a Left Arrow` to move to the pane on the left)

    *Note: Your configuration also includes smart pane switching with Neovim using `Ctrl+h/j/k/l`.*

*   **Maximize/Unmaximize current pane:**

    `Ctrl+a` then `z`

*   **Close current pane:**

    `Ctrl+a` then `x` (you'll be prompted to confirm)

## Next Steps

This guide covers the absolute basics. To learn more about your specific Tmux configuration, including advanced setup, keybindings, and commands, refer to the `setup_keybindings_commands.md` document.
