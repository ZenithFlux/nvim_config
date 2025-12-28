---@module "snacks"

local exclude_patterns = { 'node_modules/', '.git/', '.venv*/' }

local function regular_opts()
  return { hidden = true , exclude = exclude_patterns }
end

local function no_ign_opts()
  return { hidden = true, ignored = true, exclude = exclude_patterns }
end

local function get_current_dir()
  local curr_path = vim.fn.expand("%:p")
  if curr_path:sub(1, 6) == "oil://" then
    return require("oil").get_current_dir()
  end

  local stat = vim.uv.fs_stat(curr_path)
  if stat == nil then
    error(curr_path .. " doesn't exist!")
  end

  if stat.type == "file" then
    local dir_path = vim.fn.fnamemodify(curr_path, ":h")
    return dir_path
  elseif stat.type == "directory" then
    return curr_path
  end

  error("Current path is neither file nor directory!")
end

return {
  "folke/snacks.nvim",
  tag = "stable",
  priority = 1000,
  lazy = false,
  dependencies = {
    { "echasnovski/mini.icons", opts = {} }
  },
  opts = {
    picker = {
      win = {
        preview = {
          wo = {
            number = false,
          }
        }
      },
      layout = {
        preset = "ivy",
        layout = { height = 0.75 },
      },
      formatters = {
        file = {
          filename_first = true,
        }
      }
    }
  },
  keys = {
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_files() end, desc = "Find Git Files" },

    -- Grep
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>/", function() Snacks.picker.grep(regular_opts()) end, desc = "Grep" },
    { "<leader>?", function() Snacks.picker.grep(no_ign_opts()) end, desc = "Grep No-Ignore"},
    {
      "<leader>sg", function()
        local opts = no_ign_opts()
        opts["dirs"] = { get_current_dir() }
        Snacks.picker.grep(opts)
      end, desc = "Grep Current Dir"
    },
    {
      "<leader>sw", function() Snacks.picker.grep_word() end,
      desc = "Visual selection or word", mode = { "n", "x" },
    },

    -- search
    { "<leader>sp", function() Snacks.picker.pickers() end, desc = "Find Pickers"},
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sf", function() Snacks.picker.files(regular_opts()) end, desc = "Find Files" },
    { "<leader>sF", function() Snacks.picker.files(no_ign_opts()) end, desc = "Find Files No-Ignore" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Find History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sl", function() Snacks.picker.lazy() end, desc = "Find for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume Find" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>sC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

    -- LSP keymaps
    { "grd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "grD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "grR" , ":LspRestart<CR>", desc = "[R]estart LSP" },
    { "grf", ":Format<CR>", desc = "[F]ormat current buffer" },
    { "grs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "grw", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  }
}
