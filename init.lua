-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

-- [[ Install `lazy.nvim` plugin manager ]]
require("lazy-bootstrap")

-- [[ Configure plugins ]]
require("lazy-plugins")

-- [[ Setting options ]]
require("options")

-- [[ Basic Keymaps ]]
require("keymaps")

require("autocmds")

-- [[ Configure Telescope ]]
-- (fuzzy finder)
require("telescope-setup")

-- [[ Configure Treesitter ]]
-- (syntax parser for highlighting)
require("treesitter-setup")

-- [[ Configure LSP ]]
-- (Language Server Protocol)
require("lsp-setup")

-- [[ Configure nvim-cmp ]]
-- (completion)
require("cmp-setup")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
