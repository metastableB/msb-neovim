local cpconfig = {
  {"General",
    { "Command palette (<ldr>-tcp)", ":Telescope command_palette<CR>" },
    { "Reload vimrc", ":source $MYVIMRC" },
    { 'Check health', ":checkhealth" },
    { "Jump list", ":lua require('telescope.builtin').jumplist()" },
    { "All commands", ":lua require('telescope.builtin').commands()" },
    { "Command history", ":lua require('telescope.builtin').command_history()" },
    { "Registers (A-e)", ":lua require('telescope.builtin').registers()" },
    { "Colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
    { "Vim options", ":lua require('telescope.builtin').vim_options()" },
    { "Keymaps", ":lua require('telescope.builtin').keymaps()" },
    { "Buffers", ":Telescope buffers" },
    { "Search history", ":lua require('telescope.builtin').search_history()" },
    { "Paste mode", ':set paste!' },
    { 'Cursor line', ':set cursorline!' },
    { 'Cursor column', ':set cursorcolumn!' },
    { "Spell checker", ':set spell!' },
    { "Relative number", ':set relativenumber!' },
    { "Search highlighting", ':set hlsearch!' },
    { "Loc list ", ":lua require('telescope.builtin').loclist()"},
    { "Reload file", ":e"}
  },
  {"LSP",
    { "LSP Reference (<ldr>-lr)", ":Telescope lsp_references <CR>"},
    { "LSP Document symbolds (<ldr>-ls)", ":Telescope lsp_document_symbols<CR>"},
  }
}

return cpconfig
