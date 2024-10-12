return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  build = function()
    vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/markdown-preview.nvim')
    vim.fn["mkdp#util#install"]()
  end,
}
