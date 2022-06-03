-- Utility/Helper Lua functions
local M = {}
M.user_mappings = {}
M.buffer_mappings = {}

-- A wrapper over vim.api.nvim_set_keymap.
function addusermap(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    -- We don't apply maps here
    -- vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    table.insert(M.user_mappings, {mode, lhs, rhs, options})
end

-- Add user buffer maps (bmap)
-- A wrapper over vim.api.nvim_set_keymap.
function adduserbmap(bufnr, mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    -- We don't apply maps here
    -- vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    table.insert(M.buffer_mappings, {bufnr, mode, lhs, rhs, options})
end


function applymaps()
	for k, v in pairs(M.user_mappings) do
		local mode, lhs, rhs, options = v[1], v[2], v[3], v[4]
    		vim.api.nvim_set_keymap(mode, lhs, rhs, options)
	end
	for k, v in pairs(M.buffer_mappings) do
		local bufnr, mode, lhs, rhs, options = v[1], v[2], v[3], v[4], v[5]
    		vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
    end
end

function cycle_theme()
	local base16 = require'base16'
	if M.themes == nil then 
		local theme_names = base16.theme_names()
		M.themes = {}
		M.themes.theme_names = theme_names
		M.themes.b16_position = 1
	end
	M.themes.b16_position = (M.themes.b16_position % #M.themes.theme_names) + 1
	local name = M.themes.theme_names[M.themes.b16_position]
	base16(base16.themes[name], true)
	print("Theme: " .. name)
end

M.addusermap = addusermap
M.applymaps = applymaps
M.cycle_theme = cycle_theme
return M
