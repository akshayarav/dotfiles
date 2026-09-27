return {
  "nicolasgb/jj.nvim",
  version = "*", -- pre-v1, so stick to tagged releases
  cmd = { "J", "Jdiff", "Jvdiff", "Jhdiff", "Jbrowse", "Jread", "Jedit", "Jtabedit", "Jsplit", "Jvsplit" },
  keys = {
    { "<leader>jl", "<cmd>J log<cr>", desc = "Log" },
    { "<leader>js", "<cmd>J status<cr>", desc = "Status" },
    { "<leader>jd", "<cmd>J describe<cr>", desc = "Describe change" },
    { "<leader>jn", "<cmd>J new<cr>", desc = "New change" },
    { "<leader>jD", "<cmd>Jdiff<cr>", desc = "Diff file vs parent" },
  },
  config = function()
    require("jj").setup({})
  end,
}
