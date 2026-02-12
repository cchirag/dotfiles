return {
  -- Mason: install LSPs and tools
  {
    "mason-org/mason.nvim",
    opts = {
      PATH = "append",
      ensure_installed = {
        "gopls", "goimports", "gofumpt", "golangci-lint", "delve",
        "typescript-language-server", "eslint-lsp", "prettier",
        "pyright", "black", "isort", "ruff",
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
        tsserver = {},
        pyright = {},
        rust_analyzer = {},
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
