local function set_filetype(pattern, filetype)
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = pattern,
    callback = function() vim.bo.filetype = filetype end,
  })
end

set_filetype("hyprland.conf", "hyprlang")
set_filetype("*.http", "http")
set_filetype(".env.*", "sh")
set_filetype("go.mod", "gomod")
set_filetype("*.rasi", "rasi")
set_filetype({ "docker-compose.yml", "docker-compose.yaml" }, "yaml.docker-compose")
