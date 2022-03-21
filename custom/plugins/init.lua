
return {
  {'Vimjas/vim-python-pep8-indent'},

  {'famiu/bufdelete.nvim'},
	
  -- Proper spell-check with nvim tree sitter highlighting.
  -- NEEDS FIXING
  {
    'lewis6991/spellsitter.nvim',
    config = function()
      require('spellsitter').setup({
	      enable=true,
      })
    end,
  },
  -- Nvim Orgmode
  {
    'nvim-orgmode/orgmode',
    config = function()
      require('orgmode').setup_ts_grammar()
      require('orgmode').setup({
        org_agenda_files = {'~/org/agenda/*'},
        org_default_notes_file = '~/org/default.org',
    })
    end,
  },
}
