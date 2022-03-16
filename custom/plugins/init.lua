
return {
  {'Vimjas/vim-python-pep8-indent'},

  {'famiu/bufdelete.nvim'},
	
  -- Proper spell-check with nvim tree sitter highlighting.
  {
    'lewis6991/spellsitter.nvim',
    config = function()
      require('spellsitter').setup()
    end,
  },
}
