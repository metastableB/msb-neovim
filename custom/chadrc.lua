-- Custom plugins and options. 
--
-- See: https://github.com/siduck/dotfiles/blob/master/nvchad/custom/chadrc.lua
local M = {}

local userPlugins = require "custom.plugins"
local pluginConf = require "custom.plugins.configs"

-- make sure you maintain the structure of `core/default_config.lua` here,
M.plugins = {
   -- enable/disable plugins (false for disable)
  status = {
    -- These are disabled by default. Enable them
    colorizer = true, -- (for kicks and giggles)
    alpha = true, -- (dashboard)
  },

  options = {
    luasnip = {
      snippet_path = {},
    },
    lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig",
    },
  },

  default_plugin_config_replace = {
    nvim_treesitter = pluginConf.treesitter,
    nvim_tree = pluginConf.nvimtree,
    telescope = pluginConf.telescope,
  },

  install = userPlugins,
}

M.ui = {
   theme = "onedark",
}

return M
