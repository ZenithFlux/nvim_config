vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
----------------------

local function map(mode, lhs, rhs, desc)
  local opts = {remap=true, desc=desc}
  vim.keymap.set(mode, lhs, rhs, opts)
end

map('n', '<Up>', '<C-W>W', "Go to previous window")
map('n', '<Down>', '<C-W>w', "Go to next window")
map('n', '<Left>', vim.cmd.bp, "Go to previous buffer")
map('n', '<Right>', vim.cmd.bn, "Go to next buffer")
map({'n','v'}, '<leader>p', '"_dP', "[P]aste without yanking")
map('', '<C-D>', '<C-D>zz', "Scroll half page down and center cursor")
map('', '<C-U>', '<C-U>zz', "Scroll half page up and center cursor")
map('n', '<leader>f', vim.cmd.E, 'Explore [F]iletree')
map('v', 'r', '"ry:%s~<C-R>r~~gc<Left><Left><Left>', '[R]eplace Selected Text')
map('t', '<Esc>', '<C-\\><C-N>', 'Exit Terminal Mode')

vim.keymap.set('n', '<leader>l', function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    print('Diagnostics enabled')
  else
    vim.diagnostic.disable()
    print('Diagnostics disabled')
  end
end, {desc = 'Toggle diagnostics'})
