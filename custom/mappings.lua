local map = require("core.utils").map
--local dap = require("custom.plugins.common").dap_palette

-- Telescope: References and lsp document keywords (functions)
-- More mappings are specified as part of custom palette
map("n", "<leader>lr", ":lua require('telescope.builtin').lsp_references() <CR>")
map("n", "<leader>ls", ":lua require('telescope.builtin').lsp_document_symbols()<CR>")

-- Lets use the modifier 'c' for everything telescope related for now
map("n", "cp", ":Telescope custompalette <CR>")
map("n",  "td", ":lua require('custom.plugins.myplugs').todofloat.toggle()<CR>")
local opts = {noremap = true, silent = true}
map("n", "<leader>nf", ":lua require('neogen').generate()<CR>", opts)

-- DAP (Debugger)
--map("n", "<leader>dp", ":lua require('custom.plugins.common').dap_palette()<CR>")
--map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
--map("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
--map("n", "<leader>dso", "lua require'dap'.step_over()<CR>")
--map("n", "<leader>dsi", "lua require'dap'.step_into()<CR>")
