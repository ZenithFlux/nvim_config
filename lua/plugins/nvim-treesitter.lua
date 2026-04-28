return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,

  build = { function ()
    -- This function will install 'tree-sitter' in ~/.local/bin, if not found
    if vim.fn.executable("tree-sitter") == 0 then
      local download_url = vim.fn.system(
        "curl -s https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest"
        .. " | grep 'browser_download_url.*tree-sitter-cli-linux-x64.zip'"
        .. " | cut -d '\"' -f 4"
      )
      download_url = vim.trim(download_url)

      local cmds = {
        "mkdir -p ~/.local/bin",
        "curl -L '" .. download_url .. "' -o ~/.local/bin/tree-sitter-cli-linux-x64.zip",
        "unzip -o ~/.local/bin/tree-sitter-cli-linux-x64.zip -d ~/.local/bin",
        "chmod a+x ~/.local/bin/tree-sitter",
        "rm ~/.local/bin/tree-sitter-cli-linux-x64.zip",
      }

      for _, cmd in ipairs(cmds) do
          local result = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
              vim.notify("tree-sitter install failed at: " .. cmd .. "\n" .. result, vim.log.levels.ERROR)
              return
          end
      end

      vim.notify("tree-sitter installed at ~/.local/bin", vim.log.levels.INFO)
    end
  end, ":TSUpdate" },

  config = function ()
    require('nvim-treesitter').install({
      'lua', 'vimdoc', 'vim', 'bash', 'python', 'c', 'cpp', 'cmake', 'markdown',
      'markdown_inline', "dockerfile"
    })

    -- Indentation
    local indent_excluded = { "python", "c", "cpp" }

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        if not vim.tbl_contains(indent_excluded, vim.bo.filetype) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
