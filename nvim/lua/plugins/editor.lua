local rg_excludes = table.concat({
  [[-g "!.git"]],
  [[-g "!.jj"]],
  [[-g "!**/bin/**"]],
  [[-g "!**/env/**"]],
  [[-g "!**/venv/**"]],
  [[-g "!**/.venv/**"]],
  [[-g "!**/.env"]],
  [[-g "!**/.env.*"]],
  [[-g "!**/*.env"]],
}, " ")

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
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
    },
    opts = {
      keymap = {
        fzf = {
          true,
          ["up"] = "up",
          ["down"] = "down",
          ["ctrl-k"] = "up",
          ["ctrl-j"] = "down",
          ["ctrl-p"] = "up",
          ["ctrl-n"] = "down",
        },
      },
      fzf_opts = {
        ["--cycle"] = true,
        ["--pointer"] = ">",
      },
      files = {
        cmd = "rg --color=never --files " .. rg_excludes,
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 "
          .. rg_excludes
          .. " -e",
      },
      buffers = {
        -- fzf-lua otherwise pins the current buffer as an unselectable header.
        fzf_opts = { ["--header-lines"] = false },
      },
    },
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

  -- Dim the buffer and label matching text or syntax nodes for direct jumps.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
}
