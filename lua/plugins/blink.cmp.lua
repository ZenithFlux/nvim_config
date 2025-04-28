return {
  'saghen/blink.cmp',
  version = '1.*',
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-space>'] = {},
      ['<C-n>'] = { "show", "select_next", "fallback_to_mappings" }
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      documentation = { auto_show = true },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        }
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" },

  dependencies = { 'rafamadriz/friendly-snippets' },
}
