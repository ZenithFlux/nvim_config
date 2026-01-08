local utils = require('utils')

-- Keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics under the cursor' })
----------------------

vim.keymap.set('', '<C-D>', '<C-D>zz', { desc = 'Scroll half page down and center cursor' })
vim.keymap.set('', '<C-U>', '<C-U>zz', { desc = 'Scroll half page up and center cursor' })

vim.keymap.set('n', '<C-P>', '<C-L>', { desc = 'Clears and redraws the screen' })
vim.keymap.set('n', '<C-K>', '<C-W>W', { desc = 'Go to previous window' })
vim.keymap.set('n', '<C-J>', '<C-W>w', { desc = 'Go to next window' })
vim.keymap.set('n', '<C-H>', vim.cmd.bp, { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<C-L>', vim.cmd.bn, { desc = 'Go to next buffer' })
vim.keymap.set('n', '<leader>;', utils.smart_curr_buf_del, { desc = 'Delete current buffer' })
vim.keymap.set('n', '<leader>:', function() vim.cmd.bd('#') end, { desc = 'Delete alternate buffer' })
vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select last [P]asted text' })
vim.keymap.set('n', '<leader>f', vim.cmd.Oil, { desc = 'Open [F]iletree' })

vim.keymap.set('v', '<leader>p', '"_dP', { desc = '[P]aste without yanking' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = "[Y]ank to system clipboard" })
vim.keymap.set('n', '<leader>Y', '"+y$', { desc = "Caps version of <leader>y" })
vim.keymap.set('v', '<', '<gv', { desc = 'Outdent without exiting visual mode' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent without exiting visual mode' })
vim.keymap.set('v', '.', ":norm .<CR>", { desc = 'Repeat command for each line' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { desc = 'Exit Terminal Mode' })

vim.keymap.set('n', '<leader>th', function()
  vim.o.hlsearch = not vim.o.hlsearch
end, { desc = 'Toggle hlsearch' })

vim.keymap.set('n', '<leader>tr', function()
  vim.bo.readonly = not vim.bo.readonly
end, { desc = 'Toggle readonly' })

vim.keymap.set('n', '<leader>ti', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ nil }))
end, { desc = "Toggle inlay hints" })

vim.keymap.set('n', '<leader>tx', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })

vim.keymap.set('v', '<leader>r', function()
  local lines = utils.get_selected_text()
  for i, l in ipairs(lines) do
    local l_splits = utils.split_string(l, "\\")
    lines[i] = table.concat(l_splits, "\\\\", 1, #l_splits)
  end
  local text = table.concat(lines, '\\n')

  local o = ''
  if vim.fn.getpos(".")[2] > vim.fn.getpos("v")[2] then
    o = 'o'
  end

  utils.vim_send_keys(o .. '<Esc>:.,$s~\\V\\C' .. text .. '~~gc<Left><Left><Left>')
end, { desc = 'Replace Next Matching' })

vim.keymap.set('v', '<leader>R', function()
  local lines = utils.get_selected_text()
  for i, l in ipairs(lines) do
    local l_splits = utils.split_string(l, "\\")
    lines[i] = table.concat(l_splits, "\\\\", 1, #l_splits)
  end
  local text = table.concat(lines, '\\n')

  utils.vim_send_keys('<Esc>:%s~\\V\\C' .. text .. '~~gc<Left><Left><Left>')
end, { desc = 'Replace All Matching' })
