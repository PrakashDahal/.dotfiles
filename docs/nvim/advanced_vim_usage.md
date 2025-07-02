# Advanced Vim Usage: Unleashing the Power

This guide builds upon the basic Vim concepts and introduces more advanced techniques, motions, and features that will significantly boost your editing efficiency. While it's detailed, it aims to be understandable for new Vim users who have grasped the fundamentals.

## The Power of Operators and Motions

Vim's true power lies in combining **operators** (what you want to do) with **motions** (where you want to do it). This creates a highly efficient and expressive language for editing.

**Common Operators:**

- `d`: Delete
- `y`: Yank (copy)
- `c`: Change (delete and enter Insert Mode)
- `v`: Visual select (already covered, but important for context)
- `>`: Indent
- `<`: Unindent

\*\*Review of Basic Motions (from `basic_vim_usage.md`):

- `h`, `j`, `k`, `l`: Character movements
- `w`, `b`, `e`: Word movements
- `0`, `^`, `$`: Line start/end
- `gg`, `G`: File start/end
- `{number}j`, `{number}k`, `{number}G`: Repeat movements

**Combining Operators and Motions (Examples):**

- `dw`: Delete word (from cursor to end of word)
- `d$`: Delete to end of line
- `dd`: Delete current line (special case: `d` operator applied to `d` motion, which means current line)
- `yw`: Yank word
- `ce`: Change to end of word
- `y$`: Yank to end of line
- `c0`: Change to beginning of line
- `dap`: Delete around paragraph (deletes the current paragraph, including blank lines)
- `yip`: Yank inner paragraph (yanks the text of the current paragraph, excluding blank lines)
- `ciw`: Change inner word (changes the word under the cursor)
- `das`: Delete a sentence

**Text Objects (The "a" and "i" prefixes):**

Text objects allow you to operate on logical blocks of text. They are often used with operators.

- `a`: "around" - includes the surrounding whitespace or delimiters.
- `i`: "inner" - excludes the surrounding whitespace or delimiters.

Common Text Objects:

- `w`: word
- `p`: paragraph
- `s`: sentence
- `(` or `)`: parentheses `()`
- `{` or `}`: curly braces `{}`
- `[` or `]`: square brackets `[]`
- `<` or `>`: angle brackets `<>`
- `'` or `'`: single quotes `''`
- `"` or `"`: double quotes `""`
- `` ` `` or `` ` ``: backticks `````

**Examples with Text Objects:**

- `di(`: Delete inner parentheses (deletes content inside `()`, not the parentheses themselves)
- `da[`: Delete around square brackets (deletes content inside `[]` and the brackets themselves)
- `yi"`: Yank inner double quotes (yanks content inside `""`, not the quotes)
- `ca{`: Change around curly braces (changes content inside `{}` and the braces themselves)

## Repeating Actions: The Dot Command (`.`) and Numbers

- **The Dot Command (`.`):** Repeats the _last change_ you made. This is incredibly powerful for repetitive tasks.

  - Example: If you delete a line with `dd`, pressing `.` will delete another line.
  - Example: If you change a word with `ciw` and type something, pressing `.` will change the next word to the same text.

- **Numbers as Multipliers:** You can prefix most commands with a number to repeat them that many times.
  - `5dd`: Delete 5 lines.
  - `3yw`: Yank 3 words.
  - `10j`: Move down 10 lines.
  - `5x`: Delete 5 characters.

## Macros: Recording and Replaying Actions (`q`)

Macros allow you to record a sequence of keystrokes and then replay them multiple times. This is perfect for complex, repetitive tasks.

1.  **Start Recording:** Press `q` followed by a letter (e.g., `a` to `z`) to store the macro in that register. For example, `qa` starts recording into register `a`.
2.  **Perform Actions:** Do the sequence of edits you want to record.
3.  **Stop Recording:** Press `q` again.
4.  **Replay Macro:** Press `@` followed by the register letter (e.g., `@a` to replay macro `a`).
5.  **Replay Multiple Times:** Prefix with a number (e.g., `10@a` to replay macro `a` 10 times).

**Example Macro Scenario:** You have a list of items, and you want to wrap each item in HTML `<li>` tags.

- Go to the first item.
- `qa` (start recording into register `a`)
- `I<li>` (go to beginning of line, insert `<li>`)
- `<Esc>` (exit insert mode)
- `A</li>` (go to end of line, append `</li>`)
- `<Esc>` (exit insert mode)
- `j` (move to the next line)
- `q` (stop recording)
- Now, for the remaining items, just press `@a` or `5@a` if you have 5 more items.

## Advanced Visual Mode

Visual mode is not just for selecting text; it's for applying operators to a selection.

- **`v` (Character-wise):** Selects characters.
- **`V` (Line-wise):** Selects entire lines.
- **`<C-v>` (Block-wise):** Selects a rectangular block of text. This is incredibly useful for inserting text at multiple lines simultaneously or deleting columns.

\*\*Actions in Visual Mode (Review & More):

Once text is selected, you can apply operators:

- `d`: Delete selected text.
- `y`: Yank (copy) selected text.
- `c`: Change selected text (deletes and enters Insert Mode).
- `>`: Indent selected lines.
- `<`: Unindent selected lines.
- `~`: Toggle case of selected characters.
- `gU`: Make selected text uppercase.
- `gu`: Make selected text lowercase.

**Block Visual Mode (`<C-v>`) Power:**

1.  **Insert text at multiple lines:**

    - `Ctrl+v` to enter block visual mode.
    - Select the desired lines (move `j` or `k`).
    - Press `I` (capital `i`) to insert at the beginning of the block, or `A` (capital `a`) to append at the end.
    - Type your text.
    - Press `<Esc>` twice. The text will appear on all selected lines.

2.  **Delete columns:**
    - `Ctrl+v` to enter block visual mode.
    - Select the column you want to delete.
    - Press `d`.

## Command-Line Mode (`:`) - Beyond Basic File Operations

Command-Line mode allows you to execute powerful commands, often with ranges and flags.

- **Ranges:** You can specify a range of lines for a command.
  - `:{start},{end}command`: Apply command from `start` line to `end` line.
  - `:%command`: Apply command to the entire file (same as `1,$command`).
  - `:.command`: Apply command to the current line.
  - `:'a,'b command`: Apply command from mark `a` to mark `b`.
  - `:'<,'> command`: Apply command to the currently visually selected lines.

**Examples with Ranges:**

- `:10,20d`: Delete lines 10 through 20.
- `:%s/old/new/g`: Replace all occurrences of `old` with `new` in the entire file.
- `:.,+5d`: Delete current line and the next 5 lines.

**Global Command (`:g`):**

The global command allows you to execute a command on lines that match a pattern.

- `:g/{pattern}/command`: Execute `command` on all lines matching `pattern`.
- `:g!/{pattern}/command` or `:v/{pattern}/command`: Execute `command` on all lines _not_ matching `pattern` (inverse global).

**Example Global Commands:**

- `:g/TODO/d`: Delete all lines containing "TODO".
- `:g/^#/d`: Delete all lines that start with `#` (comments).
- `:g/function/normal! I// ` `: Add `// ` at the beginning of every line containing "function".

## Registers: Your Clipboards and More (`"`)

Vim has multiple registers (like clipboards) where you can store text.

- **Unnamed Register (`"`):** This is the default register for `y` (yank), `d` (delete), `c` (change), and `p` (paste). Whatever you yank or delete goes here.
- **Numbered Registers (`"0` to `"9`):** `"0` stores the last yanked text. `"1` stores the last deleted/changed text, `"2` the second to last, and so on.
- **Named Registers (`"a` to `"z`):** You can explicitly specify a register to yank or delete into, or paste from.
  - `"ayy`: Yank the current line into register `a`.
  - `"ap`: Paste the contents of register `a`.
  - `"Adw`: Append the deleted word to register `A` (uppercase appends).
- **Black Hole Register (`"_`):** If you delete or yank into this register, the text is discarded. Useful when you want to delete something without affecting your main clipboard.
  - `"_dd`: Delete a line without putting it in any register.
- **System Clipboard Register (`"+` or `"*`):** Allows interaction with your system's clipboard.
  - `"+yy`: Yank current line to system clipboard.
  - `"+p`: Paste from system clipboard.

## Marks: Jumping Around (`m`, `'`, `` ` ``)

Marks allow you to save specific positions in your files and jump back to them quickly.

- **Set a Mark:** `m` followed by a lowercase letter (`a` to `z`) to set a local mark (within the current file), or an uppercase letter (`A` to `Z`) for a global mark (across files).
  - `ma`: Set mark `a` at the current cursor position.
- **Jump to a Mark:**
  - `` `a ``: Jump to the exact position of mark `a`.
  - `'a`: Jump to the beginning of the line where mark `a` was set.
- **List Marks:** `:marks`

## Buffers, Windows, and Tabs

Vim's terminology for managing files and views:

- **Buffer:** An in-memory representation of a file. When you open a file, it's loaded into a buffer. You can have many buffers open, even if they are not visible.
- **Window:** A viewport into a buffer. You can split your Vim screen into multiple windows to view different buffers or different parts of the same buffer.
- **Tab Page:** A collection of windows. Similar to tabs in a web browser, but each Vim tab can contain its own unique window layout.

**Buffer Commands:**

- `:ls` or `:buffers`: List all open buffers.
- `:bnext` or `:bn`: Go to the next buffer.
- `:bprev` or `:bp`: Go to the previous buffer.
- `:bdelete` or `:bd`: Close a buffer.
- `:buffer {number}` or `:buffer {name}`: Go to a specific buffer.

**Window Commands:**

- `:sp` or `:split`: Split the current window horizontally.
- `:vsp` or `:vsplit`: Split the current window vertically.
- `<C-w>h`, `<C-w>j`, `<C-w>k`, `<C-w>l`: Move between windows.
- `<C-w>c`: Close the current window.
- `<C-w>o`: Close all other windows except the current one.

**Tab Page Commands:**

- `:tabnew`: Create a new tab page.
- `:tabnext` or `:tabn`: Go to the next tab page.
- `:tabprevious` or `:tabp`: Go to the previous tab page.
- `:tabclose`: Close the current tab page.
- `gt`: Go to the next tab page.
- `gT`: Go to the previous tab page.

## Folds: Hiding Code Blocks (`za`, `zc`, `zo`, `zm`, `zr`, `zR`, `zd`, `zD`)

Folds allow you to hide sections of code to improve readability and navigate large files more easily.

- `za`: Toggle fold (open if closed, close if open).
- `zc`: Close fold.
- `zo`: Open fold.
- `zm`: More folds (close folds at current level).
- `zr`: Reduce folds (open folds at current level).
- `zR`: Open all folds.
- `zM`: Close all folds.
- `zd`: Delete fold at cursor.
- `zD`: Delete all folds.

## Arguments List: Working with Multiple Files (`:args`, `:next`, `:prev`)

The arguments list is a way to manage a set of files you're working on.

- `:args {files}`: Set the arguments list (e.g., `:args *.js`)
- `:args`: Show the current arguments list.
- `:next` or `:n`: Go to the next file in the arguments list.
- `:prev` or `:p`: Go to the previous file in the arguments list.
- `:first` or `:rewind`: Go to the first file.
- `:last`: Go to the last file.

## Handy Tips

### Saving Files with Sudo Privileges

Sometimes you open a file that requires root (sudo) permissions to save, but you forgot to open Vim with `sudo vim`. Instead of quitting and reopening, you can save the file directly from within Vim:

```vim
:w !sudo tee %
```

**Explanation:**

- `:w`: The standard write command.
- `!`: Tells Vim to run the following command in the shell.
- `sudo tee %`: This is the shell command.
  - `sudo`: Executes the `tee` command with superuser privileges.
  - `tee`: A command that reads from standard input and writes to standard output and files. Here, it reads the content of the current buffer (which Vim pipes to `tee`'s standard input).
  - `%`: A special Vim register that expands to the current file's path.

This command effectively pipes the current buffer's content through `sudo tee` to overwrite the original file with root permissions.

### Executing Shell Commands

You don't always need to leave Vim to run a shell command. You can execute commands directly from Command-Line mode:

- `:{command}`: Execute a shell command. The output will be displayed in Vim.
  - Example: `:!ls -l` will list files in the current directory.
- `:{range}w !{command}`: Filter a range of lines through an external command.
  - Example: `:%w !sort` will sort the entire file.
- `:{range}r !{command}`: Read the output of an external command into the buffer.
  - Example: `:r !date` will insert the current date and time below the cursor.

### Interactive Search and Replace

You can perform search and replace operations with a confirmation prompt, allowing you to decide whether to replace each match.

- `:%s/old/new/gc`: Replace `old` with `new` globally (`g`) with confirmation (`c`) throughout the entire file (`%`).
  - When prompted, press `y` to replace, `n` to skip, `a` to replace all, `q` to quit, `l` to replace this one and quit, or `<C-e>` to scroll the screen.

### Joining Lines

You can quickly join lines together:

- `J`: Join the current line with the line below it.
- `{number}J`: Join the current line with the next `number` lines.

## Conclusion

This advanced guide has only scratched the surface of Vim's capabilities. The key to mastering Vim is consistent practice and exploring its extensive help system (`:help`). Don't try to learn everything at once. Pick a few new commands or concepts, integrate them into your workflow, and then add more as you become comfortable.

Happy Vimming!
