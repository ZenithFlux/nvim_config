return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
  }
}
