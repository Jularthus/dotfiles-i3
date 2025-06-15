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
    tooltip = "LunarVim 4 the win",
  }
}

-- Nvim-tree config
lvim.builtin.nvimtree.setup.actions = {
  open_file = {
    quit_on_open = true,
  },
}

-- Neoformat configuration
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])

-- Disabling JS suggestions
-- require('lspconfig').tsserver.setup({
--     init_options = {
--         preferences = {
--             disableSuggestions = true,
--         },
--     },
-- })

-- add terminal shortcut
lvim.builtin.which_key.mappings["t"] = {
  name = "+terminal",
  t = { '<cmd>ToggleTerm<CR>', "Open terminal" },
  d = { '<cmd>TermExec cmd="dd"<CR>', "Open term and run DevDocker" },
  h = { '<cmd>TermExec cmd="clear" dir=%:p:h<CR>', "Terminal in file dir" },
  r = { '<cmd>TermExec cmd="clear" dir=$(git rev-parse --show-toplevel)<CR>', "Terminal in project root" },
}

-- add select shortcuts
lvim.builtin.which_key.mappings["v"] = {
  name = "+Select",
  f = { '[{kVj%', "Select whole function" },
}

-- formatting
-- lvim.format_on_save.enabled = true
-- lvim.format_on_save.pattern = { "*" }
