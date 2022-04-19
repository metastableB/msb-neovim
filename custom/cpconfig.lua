-- Configuration of the custom pallet
local tbuiltin = require "telescope.builtin"
local textensions = require "telescope".extensions
local floatw = require "custom.plugins.float"
local vimrc = string.sub(os.getenv("MYVIMRC"), 1, -9)
local cheatsheet_file = vimrc .. "lua/custom/cheatsheet.lua"

local M = {}
-- Settings for dap 
local cpconfig = {
  {
    name = "MSB Cheatsheet",
    action = floatw.toggle,
    action_args = cheatsheet_file,
    helpstr = "Show cheat sheet",
  },
  { 
    name = "Custom-palette (<leader>-cp)", 
    action = function()
      ext = require('telescope').load_extension('custompalette')
      ext.custompalette()
    end,
    helpstr = ":Telescope custompalette",
  },
  {
    name = "Reload vimrc",
    action = vim.cmd,
    action_args = ":source $MYVIMRC",
    helpstr = ":source $MYVIMRC",
  },
  {
    name = 'Check health',
    action = vim.cmd,
    action_args = ":checkhealth",
    helpstr = ":checkhealth",
  },
  {
    name = "Jump list",
    action = tbuiltin.jumplist,
    helpstr = ":Telescope jumplist",
  },
  {
    name = "All commands",
    action = tbuiltin.commands,
    helpstr = ":Telescope commands",
  },
  {
    name = "Command history",
    action = tbuiltin.command_history,
    helpstr = ":Telescope command_history",
  },
  {
    name = "Registers (A-e)",
    action = tbuiltin.registers,
    helpstr = ":Telescope registers",
  },
  {
    name = "Colorshceme",
    action = tbuiltin.colorscheme,
    helpstr = ":Telescope colorscheme",
  },
  {
    name = "Vim options",
    action = tbuiltin.vim_options,
    helpstr = ":Telescope vim_options",
  },
  {
    name = "Keymaps",
    action = tbuiltin.keymaps,
    helpstr = ":Telescope keymaps",
  },
  {
    name = "Buffers",
    action = tbuiltin.buffers,
    helpstr = ":Telescope buffers",
  },
  {
    name = "Search history",
    action = tbuiltin.search_history,
    helpstr = ":Telescope search_history",
  },
  {
    name = "Paste mode",
    action = vim.cmd,
    action_args = ':set paste!',
    helpstr = ':set paste!',
  },
  {
    name = 'Cursor line',
    action = vim.cmd,
    action_args = ':set cursorline!',
    helpstr = ':set cursorline!',
  },
  {
    name = 'Cursor column',
    action = vim.cmd,
    action_args = ':set cursorcolumn!',
    helpstr = ':set cursorcolumn!',
  },
  {
    name = "Spell checker",
    action = vim.cmd,
    action_args = ':set spell!',
    helpstr = ':set spell!'
  },
  {
    name = "Relative number",
    action = vim.cmd,
    action_args = ':set relativenumber!',
    helpstr = ':set relativenumber!'
  },
  {
    name = "Search highlighting",
    action = vim.cmd,
    action_args = ':set hlsearch!',
    helpstr = ':set hlsearch!'
  },
  {
    name = "Loc list ",
    action = tbuiltin.loclist,
    helpstr = "telescope.builtin.loclist()",
  },
  {
    name = "Reload file",
    action = vim.cmd,
    action_args = ":e ",
    helpstr = ":e ",
  },
  {
    name = "LSP Reference (<ldr>-lr)",
    action = function ()
      lsp = require('telescope.builtin')
      lsp.lsp_references()
      end,
    helpstr = ":lua require('telescope.builtin').lsp_references()",
  },
  {
    name = "LSP Document symbolds (<ldr>-ls)",
    action = tbuiltin.lsp_document_symbols,
    helpstr = ":Telescope lsp_document_symbols",
  },
}

M.mastertable = cpconfig
return M
