vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- LAZY
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- END LAZY


require("lazy").setup({
  { "lunarvim/colorschemes", lazy = false },
  { "LunarVim/bigfile.nvim", event = "BufReadPre", config = true },
  { "akinsho/bufferline.nvim", event = "BufReadPost", dependencies = "nvim-web-devicons" },
  { "lewis6991/gitsigns.nvim", event = "BufReadPost", config = true },
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPost"},
  { "nvim-lualine/lualine.nvim", event = "VimEnter", dependencies = "nvim-web-devicons", config = true },
  { "sbdchd/neoformat", cmd = "Neoformat" },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  { "SmiteshP/nvim-navic", event = "BufReadPost", config = true },
  { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "BufReadPost" },
  { "JoosepAlviste/nvim-ts-context-commentstring", event = "BufReadPost" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "RRethy/vim-illuminate", event = "BufReadPost" },
  { "folke/which-key.nvim", event = "VeryLazy", config = true },
  {'akinsho/toggleterm.nvim', version = "*", config = true},
  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
})

vim.cmd("colorscheme darkplus")
vim.cmd [[
  hi Normal guibg=NONE
  hi NormalNC guibg=NONE
]]

vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.number = true

local wk = require("which-key")
wk.add( {
  { "<leader>t", group = "terminal" },
    { "<leader>th", "<cmd>ToggleTerm dir=~<CR>", desc = "Open terminal in home dir" },
    { "<leader>tt", "<cmd>ToggleTerm dir=%:p:h<CR>", desc = "Open terminal" },
}
)

require("toggleterm").setup({
  direction = "vertical",
  size = function()
    return math.floor(vim.o.columns * 0.3)
  end,
})

