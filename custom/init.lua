--  The top level init.lua, (outside lua folder) calls
-- loads the three main modules, [options, mappings, plugins]. These files
-- internally then use the custom settings to overwrite their own settings. The
-- custom folder mainly just contains lua tables with custom values and
-- functions. These are then passed on to the appropriate variable (see
-- chardrc) so that they are applied on load.
--
--
-- Plugins and Plugin Settings
-- --------------------------
-- Plugin information is localized to custom.plugins module and are loaded from
-- custom.chadrc. See custom.chardrc to see how plugins and plugin options can
-- be modified.
--
-- To see how exactly the overwride happens see 
--     plugins.init.lua
--     core.utils.load_config
--     core.override_req
--     core.tbl_override_req
-- and specifically the call to vim.tbl_deep_extend. From its documentation: 
--    Merges recursively two or more map-like tables.
                --
                -- Parameters: 
                --     {behavior}  Decides what to do if a key is found in more
                --                 than one map:
                --                 • "error": raise an error
                --                 • "keep": use value from the leftmost map
                --                 • "force": use value from the rightmost map
                --     {...}       Two or more map-like tables.
                --
                --
-- User Plugin Settings
-- --------------------
-- See how we incorporated nvim-orgmode through edits in custom/plugins/init and chardrc.init
--
-- Global vim Settings
-- -------------------
-- After loading the options from chardrc, the toplevel init.lua calls this
-- module. We add our global settings here.
--
-- print("Hello I'm loaded")
--
------------------------------
-- Mappings  and Autocommands
------------------------------
require "custom.mappings"
require "custom.autocmds"
require "custom.autocmds"

---------------------
-- Global Settings -- 
---------------------

-- Line wrap
vim.wo.wrap = true
vim.o.textwidth = 79

-- Spell-check
-- Vim native spell check highlighting has conflicts with tree-sitter. We thus
-- use spellsitter, an extra plugin to make spell checks visible. We dont need
-- to enable these for spell-checking.
-- vim.o.spell = true
-- vim.o.spelllang = "en_us"

-- Folding: 
-- Tree sitter based folding. We are going to use expression based folding
-- where the expressions are provided by tree-sitter.
--  This small script helps hand over folding to tree-sitter whenever a parser
--  is available, otherwise work with existing indent profile.
-- Non global folding because tree-sitter does not work with orgmode files and
-- some other weird behaviours. 
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/475#issuecomment-748532035
-- https://github.com/nvim-orgmode/orgmode/issues/75
-- z-o: open folds
-- z-O: open all folds at cursor
-- z-c: close fold
-- z-m: Increase the fold level by one
-- z-r: decrease teh fold level by one
-- zR: open everything
local define_modules = require('nvim-treesitter').define_modules
local query = require('nvim-treesitter.query')

local foldmethod_backups = {}
local foldexpr_backups = {}

function tsattach(bufnr)
  local buf_info = vim.api.nvim_call_function('getbufinfo', {bufnr})
  -- Fold settings are actually window based...
  foldmethod_backups[bufnr] = vim.wo.foldmethod
  foldexpr_backups[bufnr] = vim.wo.foldexpr
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
end

function tsdetach(bufnr)
  vim.wo.foldmethod = foldmethod_backups[bufnr]
  vim.wo.foldexpr = foldexpr_backups[bufnr]
  foldmethod_backups[bufnr] = nil
  foldexpr_backups[bufnr] = nil
end

define_modules({
  folding = {
    enable = true,
    attach = tsattach,
    detach = tsdetach,
    is_supported = query.has_folds
  }
})
