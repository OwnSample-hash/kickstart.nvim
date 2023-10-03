require "custom.plugins.snipets"
vim.wo.rnu = true
vim.wo.number = true
vim.o.hlsearch = true
vim.o.termguicolors = true
vim.o.colorcolumn = "80"

vim.cmd("map <C-s> <cmd>:w<cr>")
vim.cmd("map <C-y> <cmd>:undo<cr>")
vim.cmd("map <C-z> <cmd>:redo<cr>")
vim.cmd("tnoremap <Esc> <C-\\><C-n>")
vim.cmd("map <F2> :lua vim.lsp.buf.rename()<cr>")
vim.keymap.set('n', '<leader>Q', function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
end, { desc = 'Toggle Floating Diagnostics' })

function Set_tab(tabwidth)
    -- vim.cmd("set tabstop=" .. tonumber(tabwidth) .. " shiftwidth=" .. tonumber(tabwidth) .. " expandtab")
    vim.o.tabstop = tonumber(tabwidth)
    vim.o.shiftwidth = tonumber(tabwidth)
    vim.o.expandtab = true
    vim.cmd("echo \"Tab width set to " .. tabwidth .. "\"")
end

vim.cmd("command! -nargs=1 Tab lua Set_tab(<q-args>)")
vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<cmd>ClangdSetInlayHints<cr>", true, false, true),
    "m",
    true)
-- if vim.is_callable("ClangdSetInlayHints") then
--     vim.cmd("ClangdSetInlayHints")
-- else
--     vim.cmd("echo \"No\"")
-- end
return {}
