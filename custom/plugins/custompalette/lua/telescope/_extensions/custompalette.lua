-- A custom command palette based on Telescope.
--
-- You define a potentially recursive table of Keys and actions and this script
-- will recursively explore it.
-- 
-- Reference: https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md

-- Obtain the pickers/finders/themes/actions etc that ship with telescope. We
-- will use this to build our palette.

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
    error("This plugins requires telescope.nvim")
end
local pickers = require "telescope.pickers"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local themes = require "telescope.themes"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local entry_display = require("telescope.pickers.entry_display")
-- Turn this on the respect the user specified telescope option
local respect_user_opts = false
local palette_opts = themes.get_dropdown{}

-- The master table for the palette
local palette_table = {} 
local function setup(ptable, useropts_on)
  -- Extend our opts with custom theme
  palette_opts = themes.vscode(palette_opts)
  palette_table = ptable
  if useropts_on == true then
    respect_user_opts = true
  end
  if useropts_on == false then
    respect_user_opts = false
  end
end

-- Lets define some custom themes
function themes.vscode(opts)
  opts = opts or {}
  local theme_opts = {
    theme = "dropdown",
    results_title = false,
    sorting_strategy = "descending",
    layout_strategy = "vertical",
    layout_config = {
      -- anchor = "N",
      -- prompt_position = "top",
      width = function(_, max_columns, _)
        return math.min(max_columns, 120)
      end,
      height = function(_, _, max_lines)
        return math.min(max_lines, 15)
      end,
    },
  }
  if opts.layout_config and opts.layout_config.prompt_position == "bottom" then
    theme_opts.borderchars = {
      prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      results = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    }
  end
  return vim.tbl_deep_extend("force", opts, theme_opts)
end

-- Couple of test cases
local test1 = { 
  {
    name = 'echo 24',
    action = function () 
      print("Deeper action")
    end,
    action_args = {},
  },
}
local test0 = { 
    {
      name = 'echo 42',
      action = function () 
        print("HELLO WORLD. This is an action");
      end,
      action_args = {},
    },
    {
      name="Test 1",
    },
    {
      name="Test 2 Sub-table",
      subtable = s,
    }  
  }

function entry_maker_fn(entry)
  -- This function is called to display palette entries
  local cols = vim.o.columns
  local width = conf.width or conf.layout_config.width
  width = width or conf.layout_config[conf.layout_strategy].width or cols
  local tel_win_width
  -- width = 80 -> column width, width = 0.7 -> ratio
  if width > 1 then
    tel_win_width = width
  else
    tel_win_width = math.floor(cols * width)
  end
  local desc_width = math.floor(cols * 0.05)
  local command_width = 28

  -- NOTE: the width calculating logic is not exact, but approx enough
  local displayer = entry_display.create({
    separator = " ▏",
    items = {
      { width = command_width },
      { width = tel_win_width - desc_width - command_width },
      { remaining = true },
    },
  })

  local function make_display()
    return displayer({
      { entry.name },
      { entry.helpstr or ""},
    })
  end

  return {
    value = entry,
    display = make_display,
    -- I think this is the attribute fuzzy search is going to happen
    ordinal = string.format("%s", entry.name)
  }
end

-- An action function that will run the selected command
local function run_selection(prompt_bufnr, map)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    -- Check if the table has an action and if yes, execute it.
    action = selection.value.action
    subtable = selection.value.subtable
    action_args = selection.value.action_args
    if selection.value.action ~= nil then
      local args = selection.value.action_args
      selection.value.action(args)
    end
    -- Check if the table has a sub-table. If yes recursively call self
    if selection.value.subtable ~= nil then
      custompalette_fn(palette_opts, subtable)
    end
  end)
  return true
end

-- our picker function: colors
function custompalette_fn(opts, M)
  if respect_user_opts ~= true then
    opts = palette_opts
  end
  M = M or palette_table
  pickers.new(opts, {
    prompt_title = "Custom Palette",
    finder = finders.new_table {
      results = M,
      entry_maker = entry_maker_fn,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = run_selection,
  }):find()
end

return telescope.register_extension({
  exports = {
    custompalette = custompalette_fn,
    setup = setup
  },
})
