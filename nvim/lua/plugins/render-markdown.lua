return {
  -- Renders markdown in the buffer (headings, lists, tables, code blocks); the cursor line shows raw text
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = "markdown",
  keys = {
    { "<leader>tm", "<cmd>RenderMarkdown buf_toggle<cr>", ft = "markdown", desc = "Toggle markdown rendering" },
  },
  opts = {},
}
