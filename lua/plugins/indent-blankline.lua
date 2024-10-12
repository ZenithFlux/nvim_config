-- Add indentation guides even on blank lines
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    scope = {
      show_start = false,
      show_end = false,
    },
  },
}
