return {
  -- Mason: install LSPs and tools
  {
    "mason-org/mason.nvim",
    opts = {
      PATH = "append",
      ensure_installed = {
        "gopls", "goimports", "gofumpt", "golangci-lint", "delve",
        "typescript-language-server", "eslint-lsp", "prettier",
        "pyright", "black", "isort",
        "rust-analyzer",
        "html-lsp", "css-lsp", "emmet-ls",
      },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "go", "gomod", "gowork", "typescript", "javascript", "tsx",
        "python", "rust", "html", "css", "scss",
        "json", "yaml", "toml", "lua", "vim", "bash",
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = { update_in_insert = false, virtual_text = false, severity_sort = true },
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true, shadow = true },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        tsserver = {},
        pyright = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              -- Reduce memory usage
              procMacro = { enable = false },           -- Biggest memory saver
              cargo = {
                allFeatures = false,                    -- Don't analyze all features
                loadOutDirsFromCheck = false,           -- Skip build script outputs
              },
              -- Faster diagnostics
              checkOnSave = {
                command = "check",                      -- Use check instead of clippy
                extraArgs = { "--target-dir", "/tmp/rust-analyzer-check" },
              },
              -- Disable expensive features
              completion = { callable = { snippets = "none" } },
              lens = { enable = false },                -- Code lens off
              inlayHints = { enable = false },
            },
          },
        },
        html = { filetypes = { "html", "templ" } },
        cssls = { filetypes = { "css", "scss", "less" } },
        emmet_ls = { filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" } },
        eslint = { settings = { format = false } },
      },
    },
  },

  -- Formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        python = { "black", "isort" },
      },
    },
  },
}
