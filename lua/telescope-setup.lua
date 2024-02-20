-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope_actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = telescope_actions.move_selection_previous,
        ["<C-j>"] = telescope_actions.move_selection_next,
        ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
      },
    },
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })

vim.keymap.set(
  "n",
  "<leader>fl",
  function()
    require("telescope.builtin").live_grep({
      grep_open_files = true,
      prompt_title = "Live Grep in Open Files",
    })
  end,
  { desc = "[F]ind in open files" }
)
vim.keymap.set("n", "<leader>fs", require("telescope.builtin").find_files, { desc = "[F]ile [s]earch" })
vim.keymap.set(
  "n",
  "<leader>fS",
  function() require("telescope.builtin").find_files({ hidden = true }) end,
  { desc = "[F]ile [s]earch (with hidden files)" }
)
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles, { desc = "[F]ind recently [o]pened files" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").live_grep, { desc = "[F]ind by [w]ord" })
vim.keymap.set(
  "n",
  "<leader>fW",
  function()
    require("telescope.builtin").live_grep({
      additional_args = { "--hidden" },
    })
  end,
  { desc = "[F]ind by [w]ord (with hidden files)" }
)
vim.keymap.set("n", "<leader>f<Enter>", require("telescope.builtin").resume, { desc = "[F]ind resume" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [h]elp" })
vim.keymap.set("n", "<leader>fn", require("telescope").extensions.notify.notify, { desc = "[F]ind [n]otifications" })

-- vim: ts=2 sts=2 sw=2 et
