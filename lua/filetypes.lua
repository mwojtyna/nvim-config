vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "hyprland.conf",
  callback = function() vim.cmd.setfiletype("hyprlang") end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.http",
  callback = function() vim.cmd.setfiletype("http") end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = ".env.*",
  callback = function() vim.bo.filetype = "sh" end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "go.mod",
  callback = function() vim.bo.filetype = "gomod" end,
})
