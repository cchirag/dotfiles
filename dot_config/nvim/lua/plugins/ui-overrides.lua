return {
  -- Disable DAP (debugging)
  { "mfussenegger/nvim-dap", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
  { "rcarriga/nvim-dap-ui", enabled = false },
  { "leoluz/nvim-dap-go", enabled = false },
  { "mfussenegger/nvim-dap-python", enabled = false },
  { "nvim-neotest/nvim-nio", enabled = false },
  { "theHamsta/nvim-dap-virtual-text", enabled = false },

  { "folke/noice.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "karb94/neoscroll.nvim", enabled = false },
  { "nvim-mini/mini.animate", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "stevearc/dressing.nvim", enabled = false },
  { "folke/which-key.nvim", enabled = false },
  {
    "folke/snacks.nvim",
    opts = {
      notifier = { enabled = false },
      scroll = { enabled = false },
      animate = { enabled = false },
    },
  },
}
