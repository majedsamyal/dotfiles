local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Leave insert mode" })
map("n", ";", ":", { desc = "Command line" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
map("n", "<leader>fp", function()
  print(vim.fn.expand "%:p")
end, { desc = "Show current file path" })

map("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Previous diagnostic" })

map("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Next diagnostic" })

map("n", "<leader>ds", vim.diagnostic.open_float, { desc = "Line diagnostics" })
