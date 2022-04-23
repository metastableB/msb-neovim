-- Currently there is no clear way to use lua to execute autocommands. We need
-- to use vim.api.nvim_command call.

--
-- We cannot use FAST Fold because we want to maintain tree-sitter based
-- folding. Not sure if this will work TODO: Update
--  Don't screw up folds when inserting text that might affect them, until
--  leaving insert mode. Foldmethod is local to the window. Protect against
-- screwing up folding when switching between windows.
-- Solution based on : https://vim.fandom.com/wiki/Keep_folds_closed_while_inserting_text
vim.api.nvim_command([[ autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif ]])
vim.api.nvim_command([[ autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif ]])

