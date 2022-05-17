-- This is the entry point for all custom configurations.
require "plugins"

local utils = require "utils"


-- require "custom.mappings"
-- require "custom.autocmds"
--
-- ---------------------
-- -- Global Settings -- 
-- ---------------------
--
-- -- Line wrap
-- vim.wo.wrap = true
-- vim.o.textwidth = 79
--
-- -- Spell check: Vim native spell check highlighting has conflicts with
-- -- tree-sitter. We thus use spellsitter, an extra plugin to make spell checks
-- -- visible.
-- vim.o.spell = true
-- vim.o.spelllang = "en_us"
--
-- -- Folding: Tree sitter based folding
-- -- We are going to use expression based folding where the expressions are
-- -- provided by tree-sitter.
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- -- I think the best solution to your current workflow problem is to actually
-- -- learn how to use fold-levels. Once you have this, you can use autocommands
-- -- to get some folding behavior. Also using the plugin nvim-treesitter-pyfold
-- -- for good defaults for python-treesitter.
-- -- z-o: open folds
-- -- z-O: open all folds at cursor
-- -- z-c: close fold
-- -- z-m: Increase the fold level by one
-- -- z-r: decrease teh fold level by one
-- -- zR: open everything
--
-- -- Jumplist: Make it behave like tags (natural). (Only neovim)
-- vim.o.jumpoptions = vim.o.jumpoptions .. "stack"
--

-- Remapping Leader to Space
vim.g.mapleader = "<Space>"
utils.applymaps()
