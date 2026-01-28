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
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    },
    { "williamboman/mason-lspconfig.nvim" },
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
      config = function()
        vim.notify = require("notify")
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
      version = "v2.*",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VeryLazy",
      config = function()
        require("bufferline").setup({})
      end,
    },
  })
end

return M
