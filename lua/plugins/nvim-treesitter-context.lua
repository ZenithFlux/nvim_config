return {
  'nvim-treesitter/nvim-treesitter-context',
  opts = {
    max_lines = 2,
    multiline_threshold = 1,
    trim_scope = 'inner',
    mode = 'topline',
  },

  dependencies = { 'nvim-treesitter/nvim-treesitter' },
}
