# Getting Around

- Text Editing
    y to copy an element under the cursor. Copy the selected text in visual mode.
    p to paste the copied element or the deleted line.
- Seeeking next
    Seek mode press "s" followed by the character you want to get. Ex : "ss" search for all occurrences of s in the file.
    Each of the occurrences have a letter pink next to it. Press it to jump to the occurrence.
- Replace
    Press r to replace a character under the cursor.
- Scrolling
    CTRL-d to go down
    CTRL-u to go up
    CTRL-f to go forward
    CTRL-b to go backwards
    CTRL-y and CTRL-e scroll by a single line
    zt, zb nd zz move the line that the cursor is currently on to the top, bottom or middle of the screen respectively.
    :help scrolling to get help
- Moving by words
    w move to the beginning of the next word
    e move to the end of the current word
    b moves backwards to the beginning the current word
    W move just after the next whitespace character.
    E move to the next whitespace after the end of the current word.
    B move backwards to the previous whitespace after the beginning of the current word.
- Line
    0 moves o the beginning of the line
    $ moves to the end of the line
    CTRL-o jump to the last place I jumped from
    CTRL-i jump forward in the history of jumps
    :number moves the line number

# Files in LazyVim

Access LazyVim config files at any time with <Space>fc

- File Pikers
    SpaceSpace acces the file picker from the root directory
    :lcd command to change the local working directory in the current window
- Explorer
    <Space>e to open the Explorer in the root directory of the project
    <Space>E opens the Explorer in the cwd
    All the navigation commands like j and k and 10j works in the E xplorer to navigate. d works on a file to delete it.
    y to copy a file.
    m to move a file.
    p to paste it
    a to create a file or directory
    ENTER to open a selected file or if the file is under the cursor
    <CTRL>v open file in a vertical split 
    <CTRL>s open file in a horizontal split
- Mini.Files Alternative
    <Space>fm to open mini.files in the directory of the current file
    <Space>fM to open mini.files in the cwd
    Same as above, navigation commands works.

# Basic Editing with Verbs

  <verb><count><motion> or <count><verb><motion> is the command pattern

- Deleting Text
    dh to delete the character to the left of the cursor.
    d3w to delete three words.
    3dw to delete one word, three separate times.
    d^ to delete from the cursor to the beginning of the line.
    d2fe to delete all text between the cursor location and the second e after the cursor, including that second e.
    d2Ta to delete all text between the cursor and the second a behind the cursor, not including that second a.
    dsfoos to delete text between the current cursor position and the label s that pops up when you use Seek mode to seek to foo. Note that Seek mode always jumps to the beginning of the word you searched for. This means that if the foo you jump to is after the current cursor location, the oo will not be deleted, but the f will. But if the foo you jump to is before the current cursor location, all three letters of foo will be deleted.
- Changing Text
    use c instead of d to change the text which will delete the text and enter insert mode.
- Operating to End of the Current line
    We can use d$ and c$ to delete or change to the end of the line, but the D and C do the same.
    To delete to the beginning, there is no shortcuts. Use d0 and d^.
- Operating on entire line
    Duplicate the verb to acces the whole line:
    dd to delete the entire line
    cc to delete the entire line and enter insert mode
- Shortcuts for modifying individual characters
    dl deletes the character under the cursor, shortcut is x. Use X to delete to the left of the cursor
    Use r to replace a character.
    Use J "Join lines"  to delete the new line at the end of the current line. Use gJ to join without modifying any whitespace.

# Objects and Operator Pending Mode

# Buffers, Windows, Tabs and Sessions
- Buffers
    - Moving between buffers: H for left and l for right.
    - <Space>, to see the opened buffer list and select buffers
    - <CTRL>x to close the buffer that the cursor is on.
    - <Space>b to pop the menu of buffer related functions. 
    - <Space>bd to close the current buffer
    - <Space>bD to close the current buffer and the window split it is in.
    - <Space>bl close all buffers to the left int the tab line 
    - <Space>br close all buffers to the right in the tab line
    - <Space>bo close all buffers other than the active one
    - <Space>bp pin an active buffer
    - <Space>bP delete all non-pinned buffers/close all buffers if no buffer is pinned

- Windows Management
    - <Space>w / <CTRL>w display the window management commands
    - <Space>wv / <Space>| split the current window vertically
    - <Space>ws split the current window horizontally
    - <Space>wq closes the window, and if it is the only window open, exits (quits) Neovim.
    - <Space>wc closes the window unless it is the only window open, in which case it displays an error and refuses to close.
    - <Space>wd deletes the window. It is actually doing exactly the same operation as <Space>wc, but it is helpful for muscle memory for its symmetry with <Space>bd to “delete” an open buffer.
    - <Space>wo to close all windows except this one
    - <CTRL>h, j, k, l to move the cursor between windows
    - <Space>w= make all the windows the same size
    
- Collapsing
    - zc to collapse the current loop/function
    - zo t open the collapsed lopp/function
    - za collapse if not collapsed and open if collapsed
    - zR open all folds

- Sessions
    - <Space>qq to quit Neovim and save current session. When opening neovim again, press s on the dashboard to restore session. If the dashboard is gone, use <Space>qS to restore Neovim.
    - Sessions are scoped to folders. 

# Programming Language Support
- Mason.nvim
    - <Space>cm open Mason
    - g? to see help and keybindings
    - Enter to see package description
    - <Space>sn to open the "noice" search menu
    - <Space>sna to open noice messages (notifications)
    - <Space>cl opens a picker of installed LSP and debug info (not working for me)

- Debugging
    - :checkhealth to see all information about installed things for LazyVim
      - :chechealth vim.lsp for LSP
      - :chechealth mason for mason
    - :LazyHealth LazyVim specific information

- Code Diagnostic
    - <Space>cd to invoke a diagnostic on a line of code.
    - <Space>x to open the quickfix and trouble window
    - <Space>xx to open the trouble menu for the current file
    - <Space>xX to open the trouble menu for all current workspaces
    - <Space>ca to open the code action menu to view quick fixes available on an error.

# Navigating Source Files
- gd Go to definition of a function,class, variable
- CTRL-o to move back to where I was
- CTRL-i to move forward in the jump history
- gr is for Go to Reference. Display a window with a list of all references in all project files of the function,variable,class...
- <Space>ss is for Search Symbol which allows to search all functions in a file and navigate to them
- <Space>sS search for the whole project if not the all system



# Debugger

- <Space>d open debugging commands menu
- <Space>db to set a breakpoint
- <Space>da open run menu


# Comments

- gcc to comment a line
- 5gcc to comment the 5 line below the cursor
- gco to add a new comment line
