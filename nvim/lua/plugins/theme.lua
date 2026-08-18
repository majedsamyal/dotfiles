return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
      vim.o.background = "dark"

      require("catppuccin").setup {
        flavour = "mocha",
        auto_integrations = false,
        integrations = {
          alpha = true,
          blink_cmp = {
            style = "bordered",
          },
          gitsigns = true,
          indent_blankline = {
            enabled = true,
          },
          leap = true,
          lsp_trouble = true,
          lualine = {
            enabled = true,
            theme = "mocha",
          },
          mason = true,
          noice = true,
          nvim_surround = true,
          treesitter = true,
          which_key = true,
        },
      }
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },
}
