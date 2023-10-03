-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--[[ require("custom.plugins.config") ]]

_G.clang_inlay_hints_on = false
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        lazy = true,
        keys = {
            { "<leader>f", "<cmd>Neotree focus<cr>", desc = "NeoTree float" },
            { "<leader>F", "<cmd>Neotree close<cr>", desc = "NeoTree close" },
        },
        config = function()
            require("neo-tree").setup()
        end,
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {},
        keys = {
            { "<Tab>",   "<cmd>bnext<cr>",     desc = "Next tab" },
            { "<S-Tab>", "<cmd>bprevious<cr>", desc = "Prev tab" },
        }
    },
    {
        "p00f/clangd_extensions.nvim",
        lazy = false,
        config = function(_)
            local lspc = require("lspconfig").clangd
            lspc.setup({
                on_attach = function()
                    require("clangd_extensions.inlay_hints").setup_autocmd()
                    require("clangd_extensions.inlay_hints").set_inlay_hints()
                end
            })
        end,
        keys = {
            {
                "<leader>it",
                function()
                    if not _G.clang_inlay_hints_on then
                        vim.cmd("ClangdSetInlayHints")
                        _G.clang_inlay_hints_on = true
                    else
                        vim.cmd("ClangdDisableInlayHints")
                        _G.clang_inlay_hints_on = false
                    end
                end,
                desc = "Toggeles Inlay hints"
            },
            { "<leader>as", "<cmd>ClangdAST<cr>",        desc = "Clangd AST" },
            { "<leader>b",  "<cmd>ClangdSymbolInfo<cr>", desc = "Clang Symbol Info" }
        },
    },
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    {
        "fedepujol/move.nvim",
        lazy = false,
        config = function()
            --           require('move').setup()
            local opts = { noremap = true, silent = true }
            -- Normal-mode commands
            vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
            vim.keymap.set('n', '<A-Down>', ':MoveLine(1)<CR>', opts)
            vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
            vim.keymap.set('n', '<A-Up>', ':MoveLine(-1)<CR>', opts)
            vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
            vim.keymap.set('n', '<A-Left>', ':MoveHChar(-1)<CR>', opts)
            vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
            vim.keymap.set('n', '<A-Right>', ':MoveHChar(1)<CR>', opts)
            vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
            vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)

            -- Visual-mode commands
            vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
            vim.keymap.set('v', '<A-Down>', ':MoveBlock(1)<CR>', opts)
            vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
            vim.keymap.set('v', '<A-Up>', ':MoveBlock(-1)<CR>', opts)
            vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
            vim.keymap.set('v', '<A-Left>', ':MoveHBlock(-1)<CR>', opts)
            vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)
            vim.keymap.set('v', '<A-Right>', ':MoveHBlock(1)<CR>', opts)
        end
    }
}
