-- [[ Configure Telescope ]]
local ignore_patterns = { 'node_modules', '.git', '.venv' }

require('telescope').setup {
  defaults = {
    layout_config = { preview_width = 0.5 },
    path_display = function(_, path)
      local tail = require("telescope.utils").path_tail(path)
      return string.format("%s: %s", tail, path)
    end,
  },
  pickers = {
    live_grep = {
      file_ignore_patterns = ignore_patterns,
      additional_args = { '--hidden' },
    },
    find_files = {
      file_ignore_patterns = ignore_patterns,
      hidden = true,
    }
  }
}

pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.loop.cwd()
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

local builtin = require 'telescope.builtin'

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    builtin.live_grep {
      cwd = git_root,
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
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', vim.cmd.LiveGrepGitRoot, { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
vim.keymap.set('i', '<C-Z>', builtin.symbols, { desc = 'Select a symbol or emoji' })

vim.keymap.set('n', '<leader>sF', function()
  builtin.find_files({ no_ignore = true, no_ignore_parent = true })
end, { desc = '[S]earch [F]iles No-Ignore' })

-- [[ Configure Treesitter ]]
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'lua', 'vimdoc', 'vim', 'bash', 'python', 'c', 'cpp', 'cmake', 'markdown', 'markdown_inline',
    },

    -- Autoinstall language if not installed when corresponding file is opened.
    auto_install = false,

    highlight = { enable = true },
    indent = {
      enable = true,
      disable = { 'python', 'c', 'cpp' },
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'Z',
        node_incremental = 'Z',
        scope_incremental = '<C-B>',
        node_decremental = 'X',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- Can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)


-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lR' , vim.cmd.LspRestart, '[R]estart LSP')

  nmap('<leader>lr', vim.lsp.buf.rename, '[R]ename')
  nmap('<leader>la', vim.lsp.buf.code_action, 'Code [A]ction')

  nmap('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
  nmap('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>lt', builtin.lsp_type_definitions, '[T]ype Definition')
  nmap('<leader>ls', builtin.lsp_document_symbols, 'Document [S]ymbols')
  nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  vim.keymap.set('i', '<C-J>', vim.lsp.buf.signature_help, {
    buffer = bufnr, desc = 'Signature Documentation'
  })

  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  nmap('<leader>lF', vim.lsp.buf.format, '[F]ormat current buffer')
end


local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
    root_dir = vim.loop.cwd,
  },
  marksman = {},
  cmake = {},
  clangd = {},
}

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup(
        vim.tbl_extend("keep", servers[server_name] or {}, {
          capabilities = capabilities,
          on_attach = on_attach,
        })
      )
    end,
  }
}

-- [[ Configure nvim-cmp ]]
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

vim.keymap.set('n', '<leader>u', function()
  vim.cmd.UndotreeToggle()
  local key = vim.api.nvim_replace_termcodes('<C-W>w', true, false, true)
  vim.api.nvim_feedkeys(key, 'n', false)
end, { desc = "Open [U]ndotree" })

-- document existing key chains
require('which-key').add({
  { '<leader>g', group = '[G]it' },
  { '<leader>h', group = 'Git [H]unk' },
  { '<leader>l', group = '[L]SP' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>w', group = '[W]orkspace' },
  {
    mode = 'v',
    { '<leader>', group = 'VISUAL <leader>' },
    { '<leader>h', group = 'Git [H]unk' },
  }
})

-- [[ Configure highlight groups ]]
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bold = true, italic = true })
