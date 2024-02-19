-- [[ Configure plugin et
-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gvdiffsplit" },
    keys = {
      {
        "<leader>gg",
        function()
          local cmd = ":Git<CR>";
          vim.api.nvim_input(require("utils").is_wide() and cmd .. "<C-w><S-l>" or cmd);
        end,
        desc = "Open Fugitive"
      },
      {
        "<leader>gd",
        ":Gvdiffsplit!<CR>",
        desc = "[D]iff view",
      },
      {
        "<leader>gl",
        ":Git log<CR>",
        desc = "Git [l]og",
      }
    }
  },

  -- Detect tabstop and shiftwidth automatically
  {
    'tpope/vim-sleuth',
    event = "BufRead",
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = "BufRead",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      "b0o/schemastore.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {}
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = "BufRead",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = "BufRead",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']g', function()
          if vim.wo.diff then
            return ']g'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[g', function()
          if vim.wo.diff then
            return '[g'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>gs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage git hunk' })
        map('v', '<leader>gh', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset git hunk' })
        -- normal mode
        map("n", "<leader>gh", gs.reset_hunk, { desc = "Reset hunk" });
        map("n", "<leader>gr", gs.reset_buffer, { desc = "Reset buffer" });
        map('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
        -- map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        -- map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        -- map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        -- map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>gb', function() gs.blame_line { full = false } end, { desc = 'Blame line' })
        -- map('n', '<leader>gd', gs.diffthis, { desc = 'Git diff' })
        -- map('n', '<leader>gD', function()
        --   gs.diffthis '~'
        -- end, { desc = 'Git diff against last commit' })

        -- Toggles
        -- map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        -- map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle git show deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
      end,
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        terminal_colors = false,
      });
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local lualine = require("lualine");

      lualine.setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = '|',
          section_separators = '',
        },
      });
      local config = lualine.get_config();
      table.insert(config.sections.lualine_c, { "searchcount" });

      lualine.setup(config);
    end
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = "BufRead",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = "▏",
      },
      scope = { enabled = true },
    }
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {}, event = "BufRead" },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = "VeryLazy",
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = "VeryLazy",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {}
  },

  {
    'stevearc/dressing.nvim',
    event = "VeryLazy",
    opts = {},
  },

  {
    'akinsho/toggleterm.nvim',
    version = "*",
    -- event = "VeryLazy",
    keys = {
      {
        "<leader>tb",
        function()
          local Terminal = require('toggleterm.terminal').Terminal
          local btm = Terminal:new({
            cmd = "btm",
            hidden = true,
            direction = "float",
            float_opts = {
              width = function()
                local width = vim.o.co;
                return width - math.floor(width / 7.5)
              end,
            }
          })
          btm:toggle();
        end,
        desc = "btm"
      }
    },
    opts = {},
  },

  {
    "echasnovski/mini.move",
    keys = {
      { "<M-h>", mode = "n", desc = "Move line left" },
      { "<M-j>", mode = "n", desc = "Move line down" },
      { "<M-k>", mode = "n", desc = "Move line up" },
      { "<M-l>", mode = "n", desc = "Move line right" },
      { "<M-h>", mode = "v", desc = "Move selection left" },
      { "<M-j>", mode = "v", desc = "Move selection down" },
      { "<M-k>", mode = "v", desc = "Move selection up" },
      { "<M-l>", mode = "v", desc = "Move selection right" },
    },
    opts = {
      mappings = {
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
    },
  },
  {
    "echasnovski/mini.splitjoin",
    keys = {
      { "<leader>s", function() require("mini.splitjoin").toggle() end, desc = "[S]plit/join" }
    },
    opts = {},
  },

  {
    'nguyenvukhang/nvim-toggler',
    keys = {
      { "<leader>i", function() require("nvim-toggler").toggle() end, desc = "[I]nvert word meaning" }
    },
    opts = {},
  },

  {
    "RRethy/vim-illuminate",
    event = "BufRead",
    keys = {
      { "]]", function() require("illuminate").goto_next_reference() end, desc = "Next reference" },
      { "[[", function() require("illuminate").goto_prev_reference() end, desc = "Previous reference" },
    },
    config = function()
      local opts = { bg = require("tokyonight.colors").moon().bg_highlight }
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", opts);
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", opts);
      vim.api.nvim_set_hl(0, "IlluminatedWordText", opts);

      require("illuminate").configure({})
    end,
  },

  {
    'kevinhwang91/nvim-ufo',
    event = "LspAttach",
    dependencies = {
      'kevinhwang91/promise-async',
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup(
            {
              relculright = true,
              segments = {
                { text = { builtin.foldfunc },           click = "v:lua.ScFa" },
                { text = { " ", builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                { text = { "%s" },                       click = "v:lua.ScSa" },
              }
            }
          )
        end

      }
    },
    opts = {},
  },

  {
    "hiphish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({});
    end
  },

  {
    "3rd/image.nvim",
    event = "BufRead",
    opts = {
      tmux_show_only_in_active_window = true,
    },
  },

  {
    "vladdoster/remember.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").setup({
        hint_enable = false,
        toggle_key = "<C-p>",
      })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>m",
        function()
          require("harpoon"):list():append();
          vim.notify("Added to harpoon", vim.log.levels.INFO);
        end,
        desc = "[M]ark for harpoon list"
      },
      { "<leader>h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Open [h]arpoon" },
      { "]b",        function() require("harpoon"):list():prev() end,                                   desc = "Previous harpoon mark" },
      { "]b",        function() require("harpoon"):list():next() end,                                   desc = "Next harpoon mark" },
      { "<leader>1", function() require("harpoon"):list():select(1) end,                                desc = "which_key_ignore" },
      { "<leader>2", function() require("harpoon"):list():select(2) end,                                desc = "which_key_ignore" },
      { "<leader>3", function() require("harpoon"):list():select(3) end,                                desc = "which_key_ignore" },
      { "<leader>4", function() require("harpoon"):list():select(4) end,                                desc = "which_key_ignore" },
      { "<leader>5", function() require("harpoon"):list():select(5) end,                                desc = "which_key_ignore" },
    },
    opts = {
      settings = {
        save_on_toggle = true,
      }
    }
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false,
    keys = {
      { "<leader>o", ":Neotree toggle<CR>", desc = "Open neotree" },
    },
    config = function()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define("DiagnosticSignError",
        { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn",
        { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo",
        { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint",
        { text = "󰌵", texthl = "DiagnosticSignHint" })

      require("neo-tree").setup({
        default_component_configs = {
          git_status = {
            symbols = {
              -- Change type
              added     = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted   = "✖", -- this can only be used in the git_status source
              renamed   = "󰁕", -- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored   = "",
              unstaged  = "󰄱",
              staged    = "",
              conflict  = "",
            }
          },
        },
        window = {
          position = "left",
          width = 50,
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
          }
        },
        filesystem = {
          filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
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
        },
      })
    end
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      require("notify").setup();
      vim.notify = require("notify");
    end
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  require('kickstart.plugins.autoformat'),
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- vim: ts=2 sts=2 sw=2 et
