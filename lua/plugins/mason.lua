-- [[ Configure LSP ]]
-- Enable the following language servers. They will automatically be installed.
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config.
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        hint = { enable = true },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  bashls = {},
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
          useLibraryCodeForTypes = false,
        },
      },
    },
  },
  ruff = {},
  marksman = {},
  cmake = {},
  clangd = {},
}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

return {
  {
    'williamboman/mason.nvim',
    tag = 'stable',
    opts = {},
  },
  {
    'williamboman/mason-lspconfig.nvim',
    tag = 'stable',
    opts = {
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = { exclude = { 'ruff' } },
    },
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
  },
}
