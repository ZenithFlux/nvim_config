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

  lspmap("n", '<leader>lR' , vim.cmd.LspRestart, '[R]estart LSP')

  lspmap("n", '<leader>lr', vim.lsp.buf.rename, '[R]ename')
  lspmap("n", '<leader>la', vim.lsp.buf.code_action, 'Code [A]ction')

  lspmap("n", 'gd', builtin.lsp_definitions, '[G]oto [D]efinition')
  lspmap("n", 'gr', builtin.lsp_references, '[G]oto [R]eferences')
  lspmap("n", 'gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
  lspmap("n", '<leader>lt', builtin.lsp_type_definitions, '[T]ype Definition')
  lspmap("n", '<leader>ls', builtin.lsp_document_symbols, 'Document [S]ymbols')
  lspmap("n", '<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  lspmap('i', '<C-J>', vim.lsp.buf.signature_help, 'Signature Documentation')

  lspmap("n", 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  lspmap("n", '<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  lspmap("n", '<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  lspmap("n", '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  lspmap("n", '<leader>lF', vim.lsp.buf.format, '[F]ormat current buffer')
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
