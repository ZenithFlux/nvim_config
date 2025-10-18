vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics under the cursor' })
----------------------

vim.keymap.set('', '<C-D>', '<C-D>zz', { desc = 'Scroll half page down and center cursor' })
vim.keymap.set('', '<C-U>', '<C-U>zz', { desc = 'Scroll half page up and center cursor' })

vim.keymap.set('n', '<C-P>', '<C-L>', { desc = 'Clears and redraws the screen' })
vim.keymap.set('n', '<C-K>', '<C-W>W', { desc = 'Go to previous window' })
vim.keymap.set('n', '<C-J>', '<C-W>w', { desc = 'Go to next window' })
vim.keymap.set('n', '<C-H>', vim.cmd.bp, { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<C-L>', vim.cmd.bn, { desc = 'Go to next buffer' })
vim.keymap.set('n', '<leader>:', function() vim.cmd.bd('#') end, { desc = 'Delete alternate buffer' })
vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select last [P]asted text' })
vim.keymap.set('n', '<leader>f', vim.cmd.Oil, { desc = 'Open [F]iletree' })

vim.keymap.set('v', '<leader>p', '"_dP', { desc = '[P]aste without yanking' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = "[Y]ank to system clipboard" })
vim.keymap.set('n', '<leader>Y', '"+y$', { desc = "Caps version of <leader>y" })
vim.keymap.set('v', 'r', '"ry:%s~<C-R>r~~gc<Left><Left><Left>', { desc = '[R]eplace Selected Text' })
vim.keymap.set('v', '<', '<gv', { desc = 'Outdent without exiting visual mode' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent without exiting visual mode' })

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

vim.keymap.set('n', '<leader>;', function()
  -- Smart buffer deletion: Prevents the window from closing by switching buffers
  -- (to alternate or next listed) before calling `bd`, unless only one listed buffer exists.

  --- @returns bool
  local function at_most_one_buf_listed()
    local buf_list = vim.api.nvim_list_bufs()
    local got_one = false
    for _, bufnr in ipairs(buf_list) do
      if vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
        if got_one then
          return false
        end
        got_one = true
      end
    end
    return true
  end

  local alt_bufnr = vim.fn.bufnr('#')

  if at_most_one_buf_listed() then
    vim.cmd.bd()
  elseif alt_bufnr ~= -1 and vim.api.nvim_get_option_value("buflisted", { buf = alt_bufnr }) then
    vim.cmd.b('#')
    vim.cmd.bd('#')
  else
    vim.cmd.bn()
    vim.cmd.bd('#')
  end
end, { desc = 'Delete current buffer' })
