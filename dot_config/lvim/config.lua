lvim.transparent_window = true
lvim.colorscheme = "darkplus"

lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "sbdchd/neoformat" },
  { "vyfor/cord.nvim" },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
}

-- Cord.nvim config (discord rich presence)
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

-- Auto format on save (disabled for now, use :Neoformat instead)
-- lvim.format_on_save = true

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
  d = { '<cmd>TermExec cmd="clear ; dd"<CR>', "Open term and run DevDocker" },
  h = { '<cmd>TermExec cmd="clear" dir=%:p:h<CR>', "Terminal in file dir" },
  r = { '<cmd>TermExec cmd="clear" dir=$(git rev-parse --show-toplevel)<CR>', "Terminal in project root" },
}

-- add select shortcut V2
lvim.builtin.treesitter.textobjects = {
  select = {
    enable = true,
    lookahead = true,
    keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
    },
  },
}

-- (DEPRECATED) add select shortcuts
-- lvim.builtin.which_key.mappings["v"] = {
--   name = "+Select",
--   f = { '[{kVj%', "Select whole function" },
-- }
