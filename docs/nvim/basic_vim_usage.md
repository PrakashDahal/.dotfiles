# Vim for Beginners: A Simple Guide

Vim is a powerful text editor that works differently from most others. Instead of just typing, you switch between modes to do different things.

## The Main Modes

1.  **Normal Mode:** This is where you start. You use it to move around and give commands (like delete or copy). You *cannot* type text here.
    *   **How to enter:** Press `<Esc>` (Escape key).

2.  **Insert Mode:** This is where you type text. It works like a regular text editor.
    *   **How to enter:** From Normal Mode, press `i` (insert at cursor), `a` (append after cursor), or `o` (new line below).
    *   **How to exit:** Press `<Esc>` to go back to Normal Mode.

3.  **Command-Line Mode (Ex Mode):** This is for special commands like saving or quitting. You'll see a colon (`:`) at the bottom of the screen.
    *   **How to enter:** From Normal Mode, press `:`.
    *   **How to exit:** After running a command, you go back to Normal Mode.

## Getting Started

1.  **Open Vim:**
    ```bash
    vim filename.txt
    ```
    (If `filename.txt` doesn't exist, Vim will create it.)

2.  **Type Text:**
    *   Press `i` to enter **Insert Mode**.
    *   Type your text.

3.  **Save Your Work:**
    *   Press `<Esc>` to go to **Normal Mode**.
    *   Type `:w` and press `<Enter>`.

4.  **Quit Vim:**
    *   Press `<Esc>` to go to **Normal Mode**.
    *   Type `:q` and press `<Enter>`.
    *   If you have unsaved changes, use `:q!` to quit without saving, or `:wq` to save and quit.

## Basic Movements (in Normal Mode)

*   `h`: Move left
*   `j`: Move down
*   `k`: Move up
*   `l`: Move right
*   `w`: Move to the start of the next word
*   `b`: Move to the start of the previous word
*   `gg`: Go to the very first line of the file
*   `G`: Go to the very last line of the file
*   `{number}G`: Go to a specific line number (e.g., `10G` goes to line 10)

## Basic Editing (in Normal Mode)

*   `x`: Delete the character under the cursor
*   `dd`: Delete the entire current line
*   `yy`: Copy (yank) the entire current line
*   `p`: Paste what you copied or deleted
*   `u`: Undo your last change
*   `<C-r>`: Redo a change you undid

## Practice Makes Perfect!

Vim takes some getting used to, but it's very efficient once you learn the basics. Keep practicing, and remember: if you're stuck, just press `<Esc>` to get back to Normal Mode.