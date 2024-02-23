-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = "*",
})

-- Set file type for hyprland.conf
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "hyprland.conf",
  callback = function() vim.cmd.setfiletype("hyprlang") end,
})

-- Disable spell checking in git log
vim.api.nvim_create_autocmd("FileType", {
  pattern = "git",
  callback = function() vim.cmd.setlocal("nospell") end,
})
