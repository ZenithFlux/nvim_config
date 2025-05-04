---@module "snacks"

local exclude_patterns = { 'node_modules/', '%.git/', '%.venv.*/' }
local regular_opts = { hidden = true , exclude = exclude_patterns}
local no_ign_opts = { hidden = true, ignored = true, exclude = exclude_patterns}

-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file:sub(1, 6) == "oil://" then
    current_file = current_file:sub(7)
  end
  local current_dir = ""
  local cwd = vim.uv.cwd() or ""
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    if current_file:sub(-1) == "/" then
      current_dir = current_file
    else
      current_dir = vim.fn.fnamemodify(current_file, ':h')
    end
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    vim.notify("GrepGitRoot: Not a git repository", vim.log.levels["WARN"])
    return
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function grep_git_root()
  local git_root = find_git_root()
  if git_root then
    local opts = vim.tbl_extend(
      "force", regular_opts, { dirs = { git_root } }
    )
    Snacks.picker.grep(opts)
  end
end

vim.api.nvim_create_user_command('GrepGitRoot', grep_git_root, {})

return {
  "folke/snacks.nvim",
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
    { "<leader>/", function() Snacks.picker.grep(regular_opts) end, desc = "Grep" },
    { "<leader>?", function() Snacks.picker.grep(no_ign_opts) end, desc = "Grep No-Ignore"},
    { "<leader>sg", vim.cmd.GrepGitRoot, desc = "Grep Git Root" },
    {
      "<leader>sw", function() Snacks.picker.grep_word() end,
      desc = "Visual selection or word", mode = { "n", "x" },
    },

    -- search
    { "<leader>sp", function() Snacks.picker.pickers() end, desc = "Find Pickers"},
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sf", function() Snacks.picker.files(regular_opts) end, desc = "Find Files" },
    { "<leader>sF", function() Snacks.picker.files(no_ign_opts) end, desc = "Find Files No-Ignore" },
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
    { "grR" , vim.cmd.LspRestart, desc = "[R]estart LSP" },
    { "grf", ":Format<CR>", desc = "[F]ormat current buffer" },
    { "gO", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "gW", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  }
}
