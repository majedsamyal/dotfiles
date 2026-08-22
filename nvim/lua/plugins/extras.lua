return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
    },
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "enter" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        list = { max_items = 50 },
        menu = {
          auto_show_delay_ms = 100,
          max_height = 8,
        },
        documentation = { auto_show = false },
      },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
    },
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = {
        progress = { enabled = false },
        signature = {
          enabled = true,
          auto_open = { enabled = false },
        },
      },
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      messages = {
        enabled = true,
        view = "mini",
        view_error = "mini",
        view_warn = "mini",
      },
      popupmenu = {
        enabled = true,
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    },
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local dashboard = require "alpha.themes.dashboard"

      dashboard.section.header.val = {
        "            _           ",
        " _ __  __ _(_)_ __ ___  ",
        "| '_ \\/ _` | | '_ ` _ \\ ",
        "| | | | (_| | | | | | | |",
        "|_| |_|\\__, |_|_| |_| |_|",
        "       |___/             ",
      }
      dashboard.section.header.opts.hl = "Statement"

      dashboard.section.buttons.val = {
        dashboard.button("n", "New file", "<cmd>enew<CR>"),
        dashboard.button("f", "Find file", "<cmd>lua vim.api.nvim_feedkeys(vim.keycode('<leader>ff'), 'm', false)<CR>"),
        dashboard.button("g", "Grep text", "<cmd>lua vim.api.nvim_feedkeys(vim.keycode('<leader>fg'), 'm', false)<CR>"),
        dashboard.button("e", "Explore files", "<cmd>Oil<CR>"),
        dashboard.button("m", "Marked files", "<cmd>Grapple toggle_tags<CR>"),
        dashboard.button("l", "Lazy plugins", "<cmd>Lazy<CR>"),
        dashboard.button("q", "Quit", "<cmd>qa<CR>"),
      }

      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        return string.format("%d plugins loaded in %.2fms", stats.loaded, stats.startuptime)
      end
      dashboard.section.footer.opts.hl = "Comment"

      dashboard.opts.opts.noautocmd = true
      require("alpha").setup(dashboard.opts)
    end,
  },
}
