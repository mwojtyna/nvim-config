-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps

--- @param opts { source: string, message: string }
--- @return string
local format_diagnostic_hover = function(opts)
  if opts.source:sub(-1) == "." then
    opts.source = opts.source:sub(1, -2)
  end
  return opts.source .. ": " .. opts.message
end

vim.keymap.set(
  "n",
  "[d",
  function() vim.diagnostic.goto_prev({ float = { format = format_diagnostic_hover } }) end,
  { desc = "Go to previous diagnostic message" }
)
vim.keymap.set(
  "n",
  "]d",
  function() vim.diagnostic.goto_next({ float = { format = format_diagnostic_hover } }) end,
  { desc = "Go to next diagnostic message" }
)
vim.keymap.set(
  "n",
  "<leader>d",
  function()
    vim.diagnostic.open_float({
      format = format_diagnostic_hover,
    })
  end,
  { desc = "Open floating diagnostic message" }
)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- document existing key chains
require("which-key").register({
  ["<leader>b"] = { name = "[B]uffer", _ = "which_key_ignore" },
  ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
  ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
  ["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
  ["<leader>p"] = { name = "[P]ackages", _ = "which_key_ignore" },
  ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
  ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
})
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require("which-key").register({
  ["<leader>"] = { name = "VISUAL <leader>" },
  ["<leader>g"] = { "[G]it hunk" },
}, { mode = "v" })

-- I can't type properly
vim.api.nvim_create_user_command("W", ":w", {})
vim.api.nvim_create_user_command("Q", ":q", {})

-- Clear search highlights
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true })
vim.keymap.set("n", "<CR>", ":noh<CR><CR>", { silent = true })

-- Better go to line start/end
vim.keymap.set("n", "H", "_")
vim.keymap.set("n", "L", "$")
vim.keymap.set("v", "H", "_")
vim.keymap.set("v", "L", "$")

-- Package managers
vim.keymap.set("n", "<leader>pl", require("lazy").show, { desc = "Open lazy" })
vim.keymap.set("n", "<leader>pm", require("mason.ui").open, { desc = "Open mason" })

-- Center screen after half down/up
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Vim panes
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")

-- For convience
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })
vim.keymap.set("n", "<leader>c", "<C-w><C-h>:q!<CR>", { desc = "[C]lose diff" })
vim.keymap.set("n", "]t", vim.cmd.tabnext, { desc = "Next tab" })
vim.keymap.set("n", "[t", vim.cmd.tabprevious, { desc = "Previous tab" })
vim.keymap.set("t", "<M-q>", "<C-\\><C-n>")
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Buffer [d]elete" })
vim.keymap.set("n", "<C-a>", "ggVG")
vim.api.nvim_create_user_command("E", ":EslintFixAll", {})

-- Don't overwrite register when pasting over a word
vim.keymap.set("x", "p", "pgvy", { noremap = true })

-- vim: ts=2 sts=2 sw=2 et
