-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true

-- Relative line numbers, highlight current
vim.o.relativenumber = true
vim.o.cursorline = true

-- Cover default status bar
-- vim.o.cmdheight = 0

-- Open new panes below
vim.o.splitbelow = true
vim.o.splitright = true

-- Sane defaults for folds
vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Max nvim-cmp menu height
vim.o.ph = 25

-- Visual block anywhere
vim.o.virtualedit = "block"

-- Make preview buffers (telescope, vim-fugitive) have smaller indents
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- vim: ts=2 sts=2 sw=2 et
