local map = require("core.utils").map

-- Telescope: References and lsp document keywords (functions)
map("n", "<leader>lr", ":Telescope lsp_references <CR>")
map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
map("n", "<leader>tcp", ":Telescope command_pallete<CR>")
