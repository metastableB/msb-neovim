-- local utils = require("utils")
local M = {}

-- Nvim-tree:
-- Remember this needs to be specified as a callable and not a table.
-- These functions are run after the plugin is installed.
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
     },
    git = {
        enable = true,
        ignore = true,
     },
  }
end


-- Telescope: We add mappings here
-- These functions are run after the plugin is installed.
-- This require ensures telescope is loaded before we apply mappings
M.telescope = function()
	require('telescope')
	local map = require("utils").addusermap
	map("n", "ff", ":lua require('telescope.builtin').find_files()<cr>")
	map("n", "fg", ":lua require('telescope.builtin').live_grep()<cr>")
	map("n", "fb", ":lua require('telescope.builtin').buffers()<cr>")
	map("n", "fh", ":lua require('telescope.builtin').help_tags()<cr>")
	local apply = require("utils").applymaps
	apply()
end


-- Bufferline
M.bufferline = function()
	vim.opt.termguicolors = true
	require("bufferline").setup{
	}
end


-- overriding default plugin configs!
M.treesitter = function()
	require'nvim-treesitter.configs'.setup {
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
end

return M
