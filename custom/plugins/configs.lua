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
      "python"
   },
}

M.nvimtree = {
   git = {
      enable = false,
   },
   view = {
     hide_root_folder = false,
     preserve_window_proportions = true,
     side = 'right',
   },
   lazy_load = true,
}

return M
