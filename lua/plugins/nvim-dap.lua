return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<leader>db", function()
      require("dap").toggle_breakpoint()
      vim.notify("Breakpoint toggled", vim.log.levels.INFO)
    end, desc = "Toggle Breakpoint" },

    { "<leader>dc", function()
      require("dap").clear_breakpoints()
      vim.notify("All breakpoints cleared", vim.log.levels.INFO)
    end, desc = "Clear Breakpoints" },
  }
}
