-- Additional Rust-specific configurations
local M = {}

function M.setup()
  -- Rust file settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
      -- Set formatexpr to use rust-analyzer's formatting
      vim.bo.formatexpr = ""
      
      -- Increase timeout for large projects
      vim.lsp.set_timeout_sync(10000)
      
      -- Additional keymaps for Rust
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set("n", "<leader>rr", "<cmd>!cargo run<cr>", opts)
      vim.keymap.set("n", "<leader>rt", "<cmd>!cargo test<cr>", opts)
      vim.keymap.set("n", "<leader>rb", "<cmd>!cargo build<cr>", opts)
      vim.keymap.set("n", "<leader>rc", "<cmd>!cargo check<cr>", opts)
    end,
  })
end

return M
