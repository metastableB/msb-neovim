local M = {}
M.setup_lsp = function(attach, capabilities)
   local lspconfig = require "lspconfig"
   -- lspservers with default config 
   local servers = { "html", "cssls", "clangd", "pyright"}
   for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
         on_attach = attach,
         capabilities = capabilities,
         flags = {
            debounce_text_changes = 150,
         },
      }
   end
end

-- Disable Virtual Text for LSP and show in message area instead
-- FROM : https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or {['lnum'] = line_nr}

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end

vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

-- Disable virtual text
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

return M
