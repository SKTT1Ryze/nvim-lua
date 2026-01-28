-- lazy.nvim plugin manager configuration
local M = {}

function M:config()
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  -- Plugin specifications
  require("lazy").setup({
    -- Comment utility
    { "tomtom/tcomment_vim" },

    -- File manager
    {
      "kyazdani42/nvim-tree.lua",
      dependencies = { "kyazdani42/nvim-web-devicons" },
      keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
        { "<leader>t", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
      },
      config = function()
        require("nvim-tree").setup()
      end,
    },

    -- Search tools
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.5",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = "Telescope",
      keys = {
        { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
        { "<leader>r", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      },
      config = function()
        require("plugins.search").config()
      end,
    },
    {
      "Yggdroot/LeaderF",
      build = ":LeaderfInstallCExtension",
      lazy = true,
    },
    {
      "junegunn/fzf",
      build = function()
        vim.fn["fzf#install"]()
      end,
    },
    { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },

    -- Git tools
    {
      "airblade/vim-gitgutter",
      event = { "BufReadPre", "BufNewFile" },
    },
    {
      "tpope/vim-fugitive",
      cmd = { "Git", "G", "Gdiff", "Gwrite", "Gread" },
      keys = {
        { "<leader>gb", ":Git blame<cr>", desc = "Git blame" },
        { "<leader>gl", ":Git log<cr>", desc = "Git log" },
      },
      config = function()
        require("plugins.fugitive").config()
      end,
    },
    {
      "sindrets/diffview.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    },

    -- Themes
    { "itchyny/lightline.vim" },
    { "yuttie/inkstained-vim", lazy = true },
    { "sainnhe/everforest", lazy = true },
    { "sainnhe/edge", lazy = true },
    { "arcticicestudio/nord-vim", lazy = true },
    { "morhetz/gruvbox", lazy = true },
    { "kyoz/purify", lazy = true },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = true,
      config = function()
        require("plugins.catppuccin_").config()
      end,
    },
    { "oxfist/night-owl.nvim", lazy = true },
    {
      "Tsuzat/NeoSolarized.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("plugins.colorscheme").config()
      end,
    },

    -- LSP & Completion
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      lazy = false,
      priority = 90,  -- Load after notify (200) but before mason-lspconfig
      config = function()
        require("mason").setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          }
        })
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = false,
      priority = 80,  -- Load after mason
      dependencies = { "williamboman/mason.nvim" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "rust_analyzer", "tsserver", "gopls", "vimls", "clangd", "cssls" },
          automatic_installation = false,  -- Disable automatic setup, we configure manually
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
        -- Load LSP configuration
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

        local on_attach = function(client, bufnr)
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', 'ff', function() vim.lsp.buf.format { async = true } end, bufopts)
          vim.api.nvim_set_keymap('n', 'gb', '<C-o>', { silent = true })
        end

        local lsp_flags = { debounce_text_changes = 150 }
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Setup language servers
        require('lspconfig')['lua_ls'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            }
          },
        }
        require('lspconfig')['tsserver'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
        }
        require('lspconfig')['gopls'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities
        }
        require('lspconfig')['rust_analyzer'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities,
          settings = { ["rust-analyzer"] = {} }
        }
        require('lspconfig')['clangd'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities
        }
        require('lspconfig')['cssls'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = capabilities
        }

        -- Diagnostic signs
        local signs = {
          { name = "DiagnosticSignError", text = "❌" },
          { name = "DiagnosticSignWarn", text = "⚠️" },
          { name = "DiagnosticSignHint", text = "💡" },
          { name = "DiagnosticSignInfo", text = "🆕" },
        }
        for _, sign in ipairs(signs) do
          vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
        end

        -- Diagnostic handler
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = { prefix = "", spacing = 0 },
          signs = true,
          underline = true,
        })

        -- Notify handler
        vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
          local ok, notify = pcall(require, 'notify')
          if ok then
            notify(result.message, lvl, {
              title = 'LSP | ' .. client.name,
              timeout = 10000,
              keep = function() return false end,
            })
          else
            vim.notify(
              string.format('[LSP | %s] %s', client.name, result.message),
              vim.log.levels[lvl]
            )
          end
        end

        -- Load additional LSP utilities
        require("lsp.lsputils").config()
        require("lsp.lspsaga").config()
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        "onsails/lspkind.nvim",
      },
      config = function()
        require("plugins.cmp").config()
      end,
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/vim-vsnip" },
    {
      "j-hui/fidget.nvim",
      event = "LspAttach",
      opts = {},
    },
    { "onsails/lspkind.nvim" },
    {
      "glepnir/lspsaga.nvim",
      branch = "main",
      event = "LspAttach",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    { "RishabhRD/popfix" },
    { "RishabhRD/nvim-lsputils" },

    -- Terminal
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      keys = {
        { "<leader>j", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      },
      config = function()
        require("plugins.toggle_term").config()
      end,
    },

    -- Syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("plugins.treesitter").config()
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("plugins.treesitter_context").config()
      end,
    },

    -- UI components
    { "MunifTanjim/nui.nvim" },
    {
      "rcarriga/nvim-notify",
      lazy = false,
      priority = 200,
      config = function()
        local notify = require("notify")
        notify.setup({
          stages = "fade_in_slide_out",
          timeout = 3000,
          max_width = 50,
          max_height = 10,
          background_colour = "#000000",
          render = "compact",
          minimum_width = 30,
        })
        vim.notify = notify
      end,
    },
    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      cmd = { "Trouble", "TroubleToggle" },
      config = function()
        require("plugins.trouble_").config()
      end,
    },
    {
      "VonHeikemen/fine-cmdline.nvim",
      dependencies = { "MunifTanjim/nui.nvim" },
      keys = {
        { ":", "<cmd>FineCmdline<cr>", desc = "Fine cmdline" },
      },
      config = function()
        require("plugins.fine_cmdline").config()
      end,
    },
    {
      "akinsho/bufferline.nvim",
      version = "v4.*",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VeryLazy",
      config = function()
        require("bufferline").setup({
          options = {
            mode = "buffers",
            numbers = "none",
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            middle_mouse_command = nil,
            indicator = {
              style = 'icon',
              icon = '▎',
            },
            buffer_close_icon = '󰅖',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
              local icon = level:match("error") and " " or " "
              return " " .. icon .. count
            end,
            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true,
              }
            },
            color_icons = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            separator_style = "thin",
            always_show_bufferline = true,
          }
        })
      end,
    },
  })
end

return M
