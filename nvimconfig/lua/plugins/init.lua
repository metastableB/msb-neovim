-- Plugin Settings.
-- 
-- In the init file, we define the plugins we want packer to load and handle.
-- Settings are defined separately in their on respective files. See
-- configs.lua for an example settings file. Note that we have boot-strap
-- facility for packer. Run:
--      nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
-- Currently the bootstrapping is a little buggy and I haven't been able to
-- figure out why. Running PackerSync from within nvim is probably better.

local configs = require 'plugins.configs'
local M = {}

-- ------------- --
-- Basic Plugins --
-- ------------- --
local packer = { 'wbthomason/packer.nvim' }
local nvimtree = {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    -- tag = 'nightly', -- optional, updated every week. (see issue #1193)
    config = configs.nvimtree,
}
-- EXTERNAL DEPENDENCIES: fd, ripgrep
local telescope = {
  'nvim-telescope/telescope.nvim',
  requires = {
	  {'nvim-lua/plenary.nvim'},
	  {'kyazdani42/nvim-web-devicons' }
  },
  config = configs.telescope,
}

-- Treesitter
local treesitter = {
	'nvim-treesitter/nvim-treesitter',
	config = configs.treesitter,
}

-- ------------- --
-- QoL Plugins   --
-- ------------- --
local bufferline = {
	'akinsho/bufferline.nvim', 
	tag = "v2.*", 
	requires = 'kyazdani42/nvim-web-devicons',
 	config = configs.bufferline
}
-- a dashboard
local alphanvim = {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
	require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
}
-- Status line at the bottom of page
local feline = {'feline-nvim/feline.nvim'}

-- Indent-blank lines (vertical indent lines)
local blanklines = {
	"lukas-reineke/indent-blankline.nvim",
	config = function ()
		require("indent_blankline").setup {
		    -- for example, context is off by default, use this to turn it on
		    show_current_context = true,
		    show_current_context_start = true,
		}
	end
}

-- Terminal toggle
local toggleterm = {
	"akinsho/toggleterm.nvim",
	tag = 'v1.*',
	config = function()
  		require("toggleterm").setup()
	end
}

-- Git signs
local gitsigns = { 
	'lewis6991/gitsigns.nvim',
	config = function()
		require('gitsigns').setup()
	end
}

-- Comments
local comment = {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}

-- Base16 themes
local base16theme = {
	"norcalli/nvim-base16.lua",
	config = function()
		base16 = require 'base16'
		base16(base16.themes.brewer, true)
	end
}

-- Plugins to Install
-- ------------------
M.plugins = {
  packer,
  nvimtree,
  treesitter,
  telescope,

  bufferline,
  alphanvim,
  feline,
  blanklines,
  gitsigns,
  toggleterm,
  comment,
  base16theme
}

-- Bootstrap packer, install plugins if required, and return.
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
-- TODO: The bootstrap procedure is buggy, especially when starting with an
-- empty install. For one, the /site/ path is not added to RTP if it does not
-- exist before creation. 
local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
if not string.find(vim.o.runtimepath, rtp_addition) then
  vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
end
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Install the plugins
return require('packer').startup(function(use)
  -- Install plugins provided in M.plugins
  for k, plugin in pairs(M.plugins) do
    use(plugin)
  end
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

