local textensions = require "telescope".extensions
local cpconfig = require "custom.cpconfig"
-- Some common list of functions
local M = {}

M.dap_palette = function()
  textensions.custompalette.custompalette(nil, cpconfig.daptable)
end

return M
