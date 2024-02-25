-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>r", vim.lsp.buf.rename, "[R]ename")
  nmap(
    "<leader>a",
    function() vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } }) end,
    "Code [a]ction"
  )
  vim.keymap.set(
    "v",
    "<leader>a",
    function() vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } }) end,
    { buffer = bufnr, desc = "LSP: Code [a]ction" }
  )

  nmap("<leader>lf", function()
    vim.lsp.buf.format({
      bufnr = bufnr,
      -- Use the filter function to explicitly notify when no clients matched
      filter = function(client) return not vim.tbl_contains(require("utils").disable_format, client.name) end,
    })
  end, "[F]ormat")

  nmap("gd", function() require("telescope.builtin").lsp_definitions({ show_line = false }) end, "[G]oto [d]efinition")
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [d]eclaration") -- In C, go to header file
  nmap("gr", function() require("telescope.builtin").lsp_references({ show_line = false }) end, "[G]oto [r]eferences")
  nmap("gI", function() require("telescope.builtin").lsp_implementations({ show_line = false }) end, "[G]oto [i]mplementation")
  nmap("gt", function() require("telescope.builtin").lsp_type_definitions({ show_line = false }) end, "[G]oto [t]ype definition")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [a]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [r]emove Folder")
  nmap("<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "[W]orkspace [l]ist folders")
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.

-- Add linters and formatters here
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.hadolint,
  },
})
---@diagnostic disable-next-line: missing-fields
require("mason-null-ls").setup({
  ---@diagnostic disable-next-line: assign-type-mismatch
  ensure_installed = nil,
  automatic_installation = true,
})

-- Add LSPs here
local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
  html = { filetypes = { "html", "twig", "hbs" } },
  cssls = {},
  tsserver = {},
  eslint = {},
  tailwindcss = {},
  astro = {},
  prismals = {},

  jsonls = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
  yamlls = {
    schemaStore = {
      -- You must disable built-in schemaStore support if you want to use
      -- this plugin and its advanced options like `ignore`.
      enable = false,
      -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      url = "",
    },
    schemas = require("schemastore").yaml.schemas(),
  },
  taplo = {},
  lemminx = {},
  dockerls = {},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    })
  end,
})

-- Add borders to lsp windows
local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Set diagnostic symbols in the sign column
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- vim: ts=2 sts=2 sw=2 et
