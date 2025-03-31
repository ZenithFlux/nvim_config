-- My non-plugin keymaps
require('keymaps')

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = 'a'
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.undofile = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 1000
vim.o.scrolloff = 10
vim.o.sidescrolloff = 30
vim.g.netrw_list_hide = "^\\.\\.\\=/"
vim.o.completeopt = "menu,preview,noinsert"
vim.opt.guicursor:append('a:blinkon500-blinkoff500')
vim.o.cino = '(0,m1,N-s,Ws,+0'
vim.diagnostic.config({ virtual_text = true })

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Modifying global dicts
vim.g.python_indent = {
  open_paren = "shiftwidth()",
  closed_paren_align_last_line = false,
  continue = "shiftwidth()",
}

if vim.uv.os_uname().sysname == 'Windows_NT' then
  vim.o.shell = 'pwsh'
end


-- `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

require("more_config")

-- The line beneath this is called `modeline`.
-- vim: ts=2 sts=2 sw=2 et
