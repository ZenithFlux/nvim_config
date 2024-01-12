-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
----------------------

local function map_keys(mode, lhs, rhs, desc)
  local opts = {remap=true, desc=desc}
  vim.keymap.set(mode, lhs, rhs, opts)
end


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map_keys('n', '<Up>', '<C-W>W', "Go to previous window")
map_keys('n', '<Down>', '<C-W>w', "Go to next window")
map_keys('n', '<Left>', '<cmd>bp<CR>', "Go to previous buffer")
map_keys('n', '<Right>', '<cmd>bn<CR>', "Go to next buffer")
map_keys({'n','v'}, '<leader>p', '\"_dP', "Paste without yanking")
map_keys('', '<C-D>', '<C-D>zz', "Scroll half page down and center cursor")
map_keys('', '<C-U>', '<C-U>zz', "Scroll half page up and center cursor")

vim.keymap.set('n', '<leader>l', function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    print('Diagnostics enabled')
  else
    vim.diagnostic.disable()
    print('Diagnostics disabled')
  end
end, {desc = 'Toggle diagnostics'})
