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
