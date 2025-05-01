return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      integrations = {
        treesitter_context = false,
        blink_cmp = true,
      }
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      -- vim.cmd.colorscheme("catppuccin")
    end
  },
  {
    "neanias/everforest-nvim",
    priority = 1000,
    opts = {
      background = "hard",
      on_highlights = function(hl)
        hl.ErrorMsg.underline = nil
      end,
    },
    config = function(_, opts)
      require("everforest").setup(opts)
      vim.cmd.colorscheme("everforest")
    end,
  },
}
