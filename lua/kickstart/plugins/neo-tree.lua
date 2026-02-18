-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  keys = {
    { "<leader>o", ":Neotree toggle<CR>", desc = "NeoTree toggle", silent = true },
  },
  --- @type neotree.Config
  opts = {
    default_component_configs = {
      git_status = {
        symbols = {
          -- Change type
          added = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = "✖", -- this can only be used in the git_status source
          renamed = "󰁕", -- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },
    window = {
      position = "left",
      width = 50,
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
    filesystem = {
      filtered_items = {
        visible = true, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
      },
      hijack_netrw_behavior = "open_current",
    },
    -- event_handlers = {
    --   { event = require("neo-tree.events").FILE_MOVED, handler = require("utils").on_file_remove },
    --   { event = require("neo-tree.events").FILE_RENAMED, handler = require("utils").on_file_remove },
    -- },
  },
}
