-- My non-plugin keymaps
require('keymaps')

-- `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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

require('lazy').setup('plugins.install', {})

-- Contains both plugin configurations and keymaps
require('plugins.config')


vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.undofile = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 1000
vim.o.timeoutlen = 500
vim.o.scrolloff = 10

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Make sure the terminal supports this
vim.o.termguicolors = true


-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

if vim.loop.os_uname().sysname == 'Windows_NT' then
  vim.o.shell = 'pwsh'
end

-- The line beneath this is called `modeline`.
-- vim: ts=2 sts=2 sw=2 et
