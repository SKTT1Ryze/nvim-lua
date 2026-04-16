# Neovim Configuration

Personal Neovim config centered on Rust development, with support for Go, TypeScript, C++, Lua, Dart, and CSS. Uses lazy.nvim for plugin management with a modular Lua structure.

## Directory Structure

```
.
├── init.lua                  # Entry point: loads editor / keymap / plugins
├── lazy-lock.json            # Plugin lockfile
└── lua/
    ├── editor.lua            # Vim options (indent, search, folding)
    ├── keymap.lua            # Global keybindings
    ├── rust_config.lua       # Rust-specific LSP tuning + cargo commands
    ├── plugins/
    │   ├── init.lua          # lazy.nvim bootstrap + all plugin specs
    │   ├── cmp.lua           # Completion engine
    │   ├── treesitter.lua    # Syntax highlighting
    │   ├── treesitter_context.lua # Sticky Treesitter context
    │   ├── colorscheme.lua   # Color scheme (default: NeoSolarized)
    │   ├── catppuccin_.lua   # Catppuccin custom highlight overrides
    │   ├── search.lua        # Telescope / LeaderF / FZF
    │   ├── fine_cmdline.lua  # Command-line UI
    │   ├── toggle_term.lua   # Integrated terminal
    │   ├── trouble_.lua      # Diagnostics list
    │   ├── fugitive.lua      # Git integration
    │   └── tcomment_vim.lua  # Comment toggling
    └── lsp/
        └── lspsaga.lua       # Lspsaga keybindings
```

## Editor Conventions

| Setting | Value |
|---------|-------|
| Indentation | 2 spaces (tabstop / shiftwidth / softtabstop) |
| Line wrap | Off |
| Search | Case-insensitive + smartcase |
| Folding | Marker-based (`{{{` / `}}}`) |
| Leader key | `<Space>` |
| Timeout | Disabled |

## Plugin Management

All plugins are declared in `lua/plugins/init.lua` using lazy.nvim specs.

- Performance-critical plugins (`mason`, `nvim-notify`, default colorscheme) use `lazy = false` with explicit priority
- Other plugins lazy-load on `BufReadPre`, `LspAttach`, or `InsertEnter`
- When modifying a plugin: edit its config file in `lua/plugins/<name>.lua`, then update the spec in `init.lua` if needed

To add a new plugin:
1. Create `lua/plugins/myplugin.lua`
2. Add a spec entry in `lua/plugins/init.lua` with `config = function() require('plugins.myplugin') end`
3. Run `:Lazy sync`

## LSP Setup

All LSP servers share a common `on_attach` callback defined in `lua/plugins/init.lua`.

**Configured servers:**

| Language | Server |
|----------|--------|
| Rust | rust_analyzer (heavily tuned) |
| Go | gopls |
| TypeScript/JS | ts_ls |
| C/C++ | clangd |
| Lua | lua_ls |
| CSS | cssls |
| Dart | dartls |
| Vim script | vimls |

**Rust-specific tuning (`lua/rust_config.lua`):**
- Cache priming capped at 2 threads to prevent CPU overload on startup
- `cargo clippy --no-deps` runs on save
- Ignored proc macros: `async-trait`, `napi-derive`, `async-recursion`
- Excluded dirs: `.direnv`, `node_modules`, `.git`
- Inlay hints: chaining + parameter names enabled; type hints disabled

To add a new LSP server:
1. Add the server name to `ensure_installed` in `lua/plugins/init.lua`
2. Call `lspconfig.<server>.setup({ on_attach = on_attach, ... })` in the setup function
3. Put language-specific config in a dedicated file (see `lua/rust_config.lua` as reference)

## Key Bindings Reference

### Navigation & Files

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file tree |
| `<leader>t` | Reveal current file in tree |
| `<leader>f` | Telescope: find files |
| `<leader>r` | Telescope: live grep |
| `<leader>b` | Telescope: buffers |
| `<leader>F` | LeaderF: ripgrep search |
| `<leader>j` | Toggle terminal |
| `<C-j>` / `<C-k>` | Move 10 lines down / up |

### LSP

| Key | Action |
|-----|--------|
| `gh` | Lspsaga finder |
| `gd` | Peek definition |
| `gD` | Jump to declaration |
| `gi` | Go to implementation |
| `gr` | References |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<space>rn` | Rename symbol |
| `ff` | Format buffer |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>cd` | Show cursor diagnostics |
| `<leader>cD` | Show line diagnostics |

### Git

| Key | Action |
|-----|--------|
| `<leader>gb` | Git blame |
| `<leader>gl` | Git log |
| `<leader>gd` | Diff split |

### Comments

| Key | Action |
|-----|--------|
| `<leader>cn` | Comment selection |
| `<leader>cu` | Uncomment selection |
| `gc` | Toggle line comment |

### Rust (FileType autocmd)

| Key | Action |
|-----|--------|
| `<leader>rr` | `cargo run` |
| `<leader>rt` | `cargo test` |
| `<leader>rb` | `cargo build` |
| `<leader>rc` | `cargo check` |

## Color Scheme

- **Default:** `NeoSolarized` — set in `lua/plugins/colorscheme.lua`
- **Alternatives available:** catppuccin mocha, gruvbox, nord, edge, everforest, night-owl, purify
- To switch: change the `vim.cmd.colorscheme(...)` call in `colorscheme.lua`
- Catppuccin has extensive custom highlight overrides in `lua/plugins/catppuccin_.lua`

## Diagnostics Display

- Signs: `❌` error, `⚠️` warn, `💡` hint, `🆕` info
- Virtual text shown inline with a prefix
- Lspsaga used for enhanced UI (hover, finder, code actions)
- Trouble is available through `:Trouble`
