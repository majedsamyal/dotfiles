local servers = {
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

local mason_tools = vim.list_extend(vim.deepcopy(servers), {
  "stylua",
  "gofumpt",
  "ruff",
  "prettier",
})

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          -- Only the curated list below should start. This prevents tools such
          -- as Ruff from silently becoming a second Python language server.
          automatic_enable = false,
        },
      },
      "saghen/blink.cmp",
    },
    config = function()
      local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
      local default_config = {
        flags = { debounce_text_changes = 300 },
      }
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        default_config.capabilities = blink.get_lsp_capabilities()
      end
      vim.lsp.config("*", default_config)

      vim.lsp.config("pyright", {
        cmd = { mason_bin .. "/pyright-langserver", "--stdio" },
        settings = {
          python = {
            analysis = {
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "off",
            },
          },
        },
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
      vim.lsp.enable(servers)

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
        go = { "gofumpt" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        terraform = { "terraform_fmt" },
      },
    },
  },

  -- Formatters and other non-LSP tools managed by :MasonToolsInstall.
  -- rustfmt comes with rustup, terraform_fmt with terraform, so they
  -- are not in this list.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsInstallSync", "MasonToolsUpdate" },
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = mason_tools,
      auto_update = false,
      run_on_start = false,
    },
  },
}
