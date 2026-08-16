vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config {
  virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
  severity_sort = true,
  update_in_insert = false,
}
