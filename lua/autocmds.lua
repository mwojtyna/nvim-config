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

-- Replace the quickfix window with Trouble when viewing TSC results
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "quickfix",
  group = vim.api.nvim_create_augroup("ReplaceQuickfixWithTrouble", {}),
  callback = function()
    local title = vim.fn.getqflist({ title = 0 }).title
    if title ~= "TSC" then
      return
    end

    local ok, trouble = pcall(require, "trouble")
    if ok then
      vim.defer_fn(function()
        vim.cmd("cclose")
        trouble.open("quickfix")
      end, 0)
    end
  end,
})

-- Refresh lualine when recording a macro starts or stops
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    require("lualine").refresh({
      place = { "statusline" },
    })
  end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    -- This is going to seem really weird!
    -- Instead of just calling refresh we need to wait a moment because of the nature of
    -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
    -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
    -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
    -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
    local timer = vim.loop.new_timer()
    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        require("lualine").refresh({
          place = { "statusline" },
        })
      end)
    )
  end,
})
