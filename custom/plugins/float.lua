-- A floating window to open specific files. Creates a new buffer if the file
-- isn't already in a buffer. The idea is to make it work as a quick way to
-- look at TODO etc. Also can be used to display cheat sheet.
--
local floatw = {}

floatw.file_exists = function(name)
   local f=io.open(name, "r")
   if f~=nil then io.close(f) return true else return false end
end


floatw.round = function(float)
  return math.floor(float + .5)
end


floatw.window_config = function(ui, width, height)
    local border = vim.g.workbench_border or "rounded"
    return {
      relative = "editor",
      width = width,
      height = height,
      col = (ui.width - width) / 2,
      row = (ui.height - height) / 2,
      style = 'minimal',
      focusable = true,
      border = border
    }
end


floatw.toggle = function(filepath)
  if not floatw.file_exists(filepath) then
    vim.api.nvim_err_writeln("File not found " .. filepath)
    return
  end
    
  local ui = vim.api.nvim_list_uis()[1]
  local width = floatw.round(ui.width * 0.5)
  local height = floatw.round(ui.height * 0.5)
  -- Check if the file is already opened in a buffer
  local buf_info = vim.api.nvim_call_function('getbufinfo', {filepath})[1]
  local _bufnr
  local new_buf = false
  if buf_info then
    _bufnr = buf_info.bufnr
    print("Found existing buffer at: ", _bufnr)
  else
    -- Create a new empty buffer
    new_buf = true
    _bufnr = vim.api.nvim_create_buf({false}, {false})
    vim.api.nvim_call_function('setbufvar', {_bufnr, 'buflisted', '0'})
    buf_info = vim.api.nvim_call_function('getbufinfo', {_bufnr})[1]
  end
  --   -- open the window
  local wc = floatw.window_config(ui, width, height)
  local win_id = vim.api.nvim_open_win(_bufnr, true, wc)
  vim.api.nvim_set_current_win(win_id)
  if new_buf then
    -- If new buffer, set it to edit. This will open the file for editing in
    -- that window. 
    vim.api.nvim_command("e " .. filepath)
  end
end

return floatw
