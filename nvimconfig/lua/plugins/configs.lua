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
      "org",
      "latex",
   },
   -- These are for nvim-orgmode plugin
   highlight = {
     enable = true,
     disable = {'org'},
     additional_vim_regex_highlighting = {'org'}
   }
}

M.nvimtree = function ()
  require'nvim-tree'.setup {
     view = {
       hide_root_folder = false,
       preserve_window_proportions = true,
       side = 'left',
     },
      update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = {},
     }
    git = {
        enable = true,
        ignore = true,
     },
  }
end

return M
