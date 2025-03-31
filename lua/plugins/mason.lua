-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local lspmap = function(mode, keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end

  local builtin = setmetatable({}, {
    __index = function(_, key)
      return function()
        require("telescope.builtin")[key]()
      end
    end
  })

  lspmap("n", 'grR' , vim.cmd.LspRestart, '[R]estart LSP')
  lspmap("n", 'grd', builtin.lsp_definitions, '[G]oto [D]efinition')
  lspmap("n", 'grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  lspmap("n", 'grr', builtin.lsp_references, '[G]oto [R]eferences')
  lspmap("n", 'gri', builtin.lsp_imptementations, '[G]oto [I]mplementation')
  lspmap("n", 'grt', builtin.lsp_type_definitions, '[T]ype Definition')
  lspmap("n", 'grF', vim.lsp.buf.format, '[F]ormat current buffer')
  lspmap("n", 'gO', builtin.lsp_document_symbols, 'Document Symbols')
  lspmap("n", 'gW', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')

  lspmap("n", '<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  lspmap("n", '<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  lspmap("n", '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end


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
          require('lspconfig')[server_name].setup(
            vim.tbl_extend("keep", servers[server_name] or {}, {
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
              on_attach = on_attach,
            })
          )
        end,
      },
    },
    dependencies = { 'williamboman/mason.nvim' },
  },
}
