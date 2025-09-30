lvim.transparent_window = true

lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "sbdchd/neoformat" },
  { "vyfor/cord.nvim" },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
}

lvim.colorscheme = "darkplus"

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
    keymaps = {
      ["fa"] = "@function.outer",
      ["fi"] = "@function.inner",
    },
  },
}

-- Auto format on save (disabled for now, use :Neoformat instead)
-- lvim.format_on_save = true

-- add terminal shortcut
-- set properties
lvim.builtin["terminal"].direction = "horizontal"
lvim.builtin["terminal"].size = function()
  return math.floor(vim.o.columns * 0.3)
end

lvim.builtin.which_key.mappings["t"] = {
  name = "+terminal",
  t = { '<cmd>ToggleTerm dir=%:p:h<CR>', "Open terminal" },
  h = { '<cmd>ToggleTerm dir=~<CR>', "Terminal in home dir" },
}

-- bottom bar options 
lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.sections.lualine_x = {'encoding', 'filetype'} -- remove ugly unix logo

-- CONFIG PISCINE
lvim.lsp.automatic_servers_installation = false
lvim.builtin.cmp.sources = { name="path" }

-- -- LSP
-- lvim.lsp.automatic_configuration.skipped_servers = { "clangd" }
-- -- Clangd

-- local lspconfig = require("lspconfig")
-- lspconfig.clangd.setup {
--   cmd = { "/run/current-system/sw/bin/clangd", "--background-index" }
-- }

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
      input1 = vim.fn.input('Path to executable (-g): ', vim.fn.getcwd() .. '/', 'file')
      local path = vim.split(input1, " +")
      return path[1]
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function() 
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

