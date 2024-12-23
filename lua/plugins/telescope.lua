local builtin = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      require("telescope.builtin")[key](...)
    end
  end
})

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = ""
  local cwd = vim.uv.cwd() or ""
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    builtin.live_grep {
      cwd = git_root,
      additional_args = { "--hidden" },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- Additional configuration to telescope to change theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sG', vim.cmd.LiveGrepGitRoot, { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
vim.keymap.set('i', '<C-Z>', builtin.symbols, { desc = 'Select a symbol or emoji' })

vim.keymap.set('n', '<leader>sg', function()
  builtin.live_grep({ additional_args = { "--hidden" } })
end, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>sf', function()
  builtin.find_files({ hidden = true })
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>sF', function()
  builtin.find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
end, { desc = '[S]earch [F]iles No-Ignore' })


return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  cmd = "Telescope",

  config = function()
    local opts = {
      defaults = require("telescope.themes").get_ivy {
        file_ignore_patterns = { 'node_modules/', '%.git/', '%.venv.*/' },
        path_display = function(_, path)
          local tail = require("telescope.utils").path_tail(path)
          return string.format("%s: %s", tail, path)
        end,
      },
    }
    require("telescope").setup(opts)
    pcall(require('telescope').load_extension, 'fzf')
  end,

  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-symbols.nvim',
  },
}
