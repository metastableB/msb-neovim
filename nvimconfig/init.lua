-- This is the entry point for all custom configurations.
require "plugins"
local utils = require "utils"
-- Mappings
-- --------
-- Remapping Leader to Space
vim.g.mapleader = "<Space>"
-- This will be applied as part of some plugin other.
utils.addusermap("n", "th", ":lua require('utils').cycle_theme()<cr>")
-- Escape in terminal mode
utils.addusermap("t", "<Esc>", '<C-\\><C-n>', {noremap = true})

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

-- Folding: 
-- Requires a bit of work.
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

-- Jumplist: Make it behave like tags (natural). (Only neovim)
vim.o.jumpoptions = vim.o.jumpoptions .. "stack"

-- Spaces and Tabs
-- -------------
vim.o.tabstop = 4  -- number of visual spaces per TAB
vim.o.softtabstop = 4 
vim.o.shiftwidth = 4 --  number of spaces in tab when editing
vim.o.expandtab = true -- tabs are spaces
vim.o.autoindent = true
vim.o.copyindent = true -- copy from previous line

-- Theme
-- ------ 
vim.cmd('colorscheme material')
vim.g.material_style = "deep ocean"
