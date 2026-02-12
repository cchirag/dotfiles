return {
  -- File explorer
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
    },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "File explorer" },
      { "-", "<cmd>Oil<cr>", desc = "Parent directory" },
    },
  },

  -- Surround (add/change/delete surrounding pairs)
  -- sa = add, sd = delete, sr = replace
  -- Example: saiw" = surround word with quotes, sr"' = replace " with '
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "sa",            -- Add surrounding
        delete = "sd",         -- Delete surrounding
        replace = "sr",        -- Replace surrounding
        find = "sf",           -- Find surrounding (to the right)
        find_left = "sF",      -- Find surrounding (to the left)
        highlight = "sh",      -- Highlight surrounding
        update_n_lines = "sn", -- Update n_lines
      },
    },
  },
}
