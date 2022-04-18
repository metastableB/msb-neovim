local M = {
  { name = "Custom-palette (<leader>-cp)", helpstr = ":Telescope custompalette<CR>"},
  { name = "Reload vimrc", helpstr = ":source $MYVIMRC"},
  { name = 'Check health', helpstr = ":checkhealth"},
  { name = "Jump list", helpstr = ":lua require('telescope.builtin').jumplist()"},
}

return M
