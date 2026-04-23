-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = "*",
})

-- Automatically Open Trouble Quickfix
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  callback = function() vim.cmd([[Trouble qflist open]]) end,
})

-- Open Typst/Markdown preview based on filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "typst" },
  callback = function(args)
    local command_by_ft = {
      markdown = "MarkdownPreview",
      typst = "TypstPreview",
    }

    local ft = vim.bo[args.buf].filetype
    local command = command_by_ft[ft]
    if not command then
      return
    end

    vim.keymap.set("n", "<leader>P", function() vim.cmd(command) end, {
      buffer = args.buf,
      desc = ft == "markdown" and "Open markdown preview" or "Open Typst preview",
    })
  end,
})
