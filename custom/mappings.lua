local map = require("core.utils").map
local dap = require("custom.plugins.common").dap_palette

-- Telescope: References and lsp document keywords (functions)
-- More mappings are specified as part of custom palette
map("n", "<leader>lr", ":Telescope lsp_references <CR>")
map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
map("n", "<leader>cp", ":Telescope custompalette <CR>")
local opts = { noremap = true, silent = true }
map("n", "<leader>nf", ":lua require('neogen').generate()<CR>", opts)

-- DAP (Debugger)
--map("n", "<leader>dp", ":lua require('custom.plugins.common').dap_palette()<CR>")
--map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
--map("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
--map("n", "<leader>dso", "lua require'dap'.step_over()<CR>")
--map("n", "<leader>dsi", "lua require'dap'.step_into()<CR>")
