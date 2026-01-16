local lazy_dap = require("utils").require_on_call("dap")
local dap_view = require("utils").require_on_call("dap-view")
local unload_keymaps

-- Keymaps to be set during a debugging session.
-- Previous mappings will be restored after the debugging session is terminated.
-- Set rhs to false to disable a keymap during debugging.
local keymaps = {
  { "n", "<Up>", lazy_dap.continue, { desc = "Continue" } },
  { "n", "<Down>", lazy_dap.step_over, { desc = "Step over" } },
  { "n", "<Left>",  lazy_dap.step_out, { desc = "Step out" } },
  { "n", "<Right>", lazy_dap.step_into, { desc = "Step into" } },

  { "n", "<C-Down>", lazy_dap.run_to_cursor, { desc = "Run to cursor" } },
  { "n", "<S-Up>", lazy_dap.reverse_continue, { desc = "Reverse Continue" } },
  { "n", "<S-Down>", lazy_dap.step_back, { desc = "Step back" } },

  { {"n", "v"}, "<leader>dw", dap_view.add_expr, { desc = "Watch expression" } },
  { "n", "<leader>ds", lazy_dap.restart, { desc = "Restart Session" } },
  { "n", "<leader>dx", lazy_dap.terminate,   { desc = "Stop Debugger" } },
  { "n", "<leader>dl", false },
}
local prev_kms = {}

local function load_keymaps()
  for i, k in ipairs(keymaps) do
    local modes = k[1] ---@type string | string[]
    if type(modes) == "string" then
      modes = { modes }
    end

    local pk = {}
    for j, m in ipairs(modes) do
      pk[j] = vim.fn.maparg(k[2], m, false, true)
    end
    prev_kms[i] = pk

    if k[3] == false then
      vim.keymap.del(k[1], k[2])
    else
      ---@cast k table
      vim.keymap.set(unpack(k))
    end
  end
end

function unload_keymaps()
  for i, pks in ipairs(prev_kms) do
    local k = keymaps[i]
    local modes = k[1] ---@type string | string[]
    if type(modes) == "string" then
      modes = { modes }
    end

    for j, pk in ipairs(pks) do
      if next(pk) == nil then
        vim.keymap.del(modes[j], k[2])
      else
        vim.fn.mapset(pk)
      end
    end

    prev_kms[i] = nil
  end
end

return {
  "igorlfs/nvim-dap-view",
  opts = {},
  keys = {
    { "<leader>dv", dap_view.toggle, desc = "Toggle DAP-View"},
    {
      "<leader>ds",
      function()
        local dap = require("dap")
        if dap.listeners.on_session["my_config"] == nil then
          dap.listeners.on_session["my_config"] = function(old, new)
            if old == nil and new == nil then
            elseif old == nil then
              require("dap-view").open()
              load_keymaps()
            elseif new == nil then
              unload_keymaps()
            end
          end
        end

        dap.continue()
      end,
      desc = "Start Debugger"
    },
    { "<leader>dl", lazy_dap.run_last, desc = "Rerun last debug" },
  },

  dependencies = { "mfussenegger/nvim-dap" }
}
