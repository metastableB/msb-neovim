local M = {}

-- overriding default plugin configs!
M.treesitter = {
   ensure_installed = {
      "lua",
      "vim",
      "html",
      "css",
      "javascript",
      "json",
      "markdown",
      "bash",
      "python",
      "org"
   },
   -- These are for nvim-orgmode plugin
   highlight = {
     enable = true,
     disable = {'org'},
     additional_vim_regex_highlighting = {'org'}
   }
}

M.nvimtree = {
   git = {
      enable = false,
   },
   view = {
     hide_root_folder = false,
     preserve_window_proportions = true,
     side = 'left',
   },
   lazy_load = true,
}

return M
