-- Custom settings.
-- ---------------
-- This is an example chadrc file , its supposed to be placed in /lua/custom dir
-- lua/custom/chadrc.lua

local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.plugins = {
   -- enable/disable plugins (false for disable)
   status = {
     -- These are disabled by default. Enable them
      colorizer = true, -- (for kicks and giggles)
      dashboard = true,
   },
   options = {
      nvimtree = {
         enable_git = 0,
         -- packerCompile required after changing lazy_load
         lazy_load = true,
         view = {
           -- I like to have the root folder.
            hide_root_folder = false,
         },
      },
      luasnip = {
         snippet_path = {},
      },
      lspconfig = {
        setup_lspconf = "custom.plugins.lspconfig",
      },
  },
}


return M
