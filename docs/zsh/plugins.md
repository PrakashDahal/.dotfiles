# Zsh Plugins

Your Zsh configuration leverages several plugins managed by Oh My Zsh to enhance functionality and user experience. Below is a list of the plugins enabled in your `.zshrc` file, along with a brief description of what each plugin provides.

## Enabled Plugins

The following plugins are enabled in your `~/.zshrc`:

*   **`git`**: Provides many useful aliases and functions for Git. This is a core Oh My Zsh plugin.
*   **`gitfast`**: Offers faster Git status and other Git-related operations, especially in large repositories.
*   **`colored-man-pages`**: Adds syntax highlighting to `man` pages, making them easier to read.
*   **`history-substring-search`**: Allows you to search through your command history by typing a substring and pressing the up/down arrow keys.
*   **`zsh-completions`**: Provides additional completion definitions for various commands, improving tab completion.
*   **`zsh-autosuggestions`**: Suggests commands as you type based on your command history, similar to a predictive text feature.
*   **`cp`**: Provides aliases for the `cp` command.
*   **`you-should-use`**: A plugin that suggests better alternatives to commonly used commands (e.g., suggesting `exa` instead of `ls`).
*   **`web-search`**: Enables quick web searches directly from your terminal using predefined aliases (e.g., `google <query>`, `duckduckgo <query>`).
*   **`dirhistory`**: Enhances directory navigation by providing commands to jump to previously visited directories.

## How to Manage Plugins

Plugins are managed through Oh My Zsh. To enable or disable a plugin, you edit the `plugins` array in your `~/.zshrc` file. After making changes, you need to source your `.zshrc` file or open a new terminal session for the changes to take effect.

```bash
# Example of plugins array in ~/.zshrc
plugins=(
    git
    gitfast
    # ... other plugins ...
)
```

For more information on specific plugins or to discover new ones, refer to the [Oh My Zsh plugins documentation](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins).
