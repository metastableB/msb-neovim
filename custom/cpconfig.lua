-- Configuration of the custom pallet

local cpconfig = {
  { 
    name = "Command palette (<ldr>-tcp)", 
    action = vim.cmd,
    action_args = ":Telescope command_palette<CR>",
  },
  {
    name = "Reload vimrc",
    action = vim.cmd,
    action_args = ":source $MYVIMRC",
  },
  {
    name = 'Check health',
    action = vim.cmd,
    action_args = ":checkhealth"
  },
  {
    name = "Jump list",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').jumplist()"
  },
  {
    name = "All commands",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').commands()"
  },
  {
    name = "Command history",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').command_history()"
  },
  {
    name = "Registers (A-e)",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').registers()"
  },
  {
    name = "Colorshceme",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').colorscheme()",
  },
  {
    name = "Vim options",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').vim_options()"
  },
  {
    name = "Keymaps",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').keymaps()"
  },
  {
    name = "Buffers",
    action = vim.cmd,
    action_args = ":Telescope buffers"
  },
  {
    name = "Search history",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').search_history()"
  },
  {
    name = "Paste mode",
    action = vim.cmd,
    action_args = ':set paste!'
  },
  {
    name = 'Cursor line',
    action = vim.cmd,
    action_args = ':set cursorline!'
  },
  {
    name = 'Cursor column',
    action = vim.cmd,
    action_args = ':set cursorcolumn!'
  },
  {
    name = "Spell checker",
    action = vim.cmd,
    action_args = ':set spell!'
  },
  {
    name = "Relative number",
    action = vim.cmd,
    action_args = ':set relativenumber!'
  },
  {
    name = "Search highlighting",
    action = vim.cmd,
    action_args = ':set hlsearch!'
  },
  {
    name = "Loc list ",
    action = vim.cmd,
    action_args = ":lua require('telescope.builtin').loclist()"
  },
  {
    name = "Reload file",
    action = vim.cmd,
    action_args = ":e "
  },
  {
    name = "LSP Reference (<ldr>-lr)",
    action = vim.cmd,
    action_args = ":Telescope lsp_references <CR>"
  },
  {
    name = "LSP Document symbolds (<ldr>-ls)",
    action = vim.cmd,
    action_args = ":Telescope lsp_document_symbols<CR>"
  }
}

return cpconfig
