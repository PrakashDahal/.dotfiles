# Zsh Setup Guide

This document provides instructions for setting up your Zsh shell configuration.

## Prerequisites

Before you begin, ensure you have the following installed:

*   **Zsh:** Your system should have Zsh installed. If not, refer to your distribution's documentation for installation instructions.
*   **Oh My Zsh:** This framework manages your Zsh configuration, themes, and plugins. Follow the installation instructions on the [Oh My Zsh GitHub page](https://ohmyz.sh/).
*   **Powerlevel10k:** This is the theme used for your Zsh prompt. Follow the installation instructions on the [Powerlevel10k GitHub page](https://github.com/romkatv/powerlevel10k#installation).

## Installation Steps

1.  **Clone the dotfiles repository:**

    ```bash
    git clone https://github.com/prakashdahal/dotfiles.git ~/.dotfiles
    ```

2.  **Backup your existing Zsh configuration (optional but recommended):**

    ```bash
    mv ~/.zshrc ~/.zshrc_backup
    ```

3.  **Create a symlink to your Zsh configuration:**

    ```bash
    ln -s ~/.dotfiles/.zshrc ~/.zshrc
    ```

4.  **Configure Powerlevel10k:**

    After symlinking the `.zshrc` file, open a new terminal. You will be prompted to configure Powerlevel10k. Follow the on-screen instructions to customize your prompt.

    If the configuration wizard doesn't start automatically, you can run it manually:

    ```bash
    p10k configure
    ```

5.  **Install additional plugins (if not already installed by Oh My Zsh):**

    Some plugins might require manual installation. Refer to `plugins.md` for a list of plugins used and their potential installation steps.

## Custom Configuration

Your main Zsh configuration is located in `~/.zshrc`. This file sources Oh My Zsh and defines various settings, including:

*   **Theme:** `ZSH_THEME="powerlevel10k/powerlevel10k"` sets the Powerlevel10k theme.
*   **Plugins:** The `plugins` array lists the Oh My Zsh plugins that are enabled. Refer to `plugins.md` for details on each plugin.
*   **Custom Bash Files:** Your `.zshrc` sources `~/Documents/bashScripts/customBashFiles/personalBash.sh`. This file likely contains personal aliases, functions, or environment variables.
*   **Angular CLI Autocompletion:** The line `source <(ng completion script)` enables autocompletion for Angular CLI commands.

Any further customizations, such as additional aliases or functions, can be added directly to `~/.zshrc` or to the `personalBash.sh` file.
