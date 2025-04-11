-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  --- @diagnostic disable-next-line: missing-fields
  formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol_text", -- show only symbol annotations
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      preset = "codicons",
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.abort, -- disable
    ["<C-n>"] = cmp.mapping.abort, -- disable
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      local result, copilot = pcall(require, "copilot.suggestion")
      if not result then
        fallback()
        return
      end

      if copilot.is_visible() then
        copilot.accept()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  },
})

-- vim: ts=2 sts=2 sw=2 et
