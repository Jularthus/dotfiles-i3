lvim.transparent_window = true
vim.opt.tabstop = 4;
vim.opt.shiftwidth = 4;

lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "sbdchd/neoformat" },
  { "vyfor/cord.nvim" },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
}

lvim.colorscheme = "darkplus"
lvim.builtin.project.manual_mode = true

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

-- select function shortcut
lvim.builtin.treesitter.textobjects = {
  select = {
    enable=true,
    lookahead=true,
    keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
    },
  },
}

-- Auto format on save (disabled for now, use :Neoformat instead)
-- lvim.format_on_save = true
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])

-- add terminal shortcut
-- set properties
-- lvim.builtin["terminal"].direction = "horizontal"
-- lvim.builtin["terminal"].size = function()
--   return math.floor(vim.o.columns * 0.1)
-- end

lvim.builtin.which_key.mappings["t"] = {
  name = "+terminal",
  t = { '<cmd>ToggleTerm dir=%:p:h<CR>', "Open terminal" },
  h = { '<cmd>ToggleTerm dir=~<CR>', "Terminal in home dir" },
}

-- bottom bar options 
lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.sections.lualine_x = {'encoding', 'filetype'} -- remove ugly unix logo

-- LSP
lvim.lsp.installer.setup.automatic_installation = false
lvim.lsp.automatic_configuration.skipped_servers = { "all" }
-- Clangd

local lspconfig = require("lspconfig")
lspconfig.clangd.setup {
  cmd = { "/run/current-system/sw/bin/clangd", "--background-index" }
}

-- DEBUG
-- Debug C
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-dap',
  name = 'lldb'
}

dap.adapters.gdb = {
  type = 'executable',
  command = 'gdb',
  args = { "-i", "dap" }
}

dap.configurations.c = {
  {
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable (-g): ', vim.fn.getcwd() .. '/a.out', 'file')
      -- return vim.fn.getcwd() .. '/a.out'
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
     args = function() 
      input1 = vim.fn.input("Arguments: ")
      local args = vim.split(input1, " +")
      table.remove(args, 1)
      return args
    end,
  },
}

-- Debug Python
dap.adapters.python = {
  type = "executable",
  command = vim.fn.expand("~/.venvs/lvim/bin/python"),
  -- command = "python3",
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    program = "${file}",
    pythonPath = function()
      return "python3"
    end,
  },
}

