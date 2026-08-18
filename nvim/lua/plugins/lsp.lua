return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          ensure_installed = {
            "bashls",
            "dockerls",
            "gopls",
            "jsonls",
            "lua_ls",
            "pyright",
            "rust_analyzer",
            "terraformls",
            "ts_ls",
            "yamlls",
          },
        },
      },
      "saghen/blink.cmp",
    },
    config = function()
      local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
      end

      vim.lsp.config("pyright", {
        cmd = { mason_bin .. "/pyright-langserver", "--stdio" },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable {
        "bashls",
        "dockerls",
        "gopls",
        "jsonls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "terraformls",
        "ts_ls",
        "yamlls",
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("DotfilesLsp", { clear = true }),
        callback = function(event)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format { lsp_fallback = true, timeout_ms = 3000 }
        end,
        desc = "Format file",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}
