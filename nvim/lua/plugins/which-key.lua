return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>c", group = "code" },
      { "<leader>h", group = "hunk (git)" },
      { "<leader>j", group = "jj" },
    },
  },
}
