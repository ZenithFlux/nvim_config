vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
----------------------

vim.keymap.set('', '<C-D>', '<C-D>zz', { desc = 'Scroll half page down and center cursor' })
vim.keymap.set('', '<C-U>', '<C-U>zz', { desc = 'Scroll half page up and center cursor' })

vim.keymap.set('n', '<C-P>', '<C-L>', { desc = 'Clears and redraws the screen' })
vim.keymap.set('n', '<C-K>', '<C-W>W', { desc = 'Go to previous window' })
vim.keymap.set('n', '<C-J>', '<C-W>w', { desc = 'Go to next window' })
vim.keymap.set('n', '<C-H>', vim.cmd.bp, { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<C-L>', vim.cmd.bn, { desc = 'Go to next buffer' })
vim.keymap.set('n', '<leader>;', vim.cmd.bd, { desc = 'Delete current buffer' })
vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select last [P]asted text' })
vim.keymap.set('n', '<leader>f', vim.cmd.Ex, { desc = 'Open [F]iletree' })

vim.keymap.set('v', '<leader>p', '"_dP', { desc = '[P]aste without yanking' })
vim.keymap.set('v', 'r', '"ry:%s~<C-R>r~~gc<Left><Left><Left>', { desc = '[R]eplace Selected Text' })
vim.keymap.set('v', '<', '<gv', { desc = 'Outdent without exiting visual mode' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent without exiting visual mode' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { desc = 'Exit Terminal Mode' })

vim.keymap.set('n', '<leader>ti', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({nil}))
end, { desc = "Toggle inlay hints" })

vim.keymap.set('n', '<leader>th', function()
  vim.o.hlsearch = not vim.o.hlsearch
end, { desc = 'Toggle hlsearch' })

vim.keymap.set('n', '<leader>tx', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })
