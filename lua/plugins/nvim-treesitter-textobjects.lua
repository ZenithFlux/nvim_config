return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  config = function ()
    require("nvim-treesitter-textobjects").setup {
      select = { lookahead = true },
      move = { set_jumps = true },
    }

    -- Keymaps for selecting textobjects
    local function map_textobj_select(lhs, textobj)
      vim.keymap.set({ "x", "o" }, lhs, function()
        require "nvim-treesitter-textobjects.select".select_textobject(textobj, "textobjects")
      end, { desc = "Select " .. textobj })
    end

    map_textobj_select("aa", "@parameter.outer")
    map_textobj_select("ia", "@parameter.inner")
    map_textobj_select("af", "@function.outer")
    map_textobj_select("if", "@function.inner")
    map_textobj_select("ac", "@class.outer")
    map_textobj_select("ic", "@class.inner")

    -- Keymaps for swapping
    vim.keymap.set("n", "<leader>a", function()
      require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
    end, { desc = "Swap with next parameter" })
    vim.keymap.set("n", "<leader>A", function()
      require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
    end, { desc = "Swap with prev parameter" })

    -- Keymaps for moving
    local textobjects_move = require("nvim-treesitter-textobjects.move")

    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      textobjects_move.goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next @function.outer start" })

    vim.keymap.set({ "n", "x", "o" }, "]]", function()
      textobjects_move.goto_next_start("@class.outer", "textobjects")
    end, { desc = "Next @class.outer start" })

    vim.keymap.set({ "n", "x", "o" }, "]F", function()
      textobjects_move.goto_next_end("@function.outer", "textobjects")
    end, { desc = "Next @function.outer end" })

    vim.keymap.set({ "n", "x", "o" }, "][", function()
      textobjects_move.goto_next_end("@class.outer", "textobjects")
    end, { desc = "Next @class.outer end" })

    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      textobjects_move.goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous @function.outer start" })

    vim.keymap.set({ "n", "x", "o" }, "[[", function()
      textobjects_move.goto_previous_start("@class.outer", "textobjects")
    end, { desc = "Previous @class.outer start" })

    vim.keymap.set({ "n", "x", "o" }, "[F", function()
      textobjects_move.goto_previous_end("@function.outer", "textobjects")
    end, { desc = "Previous @function.outer end" })

    vim.keymap.set({ "n", "x", "o" }, "[]", function()
      textobjects_move.goto_previous_end("@class.outer", "textobjects")
    end, { desc = "Previous @class.outer end" })


    -- Make the textobjects' movement repeatable by ; and ,
    local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,

  dependencies = { 'nvim-treesitter/nvim-treesitter' },
}
