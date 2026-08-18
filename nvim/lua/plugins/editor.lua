return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "dockerfile",
        "go",
        "hcl",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "rust",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "camspiers/snap",
    event = "VeryLazy",
    config = function()
      local snap = require "snap"
      -- File search is Snap (not Telescope). Skip build/venv dirs and env files.
      local rg_ignore = {
        "--glob",
        "!**/bin/**",
        "--glob",
        "!**/env/**",
        "--glob",
        "!**/venv/**",
        "--glob",
        "!**/.venv/**",
        "--glob",
        "!**/.env",
        "--glob",
        "!**/.env.*",
        "--glob",
        "!**/*.env",
      }

      snap.maps {
        {
          "<Leader>ff",
          snap.config.file { producer = "ripgrep.file", args = rg_ignore },
          { command = "files" },
        },
        {
          "<Leader>fg",
          snap.config.vimgrep { args = rg_ignore },
          { command = "grep" },
        },
        { "<Leader>fb", snap.config.file { producer = "vim.buffer" }, { command = "buffers" } },
        { "<Leader>fo", snap.config.file { producer = "vim.oldfile" }, { command = "oldfiles" } },
      }
    end,
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>Oil<CR>", desc = "File explorer" },
      { "-", "<cmd>Oil<CR>", desc = "File explorer" },
    },
    opts = {
      view_options = { show_hidden = true },
      keymaps = {
        ["q"] = "actions.close",
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Grapple",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      scope = "git",
      quick_select = "123456789",
    },
    keys = {
      { "<leader>m", "<cmd>Grapple toggle<CR>", desc = "Toggle file tag" },
      { "<leader>M", "<cmd>Grapple toggle_tags<CR>", desc = "Show file tags" },
      { "<leader>n", "<cmd>Grapple cycle_tags next<CR>", desc = "Next tagged file" },
      { "<leader>p", "<cmd>Grapple cycle_tags prev<CR>", desc = "Previous tagged file" },
      { "<leader>1", "<cmd>Grapple select index=1<CR>", desc = "Tagged file 1" },
      { "<leader>2", "<cmd>Grapple select index=2<CR>", desc = "Tagged file 2" },
      { "<leader>3", "<cmd>Grapple select index=3<CR>", desc = "Tagged file 3" },
      { "<leader>4", "<cmd>Grapple select index=4<CR>", desc = "Tagged file 4" },
    },
  },

  -- s / S jump-search (Leap; the Sneak-style keys people remember).
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    name = "leap.nvim",
    keys = { "s", "S", "gs" },
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
      vim.keymap.set("n", "gs", "<Plug>(leap-from-window)", { desc = "Leap other window" })
    end,
  },
}
