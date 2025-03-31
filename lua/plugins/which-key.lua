-- Useful plugin to show you pending keybinds.
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = vim.o.timeoutlen,
    plugins = {
      presets = {
        operators = false,
      }
    },
    defer = function(ctx)
      return ctx.mode == 'v' or ctx.mode == 'V' or ctx.mode == '<C-V>'
    end,
    spec = {
      { 'gr', group = 'LSP' },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = 'Git [H]unk' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>w', group = '[W]orkspace' },
      {
        mode = 'v',
        { '<leader>', group = 'VISUAL <leader>' },
        { '<leader>h', group = 'Git [H]unk' },
      }
    },
  },
}
