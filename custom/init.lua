-- -- This is an example init file , its supposed to be placed in /lua/custom dir
-- lua/custom/init.lua

-- This is where your custom modules and plugins go.
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!

local customPlugins = require "core.customPlugins"

customPlugins.add(function(use)
  use 'Vimjas/vim-python-pep8-indent'
  use 'famiu/bufdelete.nvim'
end)

