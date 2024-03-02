vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "hyprland.conf",
  callback = function() vim.cmd.setfiletype("hyprlang") end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.http",
  callback = function() vim.cmd.setfiletype("http") end,
})

vim.filetype.add({
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
  },
})
