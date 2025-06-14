lvim.transparent_window = true
lvim.colorscheme = "darkplus"

lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "sbdchd/neoformat" },
  { "vyfor/cord.nvim" },
}

-- Cord.nvim config
require('cord').setup {
  editor = {
    client = "lunarvim",
    tooltip = "LunarVim 4 the win!",
  }
}

-- Neoformat configuration
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])

-- formatting
-- lvim.format_on_save.enabled = true
-- lvim.format_on_save.pattern = { "*" }
