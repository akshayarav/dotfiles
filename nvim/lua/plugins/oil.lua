return {
  -- Edit the filesystem like a buffer: rename/move/delete by editing lines, then :w to apply
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false, -- oil recommends against lazy-loading (it also replaces netrw for `nvim .`)
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
}
