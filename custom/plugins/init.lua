
-- PEP8 Indent
local pep8indent = {'Vimjas/vim-python-pep8-indent'}
-- Bufdelte: Maintain buffer layout on close
local bufdelete = {'famiu/bufdelete.nvim'}
-- Spellsitter: Spellcheck for treesitter TODO: DOES NOT WORK
local spellsitter = {
  'lewis6991/spellsitter.nvim',
  config = function()
    require('spellsitter').setup({
            enable=true,
    })
  end,
}
-- Orgmode and helper plugins
local orgmode = {}
orgmode.orgmode = {
  'nvim-orgmode/orgmode',
  config = function()
    require('orgmode').setup_ts_grammar()
    require('orgmode').setup({
      org_agenda_files = {'~/org/agenda/*'},
      org_default_notes_file = '~/org/default.org',
    })
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

-- Pack and Ship all plugins
local M = {
  pep8indent,
  bufdelete,
  spellsitter,
  orgmode.orgmode,
  orgmode.orgbullets
}
return M
