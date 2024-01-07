local function map_keys(mode, lhs, rhs, desc)
  local opts = {remap=true, desc=desc}
  vim.keymap.set(mode, lhs, rhs, opts)
end


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map_keys('n', '<C-Up>', '<C-W>k', "Go to above window")
map_keys('n', '<C-Down>', '<C-W>j', "Go to below window")
map_keys('n', '<C-Left>', '<C-W>h', "Go to left window")
map_keys('n', '<C-Right>', '<C-W>l', "Go to right window")
