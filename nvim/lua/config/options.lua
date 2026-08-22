-- Mason installs language servers here. Neovim's pyright config looks
-- for `pyright-langserver` on PATH, so this must be set before LSP starts.
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
if vim.env.PATH:find(mason_bin, 1, true) ~= 1 then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

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
  virtual_text = false,
  signs = { severity = { min = vim.diagnostic.severity.WARN } },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = true,
  },
}
