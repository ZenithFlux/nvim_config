local unload_keymaps

-- Keymaps to be set during a debugging session.
-- Previous mappings will be restored after the debugging session is terminated.
-- Set rhs to false to disable a keymap during debugging.
local keymaps = {
  {
    "n", "<leader>ds", function()
      require("dap").terminate()
      unload_keymaps()
      require("dap-view").close()
    end, { desc = "Stop Debugger" }
  },
  { "n", "<leader>dl", false },
  { "n", "<leader>dr", function() require("dap").restart() end , { desc = "Restart Session" } }
}
local prev_kms = {}

local function load_keymaps()
  for i, k in ipairs(keymaps) do
    prev_kms[i] = vim.fn.maparg(k[2], k[1], false, true)

    if k[3] == false then
      vim.keymap.del(k[1], k[2])
    else
      ---@cast k table
      vim.keymap.set(unpack(k))
    end
  end
end

function unload_keymaps()
  for i, k in ipairs(prev_kms) do
    if next(k) == nil then
      vim.keymap.del(keymaps[i][1], keymaps[i][2])
    else
      vim.fn.mapset(k)
    end
    prev_kms[i] = nil
  end
  assert(next(prev_kms) == nil)
end

return {
  "igorlfs/nvim-dap-view",
  opts = {},
  keys = {
    {
      "<leader>ds", function()
        local dap = require("dap")
        dap.continue()
        if dap.session() == nil then
          return
        end
        require("dap-view").open()
        load_keymaps()
      end, desc = "Start Debugger"
    },
    {
      "<leader>dl", function()
        local dap = require("dap")
        dap.run_last()
        if dap.session() == nil then
          return
        end
        require("dap-view").open()
        load_keymaps()
      end, desc = "Rerun last debug"
    },
  },
  dependencies = { "mfussenegger/nvim-dap" }
}
