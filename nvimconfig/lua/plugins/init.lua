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
local cmpconfigs = require 'plugins.cmpconfigs'
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

-- Nvim Cmp
-- Completing engine and completion sources
--
local nvimcmp = { 
    -- completion engine
    'hrsh7th/nvim-cmp',
    requires = {
        -- Common LSP configurations
        'neovim/nvim-lspconfig',
        -- Nvim-cmp-lsp. Source for built in lsp
        'hrsh7th/cmp-nvim-lsp',
        -- Sources from buffer
        'hrsh7th/cmp-buffer',
        -- Sources for path
        'hrsh7th/cmp-path',
        -- sorces from cmds
        'hrsh7th/cmp-cmdline',

        -- Snippet engine
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',

        -- Icons
        'onsails/lspkind.nvim',
    },

    config = cmpconfigs.setup_nvimcmp,
}

-- -----------------------
-- LSP and Related Stuff
-- ---------------------
--
--
-- Null-ls:  Neovim doesn't provide a way for non-LSP sources to hook into its
-- LSP client. null-ls is an attempt to bridge that gap and simplify the
-- process of creating, sharing, and setting up LSP sources using pure Lua.
local nullls = {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
	  {'nvim-lua/plenary.nvim'},
    },
    config = function()
        require("null-ls").setup({
            sources = {
                require("null-ls").builtins.formatting.stylua,
                require("null-ls").builtins.diagnostics.eslint,
                require("null-ls").builtins.completion.spell,
            },
        })
    end
}

-- Nvim-LSP-Installer
-- Neovim plugin that allows you to manage LSP servers (servers are installed
-- inside :echo stdpath("data") by default). It works in tandem with lspconfig1
-- by registering a hook that enhances the PATH environment variable, allowing
-- neovim's LSP client to locate the installed server executable.2
local lspinstaller = {
    "neovim/nvim-lspconfig",
    requires = {"williamboman/nvim-lsp-installer",},
    config = function()
        require("nvim-lsp-installer").setup {}
    end
}

-- ------------- --
-- QoL Plugins   --
-- ------------- --
-- Spellsitter: Spellcheck for treesitter
local spellsitter = {
  'lewis6991/spellsitter.nvim',
  config = function()
    require('spellsitter').setup({
      enable=true,
    })end
}

-- Lightspeed (movement)
local lightspeed = {'ggandor/lightspeed.nvim', requires={'tpope/vim-repeat'}}

-- Tab and buffer handling
local bufferline = {
	'akinsho/bufferline.nvim', 
	tag = "v2.*", 
	requires = 'kyazdani42/nvim-web-devicons',
 	config = configs.bufferline
}

-- Nvim-treesitter-pyfold: Better folding defaults.
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

-- Orgmode and helper plugins
local orgmode = {}
orgmode.orgmode = {
    'nvim-orgmode/orgmode',
    config = function()
        require('orgmode').setup()
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
-- a dashboard
local alphanvim = {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
}
-- Status line at the bottom of page
local feline = {'feline-nvim/feline.nvim', 
    config = function()
        require('feline').setup()
    end
}

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

-- Base16 themes and material themes. Set theme here.
local themes = {
	"norcalli/nvim-base16.lua",
	"marko-cerovac/material.nvim",
	-- Different pluings have different ways of starting the theme.
	config = function()
		-- base16 = require 'base16'
		-- base16(base16.themes.brewer, true)
		-- Material
        require('material').setup()
	end
}

-- Material theme
local 
cal

-- FixCurserHold: better cursor hold event behaviour. Should lead to faster
-- texts. 
local fixcursorhold = {
    'antoinemadec/FixCursorHold.nvim',
    config = function()
        vim.g.cursorhold_updatetime = 100
    end
}

-- Plugins to Install
-- ------------------
M.plugins = {
  packer,
  nvimtree,
  treesitter,
  telescope,
  nvimcmp,
  nullls,
  lspinstaller,

  spellsitter,
  lightspeed,
  bufferline,
  pyfold,
  orgmode.orgmode,
  orgmode.orgbullets,
  trouble,
  alphanvim,
  feline,
  blanklines,
  toggleterm,
  gitsigns,
  comment,
  themes,
  fixcursorhold,
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

