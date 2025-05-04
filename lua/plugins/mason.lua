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
        analysis = { typeCheckingMode = "off" },
      },
    },
    root_dir = vim.uv.cwd,
  },
  ruff = { enabled = false },
  marksman = {},
  cmake = {},
  clangd = {},
}

return {
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = vim.tbl_keys(servers),
      handlers = {
        function(server_name)
          local config = servers[server_name] or {}
          if config.enabled ~= nil and not config.enabled then
            return
          end

          -- TODO: This should be used when supported by mason-lspconfig
          -- vim.lsp.config(server_name, config)
          -- vim.lsp.enable(server_name)
          ----------------------------------------------------
          -- TODO: remove this when the above method is used
          require('lspconfig')[server_name].setup(
            vim.tbl_extend("keep", config, {
              capabilities = require("blink.cmp").get_lsp_capabilities(),
            })
          )
          ----------------------------------------------------
        end,
      },
    },
    -- TODO: remove blink.cmp as dependency when vim.lsp.config is used
    dependencies = { 'williamboman/mason.nvim', 'saghen/blink.cmp' },
  },
}
