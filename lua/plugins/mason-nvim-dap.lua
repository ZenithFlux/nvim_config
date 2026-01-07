return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    ensure_installed = { "python" },
    handlers = {
      function(config)
        -- Remove all default configurations
        -- since configs will be loaded from .vscode/launch.json
        config.configurations = {}
        require('mason-nvim-dap').default_setup(config)
      end
    },
  },
  dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" }
}
