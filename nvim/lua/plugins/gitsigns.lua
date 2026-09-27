return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end
      -- In diff mode keep nvim's own ]c/[c
      map("]c", function()
        if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
      end, "Next change")
      map("[c", function()
        if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
      end, "Previous change")
      map("<leader>hp", gs.preview_hunk, "Preview change")
      map("<leader>hr", gs.reset_hunk, "Reset change")
      map("<leader>hb", gs.blame_line, "Blame line")
    end,
  },
}
