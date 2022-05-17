-- Utility/Helper Lua functions
local M = {}
M.user_mappings = {}

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

function applymaps()
	for k, v in pairs(M.user_mappings) do
		local mode, lhs, rhs, options = v[1], v[2], v[3], v[4]
    		vim.api.nvim_set_keymap(mode, lhs, rhs, options)
	end
end


M.addusermap = addusermap
M.applymaps = applymaps
return M
