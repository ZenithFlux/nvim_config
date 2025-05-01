-- Configuring highlight groups
local function onedark_mods()
  vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
    bold = true,
    italic = true,
    bg = "#22252c",
  })
  ---@type vim.api.keyset.get_hl_info | vim.api.keyset.highlight
  local mp_hl = vim.api.nvim_get_hl(0, { name = "MatchParen" })
  mp_hl.bg = "#434a57"
  ---@cast mp_hl vim.api.keyset.highlight
  vim.api.nvim_set_hl(0, "MatchParen", mp_hl)
end


local function hl_mods(event)
  if event == nil or event.match == "onedark" then
    onedark_mods()
  end
  -- Fix wrong colors for 'new' and 'delete' due to clangd
  vim.api.nvim_set_hl(0, "@lsp.type.operator.cpp", {})
end


local augroup = vim.api.nvim_create_augroup('HighlightMods', { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "My highlight modifications",
  callback = hl_mods,
  group = augroup,
})
hl_mods({ match = vim.g.colors_name })


-- Highlight on yank
augroup = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup,
})
