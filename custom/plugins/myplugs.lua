-- Simple helper functions/plugins written based on packer handled
-- dependencies. We need this to be a plugin because we want it to only load
-- after packer has been ensure-instaleed.
local M = {}
local initialized = false
-- Library variables. Keep them nil to know where they are called from in case
-- of an error -- called before setup ()
local tscope -- Telescope modules
local float  -- float plugin
-- Plugins 
local todofloat = {}
local dappalette = {}

-- Generic init which will be called at boot
M.setup = function()
  tscope = {}
  float = {}
  tscope.extensions = require "telescope".extensions
  tscope.pickers = require "telescope.pickers"
  tscope.finders = require "telescope.finders"
  tscope.conf = require("telescope.config").values
  tscope.actions = require("telescope.actions")
  tscope.actions_state = require("telescope.actions.state")
  tscope.themes = require("telescope.themes")
  float = require "custom.plugins.float"
  initialized = true
end

--------------
-- TODO Float
-- 
-- Finds a TODO file in the working directory if already not opened. TODO files
-- are any file in the working directory or the sub-directory that has a TODO
-- in the file name (anywhere). TODO: Fix this
--
-- A picker will be offer on ambiguous choices
-- ----------
--
--
todofloat.optionpicker = function(M)
  local get_path = function(prompt_bufnr, map)
    tscope.actions.select_default:replace(function()
      tscope.actions.close(prompt_bufnr)
      local selection = tscope.actions_state.get_selected_entry()[1]
      todofloat.todofile = selection
      todofloat.__toggle()
    end)
    return true
  end
  opts = todofloat.uiconfig(opts)
  tscope.pickers.new(opts, {
    prompt_title = "Choices",
    finder = tscope.finders.new_table({
      results = M,
    }),
    sorter = tscope.conf.generic_sorter(opts),
    attach_mappings = get_path,
  }):find()
end

todofloat.set_todofile = function(filename)
  todofloat.todofile = filename
end

todofloat.find_todofile = function(dirname)
  -- search directories or ask user. Check if the file exits.
  local command = string.format("find %s| grep TODO", dirname)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

todofloat.__toggle = function()
  -- This function assumes the todofile is set.
  float.toggle(todofloat.todofile)
  
end

todofloat.uiconfig = function(opts)
  opts = opts or {}
  local theme_opts = {
  --   theme = "dropdown",
    results_title = false,
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      -- anchor = "N",
      prompt_position = "top",
      width = wfunction,
      height = function(a, b, max_lines)
        return math.min(max_lines, 10)
      end,
      width = function(_, max_columns, _)
        return math.min(max_columns, 80)
      end
    },
  }
  return vim.tbl_deep_extend('force', opts, theme_opts)
end


todofloat.toggle = function()
  if todofloat.todofile ~= nil then
    return todofloat.__toggle()
  end
  -- We need go the option picker route
  local cwd
  local allc = {}
  local cstr = todofloat.find_todofile(vim.fn.getcwd())
  for c in cstr:gmatch("[^\r\n]+") do
    table.insert(allc, c)
  end
  if allc[1] == nil then
    print("No TODO file found")
    return
  end
  -- if len (candidates > 0) ask user
  candidate = allc[1]
  if allc[2] ~= nil then
    -- use the option picker to open a file
    todofloat.optionpicker(allc)
  else 
    todofloat.set_todofile(candidate)
    todofloat.__toggle()
  end
end

--------------
-- DAP PALETTE
-- -----------
dappalette.dappalette = function()
  local cpconfig = require "custom.cpconfig"
  -- Some common list of functions
  tscope.extensions.custompalette.custompalette(nil, cpconfig.daptable)
end

M.setup()
M.todofloat = todofloat
-- Get all the requires ready
return M
