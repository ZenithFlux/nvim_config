-- Autocompletion
return {
  'hrsh7th/nvim-cmp',
  event = "InsertEnter",
  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    return {
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
        ['<C-p>'] = cmp.mapping.select_prev_item {
          behavior = cmp.SelectBehavior.Select
        },
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace
        },
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
        { name = "lazydev", group_index = 0 },
      },
    }
  end,

  dependencies = {
    {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      version = "v2.*",
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
      dependencies = { 'rafamadriz/friendly-snippets' },
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
  },
}
