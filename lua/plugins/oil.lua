return {
  'stevearc/oil.nvim',
  opts = {
    view_options = {
      is_hidden_file = function(name)
        return name:match("^%.%.$") ~= nil
      end,
    },
  },
  dependencies = {
    { "echasnovski/mini.icons", opts = {} }
  },
}
