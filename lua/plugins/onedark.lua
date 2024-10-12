return {
  'navarasu/onedark.nvim',
  priority = 1000,
  opts = {},
  config = function(_, opts)
    require('onedark').setup(opts)
    require('onedark').load()
  end
}
