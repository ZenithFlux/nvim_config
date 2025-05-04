local function formatter_or_lsp(cmd_args)
  if vim.fn.executable(cmd_args.exe) == 1 then
    return cmd_args
  end
  local msg = "'" .. cmd_args.exe .. "' is not available, using 'vim.lsp.buf.format()'"
  vim.notify_once(msg, vim.log.levels["INFO"])
  vim.lsp.buf.format()
end


local format_config = {
  python = {
    function()
      local args = require("formatter.filetypes.python").ruff()
      return formatter_or_lsp(args)
    end,
  },
}


return {
  "mhartington/formatter.nvim",
  cmd = { "Format", "FormatWrite", "FormatLock", "FormatWriteLock" },
  opts = {
    filetype = vim.tbl_extend("error", format_config, {
      ["*"] = {
        function()
          if not format_config[vim.bo.filetype] then
            vim.lsp.buf.format()
          end
        end,
      },
    })
  },
}
