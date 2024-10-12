return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = "nvim-treesitter.configs",
  opts = {
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
  },

  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'hiphish/rainbow-delimiters.nvim',
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        max_lines = 2,
        multiline_threshold = 1,
        trim_scope = 'inner',
        mode = 'topline',
      }
    },
  },
}
