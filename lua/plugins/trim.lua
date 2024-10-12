return {
  "cappyzawa/trim.nvim",
  cmd = { "Trim", "TrimToggle" },
  event = "BufWritePre",
  opts = {
    ft_blocklist = { "markdown" },
  },
}
