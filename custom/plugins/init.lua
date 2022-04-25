-- Load common plugin/utility functions
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
    config = {} -- require('custom.cpconfig')
    config.mastertable = {
	    name = 'HELLO'}
    ext.setup(config.mastertable)
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

-- Nvim-treesitter-pyfold
local pyfold = {
  'eddiebergman/nvim-treesitter-pyfold',
  config = function()
    require('nvim-treesitter.configs').setup{
      pyfold = {
        enable = true,
        custom_foldtext = true
      },
    }
  end
}

-- Trouble
-- Better error display in bottom float
local trouble = {
"folke/trouble.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    require("trouble").setup {
      -- automatically preview the location of the diagnostic. <esc> to
      -- close preview and go back to last window
    }
  end,
}
-- Debugger
-- We aren't using this as we struggled to get this working realiably
-- local dap = {}
-- dap.dap = { 'mfussenegger/nvim-dap' }
-- dap.telescope = {
--   'nvim-telescope/telescope-dap.nvim',
--   config = function ()
--     require('telescope').load_extension('dap')
--   end,
-- }
--
-- Pack and Ship all plugins
local M = {
  pep8indent,
  bufdelete,
  spellsitter,
  orgmode.orgmode,
  orgmode.orgbullets,
  lightspeed.vimrepeat,
  lightspeed.lightspeed,
  neogen,
  trouble,
  -- pyfold, kind of ugly
  -- dap.dap,
  -- dap.telescope
  -- custompalette, TODO: Do not enable. There is some bug i need to figure out
}
return M
