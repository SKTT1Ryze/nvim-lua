local Editor = {}

function Editor:config()
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.expandtab = true
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.softtabstop = 2
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.jumpoptions = 'stack'
	vim.opt.fdm = 'marker'
	vim.opt.autoread = true
  vim.o.incsearch = true
	vim.o.background = 'dark'

  vim.cmd([[set notimeout]])
  vim.cmd([[set modifiable]])
  vim.g.neovide_transparency = 0.8

  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("AutoChecktime", { clear = true }),
    callback = function()
      if vim.fn.mode() ~= "c" then
        vim.cmd("silent! checktime")
      end
    end,
  })
end

return Editor
