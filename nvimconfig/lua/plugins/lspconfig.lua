local utils = require"utils"
local addusermap = require"utils".addusermap

local M = {}


M.keybinds_init = function()
    -- Common set of keybinds that we enable as long as plugin is initialized
    local opts = { noremap=true, silent=true }
    addusermap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    addusermap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    addusermap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    addusermap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    utils.applymaps()
end

M.keybinds_onattach = function(client, bufnr)
    -- Buffer specific keybinds that we only add if an LSP attaches to the
    -- buffer. Tough this might prevent us from knowing if the keybind has
    -- applied properly. These are from the original repo. We only copy those
    -- that we will use.
    --
    --   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  adduserbmap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  adduserbmap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  adduserbmap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  adduserbmap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  adduserbmap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- addusermap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- addusermap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- addusermap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  adduserbmap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  adduserbmap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  adduserbmap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  adduserbmap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  adduserbmap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  utils.applymaps()
end


M.setup_lsp = function()
   local lspconfig = require "lspconfig"
   -- Add the initial set of keys
   M.keybinds_init()
   --  lspservers with default config 
   --  We need to specifically enable the servers to make them work.
   --
   --  pylsp: pip install python-lsp-server not python-language-server
   --  Switching back to pyright as the reason it wasn't working previously was
   --  the lack of a config file in the root directory.
   local servers = { "html", "cssls", "clangd", "pylsp"} -- pyright"}
   -- Setup the main language servers
   for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
         on_attach = M.keybinds_onattach,
      }
   end
   -- Change Gutter (line-number) diagnostics signs
   local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

-- Display errors in float
-- Note these are not lspconfig plugin settings but general neovim settings.
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

-- Disable virtual text
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = false,
})

-- Update: We've moved to trouble but still like these previews
-- Disable Virtual Text for LSP and show in message area instead
-- FROM : https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
--
-- function PrintDiagnostics(opts, bufnr, line_nr, client_id)
--   bufnr = bufnr or 0
--   line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
--   opts = opts or {['lnum'] = line_nr}
--
--   local line_diagnostics = vim.diagnostic.get(bufnr, opts)
--   if vim.tbl_isempty(line_diagnostics) then return end
--
--   local diagnostic_message = ""
--   for i, diagnostic in ipairs(line_diagnostics) do
--     diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
--     print(diagnostic_message)
--     if i ~= #line_diagnostics then
--       diagnostic_message = diagnostic_message .. "\n"
--     end
--   end
--   vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
-- end
--
-- vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]


return M
