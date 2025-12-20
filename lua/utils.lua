local M = {}

--- @param keys string
function M.vim_send_keys(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, "m", false)
end

function M.get_selected_text()
  --- Returns the currently selected text in visual/visual-line mode.
  --- A list of lines is returned.
  local mode = vim.fn.mode()
  if mode:lower() ~= "v" then
    return ""
  end

  local s_pos = vim.fn.getpos('.')
  local e_pos = vim.fn.getpos('v')
  local lines = vim.fn.getregion(s_pos, e_pos, { type = mode })
  return lines
end

function M.smart_curr_buf_del()
  -- Smart current buffer deletion: Prevents the window from closing by switching buffers
  -- (to alternate or next listed) before calling `bd`, unless only one listed buffer exists.

  --- @returns bool
  local function at_most_one_buf_listed()
    local buf_list = vim.api.nvim_list_bufs()
    local got_one = false
    for _, bufnr in ipairs(buf_list) do
      if vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
        if got_one then
          return false
        end
        got_one = true
      end
    end
    return true
  end

  local alt_bufnr = vim.fn.bufnr('#')
  local is_oil_buf = vim.fn.expand("%:p"):sub(1, 6) == "oil://"

  if is_oil_buf then
    require("oil").close()
  elseif at_most_one_buf_listed() then
    vim.cmd.bd()
  elseif alt_bufnr ~= -1 and vim.api.nvim_get_option_value("buflisted", { buf = alt_bufnr }) then
    vim.cmd.b('#')
    local ok, err = pcall(vim.cmd.bd, '#')
    if not ok then
      vim.cmd.b('#')
      error(err)
    end
  else
    vim.cmd.bn()
    local ok, err = pcall(vim.cmd.bd, '#')
    if not ok then
      vim.cmd.b('#')
      error(err)
    end
  end
end

return M
