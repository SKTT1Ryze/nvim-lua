local M = {}

function M:config()
  vim.notify = require("notify")
  .setup({background_colour = "#000000",})
end

return M
