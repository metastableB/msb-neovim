-- Configuration of the custom pallet

local cpconfig = {
  { 
    name = "Command palette (<ldr>-tcp)", 
    action = vim.cmd,
    action_args = ":Telescope command_palette<CR>",
    helpstr = ":Telescope command_palette<CR>",
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
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').jumplist()",
    helpstr = ":lua require('telescope.builtin').jumplist()",
  },
  {
    name = "All commands",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').commands()",
    helpstr = ":lua require('telescope.builtin').commands()",
  },
  {
    name = "Command history",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').command_history()",
    helpstr = ":lua require('telescope.builtin').command_history()",
  },
  {
    name = "Registers (A-e)",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').registers()",
    helpstr = ":lua require('telescope.builtin').registers()",
  },
  {
    name = "Colorshceme",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').colorscheme()",
    helpstr = ":lua require('telescope.builtin').colorscheme()",
  },
  {
    name = "Vim options",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').vim_options()",
    helpstr = ":lua require('telescope.builtin').vim_options()",
  },
  {
    name = "Keymaps",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').keymaps()",
    helpstr = ":lua require('telescope.builtin').keymaps()",
  },
  {
    name = "Buffers",
    action = vim.cmd,
    action_args = ":Telescope buffers",
    helpstr = ":Telescope buffers",
  },
  {
    name = "Search history",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').search_history()",
    helpstr = ":lua require('telescope.builtin').search_history()",
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
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').loclist()",
    helpstr = ":lua require('telescope.builtin').loclist()",
  },
  {
    name = "Reload file",
    action = vim.cmd,
    action_args = ":e ",
    helpstr = ":e ",
  },
  {
    name = "LSP Reference (<ldr>-lr)",
    action = vim.cmd,
    action_args = ":Telescope lsp_references <CR>",
    helpstr = ":Telescope lsp_references <CR>",
  },
  {
    name = "LSP Document symbolds (<ldr>-ls)",
    action = vim.cmd,
    action_args = ":Telescope lsp_document_symbols<CR>",
    helpstr = ":Telescope lsp_document_symbols<CR>",
  }
}

return cpconfig
