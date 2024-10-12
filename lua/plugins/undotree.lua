return {
  'mbbill/undotree',
  cmd = "UndotreeToggle",
  keys = {
    { '<leader>u',
      function()
        vim.cmd.UndotreeToggle()
        local key = vim.api.nvim_replace_termcodes('<C-W>w', true, false, true)
        vim.api.nvim_feedkeys(key, 'n', false)
      end,
      desc = "Open [U]ndotree",
    }
  }
}
