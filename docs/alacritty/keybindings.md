# Alacritty Keybindings

Alacritty's keybindings are primarily configured within the `alacritty.toml` file. Unlike some other terminal emulators, Alacritty focuses on performance and simplicity, and many common keybindings are handled by your shell or applications running within the terminal (e.g., Neovim, tmux).

## Default Keybindings (from `alacritty.toml`)

Your `alacritty.toml` currently defines the following keybindings:

| Keybinding | Description                                 |
| ---------- | ------------------------------------------- |
| `None`     | No explicit keybindings are defined in your `alacritty.toml` file. |

## Common Terminal Keybindings

Many common actions are handled by your shell (e.g., Zsh, Bash) or multiplexer (e.g., tmux).

*   **Copy/Paste:** Alacritty supports OSC 52 for copy/paste, which allows applications like Neovim to interact with the system clipboard. You can typically use your system's standard copy/paste shortcuts (e.g., `Ctrl+Shift+C`/`Ctrl+Shift+V` on Linux, `Cmd+C`/`Cmd+V` on macOS).
*   **New Tab/Window:** These are usually managed by your desktop environment or window manager.
*   **Scrolling:** Use your mouse scroll wheel or your shell's history navigation (e.g., `Ctrl+P`/`Ctrl+N` in Bash/Zsh).

For more advanced keybinding configurations, you would typically define them within your shell's configuration (e.g., `.zshrc`, `.bashrc`) or a terminal multiplexer like tmux.
