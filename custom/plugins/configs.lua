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
      enable = true,
      ignore = true,
   },
   view = {
     hide_root_folder = false,
     preserve_window_proportions = true,
     side = 'left',
   },
   lazy_load = true,
   update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
   }
}

local cp = require "custom.plugins.commandpalette"
M.telescope = {
  -- These key is added to the table if it does not exist. If the key exists,
  -- these values are used to override them.
  extensions = {
    command_palette = cp,
  },
}
return M
