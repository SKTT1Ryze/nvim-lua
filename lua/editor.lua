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
  vim.o.incsearch = true
	vim.o.background = 'dark'

  vim.cmd([[set notimeout]])

  vim.g.neovide_transparency = 0.8
end

return Editor
