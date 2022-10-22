local Lsp = {}

function Lsp:config()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })

  require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "rust_analyzer", "tsserver", "gopls", "vimls" }
  })

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap = true, silent = true }
  --  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'ff', function() vim.lsp.buf.formatting { async = true } end, bufopts)

    -- Go back
    vim.api.nvim_set_keymap('n', 'gb', '<C-o>', { silent = true })
  end

  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }

  -- Cmp
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require('lspconfig')['sumneko_lua'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    format = {
      enable = true,
      -- Put format options here
      -- NOTE: the value should be STRING!!
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
    format = {
      enable = true
    }
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
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
  }

  local notify = require 'notify'
  vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({
      'ERROR',
      'WARN',
      'INFO',
      'DEBUG',
    })[result.type]
    notify({ result.message }, lvl, {
      title = 'LSP | ' .. client.name,
      timeout = 10000,
      keep = function()
        return lvl == 'ERROR' or lvl == 'WARN'
      end,
    })
  end

  require("lsp.lsputils").config()
  require("lsp.lspsaga").config()
end

return Lsp
