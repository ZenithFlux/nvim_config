-- [[ Configure highlight groups ]]

local function onedark_mods(einfo)
  if einfo ~= nil then
    assert(einfo.event == "ColorScheme",
      "Called on " .. einfo.event .. " event, instead of ColorScheme")
    if einfo.match ~= "onedark" then
      return
    end
  end

  vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
    bold = true,
    italic = true,
    bg = "#22252c",
  })

  ---@type vim.api.keyset.hl_info | vim.api.keyset.highlight
  local mp_hl = vim.api.nvim_get_hl(0, { name = "MatchParen" })
  mp_hl.bg = "#434a57"
  ---@cast mp_hl vim.api.keyset.highlight
  vim.api.nvim_set_hl(0, "MatchParen", mp_hl)
end

local function hl_mods(event)
  onedark_mods(event)
  -- Fix for wrong 'new' and 'delete' color due to clangd
  vim.api.nvim_set_hl(0, "@lsp.type.operator.cpp", {})
end

hl_mods()
local augroup = vim.api.nvim_create_augroup('HighlightMods', { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "My highlight modifications",
  callback = hl_mods,
  group = augroup,
})

-- Highlight on yank
augroup = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup,
})
