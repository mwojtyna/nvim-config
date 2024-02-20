M = {}

M.is_wide = function() return vim.o.co > 150 end

M.disable_format = { "lua_ls", "jsonls", "tsserver", "html", "cssls" }

--- Used in a neo-tree handler
--- @param args { source: string, destination: string }
M.on_file_remove = function(args)
  local ts_clients = vim.lsp.get_active_clients({ name = "tsserver" })
  for _, ts_client in ipairs(ts_clients) do
    -- Have to defer otherwise doesn't work
    vim.defer_fn(
      function()
        ts_client.request("workspace/executeCommand", {
          command = "_typescript.applyRenameFile",
          arguments = {
            {
              sourceUri = vim.uri_from_fname(args.source),
              targetUri = vim.uri_from_fname(args.destination),
            },
          },
        })
      end,
      1000
    )
  end
end

return M
