local M = {}

---@param keys string
function M.vim_send_keys(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, "m", false)
end

---Returns the currently selected text in visual/visual-line mode.
---A list of lines is returned.
---@return string[]
function M.get_selected_text()
  local mode = vim.fn.mode()
  if mode:lower() ~= "v" then
    return {}
  end

  local s_pos = vim.fn.getpos('.')
  local e_pos = vim.fn.getpos('v')
  local lines = vim.fn.getregion(s_pos, e_pos, { type = mode })
  return lines
end

---Smart current buffer deletion: Prevents the window from closing by switching buffers
---(to alternate or next listed) before calling `bd`, unless only one listed buffer exists.
function M.smart_curr_buf_del()
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

---Only 'require' a pkg when a function under it is called.
---@param pkg_name string
function M.require_on_call(pkg_name)
  return setmetatable({}, {
    __index = function(_, value)
      return function(...)
        require(pkg_name)[value](...)
      end
    end
  })
end

---Splits a string based on a separator character
---@param s string The string to be split
---@param sep string The char to be used as a separator
---@return string[]
function M.split_string(s, sep)
    if #sep ~= 1 then
        error("Only single char separators are supported")
    end
    local si = 1
    local chunks = {}
    for i = 1, #s do
        if s:sub(i, i) == sep then
            chunks[#chunks + 1] = s:sub(si, i-1)
            si = i + 1
        end
    end
    chunks[#chunks + 1] = s:sub(si, #s)
    return chunks
end

---Split a command string into list of arguments.
---Follows similar rules as bash command line.
---@param cmd_text string # E.g. "grep -rn 'hello sam'"
---@return string[] # E.g. {"grep", "-rn", "hello sam"}
function M.split_cmd_args(cmd_text)
  local args = {}
  local i = 1

  while i <= #cmd_text do
    local c = cmd_text:sub(i, i)
    while c == " " do
      i = i + 1
      if i > #cmd_text then
        break
      end
      c = cmd_text:sub(i, i)
    end
    if i > #cmd_text then
      break
    end

    if c == '"' then
      i = i + 1
      if i > #cmd_text then
        error('Unclosed "')
      end
      c = cmd_text:sub(i, i)
      local one_arg = ""
      while c ~= '"' do
        if c == "\\" then
          i = i + 1
          if i > #cmd_text then
            break
          end
          c = cmd_text:sub(i, i)
          if not (c == "$" or c == "`" or c == '"' or c == "\\") then
            one_arg = one_arg .. "\\"
          end
        end

        one_arg = one_arg .. c
        i = i + 1
        if i > #cmd_text then
          break
        end
        c = cmd_text:sub(i, i)
      end

      if i > #cmd_text then
        error('Unclosed "')
      else
        args[#args + 1] = one_arg
      end
    elseif c == "'" then
      i = i + 1
      local si = i
      while i <= #cmd_text and cmd_text:sub(i, i) ~= "'" do
        i = i + 1
      end
      if i > #cmd_text then
        error("Unclosed '")
      else
        args[#args + 1] = cmd_text:sub(si, i - 1)
      end
    else
      local one_arg = ""
      while not (c == " " or c == "'" or c == '"') do
        if c == "\\" then
          i = i + 1
          if i > #cmd_text then
            error("'\\' should be followed by some char")
          end
          c = cmd_text:sub(i, i)
        end

        one_arg = one_arg .. c
        i = i + 1
        if i > #cmd_text then
          break
        end
        c = cmd_text:sub(i, i)
      end

      args[#args + 1] = one_arg
      i = i - 1
    end

    -- `i` will always be at the end of the last arg
    i = i + 1
  end

  return args
end

return M
