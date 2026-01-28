require('editor').config()
require('keymap').config()
require('plugins').config()
-- LSP configuration is now loaded within lazy.nvim plugin specs

-- Load Rust-specific configurations
require('rust_config').setup()

