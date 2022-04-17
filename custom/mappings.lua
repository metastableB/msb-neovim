local map = require("core.utils").map

-- Telescope: References and lsp document keywords (functions)
-- More mappings are specified as part of custom palette
map("n", "<leader>lr", ":Telescope lsp_references <CR>")
map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
map("n", "<leader>cp", ":Telescope custompalette <CR>")
