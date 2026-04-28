return {
  'stevearc/oil.nvim',
  tag = "stable",
  lazy = false,
  opts = {
    view_options = {
      is_hidden_file = function(name)
        return name:match("^%.%.$") ~= nil
      end,
    },
  },
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} }
  },
}
