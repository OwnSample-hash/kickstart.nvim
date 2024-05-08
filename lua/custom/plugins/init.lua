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
    'tanvirtin/vgit.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('vgit').setup()
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>",       desc = "[M]arkdown[P]review" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>",   desc = "[M]arkdownPreview[S]top" },
      { "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", desc = "[M]arkdownPreview[T]oggle" },

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
    "norcalli/nvim-colorizer.lua",
    config = function()
      require 'colorizer'.setup()
    end

  },
  {
    "fedepujol/move.nvim",
    -- lazy = false,
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
  },
  {
    "p00f/godbolt.nvim",
    config = function()
      require('godbolt').setup({})
    end
  },
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    config = function()
      require 'window-picker'.setup()
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  "LunarVim/bigfile.nvim",
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    lazy = false,
    keys = {
      { "<Leader>gc", "<cmd>Neogen<cr>", desc = "Gen annot" }
    }

    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
  },
  {
    'Bekaboo/dropbar.nvim',
    enabled = false,
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim'
    },
    opts = { icons = { kinds = { use_devicons = false } } }
  },
  {
    "edKotinsky/Arduino.nvim",
  }
}
