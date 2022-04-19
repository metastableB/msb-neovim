-- PEP8 Indent
local pep8indent = {'Vimjas/vim-python-pep8-indent'}
-- Bufdelte: Maintain buffer layout on close
local bufdelete = {'famiu/bufdelete.nvim'}
-- Spellsitter: Spellcheck for treesitter
local spellsitter = {
  'lewis6991/spellsitter.nvim',
  config = function()
    require('spellsitter').setup({
            enable=true,
    })
  end,
}
-- Lightspeed (movement)
local lightspeed = {}
lightspeed.vimrepeat = { 'tpope/vim-repeat' }
lightspeed.lightspeed = { 'ggandor/lightspeed.nvim' }

-- Orgmode and helper plugins
local orgmode = {}
orgmode.orgmode = {
  'nvim-orgmode/orgmode',
  config = function()
    require('orgmode').setup_ts_grammar()
    require('orgmode').setup({
      org_agenda_files = {'~/org/agenda/*'},
      org_default_notes_file = '~/org/default.org',
    })
  end,
}

orgmode.orgbullets = {
  'akinsho/org-bullets.nvim',
  config = function()
    require('org-bullets').setup({
      symbols = { "◉", "○", "✸", "✿" },
      -- -- or a function that receives the defaults and returns a list
      -- symbols = function(default_list)
      --   table.insert(default_list, "♥")
      --   return default_list
      -- end
    })
  end,
}

-- Custom command palette
---------
-- We need to specify absolute path. Remove init.lua
local vimrc = string.sub(os.getenv("MYVIMRC"), 1, -9)
local pluginroot = vimrc .. "lua/custom/plugins/"
local pluginpath = pluginroot .. "custompalette/"
local custompalette = {
  pluginpath,
  as = 'custompalette',
  config = function()
    -- local cpconfig = require("custom.cpconfig")
    ext = require('telescope').load_extension('custompalette')
    config = require('custom.cpconfig')
    ext.setup(config)
  end,
}

-- Neogen 
-- Treesitter based docstring annotation (comments i.e.)
local neogen = {
  "danymat/neogen",
  config = function()
    require('neogen').setup {}
  end,
}

-- Debugger
local dap = {}
dap.dap = { 'mfussenegger/nvim-dap' }
dap.dapinstall = { 
  "Pocco81/DAPInstall.nvim",
  config = function () 
    local dap_install = require("dap-install")
    dap_install.setup({
      installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
    })
  end
}
dap.telescope = {
  'nvim-telescope/telescope-dap.nvim',
  config = function ()
    require('telescope').load_extension('dap')
  end,
}
--
-- Pack and Ship all plugins
local M = {
  pep8indent,
  bufdelete,
  spellsitter,
  orgmode.orgmode,
  orgmode.orgbullets,
  custompalette,
  lightspeed.vimrepeat,
  lightspeed.lightspeed,
  neogen,
  dap.dap,
  dap.dapinstall,
  dap.telescope
}
return M
