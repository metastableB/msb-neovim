-- A floating window to open specific files.
-- The idea is to make it work as a quick way to look at TODO etc. 
-- Also can be used to display cheat sheet.
--
local floatw = {}
-- Global buffer (creates a buffers and returnts its number)
-- listed, scratch
bufnr_g = vim.api.nvim_create_buf(false, true)


function file_exists(name)
   local f=io.open(name, "r")
   if f~=nil then io.close(f) return true else return false end
end


function round(float)
  return math.floor(float + .5)
end


function window_config(width, height)
    local border = vim.g.workbench_border or "double"
    return {
      relative = "editor",
      width = width,
      height = height,
      col = (ui.width - width) / 2,
      row = (ui.height - height) / 2,
      style = 'minimal',
      focusable = false,
      border = border
    }
end


floatw.toggle = function(filepath)
  if not file_exists(filepath) then
    vim.api.nvim_err_writeln("File not found " .. filepath)
    return
  end
    
  ui = vim.api.nvim_list_uis()[1]
  local width = round(ui.width * 0.5)
  local height = round(ui.height * 0.5)
  -- Check if the file is already opened in a buffer
  local buf_info = vim.api.nvim_call_function('getbufinfo', {filepath})[1]
  local _bufnr = bufnr_g
  if buf_info then
    _bufnr = buf_info.bufnr
    print("Found existing buffer at", _bufnr)
  end
  -- open the window
  local win_id = vim.api.nvim_open_win(_bufnr, true, window_config(width, height))
  vim.api.nvim_set_current_win(win_id)
  -- If new buffer, set it to edit
  if not buf_info then
    vim.api.nvim_command("e " .. filepath)
  end
end

return floatw
