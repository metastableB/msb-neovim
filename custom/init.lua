-- Current understanding: The top level init.lua, (outside lua folder) calls
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
--------------
-- Mappings --
--------------
require "custom.mappings"

---------------------
-- Global Settings -- 
---------------------

-- Line wrap
vim.wo.wrap = true
vim.o.textwidth = 79

-- Spell check: Vim native spell check highlighting has conflicts with
-- tree-sitter. We thus use spellsitter, an extra plugin to make spell checks
-- visible.
vim.o.spell = true
vim.o.spelllang = "en_us"

-- Folding: Tree sitter based folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
