-- Minimal Neovim Config
vim.g.mapleader, vim.g.maplocalleader = " ", " "

-- Repos where formatting is disabled (git origin patterns)
local format_disabled_repos = {
  "chirag%-bruno/bruno%.git",
  "chirag%-bruno/bruno%-enterprise%-edition%.git",
}

-- Check if formatting should be disabled for current repo (cached)
local format_cache = { cwd = "", disabled = false }
local function format_disabled()
  local cwd = vim.fn.getcwd()
  if format_cache.cwd == cwd then return format_cache.disabled end
  format_cache.cwd = cwd
  local origin = vim.fn.system("git remote get-url origin 2>/dev/null"):gsub("\n", "")
  format_cache.disabled = false
  if origin ~= "" then
    for _, pattern in ipairs(format_disabled_repos) do
      if origin:match(pattern) then format_cache.disabled = true; break end
    end
  end
  return format_cache.disabled
end

-- Options
local opt = vim.opt
opt.number, opt.relativenumber = true, true
opt.tabstop, opt.shiftwidth, opt.expandtab, opt.smartindent = 2, 2, true, true
opt.wrap, opt.ignorecase, opt.smartcase = false, true, true
opt.splitbelow, opt.splitright, opt.termguicolors, opt.signcolumn = true, true, true, "yes"
opt.updatetime, opt.timeoutlen, opt.undofile = 250, 300, true
opt.foldmethod, opt.foldexpr, opt.foldlevel = "expr", "v:lua.vim.treesitter.foldexpr()", 99
opt.mouse, opt.guicursor = "", "a:blinkon0"
opt.scrolloff, opt.sidescrolloff, opt.clipboard, opt.winborder = 8, 8, "unnamedplus", "rounded"
opt.cmdheight = 0           -- hide command line when not in use
opt.showcmdloc = "statusline"  -- show pending command in statusline

-- Git branch cache
local git_cache = { branch = "", cwd = "" }
local function git_branch()
  local cwd = vim.fn.getcwd()
  if git_cache.cwd ~= cwd then
    git_cache.cwd, git_cache.branch = cwd, vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  end
  return git_cache.branch
end

-- LSP progress
local lsp_progress = ""
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local data = ev.data.params.value
    if data.kind == "end" then
      lsp_progress = ""
    else
      lsp_progress = (data.title or "") .. (data.message and " " .. data.message or "")
      if #lsp_progress > 30 then lsp_progress = lsp_progress:sub(1, 30) .. "…" end
    end
    vim.cmd.redrawstatus()
  end,
})

-- Statusline
local mode_map = {
  n = { "NORMAL", "StatusMode" }, i = { "INSERT", "StatusModeInsert" },
  v = { "VISUAL", "StatusModeVisual" }, V = { "V-LINE", "StatusModeVisual" }, [""] = { "V-BLOCK", "StatusModeVisual" },
  c = { "COMMAND", "StatusModeCommand" }, R = { "REPLACE", "StatusModeInsert" }, t = { "TERMINAL", "StatusMode" },
}
function Statusline()
  local m = mode_map[vim.fn.mode()] or { vim.fn.mode(), "StatusMode" }
  local b = git_branch()
  local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local diag = (e > 0 and "%#StatusError# E:" .. e .. " " or "") .. (w > 0 and "%#StatusWarn# W:" .. w .. " " or "")
  local lsp = ""
  if lsp_progress ~= "" then
    lsp = "%#StatusLsp# " .. lsp_progress .. " "
  else
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then
      local names = {}
      for _, c in ipairs(clients) do table.insert(names, c.name) end
      lsp = "%#StatusLsp# " .. table.concat(names, ", ") .. " "
    end
  end
  return "%#" .. m[2] .. "# " .. m[1] .. " %#StatusLine#" .. (b ~= "" and "%#StatusBranch#  " .. b .. " " or "") .. "%#StatusFile# %f %m %S%=" .. lsp .. diag .. "%#StatusPos# %l:%c "
end
opt.statusline = "%!v:lua.Statusline()"

-- Autocmds
local au = vim.api.nvim_create_autocmd
au("ColorScheme", { callback = function()
  local hl, get = vim.api.nvim_set_hl, function(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
  local bg = get("Normal").bg or 0x1F1F28
  hl(0, "StatusLine", { bg = bg })  -- transparent (matches editor)
  hl(0, "StatusMode", { fg = bg, bg = get("Function").fg, bold = true })
  hl(0, "StatusModeInsert", { fg = bg, bg = get("String").fg, bold = true })
  hl(0, "StatusModeVisual", { fg = bg, bg = get("Keyword").fg, bold = true })
  hl(0, "StatusModeCommand", { fg = bg, bg = get("WarningMsg").fg or get("Type").fg, bold = true })
  hl(0, "StatusBranch", { fg = get("Keyword").fg, bg = bg })
  hl(0, "StatusFile", { fg = get("Normal").fg, bg = bg })
  hl(0, "StatusLsp", { fg = get("Comment").fg, bg = bg, italic = true })
  hl(0, "StatusError", { fg = get("DiagnosticError").fg, bg = bg, bold = true })
  hl(0, "StatusWarn", { fg = get("DiagnosticWarn").fg, bg = bg })
  hl(0, "StatusPos", { fg = get("Function").fg, bg = bg })
end })
au({ "BufEnter", "FocusGained", "DirChanged" }, { callback = function() git_cache.cwd = "" end })
au("FileType", { callback = function() pcall(vim.treesitter.start) end })
au("TextYankPost", { callback = function() vim.highlight.on_yank({ timeout = 150 }) end })
au("BufReadPost", { callback = function()
  local mark = vim.api.nvim_buf_get_mark(0, '"')
  if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
end })

-- Keymaps
local map = vim.keymap.set
map("", "<ScrollWheelUp>", "<Nop>")
map("", "<ScrollWheelDown>", "<Nop>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<S-h>", "<cmd>bprev<cr>")
map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<leader>bd", "<cmd>bdelete<cr>")
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "J", ":m '>+1<cr>gv=gv", { silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { silent = true })
map("n", "<leader>rn", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<leader>xd", vim.diagnostic.open_float)
map("n", "]q", "<cmd>cnext<cr>zz")
map("n", "[q", "<cmd>cprev<cr>zz")
map("n", "<leader>xq", "<cmd>copen<cr>")
map("n", "<leader>xc", "<cmd>cclose<cr>")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000, config = function() vim.cmd("colorscheme kanagawa-dragon") end },

  { "stevearc/oil.nvim", lazy = false, config = function()
    require("oil").setup({ default_file_explorer = true, delete_to_trash = true, skip_confirm_for_simple_edits = true, view_options = { show_hidden = true }, use_default_keymaps = true })
    map("n", "<leader>e", "<cmd>Oil<cr>")
    map("n", "-", "<cmd>Oil<cr>")
  end },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { indent = { char = "│" }, scope = { enabled = false } } },

  { "ibhagwan/fzf-lua", cmd = "FzfLua", keys = { "<leader>f", "<leader>sr" }, config = function()
    local fzf = require("fzf-lua")
    fzf.setup({ winopts = { preview = { default = "bat" } }, keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } } })
    map("n", "<leader>ff", fzf.files)
    map("n", "<leader>fg", fzf.live_grep)
    map("n", "<leader>fb", fzf.buffers)
    map("n", "<leader>fh", fzf.help_tags)
    map("n", "<leader>fr", fzf.oldfiles)
    map("n", "<leader>fs", fzf.lsp_document_symbols)
    map("n", "<leader>fw", fzf.grep_cword)
    map("n", "<leader>fW", fzf.grep_cWORD)
    map("v", "<leader>fw", fzf.grep_visual)
    map("n", "<leader>fq", function() fzf.live_grep({ actions = { ["default"] = fzf.actions.file_edit_or_qf, ["ctrl-q"] = fzf.actions.file_sel_to_qf } }) end)
    map("n", "<leader>sr", function()
      local s = vim.fn.input("Search: "); if s == "" then return end
      fzf.grep({ search = s, actions = { ["default"] = fzf.actions.file_sel_to_qf } })
      vim.defer_fn(function()
        local r = vim.fn.input("Replace: "); if r ~= "" then vim.cmd("cdo s/" .. vim.fn.escape(s, "/") .. "/" .. vim.fn.escape(r, "/") .. "/g | cfdo update") end
      end, 200)
    end)
  end },

  { "mason-org/mason.nvim", opts = {} },
  { "mason-org/mason-lspconfig.nvim", opts = { ensure_installed = { "gopls", "ts_ls", "pyright", "rust_analyzer", "lua_ls" } } },

  { "neovim/nvim-lspconfig", config = function()
    local caps = require("cmp_nvim_lsp").default_capabilities()
    au("LspAttach", { callback = function(a)
      local o = { buffer = a.buf }
      map("n", "gd", vim.lsp.buf.definition, o)
      map("n", "gD", vim.lsp.buf.declaration, o)
      map("n", "gr", vim.lsp.buf.references, o)
      map("n", "gi", vim.lsp.buf.implementation, o)
      map("n", "K", vim.lsp.buf.hover, o)
      map("n", "<leader>ca", vim.lsp.buf.code_action, o)
      map("n", "<leader>cr", vim.lsp.buf.rename, o)
      map("n", "<leader>cs", vim.lsp.buf.signature_help, o)
    end })
    local servers = {
      gopls = { filetypes = { "go", "gomod", "gowork", "gotmpl" }, root_markers = { "go.mod", ".git" },
        settings = { gopls = { analyses = { unusedparams = true, shadow = true }, staticcheck = true, gofumpt = true } } },
      ts_ls = { cmd = { "typescript-language-server", "--stdio" }, filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }, root_markers = { "package.json", ".git" } },
      pyright = { cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" }, root_markers = { "pyproject.toml", ".git" } },
      rust_analyzer = { filetypes = { "rust" }, root_markers = { "Cargo.toml", ".git" },
        settings = { ["rust-analyzer"] = { procMacro = { enable = false }, cargo = { allFeatures = false, loadOutDirsFromCheck = false }, checkOnSave = true, check = { command = "check" }, lens = { enable = false }, inlayHints = { enable = false } } } },
      lua_ls = { filetypes = { "lua" }, root_markers = { ".luarc.json", ".git" },
        settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false }, telemetry = { enable = false } } } },
    }
    for name, cfg in pairs(servers) do
      cfg.capabilities = caps
      vim.lsp.config[name] = cfg
    end
    vim.lsp.enable(vim.tbl_keys(servers))
    vim.diagnostic.config({ virtual_text = false, severity_sort = true, float = { border = "rounded" } })
  end },

  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp" }, config = function()
    local cmp = require("cmp")
    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(), ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), ["<Tab>"] = cmp.mapping.select_next_item(), ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      sources = { { name = "nvim_lsp" } },
      window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
    })
  end },

  { "stevearc/conform.nvim", event = "BufWritePre", keys = { { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end } },
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" }, python = { "black", "isort" }, rust = { "rustfmt" }, lua = { "stylua" },
        javascript = { "prettier" }, typescript = { "prettier" }, typescriptreact = { "prettier" }, javascriptreact = { "prettier" },
        html = { "prettier" }, css = { "prettier" }, scss = { "prettier" }, json = { "prettier" }, yaml = { "prettier" },
      },
      format_on_save = function() if format_disabled() then return nil end return { timeout_ms = 500, lsp_fallback = true } end,
  } },

  { "windwp/nvim-autopairs", event = "InsertEnter", config = function()
    require("nvim-autopairs").setup({})
    require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
  end },
}, { performance = { rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin" } } } })
